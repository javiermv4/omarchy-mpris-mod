// Classify MPRIS players and format track text for the bar widget.
// Suppress artist metadata for web browsers (Firefox, Chrome, Brave, etc.)
// where artist strings are often redundant channel names, site names, or noise.

var KNOWN_BROWSERS = [
  "firefox",
  "chrome",
  "chromium",
  "brave",
  "vivaldi",
  "opera",
  "librewolf",
  "waterfox",
  "floorp",
  "torbrowser",
  "icecat",
  "palemoon",
  "seamonkey",
  "epiphany",
  "falkon",
  "midori",
  "qutebrowser",
  "ladybird",
  "luakit",
  "nyxt",
  "badwolf"
]

var BOUNDARY_BROWSERS = /(^|[-_. ])(microsoft-edge|msedge|edge|zen|arc|min)($|[-_. ])/
var DBUS_BOUNDARY_BROWSERS = /(^|\.)(microsoft-edge|msedge|edge|zen|arc|min)(\.|$)/

function isBrowser(player) {
  if (!player) return false

  var dbus = ""
  var desktop = ""
  var identity = ""

  if (typeof player === "string") {
    dbus = player.toLowerCase()
  } else {
    dbus = String(player.dbusName || "").toLowerCase()
    desktop = String(player.desktopEntry || "").toLowerCase()
    identity = String(player.identity || "").toLowerCase()
  }

  var combined = dbus + " " + desktop + " " + identity
  if (combined.indexOf("browser") !== -1) return true
  if (identity === "web" || identity === "gnome web") return true

  if (BOUNDARY_BROWSERS.test(desktop) || BOUNDARY_BROWSERS.test(identity) || DBUS_BOUNDARY_BROWSERS.test(dbus)) {
    return true
  }

  for (var i = 0; i < KNOWN_BROWSERS.length; i++) {
    if (combined.indexOf(KNOWN_BROWSERS[i]) !== -1) return true
  }

  return false
}

function formatDisplayText(title, artist, isBrowser, showArtist) {
  var cleanTitle = String(title || "").trim()
  var cleanArtist = String(artist || "").trim()

  if (isBrowser) {
    return cleanTitle
  }

  if (showArtist && cleanArtist && cleanTitle) {
    return cleanArtist + " — " + cleanTitle
  }

  return cleanTitle || cleanArtist
}

