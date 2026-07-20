local git = require("rootbeer.git")
local optional = require("modules.lib.optional")
local profile = require("rootbeer.profile")
local rb = require("rootbeer")

local editor = optional.find_binary({
  "hx",
  "nvim",
  "vim",
  "nano",
})

local config = {
  user = {
    name = "Michael Buckley",
    email = profile.select({
      personal = "michaelcbuckley@proton.me",
      work = rb.host.user .. "@cisco.com",
    }),
  },
  advice = { defaultBranchName = false },

  signing = {
    key = "~/.ssh/active/signing.pub",
    format = "ssh",
  },
  pull_rebase = true,
  merge_conflictstyle = "zdiff3",
  ignores = {
    ".DS_Store",
    ".AppleDouble",
    ".LSOverride",
    "Icon",
    ".direnv",
    "._*",
    ".DocumentRevisions-V100",
    ".fseventsd",
    ".Spotlight-V100",
    ".TemporaryItems",
    ".Trashes",
    ".VolumeIcon.icns",
    ".com.apple.timemachine.donotpresent",
    ".AppleDB",
    ".AppleDesktop",
    "Network Trash Folder",
    "Temporary Items",
    ".apdisk",
    "*~",
    ".fuse_hidden*",
    ".directory",
    ".Trash-*",
    ".nfs*",
  },

  extra = {
    init = {
      defaultBranch = "main",
    },

    fetch = {
      prune = true,
    },

    push = {
      autoSetupRemote = true,
      followTags = true,
    },

    rebase = {
      autoSquash = true,
      updateRefs = true,
    },

    rerere = {
      enabled = true,
    },

    diff = {
      algorithm = "histogram",
      colorMoved = "default",
    },

    commit = {
      verbose = true,
      gpgSign = true,
    },

    branch = {
      sort = "-committerdate",
    },

    tag = {
      sort = "version:refname",
    },

    column = {
      ui = "auto",
    },

    help = {
      autocorrect = "prompt",
    },

    http = {
      postBuffer = 157286400,
    },
  },
}

-- Merge in delta settings if available
local delta = optional.find_binary("delta")
if delta then
  config.pager = delta

  config.extra.delta = {
    ["side-by-side"] = true,
    ["line-numbers"] = true,
    ["zero-style"] = "dim syntax",
    navigate = true,
  }

  config.extra.interactive = {
    diffFilter = delta .. " --color-only",
  }
end

if editor then
  config.editor = editor
end

git.config(config)
