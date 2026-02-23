pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root
    property bool isPlaying: false
    property string title: ""
    property string artist: ""

    // Check if player is actually active
    property bool hasActivePlayer: title !== ""

    // --- 1. METADATA POLLING ---
    property Process metaProc: Process {
        // We check specifically for spotify
        command: ["playerctl", "-p", "spotify", "metadata", "--format", "{{status}}::{{artist}}::{{title}}"]
        stdout: SplitParser {
            onRead: data => {
                let parts = data.trim().split("::");
                if (parts.length >= 3) {
                    root.isPlaying = (parts[0] === "Playing");
                    root.artist = parts[1];
                    root.title = parts[2];
                } else {
                    // Reset if data is weird or empty
                    root.isPlaying = false;
                    root.title = "";
                    root.artist = "";
                }
            }
        }
    }

    // --- 2. CONTROLS ---
    property Process actionProc: Process {
        command: ["true"]
    }

    function playPause() {
        actionProc.command = ["playerctl", "-p", "spotify", "play-pause"];
        actionProc.running = true;
        _refresh.restart();
    }

    function next() {
        actionProc.command = ["playerctl", "-p", "spotify", "next"];
        actionProc.running = true;
        _refresh.restart();
    }

    function prev() {
        actionProc.command = ["playerctl", "-p", "spotify", "previous"];
        actionProc.running = true;
        _refresh.restart();
    }

    property Timer _refresh: Timer {
        interval: 200
        onTriggered: metaProc.running = true
    }

    property Timer _ticker: Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: metaProc.running = true
    }
}
