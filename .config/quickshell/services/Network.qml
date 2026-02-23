pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    // --- Public API ---
    property bool connected: false
    property string ssid: "Disconnected"
    property int signalStrength: 0
    property var scannedNetworks: []

    // Set your interface here (check 'ip link' if unsure, but wlan0 is standard)
    property string interfaceName: "wlan0"

    // --- 1. STATUS CHECK ---
    // Fix: Assigned to property '_ticker'
    property Timer _ticker: Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            statusProc.running = false;
            statusProc.running = true;
        }
    }

    // Fix: Assigned to property 'statusProc'
    property Process statusProc: Process {
        // using bash -c to enable pipes (|) and sed
        command: ["bash", "-c", "iwctl station " + root.interfaceName + " show | sed -r 's/\\x1B\\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g'"]

        stdout: StdioCollector {
            onStreamFinished: {
                var lines = text.split("\n");

                var isConnected = false;
                var currentSSID = "Disconnected";
                var rssi = -100;

                for (var i = 0; i < lines.length; i++) {
                    var line = lines[i].trim();

                    if (line.startsWith("State")) {
                        if (line.includes("connected"))
                            isConnected = true;
                    }

                    if (line.startsWith("Connected network")) {
                        var match = line.match(/Connected network\s+(.+)/);
                        if (match && match[1])
                            currentSSID = match[1].trim();
                    }

                    if (line.startsWith("RSSI")) {
                        var parts = line.split(/\s+/);
                        if (parts.length >= 2) {
                            var val = parseInt(parts[1]);
                            if (!isNaN(val))
                                rssi = val;
                        }
                    }
                }

                root.connected = isConnected;
                root.ssid = isConnected ? currentSSID : "Disconnected";

                if (isConnected) {
                    var quality = (rssi + 100) * 2;
                    root.signalStrength = Math.max(0, Math.min(100, quality));
                } else {
                    root.signalStrength = 0;
                }
            }
        }
    }

    // --- 2. SCANNING PROCESS ---
    property Process scanProc: Process {
        command: ["bash", "-c", "iwctl station " + root.interfaceName + " get-networks | sed -r 's/\\x1B\\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g'"]

        stdout: StdioCollector {
            onStreamFinished: {
                var lines = text.split("\n");
                var nets = [];

                for (var i = 0; i < lines.length; i++) {
                    var line = lines[i].trim();
                    if (!line || line.startsWith("Network") || line.startsWith("----") || line.includes("Available networks"))
                        continue;

                    if (line.startsWith(">"))
                        line = line.substring(1).trim();

                    var parts = line.split(/\s{2,}/);
                    if (parts.length > 0)
                        nets.push(parts[0]);
                }
                root.scannedNetworks = [...new Set(nets)].slice(0, 10);
            }
        }
    }

    // --- 3. ACTIONS ---
    property Process actionProc: Process {
        command: ["true"]
    }

    function scan() {
        scanProc.running = false;
        scanProc.running = true;
    }

    function connect(name) {
        actionProc.command = ["iwctl", "station", root.interfaceName, "connect", name];
        actionProc.running = true;
    }

    function disconnect() {
        actionProc.command = ["iwctl", "station", root.interfaceName, "disconnect"];
        actionProc.running = true;
    }
}
