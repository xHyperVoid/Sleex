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
        Flow {
            id: paletteFlow
            Layout.fillWidth: true
            spacing: 2
            property list<var> palettes: [
                {"value": "auto", "displayName": "Auto"},
                {"value": "scheme-content", "displayName": "Content"},
                {"value": "scheme-expressive", "displayName": "Expressive"},
                {"value": "scheme-fidelity", "displayName": "Fidelty"},
                {"value": "scheme-fruit-salad", "displayName": "Fruit Salad"},
                {"value": "scheme-monochrome", "displayName": "Monochrome"},
                {"value": "scheme-neutral", "displayName": "Neutral"},
                {"value": "scheme-rainbow", "displayName": "Rainbow"},
                {"value": "scheme-tonal-spot", "displayName": "Tonal Spot"},
            ]

            Repeater {
                model: paletteFlow.palettes
                delegate: SelectionGroupButton {
                    id: paletteButton
                    required property var modelData
                    required property int index
                    onYChanged: {
                        if (index === 0) {
                            paletteButton.leftmost = true
                        } else {
                            var prev = paletteFlow.children[index - 1]
                            var thisIsOnNewLine = prev && prev.y !== paletteButton.y
                            paletteButton.leftmost = thisIsOnNewLine
                            prev.rightmost = thisIsOnNewLine
                        }
                    }
                    leftmost: index === 0
                    rightmost: index === paletteFlow.palettes.length - 1
                    buttonText: modelData.displayName;
                    toggled: ConfigOptions.appearance.palette.type === modelData.value
                    onClicked: {
                        ConfigLoader.setConfigValueAndSave("appearance.palette.type", modelData.value);
                    }
                }
            }
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
            checked: ConfigOptions.appearance.transparency
            onClicked: checked = !checked;
            // onCheckedChanged: {
            //     ConfigLoader.setConfigValueAndSave("appearance.transparency", checked);
            // }
            StyledToolTip {
                content: "Not yet implemented."
            }
        }
    }
    

    ContentSection {
        title: "Shell windows"

        ConfigSwitch {
            text: "Title bar"
            checked: ConfigOptions.windows.showTitlebar
            onClicked: checked = !checked;
            onCheckedChanged: {
                ConfigLoader.setConfigValueAndSave("windows.showTitlebar", checked);
            }
        }
    }

    ContentSection {
        title: "Bar"

        ConfigSwitch {
            text: "Show app name"
            checked: ConfigOptions.bar.showTitle
            onClicked: checked = !checked;
            onCheckedChanged: {
                ConfigLoader.setConfigValueAndSave("bar.showTitle", checked);
            }
        }

        ConfigSwitch {
            text: "Show system ressources usage"
            checked: ConfigOptions.bar.showRessources
            onClicked: checked = !checked;
            onCheckedChanged: {
                ConfigLoader.setConfigValueAndSave("bar.showRessources", checked);
            }
        }

        ConfigSwitch {
            text: "Show Workspaces"
            checked: ConfigOptions.bar.showWorkspaces
            onClicked: checked = !checked;
            onCheckedChanged: {
                ConfigLoader.setConfigValueAndSave("bar.showWorkspaces", checked);
            }
        }

        ConfigSwitch {
            text: "Show clock"
            checked: ConfigOptions.bar.showClock
            onClicked: checked = !checked;
            onCheckedChanged: {
                ConfigLoader.setConfigValueAndSave("bar.showClock", checked);
            }
        }

        ConfigSwitch {
            text: "Show tray and system icons"
            checked: ConfigOptions.bar.showTrayAndIcons
            onClicked: checked = !checked;
            onCheckedChanged: {
                ConfigLoader.setConfigValueAndSave("bar.showTrayAndIcons", checked);
            }
        }
    }
}