import QtQuick
import Quickshell
import "../theme"
import qs.services

Item {
    id: root
    width: 28
    height: 28
    property var windowRef // From Bar.qml

    IconButton {
        anchors.centerIn: parent
        iconSource: Network.connected ? "../assets/icons/wifi.svg" : "../assets/icons/wifi_off.svg"

        onClicked: {
            wifiPopup.visible = !wifiPopup.visible;
            if (wifiPopup.visible)
                Network.scan();
        }
    }

    // --- FIX STARTS HERE ---
    PanelWindow {
        id: dismiss
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        } // Correct way
        visible: wifiPopup.visible
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            MouseArea {
                anchors.fill: parent
                onClicked: wifiPopup.visible = false
            }
        }
    }
    // --- FIX ENDS HERE ---

    WifiPopup {
        id: wifiPopup
        anchor.window: root.windowRef
        anchor.item: root
        anchor.edges: Qt.BottomEdge | Qt.RightEdge
    }
}
