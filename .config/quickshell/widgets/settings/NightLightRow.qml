import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Io
import "../../theme"
import ".."

RowLayout {
    Layout.fillWidth: true
    spacing: 12

    // Track state locally
    property bool isActive: false

    // --- PROCESS 1: Turn ON (Blocks while running) ---
    Process {
        id: _onProc
        command: ["hyprsunset", "-t", "4700"]
    }

    // --- PROCESS 2: Turn OFF (Instant kill) ---
    Process {
        id: _offProc
        command: ["pkill", "hyprsunset"]
    }

    // Left Side (Icon + Text)
    RowLayout {
        spacing: 12
        Layout.fillWidth: true

        Item {
            width: 20
            height: 20
            Image {
                id: nlIconRaw
                anchors.fill: parent
                source: "../../assets/icons/moon.svg"
                visible: false
                fillMode: Image.PreserveAspectFit
            }
            ColorOverlay {
                anchors.fill: nlIconRaw
                source: nlIconRaw
                color: Theme.foreground
            }
        }
        Text {
            text: "Night Light"
            font.family: "JetBrainsMono Nerd Font"
            color: Theme.foreground
            font.bold: true
            font.pixelSize: 13
        }
    }

    // Toggle Switch
    Toggle {
        checked: parent.isActive
        activeColor: Theme.orange

        onToggled: {
            parent.isActive = !parent.isActive;

            if (parent.isActive) {
                // Stop any kill command, start sunset
                _offProc.running = false;
                _onProc.running = true;
            } else {
                // Stop the running sunset process
                _onProc.running = false;
                // Explicitly run pkill to be safe
                _offProc.running = true;
            }
        }
    }
}
