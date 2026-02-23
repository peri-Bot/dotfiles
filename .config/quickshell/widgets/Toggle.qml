import QtQuick
import "../theme"

Rectangle {
    id: root
    
    // --- API ---
    property bool checked: false
    property color activeColor: Theme.blue 
    signal toggled()

    implicitWidth: 44
    implicitHeight: 24
    radius: 12
    
    // Background logic
    color: checked ? activeColor : "#504945" 
    Behavior on color { ColorAnimation { duration: 200 } }

    // The Thumb
    Rectangle {
        id: thumb
        width: 18; height: 18
        radius: 9
        anchors.verticalCenter: parent.verticalCenter
        
        // Slide logic
        x: root.checked ? (root.width - width - 3) : 3
        
        color: Theme.foreground
        Behavior on x { 
            NumberAnimation { duration: 200; easing.type: Easing.OutQuad } 
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.toggled()
    }
}
