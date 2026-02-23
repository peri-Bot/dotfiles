import QtQuick
import QtQuick.Layouts
import Quickshell
import "../theme"
import qs.services

PopupWindow {
    id: popup

    width: 300
    implicitHeight: 400 // Max height
    visible: false
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 5
        anchors.rightMargin: 3

        color: Theme.background
        radius: 12
        border.color: Theme.border
        border.width: 2

        // Use a ColumnLayout for structure
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 10

            // --- HEADER ---
            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "Notifications"
                    font.family: "JetBrainsMono Nerd Font"
                    color: Theme.foreground
                    font.bold: true
                    font.pixelSize: 14
                }
                Item {
                    Layout.fillWidth: true
                }

                // Clear All Button
                Rectangle {
                    width: 24
                    height: 24
                    radius: 4
                    color: clearMouse.containsMouse ? Theme.red : "transparent"
                    visible: Notifications.count > 0

                    Image {
                        anchors.centerIn: parent
                        source: "../assets/icons/delete.svg"
                        width: 16
                        height: 16
                        fillMode: Image.PreserveAspectFit
                        // Tint black if hovering red background, else red
                        opacity: 0.8
                    }
                    MouseArea {
                        id: clearMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: Notifications.dismissAll()
                    }
                }
            }

            Rectangle {
                height: 1
                Layout.fillWidth: true
                color: "#504945"
            }

            // --- LIST ---
            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 8
                model: Notifications.list

                // Empty State
                Text {
                    visible: Notifications.count === 0
                    anchors.centerIn: parent
                    text: "No notifications"
                    color: Theme.foreground
                    opacity: 0.5
                }

                delegate: Rectangle {
                    width: ListView.view.width
                    height: contentCol.implicitHeight + 16
                    color: "#3c3836" // Lighter background for items
                    radius: 8

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 10

                        // Content
                        ColumnLayout {
                            id: contentCol
                            Layout.fillWidth: true
                            spacing: 2

                            // App Name
                            Text {
                                text: modelData["app-name"]
                                color: Theme.blue
                                font.bold: true
                                font.pixelSize: 11
                            }
                            // Summary (Title)
                            Text {
                                text: modelData["summary"]
                                color: Theme.foreground
                                font.bold: true
                                font.pixelSize: 12
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                            // Body
                            Text {
                                text: modelData["body"]
                                color: Theme.foreground
                                opacity: 0.8
                                font.pixelSize: 11
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                                maximumLineCount: 2
                            }
                        }

                        // Close Button for specific item
                        Rectangle {
                            width: 20
                            height: 20
                            radius: 10
                            color: closeMouse.containsMouse ? Theme.red : "transparent"

                            Image {
                                anchors.centerIn: parent
                                source: "../assets/icons/close.svg"
                                width: 14
                                height: 14
                            }
                            MouseArea {
                                id: closeMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: Notifications.dismiss(modelData.id.data)
                            }
                        }
                    }

                    // Click item to invoke (open app)
                    MouseArea {
                        z: -1 // Behind the close button
                        anchors.fill: parent
                        onClicked: Notifications.invoke(modelData.id.data)
                    }
                }
            }
        }
    }
}
