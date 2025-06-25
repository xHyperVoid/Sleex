import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "root:/services/"
import "root:/modules/common/"
import "root:/modules/common/widgets/"

ContentPage {
    forceWidth: true
    ContentSection {
        title: "Audio"
        ConfigSwitch {
            text: "Earbang protection"
            checked: ConfigOptions.audio.protection.enable
            onCheckedChanged: {
                ConfigLoader.setConfigValueAndSave("audio.protection.enable", checked);
            }
            StyledToolTip {
                content: "Prevents abrupt increments and restricts volume limit"
            }
        }
    }
    ContentSection {
        title: "AI"
        MaterialTextField {
            id: systemPromptField
            Layout.fillWidth: true
            placeholderText: "System prompt"
            text: ConfigOptions.ai.systemPrompt
            wrapMode: TextEdit.Wrap
            onTextChanged: {
                ConfigLoader.setConfigValueAndSave("ai.systemPrompt", text);
            }
        }
    }

    ContentSection {
        title: "Bar"

        ContentSubsection {
            title: "Workspaces"
            tooltip: "Tip: Hide icons and always show numbers for\nthe classic Sleex experience"

            ConfigRow {
                uniform: true
                ConfigSwitch {
                    text: 'Show app icons'
                    checked: ConfigOptions.bar.workspaces.showAppIcons
                    onCheckedChanged: {
                        ConfigLoader.setConfigValueAndSave("bar.workspaces.showAppIcons", checked);
                    }
                }
                ConfigSwitch {
                    text: 'Always show numbers'
                    checked: ConfigOptions.bar.workspaces.alwaysShowNumbers
                    onCheckedChanged: {
                        ConfigLoader.setConfigValueAndSave("bar.workspaces.alwaysShowNumbers", checked);
                    }
                }
            }
            ConfigSpinBox {
                text: "Workspaces shown"
                value: ConfigOptions.bar.workspaces.shown
                from: 1
                to: 30
                stepSize: 1
                onValueChanged: {
                    ConfigLoader.setConfigValueAndSave("bar.workspaces.shown", value);
                }
            }
            ConfigSpinBox {
                text: "Number show delay when pressing Super (ms)"
                value: ConfigOptions.bar.workspaces.showNumberDelay
                from: 0
                to: 1000
                stepSize: 50
                onValueChanged: {
                    ConfigLoader.setConfigValueAndSave("bar.workspaces.showNumberDelay", value);
                }
            }
        }   
    }

    ContentSection {
        title: "Dashboard"

        MaterialTextField {
            id: ghUsername
            Layout.fillWidth: true
            placeholderText: "Github username"
            text: ConfigOptions.dashboard.ghUsername
            wrapMode: TextEdit.Wrap
            onTextChanged: {
                ConfigLoader.setConfigValueAndSave("dashboard.ghUsername", text);
            }
        }

    }

    ContentSection {
        title: "Battery"

        ConfigRow {
            uniform: true
            ConfigSpinBox {
                text: "Low warning"
                value: ConfigOptions.battery.low
                from: 0
                to: 100
                stepSize: 5
                onValueChanged: {
                    ConfigLoader.setConfigValueAndSave("battery.low", value);
                }
            }
            ConfigSpinBox {
                text: "Critical warning"
                value: ConfigOptions.battery.critical
                from: 0
                to: 100
                stepSize: 5
                onValueChanged: {
                    ConfigLoader.setConfigValueAndSave("battery.critical", value);
                }
            }
        }
    }
}