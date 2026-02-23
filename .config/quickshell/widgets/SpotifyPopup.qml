import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell
import "../theme"
import qs.services

PopupWindow {
    id: popup
    implicitWidth: 220
    implicitHeight: 110
    visible: false
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 4
        color: Theme.background
        radius: 12
        border.color: Theme.border
        border.width: 2

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 10

            // 1. Info (Title / Artist)
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                
                Text {
                    text: Media.title || "No Music"
                    color: Theme.foreground
                    font.bold: true
                    font.pixelSize: 13
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                }
                Text {
                    text: Media.artist || "Spotify"
                    color: Theme.foreground
                    opacity: 0.7
                    font.pixelSize: 11
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Rectangle { height: 1; Layout.fillWidth: true; color: "#504945" }

            // 2. Controls (Prev - Play/Pause - Next)
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 20

                // Prev
                Image {
                    source: "../assets/icons/skip_previous.svg"
                    sourceSize: Qt.size(20,20)
                    MouseArea { anchors.fill: parent; onClicked: Media.prev() }
                    ColorOverlay { anchors.fill: parent; source: parent; color: Theme.foreground }
                }

                // Play / Pause
                Image {
                    source: Media.isPlaying ? "../assets/icons/pause.svg" : "../assets/icons/play_arrow.svg"
                    sourceSize: Qt.size(24,24)
                    MouseArea { anchors.fill: parent; onClicked: Media.playPause() }
                    ColorOverlay { anchors.fill: parent; source: parent; color: Theme.foreground }
                }

                // Next
                Image {
                    source: "../assets/icons/skip_next.svg"
                    sourceSize: Qt.size(20,20)
                    MouseArea { anchors.fill: parent; onClicked: Media.next() }
                    ColorOverlay { anchors.fill: parent; source: parent; color: Theme.foreground }
                }
            }
        }
    }
}
