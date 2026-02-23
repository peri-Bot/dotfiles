import QtQuick
import "../theme"

Rectangle {
    // Determine width based on text to keep it tight
    width: dateText.implicitWidth + 20
    height: 26
    radius: 8
    color: "transparent"// Inner background
    border.color: "transparent"
    border.width: 1

    Text {
        id: dateText
        anchors.centerIn: parent
        color: Theme.foreground
        font.family: "JetBrainsMono Nerd Font"

        font.pixelSize: 13
        font.bold: true
        font.weight: Font.Bold

        // Updates automatically
        text: Qt.formatDateTime(new Date(), "HH:mm ◎ ddd MMM d")

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: dateText.text = Qt.formatDateTime(new Date(), "HH:mm ◎ ddd MMM d")
        }
    }
}
