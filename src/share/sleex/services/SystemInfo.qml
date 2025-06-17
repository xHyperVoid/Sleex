pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

/**
 * Provides some system info: distro, username.
 */
Singleton {
    property string distroName: "Unknown"
    property string distroId: "unknown"
    property string distroIcon: "linux-symbolic"
    property string username: "user"

    Timer {
        triggeredOnStart: true
        interval: 10
        running: true
        repeat: false
        onTriggered: {
            getUsername.running = true
            fileOsRelease.reload()
            const textOsRelease = fileOsRelease.text()

            // Extract the friendly name (PRETTY_NAME field, fallback to NAME)
            const prettyNameMatch = textOsRelease.match(/^PRETTY_NAME="(.+?)"/m)
            const nameMatch = textOsRelease.match(/^NAME="(.+?)"/m)
            distroName = prettyNameMatch ? prettyNameMatch[1] : (nameMatch ? nameMatch[1].replace(/Linux/i, "").trim() : "Unknown")

            // Extract the ID (LOGO field, fallback to "unknown")
            const logoMatch = textOsRelease.match(/^LOGO=(.+)$/m)
            distroId = logoMatch ? logoMatch[1].replace(/"/g, "") : "unknown"

            // Update the distroIcon property based on distroId
            switch (distroId) {
                case "axos": distroIcon = "axos-symbolic"; break;
                default: distroIcon = "linux-symbolic"; break;
            }
        }
    }

    Process {
        id: getUsername
        command: ["whoami"]
        stdout: {
            onRead: data => {
                username = data.trim();
            }
        }
    }

    FileView {
        id: fileOsRelease
        path: "/etc/os-release"
    }
}