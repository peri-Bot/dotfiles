import QtQuick
import QtQuick.Layouts
import Quickshell
import "../theme"
import "./settings" // Import the modular folder

PopupWindow {
    id: popup

    // Anchor logic (Bottom-Right of the bar)
    anchor.window: settingsroot
    anchor.item: parent
    anchor.edges: Qt.BottomEdge | Qt.RightEdge

    implicitWidth: 240
    implicitHeight: 190
    visible: false

    color: "transparent"

    // Background Container
    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 5
        anchors.rightMargin: 3
        color: Theme.background
        radius: 16
        border.color: Theme.border
        border.width: 2

        // Main Column
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 18

            BluetoothRow {}

            NightLightRow {}

            BrightnessRow {}
        }
    }
}
