pragma Singleton
pragma ComponentBehavior: Bound

<<<<<<< HEAD
import qs.modules.common.functions
=======
import "root:/modules/common/functions/file_utils.js" as FileUtils
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
import Qt.labs.platform
import QtQuick
import Quickshell
import Quickshell.Hyprland

Singleton {
    // XDG Dirs, with "file://"
<<<<<<< HEAD
    readonly property string config: StandardPaths.standardLocations(StandardPaths.GenericConfigLocation)[0]
    readonly property string state: StandardPaths.standardLocations(StandardPaths.GenericStateLocation)[0]
    readonly property string cache: StandardPaths.writableLocation(StandardPaths.GenericCacheLocation)
=======
    readonly property string config: StandardPaths.standardLocations(StandardPaths.ConfigLocation)[0]
    readonly property string state: StandardPaths.standardLocations(StandardPaths.StateLocation)[0]
    readonly property string cache: StandardPaths.standardLocations(StandardPaths.CacheLocation)[0]
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
    readonly property string pictures: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
    readonly property string downloads: StandardPaths.standardLocations(StandardPaths.DownloadLocation)[0]
    readonly property string home: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
    
    // Other dirs used by the shell, without "file://"
<<<<<<< HEAD
    property string favicons: FileUtils.trimFileProtocol(`${Directories.cache}/sleex/media/favicons`)
    property string coverArt: FileUtils.trimFileProtocol(`${Directories.cache}/sleex/media/coverart`)
    property string latexOutput: FileUtils.trimFileProtocol(`${Directories.cache}/sleex/media/latex`)
    property string shellConfig: FileUtils.trimFileProtocol(`${Directories.home}/.sleex`)
    property string shellConfigName: "settings.json"
    property string shellConfigPath: `${Directories.shellConfig}/${Directories.shellConfigName}`
    property string todoPath: FileUtils.trimFileProtocol(`${Directories.home}/.sleex/user/todo.json`)
    property string notificationsPath: FileUtils.trimFileProtocol(`${Directories.cache}/sleex/notifications/notifications.json`)
    property string generatedMaterialThemePath: FileUtils.trimFileProtocol(`${Directories.state}/sleex/user/generated/colors.json`)
    property string cliphistDecode: FileUtils.trimFileProtocol(`/tmp/sleex/media/cliphist`)
    property string wallpaperSwitchScriptPath: FileUtils.trimFileProtocol('/usr/share/sleex/scripts/colors/switchwall.sh')
    property string wallpaperPath: FileUtils.trimFileProtocol(`${Directories.shellConfig}/wallpapers`)


=======
    property string favicons: FileUtils.trimFileProtocol(`${Directories.cache}/media/favicons`)
    property string coverArt: FileUtils.trimFileProtocol(`${Directories.cache}/media/coverart`)
    property string latexOutput: FileUtils.trimFileProtocol(`${Directories.cache}/media/latex`)
    property string shellConfig: FileUtils.trimFileProtocol(`${Directories.home}/.sleex/`)
    property string shellConfigName: "settings.json"
    property string shellConfigPath: `${Directories.shellConfig}/${Directories.shellConfigName}`
    property string todoPath: FileUtils.trimFileProtocol(`${Directories.home}/.sleex/user/todo.json`)
    property string notificationsPath: FileUtils.trimFileProtocol(`${Directories.cache}/notifications/notifications.json`)
    property string generatedMaterialThemePath: FileUtils.trimFileProtocol(`${Directories.state}/user/generated/colors.json`)
    property string cliphistDecode: FileUtils.trimFileProtocol(`/tmp/sleex/media/cliphist`)
    property string wallpaperSwitchScriptPath: FileUtils.trimFileProtocol('/usr/share/sleex/scripts/switchwall.sh`)
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
    // Cleanup on init
    Component.onCompleted: {
        Hyprland.dispatch(`exec mkdir -p '${shellConfig}'`)
        Hyprland.dispatch(`exec mkdir -p '${favicons}'`)
        Hyprland.dispatch(`exec rm -rf '${coverArt}'; mkdir -p '${coverArt}'`)
        Hyprland.dispatch(`exec rm -rf '${latexOutput}'; mkdir -p '${latexOutput}'`)
        Hyprland.dispatch(`exec rm -rf '${cliphistDecode}'; mkdir -p '${cliphistDecode}'`)
    }
}
