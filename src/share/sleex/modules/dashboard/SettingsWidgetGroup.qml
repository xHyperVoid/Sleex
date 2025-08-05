<<<<<<< HEAD
import qs.modules.common
import qs.modules.common.widgets
import qs.services
=======
import "root:/modules/common"
import "root:/modules/common/widgets"
import "root:/services"
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
import "./volumeMixer"
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: root
    color: Appearance.colors.colLayer0

    RowLayout {
        id: mainCols
        anchors.fill: parent
        spacing: 10
        
        Rectangle {
                color: Appearance.colors.colLayer1
                radius: Appearance.rounding.normal
                Layout.fillWidth: true
                Layout.fillHeight: true
<<<<<<< HEAD
                
                Text {
                    anchors.centerIn: parent
                    text: "Quick settings: coming soon"
                    color: Appearance.colors.colOnLayer1
                    font.pixelSize: 30
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }

=======
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
        }
        
        ColumnLayout {
            id: secondCol
            spacing: 10

            Rectangle {
                color: Appearance.colors.colLayer1
                radius: Appearance.rounding.normal
                Layout.fillWidth: true
                Layout.fillHeight: true
<<<<<<< HEAD

                Text {
                    anchors.centerIn: parent
                    text: "BT settings: coming soon"
                    color: Appearance.colors.colOnLayer1
                    font.pixelSize: 30
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }
=======
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
            }

            VolumeMixer {
                Layout.fillWidth: true
                Layout.fillHeight: true
                anchors.margins: 15
            }
        }
        
        ColumnLayout {
            id: thirdCol
            spacing: 10

            Rectangle {
                color: Appearance.colors.colLayer1
                radius: Appearance.rounding.normal
                Layout.fillWidth: true
                Layout.fillHeight: true
<<<<<<< HEAD

                Text {
                    anchors.centerIn: parent
                    text: "WiFi settings: coming soon"
                    color: Appearance.colors.colOnLayer1
                    font.pixelSize: 30
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }
=======
            }

            Rectangle {
                color: Appearance.colors.colLayer1
                radius: Appearance.rounding.normal
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Rectangle {
                color: Appearance.colors.colLayer1
                radius: Appearance.rounding.normal
                Layout.fillWidth: true
                Layout.fillHeight: true
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
            }
        }
    }

}