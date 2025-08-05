pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

/**
<<<<<<< HEAD
 * Provides some system info: distro, username etc...
=======
 * Provides some system info: distro, username.
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
 */
Singleton {
    property string distroName: "Unknown"
    property string distroId: "unknown"
    property string distroIcon: "linux-symbolic"
    property string username: "user"
<<<<<<< HEAD
    property string axosVersion: ""

    property string sleexVersion: "Unknown"
=======
>>>>>>> fa28d8f (Initial commit of the quickshell migration)

    Timer {
        triggeredOnStart: true
        interval: 10
        running: true
        repeat: false
        onTriggered: {
            getUsername.running = true
<<<<<<< HEAD
            getSleexVersion.running = true
=======
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
            fileOsRelease.reload()
            const textOsRelease = fileOsRelease.text()

            // Extract the friendly name (PRETTY_NAME field, fallback to NAME)
            const prettyNameMatch = textOsRelease.match(/^PRETTY_NAME="(.+?)"/m)
            const nameMatch = textOsRelease.match(/^NAME="(.+?)"/m)
            distroName = prettyNameMatch ? prettyNameMatch[1] : (nameMatch ? nameMatch[1].replace(/Linux/i, "").trim() : "Unknown")

<<<<<<< HEAD
            if (distroName == "AxOS") axosVersion = axosVersionFile.text()

=======
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
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
<<<<<<< HEAD
        stdout: SplitParser {
=======
        stdout: {
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
            onRead: data => {
                username = data.trim();
            }
        }
    }

<<<<<<< HEAD
    Process {
        id: getSleexVersion
        command: ["pacman", "-Q", "sleex"]
        stdout: SplitParser {
            onRead: data => {
                const versionMatch = data.match(/^sleex\s+(\S+)/);
                sleexVersion = versionMatch ? versionMatch[1].trim() : "Unknown";
            }
        }
    }

=======
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
    FileView {
        id: fileOsRelease
        path: "/etc/os-release"
    }
<<<<<<< HEAD

    FileView {
        id: axosVersionFile
        path: "/etc/axos-version"
    }
=======
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
}