import "root:/modules/common"
import "root:/modules/common/widgets"
import "root:/services"
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
        }
        
        ColumnLayout {
            id: secondCol
            spacing: 10

            Rectangle {
                color: Appearance.colors.colLayer1
                radius: Appearance.rounding.normal
                Layout.fillWidth: true
                Layout.fillHeight: true
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
            }
        }
    }

}