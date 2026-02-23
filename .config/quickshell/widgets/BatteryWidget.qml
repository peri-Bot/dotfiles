import QtQuick
import "../theme"
import qs.services

Item {
    id: root

    // Total size: Body width + Tip width + Spacing
    width: 37
    height: 25

    property int level: Battery.capacity
    property bool charging: Battery.isCharging

    // Dynamic Color Logic
    // Charging = Green, Low = Red, Normal = Cream
    property color paintColor: {
        if (charging)
            return Theme.aqua;
        if (level <= 20)
            return Theme.red;
        return Theme.foreground;
    }

    // --- 1. BATTERY BODY (Border) ---
    Rectangle {
        id: body
        width: 25
        height: 15
        radius: 4
        color: "transparent"
        border.color: root.paintColor
        border.width: 1.5

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        // --- 2. BACKGROUND TEXT (The part NOT covered by liquid) ---
        Text {
            anchors.centerIn: parent
            font.family: "JetBrainsMono Nerd Font"
            text: root.level
            color: root.paintColor // Same color as border
            font.bold: true
            font.weight: Font.Bold
            font.pixelSize: 12
        }

        // --- 3. LIQUID MASK (Clips the fill) ---
        Item {
            id: mask
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.margins: 2 // Gap between border and liquid

            // Width changes based on percentage
            width: (parent.width - 4) * (root.level / 100)
            clip: true // This cuts off the content

            // Smooth animation for the liquid movement
            Behavior on width {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.OutQuad
                }
            }

            // --- 4. LIQUID FILL ---
            Rectangle {
                id: fill
                // The fill is always "full width" relative to the body,
                // but the mask hides the right side.
                width: body.width - 4
                height: parent.height
                radius: 2
                color: root.paintColor

                // --- 5. FOREGROUND TEXT (The part COVERED by liquid) ---
                // This text sits exactly on top of the background text,
                // but its color is dark to contrast with the liquid.
                Text {
                    anchors.centerIn: parent
                    text: root.level
                    font.family: "JetBrainsMono Nerd Font"
                    color: Theme.background // Dark Text
                    font.bold: true
                    font.pixelSize: 12
                    font.weight: Font.Bold
                }
            }
        }
    }

    // --- 6. BATTERY TIP ---
    Rectangle {
        width: 3
        height: 8
        radius: 1.5
        color: root.paintColor

        anchors.left: body.right
        anchors.leftMargin: 3
        anchors.verticalCenter: parent.verticalCenter
    }
}
