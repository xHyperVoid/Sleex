import QtQuick
import Quickshell
import "root:/modules/common/"
import "root:/modules/common/widgets/"
import "root:/modules/settings/volumeMixer"

ContentPage {
    forceWidth: true

    ContentSection {
        title: "Audio"

        VolumeMixer {
            Layout.fillWidth: true
            Layout.fillHeight: true
            anchors.margins: 15
        }
    }
}