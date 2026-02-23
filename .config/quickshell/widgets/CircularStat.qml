import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../theme"

RowLayout {
    id: root
    spacing: 8

    // --- Data Inputs ---
    property string iconSource
    property string textLabel
    property int percentage: 0 // Ranges from 0 to 100

    // Force a redraw whenever the number changes
    onPercentageChanged: ringCanvas.requestPaint()

    // 1. The Ring + Icon Container
    Item {
        width: 24
        height: 24

        Canvas {
            id: ringCanvas
            anchors.fill: parent
            antialiasing: true

            // Optimization for crisp rendering
            renderTarget: Canvas.FramebufferObject
            renderStrategy: Canvas.Threaded

            // Draw immediately on load
            Component.onCompleted: requestPaint()

            onPaint: {
                var ctx = getContext("2d");

                // 1. Setup
                ctx.reset();
                ctx.clearRect(0, 0, width, height);

                var w = width;
                var h = height;
                var cx = w / 2;
                var cy = h / 2;

                // Ring Geometry
                var thickness = 3;
                var radius = (Math.min(w, h) / 2) - (thickness / 2);
                var startAngle = -Math.PI / 2; // Top (12 o'clock)
                var fullCircle = Math.PI * 2;

                // 2. Draw Background Track (Dark Grey)
                ctx.beginPath();
                ctx.arc(cx, cy, radius, 0, fullCircle, false);
                ctx.lineWidth = thickness;
                ctx.lineCap = "round";
                ctx.strokeStyle = "#504945";
                ctx.stroke();

                // 3. Draw Dynamic Progress (Cream)
                // Convert integer (0-100) to float (0.0-1.0)
                // Use Math.max/min to prevent errors if data is weird
                var progress = Math.max(0, Math.min(100, percentage)) / 100.0;

                // Only draw if there is actually value > 0
                if (progress > 0) {
                    var endAngle = startAngle + (progress * fullCircle);

                    ctx.beginPath();
                    ctx.arc(cx, cy, radius, startAngle, endAngle, false);
                    ctx.lineWidth = thickness;
                    ctx.lineCap = "round";
                    // toString() is important for QML Colors in Canvas
                    ctx.strokeStyle = "#ebdbb2";
                    ctx.stroke();
                }
            }
        }

        // The Icon
        Item {
            anchors.fill: parent
            anchors.margins: 5

            Image {
                id: icon
                anchors.centerIn: parent
                source: root.iconSource
                width: 14
                height: 14
                sourceSize: Qt.size(14, 14)
                visible: false
                fillMode: Image.PreserveAspectFit
            }

            ColorOverlay {
                anchors.fill: icon
                source: icon
                color: Theme.foreground
            }
        }
    }

    // The Text
    Text {
        text: root.textLabel
        color: Theme.foreground
        font.bold: true
        font.pixelSize: 12
        Layout.alignment: Qt.AlignVCenter
    }
}
