pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root
    property int percentage: 0
    property int _max: 1 // Default to 1 to avoid division by zero

    // --- 1. GET MAX BRIGHTNESS (Runs once on start) ---
    property Process _maxProc: Process {
        command: ["brightnessctl", "m"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                let val = parseInt(data.trim());
                if (val > 0)
                    root._max = val;
            }
        }
    }

    // --- 2. GET CURRENT BRIGHTNESS (Polls to sync with keys) ---
    property Process _getProc: Process {
        command: ["brightnessctl", "g"]
        stdout: SplitParser {
            onRead: data => {
                let current = parseInt(data.trim());
                if (isNaN(current))
                    return;

                // Calculate percentage
                let newPerc = Math.round((current / root._max) * 100);

                // Only update if not currently dragging (to prevent jitter)
                if (!_setProc.running) {
                    root.percentage = newPerc;
                }
            }
        }
    }

    // --- 3. SET BRIGHTNESS ---
    // We define a reusable process object
    property Process _setProc: Process {
        command: ["true"] // Placeholder
    }

    function set(val) {
        // 1. Update UI immediately (Optimistic)
        percentage = val;

        // 2. Calculate actual value
        let actualVal = Math.round((val / 100) * _max);

        // 3. Run command
        _setProc.command = ["brightnessctl", "s", actualVal];
        _setProc.running = true;
    }

    // --- POLLING ---
    // Checks brightness every 1 second to keep slider in sync if you use Fn keys
    property Timer _ticker: Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root._getProc.running = true
    }
}
