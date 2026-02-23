// widgets/settings/BrightnessRow.qml
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../../theme"
import qs.services
import ".." // Import Slider from parent

ColumnLayout {
    spacing: 8
    Layout.fillWidth: true

    // Header
    RowLayout {
        spacing: 8
        Item {
            width: 16
            height: 16
            Image {
                id: sunRaw
                anchors.fill: parent
                source: "../../assets/icons/sun.svg"
                visible: false
                fillMode: Image.PreserveAspectFit
            }
            ColorOverlay {
                anchors.fill: sunRaw
                source: sunRaw
                color: Theme.foreground
            }
        }
        Text {
            text: "Brightness"
            font.family: "JetBrainsMono Nerd Font"
            color: Theme.foreground
            font.pixelSize: 13
            font.bold: true
        }
    }

    // New Slider Component
    Slider {
        Layout.fillWidth: true
        value: Brightness.percentage
        onMoved: val => Brightness.set(val)
    }
}
