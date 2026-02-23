// import QtQuick
// import QtQuick.Layouts
// import "../theme"
// import qs.services // Import our new module defined in qmldir
//
// RowLayout {
//     spacing: 15
//
//     // --- WIFI ---
//     RowLayout {
//         spacing: 4
//         Text {
//             text: Network.icon
//             color: Network.connected ? Theme.blue : Theme.red
//             font.pixelSize: 14
//         }
//         Text {
//             text: Network.connected ? "On" : "Off"
//             color: Theme.foreground
//             font.pixelSize: 12
//         }
//     }
//
//     // --- AUDIO ---
//     RowLayout {
//         spacing: 4
//         Text {
//             text: Audio.icon
//             color: Theme.yellow
//             font.pixelSize: 16
//         }
//         Text {
//             text: Audio.volume + "%"
//             color: Theme.foreground
//             font.pixelSize: 12
//         }
//     }
//
//     // --- CPU ---
//     RowLayout {
//         spacing: 4
//         Text {
//             text: ""
//             color: Theme.green
//             font.pixelSize: 14
//         }
//         Text {
//             text: System.cpuUsage + "%"
//             color: Theme.foreground
//             font.pixelSize: 12
//         }
//     }
// }
