pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    // --- Public API ---
    property int volume: 0
    property bool isMuted: false

    // --- 1. GET STATUS (Polls wpctl) ---
    // Output format: "Volume: 0.45" or "Volume: 0.45 [MUTED]"
    property Process _statusProc: Process {
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: SplitParser {
            onRead: data => {
                // Check Mute Status
                root.isMuted = data.includes("[MUTED]");

                // Extract Volume (0.45 -> 45)
                // Remove "Volume: " and split by space
                const parts = data.replace("Volume:", "").trim().split(" ");
                if (parts.length > 0) {
                    const rawFloat = parseFloat(parts[0]);
                    if (!isNaN(rawFloat)) {
                        root.volume = Math.round(rawFloat * 100);
                    }
                }
            }
        }
    }

    // --- 2. SET VOLUME ---
    function setVolume(val) {
        // Optimistic update
        root.volume = val;

        // Command: wpctl set-volume @DEFAULT_AUDIO_SINK@ 50%
        Quickshell.process({
            command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", (val / 100).toFixed(2)]
        });
    }

    // --- 3. TOGGLE MUTE ---
    function toggleMute() {
        // Optimistic update
        root.isMuted = !root.isMuted;

        // Command: wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        Quickshell.process({
            command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
        });

        // Force a refresh shortly after to ensure sync
        _refreshTimer.restart();
    }

    // --- TIMERS ---

    // Refresh shortly after actions
    property Timer _refreshTimer: Timer {
        interval: 100
        onTriggered: _statusProc.running = true
    }

    // Poll every 1 second to stay in sync with system changes
    property Timer _ticker: Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: _statusProc.running = true
    }
}
