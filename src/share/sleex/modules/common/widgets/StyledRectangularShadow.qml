import QtQuick
import QtQuick.Effects
<<<<<<< HEAD
import qs.modules.common
=======
import "root:/modules/common"
>>>>>>> fa28d8f (Initial commit of the quickshell migration)

RectangularShadow {
    required property var target
    anchors.fill: target
    radius: target.radius
<<<<<<< HEAD
    blur: 0.9 * Appearance.sizes.elevationMargin
    offset: Qt.vector2d(0.0, 1.0)
=======
    blur: 1.2 * Appearance.sizes.elevationMargin
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
    spread: 1
    color: Appearance.colors.colShadow
    cached: true
}
