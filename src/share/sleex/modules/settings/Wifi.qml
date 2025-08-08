import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Bluetooth
import qs.services
import qs.modules.common
import qs.modules.common.widgets

ContentPage {
    id: root
    forceWidth: true

    property string connectingToSsid: ""

    Rectangle {
        Layout.fillWidth: true
        height: childrenRect.height + 30
        color: "#40FF9800"
        radius: 6

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10

            Label {
                text: "🚧"
                font.pixelSize: 16 // Slightly smaller icon
                Layout.alignment: Qt.AlignVCenter
                rightPadding: 6
            }

            Label {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                text: "<b>WORK IN PROGRESS:</b> This module is incomplete. You can connect and disconnect to known devices, nothing else.</code>"
                font.pixelSize: 12
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                color: "white"
            }
        }
    }

    ContentSection {
        title: "Wifi settings"

        RowLayout {
            spacing: 10
            uniformCellSizes: true

            ConfigSwitch {
                text: "Enabled"
                checked: Network.wifiEnabled
                onCheckedChanged: {
                    Network.enableWifi(checked)
                }
            }
        }
    }

    RowLayout {
        spacing: 10

        StyledText {
            text: qsTr("%1 networks available").arg(Network.networks.length)
            color: Appearance.colors.colOnLayer0
            font.pixelSize: Appearance.font.pixelSize.huge
        }

        RippleButton {
            id: discoverBtn

            contentItem: Rectangle {
                id: discoverBtnBody
                radius: Appearance.rounding.full
                color: Network.scanning ? Appearance.m3colors.m3primary : Appearance.colors.colLayer2
                implicitWidth: height

                MaterialSymbol {
                    id: scanIcon

                    anchors.centerIn: parent
                    text: "replay"
                    color: Network.scanning ? Appearance.m3colors.m3onSecondary : Appearance.m3colors.m3onSecondaryContainer
                    fill: Network.scanning ? 1 : 0
                }
            }

            MouseArea {
                id: discoverArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: Network.rescanWifi();

                StyledToolTip {
                    extraVisibleCondition: discoverArea.containsMouse
                    content: "Rescan networks"
                }
            }
        }
    }

    ContentSection {

        Text {
            text: "Wifi diabled"
            color: Appearance.colors.colOnLayer1
            font.pixelSize: 30
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            visible: !Network.wifiEnabled
        }


        Repeater {
            model: ScriptModel {
                values: [...Network.networks].sort((a, b) => {
                    if (a.active !== b.active)
                        return b.active - a.active;
                    return b.strength - a.strength;
                }).slice(0, 8)
            }

            RowLayout {
                id: networkItem

                required property Network.AccessPoint modelData
                readonly property bool isConnecting: root.connectingToSsid === modelData.ssid
                readonly property bool loading: networkItem.isConnecting

                Layout.fillWidth: true
                spacing: 10

                RippleButton {
                    id: netCard
                    Layout.fillWidth: true
                    implicitHeight: contentItem.implicitHeight + 8 * 2

                    contentItem: RowLayout {
                        spacing: 10

                        RowLayout {

                            MaterialSymbol {
                                text: Network.getNetworkIcon(networkItem.modelData.strength)
                                font.pixelSize: Appearance.font.pixelSize.title
                                color: Appearance.colors.colOnSecondaryContainer
                            }

                            MaterialSymbol {
                                visible: networkItem.modelData.isSecure
                                text: "lock"
                                font.pixelSize: Appearance.font.pixelSize.larger
                                color: Appearance.colors.colOnSecondaryContainer
                            }

                        }

                        ColumnLayout {
                            id: cardTexts

                            StyledText {
                                Layout.fillWidth: true
                                text: networkItem.modelData.ssid
                                font.pixelSize: Appearance.font.pixelSize.large
                                font.weight: networkItem.modelData.active ? 500 : 400
                                color: networkItem.modelData.active ? Appearance.m3colors.m3primary : Appearance.colors.colOnLayer1
                            }
                        }

                        StyledSwitch {
                            scale: 0.80
                            Layout.fillWidth: false
                            checked: networkItem.modelData.active
                            onClicked: {
                                if (!checked) {
                                    Network.disconnectFromNetwork();
                                } else {
                                    root.connectingToSsid = networkItem.modelData.ssid;
                                    Network.connectToNetwork(networkItem.modelData.ssid, "");
                                }
                            }
                        }
                    }
                }
            }
        }
    }

}
