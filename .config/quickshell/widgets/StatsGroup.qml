import QtQuick
import QtQuick.Layouts
import "../theme"
import qs.services

Rectangle {
    id: groupRoot
    height: 25
    // Width recalculates automatically when Spotify hides/shows
    width: layout.implicitWidth + 24

    color: "#43453b"
    radius: 16
    property var windowRef

    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 15

        // CPU Ring
        CircularStat {
            iconSource: "../assets/icons/cpu.svg"
            percentage: System.cpuUsage
            textLabel: System.cpuUsage + "%"
        }

        // RAM Ring
        CircularStat {
            iconSource: "../assets/icons/ram.svg"
            percentage: System.ramPercent
            textLabel: System.ramUsed + "GB"
        }

        // Network Ring
        CircularStat {
            iconSource: "../assets/icons/network.svg"
            percentage: 0
            textLabel: System.netSpeed
        }

        // Spotify Icon (Hidden if not playing)
        SpotifyButton {
            windowRef: groupRoot.windowRef
        }
    }
}
