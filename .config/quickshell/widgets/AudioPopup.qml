import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects // Required for ColorOverlay
import Quickshell
import "../theme"
import qs.services
import "."

PopupWindow {
    id: popup

    // FIX: Use implicitWidth to silence warning
    implicitWidth: 200 // Increased slightly to fit text
    implicitHeight: 60
    visible: false
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 4
        color: Theme.background
        radius: 12
        border.color: Theme.border
        border.width: 2

        RowLayout {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 12

            // --- 1. TINTED ICON ---
            Item {
                width: 16
                height: 16
                Image {
                    id: volIcon
                    anchors.fill: parent
                    source: Audio.isMuted ? "../assets/icons/volume_off.svg" : "../assets/icons/volume_up.svg"
                    visible: false
                    sourceSize: Qt.size(16, 16)
                }
                ColorOverlay {
                    anchors.fill: volIcon
                    source: volIcon
                    color: Theme.foreground // FIX: Cream color
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Audio.toggleMute()
                }
            }

            // --- 2. SLIDER ---
            Slider {
                Layout.fillWidth: true
                value: Audio.volume
                onMoved: val => Audio.setVolume(val)
            }

            // --- 3. PERCENTAGE TEXT ---
            Text {
                text: Audio.volume + "%"
                color: Theme.foreground
                font.bold: true
                font.pixelSize: 12
                // Ensure text doesn't jitter layout too much
                Layout.minimumWidth: 30
                horizontalAlignment: Text.AlignRight
            }
        }
    }
}
