pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root
    property bool powered: false

    // --- 1. CHECK STATUS ---
    property Process _check: Process {
        command: ["bluetoothctl", "show"]
        stdout: SplitParser {
            onRead: data => {
                if (data.includes("Powered: yes"))
                    root.powered = true;
                if (data.includes("Powered: no"))
                    root.powered = false;
            }
        }
    }

    // --- 2. TOGGLE POWER ---
    property Process _toggleProc: Process {
        // We set the command dynamically before running
        command: ["true"]
    }

    function toggle() {
        let cmd = powered ? "off" : "on";
        _toggleProc.command = ["bluetoothctl", "power", cmd];
        _toggleProc.running = true;

        // Optimistic update so UI feels instant
        powered = !powered;
    }

    // --- 3. OPEN SCANNER ---
    property Process _scanProc: Process {
        command: ["blueman-manager"]
    }

    function openScanner() {
        _scanProc.running = true;
    }

    // Poll status every 3 seconds
    property Timer _ticker: Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: _check.running = true
    }
}
