import QtQuick
import Quickshell
import qs.modules.common
import qs.modules.common.widgets
import "./volumeMixer"

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