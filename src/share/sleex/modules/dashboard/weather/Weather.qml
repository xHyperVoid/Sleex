import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.services

Rectangle {
    id: weatherRoot
    width: 440
    height: 100
    color: "transparent"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 12

        RowLayout {
            spacing: 12
            Layout.fillWidth: true

            // Weather icon (simple example)
            Text {
                text: Weather.condition.indexOf("rain") >= 0 ? "rainy" :
                      Weather.condition.indexOf("cloud") >= 0 ? "cloud" :
                      Weather.condition.indexOf("sun") >= 0 ? "sunny" : "cloud"
                font.family: "Material Symbols Outlined"
                font.pixelSize: 28
                color: Theme.accentPrimary
                Layout.alignment: Qt.AlignVCenter
            }

            ColumnLayout {
                spacing: 2
                Text {
                    text: Weather.loc
                    font.pixelSize: 14
                    font.bold: true
                    color: Theme.textPrimary
                }
                Text {
                    text: Weather.temperature
                    font.pixelSize: 24
                    font.bold: true
                    color: Theme.textPrimary
                }
                Text {
                    text: Weather.condition
                    font.pixelSize: 12
                    color: Theme.textSecondary
                }
            }
            Item { Layout.fillWidth: true }
        }
    }
}