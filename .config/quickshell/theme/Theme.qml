pragma Singleton
import QtQuick

QtObject {
    // Gruvbox Dark (Hard Contrast)
    property color background: Qt.alpha("#32382f", 0.6)      // Very dark grey/black
    property color foreground: "#ebdbb2"      // Cream text

    // The "Blackest Black" Border
    property color border: Qt.alpha("#32382f", 0.5)

    property color group: "#43453b"

    // Accents
    property color red: "#cc241d"
    property color green: "#98971a"
    property color yellow: "#d79921"
    property color blue: "#458588"
    property color orange: "#d65d0e"
    property color aqua: "#8ec07c"
}
