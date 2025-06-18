import "root:/modules/common"
import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton
pragma ComponentBehavior: Bound

Singleton {
    id: root
    property int contribution_number
    property string author: "levraiardox"

    Timer {
        interval: 600000 // 10 minutes
        running: true
        repeat: true
        onTriggered: {
            getContributions.running = true;
        }
    }

    Process {
        id: getContributions
        running: true
        command: ["curl", `https://github-contributions.vercel.app/api/v1/${root.author}`]
        stdout: StdioCollector {
            onStreamFinished: {
                const json = JSON.parse(text).years[0]
                root.contribution_number = json.total
            }
        }    
    }
}
