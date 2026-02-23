// ~/.config/quickshell/Wallpaper.qml
import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow {
    // Set to Background layer so it stays behind windows and the bar
    WlrLayershell.layer: WlrLayershell.Background

    // Make it cover the whole screen
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    Image {
        anchors.fill: parent
        // Point this to an image in your 'assets' folder
        source: "../assets/wallpaper/gruvbox_spac.jpg"
        fillMode: Image.PreserveAspectCrop // Ensures it fills without stretching
    }
}
