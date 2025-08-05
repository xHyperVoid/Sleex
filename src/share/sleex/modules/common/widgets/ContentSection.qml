import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

ColumnLayout {
    id: root
    property string title
    property color backgroundColor: Appearance.colors.colLayer1
    default property alias data: sectionContent.data

    Layout.fillWidth: true
    spacing: 8
    
    StyledText {
        text: root.title
        font.pixelSize: Appearance.font.pixelSize.larger
        font.weight: Font.Medium
    }
    
    Rectangle {
        Layout.fillWidth: true
        implicitHeight: sectionContent.implicitHeight + 24 // Content height + padding
        color: root.backgroundColor
        radius: 8 // Optional: rounded corners
        
        ColumnLayout {
            id: sectionContent
            anchors.fill: parent
            anchors.margins: 12 // Padding inside the background
            spacing: 4
        }
    }
}