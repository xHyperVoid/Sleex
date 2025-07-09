import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import "root:/services/"
import "root:/modules/common/"
import "root:/modules/common/widgets/"

ContentPage {
    forceWidth: true

    Text {
        text: "Coming soon"
        color: Appearance.colors.colOnLayer1
        font.pixelSize: 30
        font.bold: true
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
    }
}