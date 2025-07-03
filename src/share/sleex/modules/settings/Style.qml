import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import "root:/services/"
import "root:/modules/common/"
import "root:/modules/common/widgets/"
import "root:/modules/common/functions/color_utils.js" as ColorUtils
import "root:/modules/common/functions/file_utils.js" as FileUtils

ContentPage {
    baseWidth: lightDarkButtonGroup.implicitWidth
    forceWidth: true

    ContentSection {
        title: "Colors & Wallpaper"

        // Light/Dark mode preference
        ButtonGroup {
            id: lightDarkButtonGroup
            Layout.fillWidth: true
            LightDarkPreferenceButton {
                dark: false
            }
            LightDarkPreferenceButton {
                dark: true
            }
        }

        // Material palette selection
        StyledText {
            text: "Material palette"
            color: Appearance.colors.colSubtext
        }
         ConfigSelectionArray {
            currentValue: Config.options.appearance.palette.type
            configOptionName: "appearance.palette.type"
            onSelected: (newValue) => {
                Config.options.appearance.palette.type = newValue;
            }
            options: [
                {"value": "auto", "displayName": "Auto"},
                {"value": "scheme-content", "displayName": "Content"},
                {"value": "scheme-expressive", "displayName": "Expressive"},
                {"value": "scheme-fidelity", "displayName": "Fidelity"},
                {"value": "scheme-fruit-salad", "displayName": "Fruit Salad"},
                {"value": "scheme-monochrome", "displayName": "Monochrome"},
                {"value": "scheme-neutral", "displayName": "Neutral"},
                {"value": "scheme-rainbow", "displayName": "Rainbow"},
                {"value": "scheme-tonal-spot", "displayName": "Tonal Spot"},
            ]

        }

        // Wallpaper selection
        StyledText {
            text: "Wallpaper"
            color: Appearance.colors.colSubtext
        }
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            RippleButtonWithIcon {
                materialIcon: "wallpaper"
                StyledToolTip {
                    content: "Pick wallpaper image on your system"
                }
                onClicked: {
                    Hyprland.dispatch(`exec ${Directories.wallpaperSwitchScriptPath}`)
                }
                mainContentComponent: Component {
                    RowLayout {
                        spacing: 10
                        StyledText {
                            font.pixelSize: Appearance.font.pixelSize.small
                            text: "Choose file"
                            color: Appearance.colors.colOnSecondaryContainer
                        }
                        RowLayout {
                            spacing: 3
                            KeyboardKey {
                                key: "Ctrl"
                            }
                            KeyboardKey {
                                key: "󰖳"
                            }
                            StyledText {
                                Layout.alignment: Qt.AlignVCenter
                                text: "+"
                            }
                            KeyboardKey {
                                key: "T"
                            }
                        }
                    }
                }
            }
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: "Change any time later with /dark, /light, /img in the launcher"
            font.pixelSize: Appearance.font.pixelSize.smaller
            color: Appearance.colors.colSubtext
        }
    
    }

    ContentSection {
        title: "Shell style"

        ConfigSwitch {
            text: "Transparency"
            checked: Config.options.appearance.transparency
            onClicked: checked = !checked;
            // onCheckedChanged: {
            //     Config.options.appearance.transparency = checked;
            // }
            StyledToolTip {
                content: "Not yet implemented."
            }
        }
    }
    

    ContentSection {
        title: "Shell windows"
        spacing: 4

        RowLayout {
            spacing: 10
            uniformCellSizes: true

            ConfigSwitch {
                text: "Title bar"
                checked: Config.options.windows.showTitlebar
                onClicked: checked = !checked;
                onCheckedChanged: {
                    Config.options.windows.showTitlebar = checked;
                }
            }

            ConfigSwitch {
                text: "Center title"
                checked: Config.options.windows.centerTitle
                onClicked: checked = !checked;
                onCheckedChanged: {
                    Config.options.windows.centerTitle = checked;
                }
            }
        }
    }

    ContentSection {
        title: "Bar"

        RowLayout {
            spacing: 10
            uniformCellSizes: true


            ConfigSwitch {
                text: "Show app name"
                checked: Config.options.bar.showTitle
                onClicked: checked = !checked;
                onCheckedChanged: {
                    Config.options.bar.showTitle = checked;
                }
            }

            ConfigSwitch {
                text: "Show ressources usage"
                checked: Config.options.bar.showRessources
                onClicked: checked = !checked;
                onCheckedChanged: {
                    Config.options.bar.showRessources = checked;
                }
            }
        }

        RowLayout {
            spacing: 10
            uniformCellSizes: true

            ConfigSwitch {
                text: "Show Workspaces"
                checked: Config.options.bar.showWorkspaces
                onClicked: checked = !checked;
                onCheckedChanged: {
                    Config.options.bar.showWorkspaces = checked;
                }
            }

            ConfigSwitch {
                text: "Show clock"
                checked: Config.options.bar.showClock
                onClicked: checked = !checked;
                onCheckedChanged: {
                    Config.options.bar.showClock = checked;
                }
            }
        }

        ConfigSwitch {
            text: "Show tray and system icons"
            checked: Config.options.bar.showTrayAndIcons
            onClicked: checked = !checked;
            onCheckedChanged: {
                Config.options.bar.showTrayAndIcons = checked;
            }
        }
    }
}