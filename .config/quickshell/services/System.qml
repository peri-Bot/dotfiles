pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    // --- CPU ---
    property int cpuUsage: 0
    property var _lastCpu: ({
            total: 0,
            idle: 0
        })

    // --- RAM ---
    property double ramUsed: 0.0
    property int ramPercent: 0

    // --- NETWORK ---
    property string netSpeed: "0 KB/s"
    property var _lastNet: ({
            bytes: 0,
            time: 0
        })

    // --- 1. CPU PROCESS ---
    property Process cpuProc: Process {
        command: ["cat", "/proc/stat"]
        stdout: SplitParser {
            onRead: data => {
                if (!data.startsWith("cpu "))
                    return;
                const parts = data.split(/\s+/);
                let user = parseInt(parts[1]);
                let idle = parseInt(parts[4]);
                let currentTotal = user + parseInt(parts[2]) + parseInt(parts[3]) + idle + parseInt(parts[5]) + parseInt(parts[6]) + parseInt(parts[7]);

                let diffTotal = currentTotal - root._lastCpu.total;
                let diffIdle = idle - root._lastCpu.idle;

                if (diffTotal > 0)
                    root.cpuUsage = Math.round(((diffTotal - diffIdle) / diffTotal) * 100);
                root._lastCpu = {
                    total: currentTotal,
                    idle: idle
                };
            }
        }
    }

    // --- 2. RAM PROCESS (Improved with AWK) ---
    property Process ramProc: Process {
        // Output: "16000 4000" (Total Used)
        command: ["bash", "-c", "free -m | awk '/^Mem:/ {print $2, $3}'"]
        stdout: SplitParser {
            onRead: data => {
                let parts = data.trim().split(" ");
                if (parts.length >= 2) {
                    let total = parseInt(parts[0]);
                    let used = parseInt(parts[1]);

                    if (total > 0) {
                        root.ramUsed = (used / 1024).toFixed(1);
                        root.ramPercent = Math.round((used / total) * 100);
                    }
                }
            }
        }
    }

    // --- 3. NETWORK PROCESS ---
    property Process netProc: Process {
        command: ["bash", "-c", "cat /proc/net/dev | awk 'NR>2 {sum+=$2} END {print sum}'"]
        stdout: SplitParser {
            onRead: data => {
                let currentBytes = parseInt(data.trim());
                let currentTime = new Date().getTime();

                if (root._lastNet.time > 0) {
                    let timeDiff = (currentTime - root._lastNet.time) / 1000;
                    let byteDiff = currentBytes - root._lastNet.bytes;
                    let speedBps = byteDiff / timeDiff;

                    if (speedBps > 1024 * 1024)
                        root.netSpeed = (speedBps / (1024 * 1024)).toFixed(1) + " MB/s";
                    else
                        root.netSpeed = Math.round(speedBps / 1024) + " KB/s";
                }
                root._lastNet = {
                    bytes: currentBytes,
                    time: currentTime
                };
            }
        }
    }

    property Timer _ticker: Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            cpuProc.running = true;
            ramProc.running = true;
            netProc.running = true;
        }
    }
}
