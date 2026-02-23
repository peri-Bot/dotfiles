// widgets/settings/BluetoothRow.qml
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects // Required for tinting
import "../../theme"
import qs.services
import ".." // Access the Toggle.qml in the same folder

RowLayout {
    spacing: 12
    Layout.fillWidth: true

    // --- LEFT SIDE: Icon & Text (Opens Manager) ---
    RowLayout {
        spacing: 12
        Layout.fillWidth: true // Takes up remaining space

        // 1. Icon (Tinted)
        Item {
            width: 20
            height: 20

            Image {
                id: btIconRaw
                anchors.fill: parent
                source: "../../assets/icons/bluetooth.svg"
                visible: false
                fillMode: Image.PreserveAspectFit
            }

            ColorOverlay {
                anchors.fill: btIconRaw
                source: btIconRaw
                color: Theme.foreground // Tint requested
            }
        }

        // 2. Text
        Text {
            text: "Bluetooth"
            font.family: "JetBrainsMono Nerd Font"
            color: Theme.foreground
            font.bold: true
            font.pixelSize: 13
            Layout.fillWidth: true
        }

        // Click on Icon OR Text to open the manager
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: Bluetooth.openScanner()
        }
    }

    // --- RIGHT SIDE: Toggle Switch ---
    Toggle {
        checked: Bluetooth.powered
        activeColor: Theme.blue
        onToggled: Bluetooth.toggle()
    }
}
