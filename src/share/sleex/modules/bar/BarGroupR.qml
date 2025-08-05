<<<<<<< HEAD
import qs.modules.common
import qs.modules.common.widgets
import qs.services
=======
import "root:/modules/common"
import "root:/modules/common/widgets"
import "root:/services"
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    property real padding: 5
    implicitHeight: 40
    implicitWidth: rowLayout.implicitWidth + padding * 2
    default property alias items: rowLayout.children
<<<<<<< HEAD
    
=======

    Canvas {
        id: background
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            ctx.fillStyle = ConfigOptions?.bar.borderless ? "transparent" : Appearance.colors.colLayer0;
            ctx.beginPath();
            ctx.moveTo(0, 0);
            ctx.lineTo(width, 0);
            ctx.lineTo(width, height - 20);
            ctx.quadraticCurveTo(width, height, width - 20, height); // bottom-right radius
            ctx.lineTo(0, height);
            ctx.lineTo(0, 0);
            ctx.closePath();
            ctx.fill();
        }
    }

>>>>>>> fa28d8f (Initial commit of the quickshell migration)
    RowLayout {
        id: rowLayout
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
            leftMargin: root.padding
            rightMargin: root.padding
        }
        spacing: 4

    }
}