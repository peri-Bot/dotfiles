import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../theme"
import qs.services

RowLayout {
    spacing: 8
    
    // Bind directly to the service
    property int value: System.cpuUsage 
    property string label: System.cpuUsage + "%"
    property string colorString: Theme.foreground.toString()

    // Trigger redraw when CPU changes
    onValueChanged: ring.requestPaint()

    Item {
        width: 24; height: 24
        
        Canvas {
            id: ring
            anchors.fill: parent
            antialiasing: true
            renderTarget: Canvas.FramebufferObject
            renderStrategy: Canvas.Threaded
            
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.clearRect(0, 0, width, height);

                var w = width; var h = height;
                var cx = w/2; var cy = h/2;
                var radius = (w/2) - 1.5;

                // Track
                ctx.beginPath();
                ctx.arc(cx, cy, radius, 0, 6.28);
                ctx.lineWidth = 3;
                ctx.lineCap = "round";
                ctx.strokeStyle = "#504945"; 
                ctx.stroke();

                // Progress
                // Convert 0-100 to 0.0-1.0
                var progress = root.value / 100.0;
                
                if (progress > 0) {
                    var start = -Math.PI / 2;
                    var end = start + (progress * Math.PI * 2);
                    
                    ctx.beginPath();
                    ctx.arc(cx, cy, radius, start, end, false);
                    ctx.lineWidth = 3;
                    ctx.lineCap = "round";
                    ctx.strokeStyle = root.colorString;
                    ctx.stroke();
                }
            }
        }

        Item {
            anchors.fill: parent; anchors.margins: 5
            Image { id: icon; anchors.centerIn: parent; source: "../assets/icons/cpu.svg"; width: 14; height: 14; visible: false }
            ColorOverlay { anchors.fill: icon; source: icon; color: Theme.foreground }
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
