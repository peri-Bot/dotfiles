import QtQuick
import Quickshell
import "../theme"
import qs.services

Item {
    id: root
    width: 28
    height: 28
    property var windowRef // From Bar.qml

    property string currentIcon: {
        if (Audio.isMuted)
            return "../assets/icons/volume_off.svg";
        if (Audio.volume < 50)
            return "../assets/icons/volume_down.svg";
        return "../assets/icons/volume_up.svg";
    }

    IconButton {
        anchors.centerIn: parent
        iconSource: root.currentIcon
        onClicked: audioPopup.visible = !audioPopup.visible
        onRightClicked: Audio.toggleMute()
    }

    // --- FIX STARTS HERE ---
    PanelWindow {
        id: dismiss
        // anchors.fill: true // <--- THIS WAS THE ERROR
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        } // Correct way
        visible: audioPopup.visible
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            MouseArea {
                anchors.fill: parent
                onClicked: audioPopup.visible = false
            }
        }
    }
    // --- FIX ENDS HERE ---

    AudioPopup {
        id: audioPopup
        anchor.window: root.windowRef
        anchor.item: root
        anchor.edges: Qt.BottomEdge | Qt.RightEdge
    }
}
