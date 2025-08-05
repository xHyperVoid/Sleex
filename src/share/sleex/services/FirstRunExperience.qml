pragma Singleton

<<<<<<< HEAD
import qs.modules.common.functions
import qs.modules.common
=======
import "root:/modules/common/functions/file_utils.js" as FileUtils
import "root:/modules/common"
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
    id: root
<<<<<<< HEAD
    property string firstRunFilePath: `${Directories.state}/sleex/user/first_run.txt`
    property string firstRunScriptPath: `/usr/share/sleex/scripts/firstRun.sh`
    property string firstRunFileContent: "This file is just here to confirm you've been greeted :>"
    property string defaultWallpaperPath: FileUtils.trimFileProtocol(`/usr/share/sleex/wallpapers/skyline.jpg`)
    property string welcomeNotifTitle: "Welcome to Sleex!"
    property string welcomeNotifBody: "First run? 👀 For a list of keybinds, hit Super + F1"
=======
    property string firstRunFilePath: `${Directories.state}/user/first_run.txt`
    property string firstRunFileContent: "This file is just here to confirm you've been greeted :>"
    property string firstRunNotifSummary: "Welcome!"
    property string firstRunNotifBody: "Hit Super+/ for a list of keybinds"
    property string defaultWallpaperPath: FileUtils.trimFileProtocol(`${Directories.home}/.sleex/wallpapers/sakura.png`)
    property string welcomeQmlPath: FileUtils.trimFileProtocol(`${Directories.config}/quickshell/welcome.qml`)
>>>>>>> fa28d8f (Initial commit of the quickshell migration)

    function load() {
        firstRunFileView.reload()
    }

    function enableNextTime() {
<<<<<<< HEAD
        Quickshell.execDetached(["bash", "-c", `rm -f ${root.firstRunFilePath}`]) 
    }
    function disableNextTime() {
        Quickshell.execDetached(["bash", "-c", `echo ${root.firstRunFileContent} > ${root.firstRunFilePath}`])
    }

    function handleFirstRun() {
        Quickshell.execDetached(["bash", "-c", `${Directories.wallpaperSwitchScriptPath} ${root.defaultWallpaperPath} --mode dark`])
        Quickshell.execDetached(["sh", `${root.firstRunScriptPath}`])
        Quickshell.execDetached(['bash', '-c', `sleep 0.5; notify-send '${root.welcomeNotifTitle}' '${root.welcomeNotifBody}' -a 'Sleex' &`])
        Quickshell.reload(true)
    }


=======
        Hyprland.dispatch(`exec rm -f '${root.firstRunFilePath}'`)
    }
    function disableNextTime() {
        Hyprland.dispatch(`exec echo '${root.firstRunFileContent}' > '${root.firstRunFilePath}'`)
    }

    function handleFirstRun() {
        Hyprland.dispatch(`exec '${Directories.wallpaperSwitchScriptPath}' '${root.defaultWallpaperPath}'`)
        Hyprland.dispatch(`exec qs -p '${root.welcomeQmlPath}'`)
    }

>>>>>>> fa28d8f (Initial commit of the quickshell migration)
    FileView {
        id: firstRunFileView
        path: Qt.resolvedUrl(firstRunFilePath)
        onLoadFailed: (error) => {
            if (error == FileViewError.FileNotFound) {
<<<<<<< HEAD
                root.handleFirstRun()
                firstRunFileView.setText(root.firstRunFileContent)
            }
        }
    }

=======
                firstRunFileView.setText(root.firstRunFileContent)
                root.handleFirstRun()
            }
        }
    }
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
}
