import QtQuick
import QtTest
import "../PlayerIdentity.js" as PlayerIdentity

TestCase {
  id: testCase
  name: "PlayerIdentity"

  function test_browserDetection() {
    var browsers = [
      { dbusName: "org.mpris.MediaPlayer2.firefox.instance_1_42", desktopEntry: "firefox", identity: "Firefox" },
      { dbusName: "org.mpris.MediaPlayer2.firefox-esr.instance_1", desktopEntry: "firefox-esr", identity: "Firefox ESR" },
      { dbusName: "org.mpris.MediaPlayer2.chromium.instance_123", desktopEntry: "chromium", identity: "Chromium" },
      { dbusName: "org.mpris.MediaPlayer2.google-chrome.instance_1", desktopEntry: "google-chrome-stable", identity: "Google Chrome" },
      { dbusName: "org.mpris.MediaPlayer2.brave.instance_1", desktopEntry: "brave-browser", identity: "Brave" },
      { dbusName: "org.mpris.MediaPlayer2.microsoft-edge.instance_1", desktopEntry: "microsoft-edge", identity: "Microsoft Edge" },
      { dbusName: "org.mpris.MediaPlayer2.vivaldi.instance_1", desktopEntry: "vivaldi-stable", identity: "Vivaldi" },
      { dbusName: "org.mpris.MediaPlayer2.opera.instance_1", desktopEntry: "opera", identity: "Opera" },
      { dbusName: "org.mpris.MediaPlayer2.zen.instance_1", desktopEntry: "zen", identity: "Zen Browser" },
      { dbusName: "org.mpris.MediaPlayer2.librewolf.instance_1", desktopEntry: "librewolf", identity: "LibreWolf" },
      { dbusName: "org.mpris.MediaPlayer2.waterfox.instance_1", desktopEntry: "waterfox", identity: "Waterfox" },
      { dbusName: "org.mpris.MediaPlayer2.floorp.instance_1", desktopEntry: "floorp", identity: "Floorp" },
      { dbusName: "org.mpris.MediaPlayer2.torbrowser.instance_1", desktopEntry: "torbrowser-launcher", identity: "Tor Browser" },
      { dbusName: "org.mpris.MediaPlayer2.epiphany.instance_1", desktopEntry: "org.gnome.Epiphany", identity: "Epiphany" },
      { dbusName: "org.mpris.MediaPlayer2.epiphany", desktopEntry: "epiphany", identity: "GNOME Web" },
      { dbusName: "org.mpris.MediaPlayer2.falkon.instance_1", desktopEntry: "org.kde.falkon", identity: "Falkon" },
      { dbusName: "org.mpris.MediaPlayer2.midori.instance_1", desktopEntry: "midori", identity: "Midori" },
      { dbusName: "org.mpris.MediaPlayer2.qutebrowser", desktopEntry: "org.qutebrowser.qutebrowser", identity: "qutebrowser" },
      { dbusName: "org.mpris.MediaPlayer2.ladybird", desktopEntry: "ladybird", identity: "Ladybird" }
    ]

    for (var i = 0; i < browsers.length; i++) {
      var b = browsers[i]
      verify(PlayerIdentity.isBrowser(b), "Expected browser detection for: " + (b.dbusName || b.identity))
    }
  }

  function test_nonBrowserDetection() {
    var musicPlayers = [
      { dbusName: "org.mpris.MediaPlayer2.spotify", desktopEntry: "spotify", identity: "Spotify" },
      { dbusName: "org.mpris.MediaPlayer2.vlc.instance_1", desktopEntry: "vlc", identity: "VLC media player" },
      { dbusName: "org.mpris.MediaPlayer2.rhythmbox", desktopEntry: "rhythmbox", identity: "Rhythmbox" },
      { dbusName: "org.mpris.MediaPlayer2.amberol", desktopEntry: "io.bassi.Amberol", identity: "Amberol" },
      { dbusName: "org.mpris.MediaPlayer2.strawberry", desktopEntry: "org.strawberrymusicplayer.strawberry", identity: "Strawberry" },
      { dbusName: "org.mpris.MediaPlayer2.clementine", desktopEntry: "clementine", identity: "Clementine" },
      { dbusName: "org.mpris.MediaPlayer2.audacious", desktopEntry: "audacious", identity: "Audacious" },
      { dbusName: "org.mpris.MediaPlayer2.deadbeef", desktopEntry: "deadbeef", identity: "DeaDBeeF" },
      { dbusName: "org.mpris.MediaPlayer2.elisa", desktopEntry: "org.kde.elisa", identity: "Elisa" },
      { dbusName: "org.mpris.MediaPlayer2.lollypop", desktopEntry: "org.gnome.Lollypop", identity: "Lollypop" },
      { dbusName: "org.mpris.MediaPlayer2.cider", desktopEntry: "cider", identity: "Cider" },
      { dbusName: "org.mpris.MediaPlayer2.youtubemusic", desktopEntry: "youtube-music", identity: "YouTube Music" }
    ]

    for (var i = 0; i < musicPlayers.length; i++) {
      var m = musicPlayers[i]
      verify(!PlayerIdentity.isBrowser(m), "False positive browser detection for: " + (m.dbusName || m.identity))
    }

    verify(!PlayerIdentity.isBrowser(null))
    verify(!PlayerIdentity.isBrowser(undefined))
  }

  function test_formatDisplayText() {
    // Non-browser with artist and title: shows "Artist — Title" when showArtist is true
    compare(PlayerIdentity.formatDisplayText("Get Lucky", "Daft Punk", false, true), "Daft Punk — Get Lucky")

    // Non-browser with showArtist disabled: shows title alone
    compare(PlayerIdentity.formatDisplayText("Get Lucky", "Daft Punk", false, false), "Get Lucky")

    // Non-browser with title only
    compare(PlayerIdentity.formatDisplayText("Get Lucky", "", false, true), "Get Lucky")
    compare(PlayerIdentity.formatDisplayText("Get Lucky", "", false, false), "Get Lucky")

    // Non-browser with artist only
    compare(PlayerIdentity.formatDisplayText("", "Daft Punk", false, true), "Daft Punk")
    compare(PlayerIdentity.formatDisplayText("", "Daft Punk", false, false), "Daft Punk")

    // Browser (e.g. Firefox) with artist and title: only title appears
    compare(PlayerIdentity.formatDisplayText("Video Title", "Channel Name", true, true), "Video Title")
    compare(PlayerIdentity.formatDisplayText("Video Title", "Channel Name", true, false), "Video Title")

    // Browser with title only
    compare(PlayerIdentity.formatDisplayText("Video Title", "", true, true), "Video Title")

    // Browser with artist only: artist does not appear
    compare(PlayerIdentity.formatDisplayText("", "Channel Name", true, true), "")

    // Empty
    compare(PlayerIdentity.formatDisplayText("", "", false, true), "")
    compare(PlayerIdentity.formatDisplayText("", "", true, true), "")
  }
}

