import QtQuick
import Quickshell
import "../theme"
import qs.services

Item {
    id: root
    width: 28; height: 28
    property var windowRef // From Bar.qml

    // 1. Base Button
    IconButton {
        anchors.centerIn: parent
        iconSource: "../assets/icons/notifications.svg"
        
        onClicked: {
            notifPopup.visible = !notifPopup.visible
            // Force refresh when opening
            if (notifPopup.visible) Notifications._poll.running = true
        }
    }

    // 2. The Badge (Red Dot with Number)
    Rectangle {
        visible: Notifications.count > 0
        
        // Positioning: Top-Right corner
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 0
        anchors.rightMargin: 0

        width: 14
        height: 14
        radius: 7
        color: Theme.red
        border.color: Theme.background
        border.width: 1

        Text {
            anchors.centerIn: parent
            text: Notifications.count > 9 ? "9+" : Notifications.count
            color: "#1d2021" // Black text on red
            font.bold: true
            font.pixelSize: 9
        }
    }

    // 3. Dismiss Mask
    PanelWindow {
        id: dismiss
        anchors { top: true; bottom: true; left: true; right: true }
        visible: notifPopup.visible
        color: "transparent"
        Rectangle { 
            anchors.fill: parent; color: "transparent" 
            MouseArea { anchors.fill: parent; onClicked: notifPopup.visible = false } 
        }
    }

    // 4. Popup
    NotificationPopup {
        id: notifPopup
        anchor.window: root.windowRef
        anchor.item: root
        anchor.edges: Qt.BottomEdge | Qt.RightEdge
    }
}
