import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "../theme"

RowLayout {
    spacing: 8

    // Exact characters from your image
    // Indices: 0 (unused), 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    property var hiragana: ["", "いち", "に", "さん", "し", "ご", "ろく", "なな", "はち", "く", "じゅう"]

    Repeater {
        model: Hyprland.workspaces

        Rectangle {
            id: wsRect
            property bool isActive: modelData.id === Hyprland.focusedWorkspace.id

            // Adaptive width: fits the text plus some padding, but keeps a minimum size
            width: Math.max(28, wsText.implicitWidth + 14)
            height: 24
            radius: 12 // Keeps the pill/rounded shape

            // Your original colors preserved
            color: isActive ? Theme.blue : "transparent"
            border.width: 1
            border.color: isActive ? Theme.blue : "transparent"

            Text {
                id: wsText
                anchors.centerIn: parent

                // Map ID to the new Hiragana array
                text: hiragana[modelData.id] || modelData.id

                // Font setup
                font.family: "Noto Sans CJK JP" // Ensure Japanese font is used
                font.bold: true
                font.pixelSize: 13

                // Active text is dark (on blue), inactive is cream
                color: isActive ? "#1d2021" : Theme.foreground
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch(`workspace ${modelData.id}`)
            }
        }
    }
}
