<<<<<<< HEAD
import qs.modules.common
=======
import "root:/modules/common"
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
import QtQuick
import Quickshell

/**
 * Recreation of GTK revealer. Expects one single child.
 */
Item {
    id: root
    property bool reveal
    property bool vertical: false
    clip: true

    implicitWidth: (reveal || vertical) ? childrenRect.width : 0
    implicitHeight: (reveal || !vertical) ? childrenRect.height : 0
<<<<<<< HEAD
    visible: reveal || (width > 0 && height > 0)
=======
    visible: reveal && width > 0 && height > 0
>>>>>>> fa28d8f (Initial commit of the quickshell migration)

    Behavior on implicitWidth {
        enabled: !vertical
        animation: Appearance.animation.elementMoveEnter.numberAnimation.createObject(this)
    }
    Behavior on implicitHeight {
        enabled: vertical
        animation: Appearance.animation.elementMoveEnter.numberAnimation.createObject(this)
    }
}
