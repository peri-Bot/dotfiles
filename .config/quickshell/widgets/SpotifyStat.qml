import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell            // <--- ADD THIS IMPORT
import "../theme"
import qs.services

Item {
    id: root

    // Hide if no media
    visible: Media.isPlaying || Media.title !== ""

    // Width logic: Icon(24) + Spacing(8) + Text
    width: visible ? (24 + 8 + songText.implicitWidth) : 0
    height: 24

    property var windowRef
    property string colorString: Theme.foreground.toString()

    RowLayout {
        anchors.fill: parent
        spacing: 8

        // Icon + Ring
        Item {
            width: 24
            height: 24

            Canvas {
                anchors.fill: parent
                antialiasing: true

                // Force paint on load
                Component.onCompleted: requestPaint()

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    ctx.clearRect(0, 0, width, height);
                    var radius = (width / 2) - 1.5;

                    // Full Ring
                    ctx.beginPath();
                    ctx.lineWidth = 3;
                    ctx.strokeStyle = root.colorString;
                    ctx.arc(width / 2, height / 2, radius, 0, 6.28);
                    ctx.stroke();
                }
            }

            Item {
                anchors.fill: parent
                anchors.margins: 5
                Image {
                    id: icon
                    anchors.fill: parent
                    source: "../assets/icons/spotify.svg"
                    visible: false
                    sourceSize: Qt.size(14, 14)
                }
                ColorOverlay {
                    anchors.fill: icon
                    source: icon
                    color: Theme.foreground
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: popup.visible = !popup.visible
            }
        }

        // Text
        Text {
            id: songText
            text: Media.title
            color: Theme.foreground
            font.bold: true
            font.pixelSize: 12
            Layout.alignment: Qt.AlignVCenter
            Layout.maximumWidth: 150
            elide: Text.ElideRight
        }
    }

    // Dismiss Mask
    PanelWindow {
        id: dismiss
        visible: popup.visible
        // Anchors for PanelWindow must be edges
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
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

    // Popup
    SpotifyPopup {
        id: popup
        anchor.window: root.windowRef
        anchor.item: root
        anchor.edges: Qt.BottomEdge | Qt.RightEdge
    }
}
