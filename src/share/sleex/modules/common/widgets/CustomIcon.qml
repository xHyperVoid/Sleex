import QtQuick
import Quickshell
import Quickshell.Widgets

Item {
    id: root
    
    property string source: ""
<<<<<<< HEAD
    property string iconFolder: Qt.resolvedUrl(Quickshell.shellPath("assets/icons"))  // The folder to check first
=======
    property string iconFolder: "root:/assets/icons"  // The folder to check first
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
    width: 30
    height: 30
    
    IconImage {
        id: iconImage
        anchors.fill: parent
        source: {
            if (iconFolder && iconFolder + "/" + root.source) {
                return iconFolder + "/" + root.source
            }
            return root.source
        }
        implicitSize: root.height
    }
}
