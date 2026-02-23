import QtQuick
import "../theme"

Item {
    id: root

    // API
    property int value: 0
    property int maxValue: 100
    signal moved(int newValue)

    implicitWidth: 200
    implicitHeight: 24

    // Background Track
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: 6
        radius: 3
        color: "#504945" // Dark Grey
    }

    // Filled Track (Active)
    Rectangle {
        width: thumb.x
        height: 6
        radius: 3
        color: Theme.foreground
        opacity: 0.5
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
    }

    // The Thumb
    Rectangle {
        id: thumb
        width: 10
        height: 20
        radius: 5
        color: Theme.foreground
        anchors.verticalCenter: parent.verticalCenter

        // Calculate X based on value (prevent division by zero)
        x: (root.maxValue > 0) ? (root.value / root.maxValue) * (root.width - width) : 0

        // Disable animation while dragging to make it feel responsive
        Behavior on x {
            enabled: !mouseArea.pressed
            NumberAnimation {
                duration: 100
                easing.type: Easing.OutQuad
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        anchors.margins: -10 // Large hit area

        function updateVal(mouse) {
            // Calculate percentage based on click position
            let percent = mouse.x / (root.width - thumb.width);
            let rawVal = Math.round(percent * root.maxValue);
            // Clamp between 0 and Max
            let finalVal = Math.max(0, Math.min(root.maxValue, rawVal));

            // Emit signal
            root.moved(finalVal);
        }

        onPressed: mouse => updateVal(mouse)
        onPositionChanged: mouse => updateVal(mouse)
    }
}
