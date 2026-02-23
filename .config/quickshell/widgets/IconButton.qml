import QtQuick
import Qt5Compat.GraphicalEffects
import "../theme"

Rectangle {
    id: root
    
    // Props
    property string iconSource
    property int size: 28
    property int iconSize: 18
    
    // Signals
    signal clicked()
    signal rightClicked()

    width: size
    height: size
    radius: size / 2

    // Background: Transparent -> Cream (Foreground) on Hover
    color: mouse.containsMouse ? Theme.foreground : "transparent"
    Behavior on color { ColorAnimation { duration: 150 } }

    // Icon logic
    Image {
        id: iconRaw
        anchors.centerIn: parent
        source: root.iconSource
        width: root.iconSize
        height: root.iconSize
        fillMode: Image.PreserveAspectFit
        visible: false 
    }

    ColorOverlay {
        anchors.fill: iconRaw
        source: iconRaw
        // Icon: Cream -> Dark (Background) on Hover
        color: mouse.containsMouse ? Theme.background : Theme.foreground
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: (mouse) => {
            if (mouse.button === Qt.RightButton) root.rightClicked()
            else root.clicked()
        }
    }
}
