import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../theme"
import qs.services

RowLayout {
    spacing: 8

    property string label: System.netSpeed
    property string colorString: Theme.foreground.toString()

    Item {
        width: 24
        height: 24

        Canvas {
            id: ring
            anchors.fill: parent
            antialiasing: true
            // Draw once
            Component.onCompleted: requestPaint()

            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);
                var radius = (width / 2) - 1.5;

                // Track
                ctx.beginPath();
                ctx.arc(width / 2, height / 2, radius, 0, 6.28);
                ctx.lineWidth = 3;
                ctx.strokeStyle = "#504945";
                ctx.stroke();

                // Full Fill (Static)
                ctx.beginPath();
                ctx.arc(width / 2, height / 2, radius, 0, 6.28);
                ctx.lineWidth = 3;
                ctx.strokeStyle = root.colorString;
                ctx.stroke();
            }
        }

        Item {
            anchors.fill: parent
            anchors.margins: 5
            Image {
                id: icon
                anchors.centerIn: parent
                source: "../assets/icons/network.svg"
                width: 14
                height: 14
                visible: false
            }
            ColorOverlay {
                anchors.fill: icon
                source: icon
                color: Theme.foreground
            }
        }
    }

    Text {
        text: root.label
        color: Theme.foreground
        font.bold: true
        font.pixelSize: 12
        Layout.alignment: Qt.AlignVCenter
    }
}
