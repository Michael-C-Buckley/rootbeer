local lib = require("lib")

require("rootbeer").packages({
  "helium",
  "make",
  "utm",
})

-- Packages that are not currently published by Rootbeer.
lib.add_brew({
  formulae = {
    "age-plugin-yubikey",
    "bash",
    "herdr",
    "lima",
    "tig",
  },
  casks = {
    "aerospace",
    "bruno",
    "codex",
    "font-ibm-plex-mono",
    "font-ibm-plex-sans",
    "font-lilex-nerd-font",
    "microsoft-outlook",
    "secretive",
    "zed",
  },
})
