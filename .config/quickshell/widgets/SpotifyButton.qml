import QtQuick
import Qt5Compat.GraphicalEffects
import Quickshell
import "../theme"
import qs.services

Item {
    id: root

    width: 22
    height: 22

    // HIDE if no title is detected (Spotify closed or stopped)
    visible: Media.hasActivePlayer

    property var windowRef

    // 1. Icon (Just the Logo, no ring)
    Image {
        id: icon
        anchors.centerIn: parent
        source: "../assets/icons/spotify.svg"
        sourceSize: Qt.size(16, 16)
        visible: false
    }

    ColorOverlay {
        anchors.fill: icon
        source: icon
        // Green if playing, Cream if paused
        color: Media.isPlaying ? "#1db954" : Theme.foreground
    }

    // 2. Interaction
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: popup.visible = !popup.visible
    }

    // 3. Dismiss Mask
    PanelWindow {
        id: dismiss
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        visible: popup.visible
        color: "transparent"
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            MouseArea {
                anchors.fill: parent
                onClicked: popup.visible = false
            }
        }
    }

    // 4. Popup
    SpotifyPopup {
        id: popup
        anchor.window: root.windowRef
        anchor.item: root
        anchor.edges: Qt.BottomEdge | Qt.RightEdge
    }
}
