pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    // --- API ---
    property int count: 0
    property var list: [] // The array of notification objects

    // --- 1. POLL ALERTS ---
    property Process _poll: Process {
        command: ["makoctl", "list"]
        stdout: SplitParser {
            onRead: data => {
                try {
                    // makoctl list returns: { "data": [ [ ...notifs... ] ] }
                    const json = JSON.parse(data);
                    if (json && json.data && json.data.length > 0) {
                        // We assume data[0] contains the main list
                        root.list = json.data[0];
                        root.count = root.list.length;
                    } else {
                        root.list = [];
                        root.count = 0;
                    }
                } catch (e) {
                    // Ignore JSON parse errors during startup/empty states
                    root.list = [];
                    root.count = 0;
                }
            }
        }
    }

    // --- ACTIONS ---
    function dismiss(id) {
        Quickshell.process({ command: ["makoctl", "dismiss", "-n", id] });
        // Force immediate refresh
        _poll.running = true;
    }

    function dismissAll() {
        Quickshell.process({ command: ["makoctl", "dismiss", "-a"] });
        _poll.running = true;
    }

    function invoke(id) {
        Quickshell.process({ command: ["makoctl", "invoke", "-n", id] });
        // Usually invoking also dismisses, depending on mako config
        _poll.running = true;
    }

    // Check every 2 seconds
    property Timer _ticker: Timer {
        interval: 2000 
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root._poll.running = true
    }
}
