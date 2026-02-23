pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property int capacity: 0
    property bool isCharging: false

    // --- POLL TIMER ---
    property Timer _ticker: Timer {
        interval: 5000 // Check every 5 seconds
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            // Restart process
            batProc.running = false;
            batProc.running = true;
        }
    }

    // --- PROCESS ---
    property Process batProc: Process {
        // Read capacity, new line, then status
        command: ["bash", "-c", "cat /sys/class/power_supply/BAT0/capacity && cat /sys/class/power_supply/BAT0/status"]

        stdout: StdioCollector {
            onStreamFinished: {
                // Split lines
                var lines = text.trim().split("\n");

                // We expect at least 2 lines
                if (lines.length >= 2) {
                    var cap = parseInt(lines[0].trim());
                    var stat = lines[1].trim();

                    if (!isNaN(cap))
                        root.capacity = cap;
                    root.isCharging = (stat === "Charging");
                }
            }
        }
    }
}
