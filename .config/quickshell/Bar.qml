import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "./theme"
import "./widgets"

PanelWindow {
    id: barWindow
    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: 40
    color: "transparent"

    Rectangle {
        anchors {
            fill: parent
            topMargin: 6
            bottomMargin: 2
            leftMargin: 12
            rightMargin: 12
        }

        // TRANSPARENT BACKGROUND (80% Opacity)
        color: Theme.background

        radius: 40
        border.color: Theme.border
        border.width: 2

        // --- 1. CENTER: Time & Date ---
        DateTime {
            id: centerClock
            anchors.centerIn: parent
        }

        // --- 2. CENTER-RIGHT: System Stats ---
        StatsGroup {
            anchors.left: centerClock.right
            anchors.leftMargin: 150
            anchors.verticalCenter: parent.verticalCenter
            // Ensure StatsGroup gets the window ref
            windowRef: barWindow
        }

        // --- 3. LEFT SIDE: Workspaces ---
        RowLayout {
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.verticalCenter: parent.verticalCenter

            Workspaces {}
        }

        // --- 4. RIGHT SIDE: Battery & Icons ---
        RowLayout {
            anchors.right: parent.right
            anchors.rightMargin: 15
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            // Battery
            BatteryWidget {}

            // Icon Group (Audio, Wifi, Notifs)
            Rectangle {
                height: 25
                width: (28 * 3) + 4 + 12

                // TRANSPARENT GROUP BACKGROUND (80% Opacity)
                color: Qt.alpha("#43453b", 0.8)

                radius: 16

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 2
                    AudioButton {
                        windowRef: barWindow
                    }
                    WifiButton {
                        windowRef: barWindow
                    }
                    NotificationButton {
                        windowRef: barWindow
                    }
                }
            }

            // Settings
            SettingsButton {
                windowRef: barWindow
            }
        }
    }
}
