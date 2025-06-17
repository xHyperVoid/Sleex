import "root:/modules/common"
import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton
pragma ComponentBehavior: Bound

Singleton {
    property int contribution_number: 0

    Timer {
        interval: 600
        running: true
        repeat: true
        onTriggered: getContributions.start()
    }

    Process {
        id: getContributions
        running: true
        command: ["curl", "-s", "https://github-contributions.vercel.app/api/v1/levraiardox"]
        stdout: StdioCollector {
            onRead: data => {
                if (data) {
                    const parsed = JSON.parse(data);
                    contribution_number = parsed.years?.[0]?.total || 0;
                } else {
                    contribution_number = 42;
                }
            }
        }
    }

}
