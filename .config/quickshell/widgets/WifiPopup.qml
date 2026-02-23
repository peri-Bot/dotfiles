import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell
import "../theme"
import qs.services

PopupWindow {
    id: popup

    // FIX: Use implicitWidth
    implicitWidth: 220
    implicitHeight: 250
    visible: false
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 4
        color: Theme.background
        radius: 12
        border.color: Theme.border
        border.width: 2

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 10

            // --- HEADER WITH TINTED ICON ---
            RowLayout {
                Layout.fillWidth: true

                Item {
                    width: 16
                    height: 16
                    Image {
                        id: wifiIcon
                        anchors.fill: parent
                        source: Network.connected ? "../assets/icons/wifi.svg" : "../assets/icons/wifi_off.svg"
                        visible: false
                        sourceSize: Qt.size(16, 16)
                    }
                    ColorOverlay {
                        anchors.fill: wifiIcon
                        source: wifiIcon
                        color: Theme.foreground // FIX: Cream color
                    }
                }

                Text {
                    text: Network.connected ? Network.ssid : "Disconnected"
                    font.family: "JetBrainsMono Nerd Font"
                    color: Theme.foreground
                    font.bold: true
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
            }

            Rectangle {
                height: 1
                Layout.fillWidth: true
                color: "#504945"
            }

            Text {
                text: "Available Networks"
                color: Theme.foreground
                font.family: "JetBrainsMono Nerd Font"
                opacity: 0.6
                font.pixelSize: 11
            }

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: Network.scannedNetworks
                delegate: Rectangle {
                    width: ListView.view.width
                    height: 26
                    color: mouse.containsMouse ? "#3c3836" : "transparent"
                    radius: 4

                    Text {
                        text: modelData
                        font.family: "JetBrainsMono Nerd Font"
                        color: Theme.foreground
                        font.pixelSize: 12
                    }
                    MouseArea {
                        id: mouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            Network.connect(modelData);
                            popup.visible = false;
                        }
                    }
                }
            }

            // Disconnect button code remains the same...
            Rectangle {
                Layout.fillWidth: true
                height: 24
                color: Theme.red
                radius: 4
                visible: Network.connected

                Text {
                    anchors.centerIn: parent
                    text: "Disconnect"
                    color: "#1d2021"
                    font.bold: true
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Network.disconnect();
                        popup.visible = false;
                    }
                }
            }
        }
    }
}
