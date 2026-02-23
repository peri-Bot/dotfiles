import QtQuick
import Qt5Compat.GraphicalEffects
import Quickshell
import "../theme"

Rectangle {
    id: settingsroot
    property var windowRef // From Bar.qml

    // --- Visuals ---
    width: 28
    height: 28
    radius: 14
    color: hoverArea.containsMouse ? Theme.foreground : "transparent"
    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }

    Image {
        id: iconRaw
        anchors.centerIn: parent
        source: "../assets/icons/settings.svg"
        width: 18
        height: 18
        fillMode: Image.PreserveAspectFit
        visible: false
    }

    ColorOverlay {
        anchors.fill: iconRaw
        source: iconRaw
        color: hoverArea.containsMouse ? Theme.background : Theme.foreground
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        // Toggle logic
        onClicked: settingsPopup.visible = !settingsPopup.visible
    }

    // --- 1. THE DISMISS MASK (Invisible Fullscreen Window) ---
    PanelWindow {
        id: dismissLayer

        // Fill the entire screen
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        // Only active when popup is open
        visible: settingsPopup.visible

        // Invisible to the eye
        color: "transparent"

        // When this layer is clicked, close the popup
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            MouseArea {
                anchors.fill: parent
                onClicked: settingsPopup.visible = false
            }
        }
    }

    // --- 2. THE POPUP ---
    SettingsPopup {
        id: settingsPopup
        anchor.window: settingsroot.windowRef
        anchor.item: settingsroot
        anchor.edges: Qt.BottomEdge | Qt.RightEdge
    }
}
