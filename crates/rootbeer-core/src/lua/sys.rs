use mlua::{IntoLua, Lua, Result as LuaResult, Table, Value};

use super::module::Module;

/// Information about the host system.
struct HostInfo {
    /// The operating system, e.g. "linux", "windows", "macos".
    os: String,

    /// The CPU architecture, e.g. "x86_64", "aarch64".
    arch: String,

    /// The hostname of the machine, if available (uses `HOSTNAME` if set).
    hostname: Option<String>,

    /// The username of the current user (uses `USER` if set).
    user: String,

    /// The home directory of the resolved user.
    home: String,

    /// The login shell of the resolved user.
    shell: String,
}

/// Unsafely retrieves the hostname using libc. Returns None if the call fails.
fn get_hostname() -> Option<String> {
    if let Ok(hostname) = std::env::var("HOSTNAME") {
        return Some(hostname.trim_end_matches('\0').to_string());
    }

    let size = unsafe { libc::sysconf(libc::_SC_HOST_NAME_MAX + 1).max(256) } as usize;
    let mut buf = vec![0u8; size];

    let result = unsafe { libc::gethostname(buf.as_mut_ptr().cast(), size) };
    if result != 0 {
        return None;
    }

    let len = buf.iter().position(|&b| b == 0).unwrap_or(buf.len());
    String::from_utf8(buf[..len].to_vec()).ok()
}

/// A representation of the user's passwd DB entry
struct UserInfo {
    name: String,
    dir: String,
    shell: String,
}

/// Fetches a UserInfo struct for the current user via the passwd database.
fn get_user() -> Option<UserInfo> {
    let mut passwd_buf = vec![0u8; 4096];
    let mut pwd: libc::passwd = unsafe { std::mem::zeroed() };
    let mut result: *mut libc::passwd = std::ptr::null_mut();

    let ret = match std::env::var("USER") {
        Ok(user) => {
            let c_user = std::ffi::CString::new(user).ok()?;
            unsafe {
                libc::getpwnam_r(
                    c_user.as_ptr(),
                    &mut pwd,
                    passwd_buf.as_mut_ptr().cast(),
                    passwd_buf.len(),
                    &mut result,
                )
            }
        }
        Err(_) => {
            let uid = unsafe { libc::getuid() };
            unsafe {
                libc::getpwuid_r(
                    uid,
                    &mut pwd,
                    passwd_buf.as_mut_ptr().cast(),
                    passwd_buf.len(),
                    &mut result,
                )
            }
        }
    };

    if ret != 0 || result.is_null() {
        return None;
    }

    let to_string = |ptr: *const libc::c_char| -> Option<String> {
        if ptr.is_null() {
            return None;
        }

        let len = unsafe { libc::strlen(ptr) };
        let bytes = unsafe { std::slice::from_raw_parts(ptr.cast::<u8>(), len) };
        std::str::from_utf8(bytes).ok().map(String::from)
    };

    Some(UserInfo {
        name: to_string(pwd.pw_name)?,
        dir: to_string(pwd.pw_dir)?,
        shell: to_string(pwd.pw_shell)?,
    })
}

impl IntoLua for HostInfo {
    fn into_lua(self, lua: &Lua) -> LuaResult<Value> {
        let table = lua.create_table()?;
        table.set("os", self.os)?;
        table.set("arch", self.arch)?;
        table.set("hostname", self.hostname)?;
        table.set("user", self.user)?;
        table.set("home", self.home)?;
        table.set("shell", self.shell)?;
        Ok(Value::Table(table))
    }
}

pub(crate) struct Sys;

impl Module for Sys {
    const NAME: &'static str = "";

    fn build(_lua: &Lua, t: &Table) -> LuaResult<()> {
        let user = get_user()
            .ok_or_else(|| mlua::Error::runtime("failed to read passwd entry for current user"))?;

        t.set(
            "host",
            HostInfo {
                os: std::env::consts::OS.to_string(),
                arch: std::env::consts::ARCH.to_string(),
                hostname: get_hostname(),
                user: user.name,
                home: user.dir,
                shell: user.shell,
            },
        )?;
        Ok(())
    }
}
