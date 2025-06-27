pragma Singleton

import "root:/modules/common/functions/file_utils.js" as FileUtils
import "root:/modules/common"
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
    id: root
    property string firstRunFilePath: `${Directories.state}/user/first_run.txt`
    property string firstRunFileContent: "This file is just here to confirm you've been greeted :>"
    property string firstRunNotifSummary: "Welcome!"
    property string firstRunNotifBody: "Hit Super+/ for a list of keybinds"
    property string defaultWallpaperPath: FileUtils.trimFileProtocol(`${Directories.home}/.sleex/wallpapers/sakura.png`)
    property string welcomeQmlPath: FileUtils.trimFileProtocol(`/usr/share/sleex/welcome.qml`)

    function load() {
        firstRunFileView.reload()
    }

    function enableNextTime() {
        Hyprland.dispatch(`exec rm -f '${root.firstRunFilePath}'`)
    }
    function disableNextTime() {
        Hyprland.dispatch(`exec echo '${root.firstRunFileContent}' > '${root.firstRunFilePath}'`)
    }

    function handleFirstRun() {
        Hyprland.dispatch(`exec '${Directories.wallpaperSwitchScriptPath}' '${root.defaultWallpaperPath}'`)
        Hyprland.dispatch(`exec qs -p '${root.welcomeQmlPath}'`)
    }

    FileView {
        id: firstRunFileView
        path: Qt.resolvedUrl(firstRunFilePath)
        onLoadFailed: (error) => {
            if (error == FileViewError.FileNotFound) {
                firstRunFileView.setText(root.firstRunFileContent)
                root.handleFirstRun()
            }
        }
    }
}
