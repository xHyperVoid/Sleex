<<<<<<< HEAD
import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
=======
import "root:/"
import "root:/services"
import "root:/modules/common"
import "root:/modules/common/widgets"
import "root:/modules/common/functions/file_utils.js" as FileUtils
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Hyprland

Item {
    id: root
    readonly property var keybinds: HyprlandKeybinds.keybinds
<<<<<<< HEAD
    property real spacing: 16
    property real titleSpacing: 8
    width: 800
    height: 600
=======
    property real spacing: 20
    property real titleSpacing: 7
    implicitWidth: rowLayout.implicitWidth
    implicitHeight: rowLayout.implicitHeight
>>>>>>> fa28d8f (Initial commit of the quickshell migration)

    property var keyBlacklist: ["Super_L"]
    property var keySubstitutions: ({
        "Super": "󰖳",
<<<<<<< HEAD
        // "Super": "⌘", // Just for you, Grace
        "mouse_up": "Scroll ↓",
        "mouse_down": "Scroll ↑",
=======
        "mouse_up": "Scroll ↓",    // ikr, weird
        "mouse_down": "Scroll ↑",  // trust me bro
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
        "mouse:272": "LMB",
        "mouse:273": "RMB",
        "mouse:275": "MouseBack",
        "Slash": "/",
        "Hash": "#",
        "Return": "Enter",
<<<<<<< HEAD
    })

    Flickable {
        id: flick
        anchors.fill: parent
        contentWidth: root.width
        contentHeight: layout.implicitHeight
        boundsBehavior: Flickable.StopAtBounds
        interactive: true
        clip: true

        ColumnLayout {
            id: layout
            width: root.width
            spacing: root.spacing

            Repeater {
                model: keybinds.children

                delegate: ColumnLayout {
                    spacing: root.titleSpacing
                    required property var modelData
                    width: parent.width

                    StyledText {
                        text: modelData.name
                        font.pixelSize: Appearance.font.pixelSize.huge
                        font.family: Appearance.font.family.title
                        color: Appearance.colors.colOnLayer0
                        wrapMode: Text.Wrap
                    }

                    Repeater {
                        model: modelData.children

                        delegate: ColumnLayout {
                            spacing: root.titleSpacing
                            required property var modelData
                            width: parent.width

                            StyledText {
                                text: modelData.name
                                font.pixelSize: Appearance.font.pixelSize.large
                                font.family: Appearance.font.family.title
                                color: Appearance.colors.colOnLayer0
                                wrapMode: Text.Wrap
                            }

                            Repeater {
                                model: modelData.keybinds

                                delegate: RowLayout {
                                    spacing: 10
                                    width: parent.width

                                    // Key sequence column, fixed width for alignment
                                    Item {
                                        Layout.preferredWidth: 250
                                        Layout.preferredHeight: 25
                                        Layout.alignment: Qt.AlignLeft

                                        RowLayout {
                                            id: keyRow
                                            spacing: 4
                                            anchors.verticalCenter: parent.verticalCenter

                                            Repeater {
                                                model: modelData.mods
                                                delegate: KeyboardKey {
                                                    required property var modelData
                                                    key: keySubstitutions[modelData] || modelData
                                                }
                                            }

                                            StyledText {
                                                visible: !keyBlacklist.includes(modelData.key) && modelData.mods.length > 0
                                                text: "+"
                                            }

                                            KeyboardKey {
                                                visible: !keyBlacklist.includes(modelData.key)
                                                key: keySubstitutions[modelData.key] || modelData.key
                                                color: Appearance.colors.colOnLayer0
=======
        // "Shift": "",
    })

    RowLayout { // Keybind columns
        id: rowLayout
        spacing: root.spacing
        Repeater {
            model: keybinds.children
            
            delegate: ColumnLayout { // Keybind sections
                spacing: root.spacing
                required property var modelData
                Layout.alignment: Qt.AlignTop
                Repeater {
                    model: modelData.children

                    delegate: Item { // Section with real keybinds
                        required property var modelData
                        implicitWidth: sectionColumnLayout.implicitWidth
                        implicitHeight: sectionColumnLayout.implicitHeight
                        ColumnLayout {
                            id: sectionColumnLayout
                            anchors.centerIn: parent
                            spacing: root.titleSpacing
                            StyledText {
                                id: sectionTitle
                                font.family: Appearance.font.family.title
                                font.pixelSize: Appearance.font.pixelSize.huge
                                color: Appearance.colors.colOnLayer0
                                text: modelData.name
                            }

                            GridLayout {
                                id: keybindGrid
                                columns: 2
                                Repeater {
                                    model: {
                                        var result = [];
                                        for (var i = 0; i < modelData.keybinds.length; i++) {
                                            const keybind = modelData.keybinds[i];
                                            result.push({
                                                "type": "keys",
                                                "mods": keybind.mods,
                                                "key": keybind.key,
                                            });
                                            result.push({
                                                "type": "comment",
                                                "comment": keybind.comment,
                                            });
                                        }
                                        return result;
                                    }
                                    delegate: Item {
                                        required property var modelData
                                        implicitWidth: keybindLoader.implicitWidth
                                        implicitHeight: keybindLoader.implicitHeight

                                        Loader {
                                            id: keybindLoader
                                            sourceComponent: (modelData.type === "keys") ? keysComponent : commentComponent
                                        }

                                        Component {
                                            id: keysComponent
                                            RowLayout {
                                                spacing: 4
                                                Repeater {
                                                    model: modelData.mods
                                                    delegate: KeyboardKey {
                                                        required property var modelData
                                                        key: keySubstitutions[modelData] || modelData
                                                    }
                                                }
                                                StyledText {
                                                    id: keybindPlus
                                                    visible: !keyBlacklist.includes(modelData.key) && modelData.mods.length > 0
                                                    Layout.alignment: Qt.AlignVCenter
                                                    text: "+"
                                                }
                                                KeyboardKey {
                                                    id: keybindKey
                                                    visible: !keyBlacklist.includes(modelData.key)
                                                    key: keySubstitutions[modelData.key] || modelData.key
                                                    color: Appearance.colors.colOnLayer0
                                                }
                                            }
                                        }

                                        Component {
                                            id: commentComponent
                                            Item {
                                                id: commentItem
                                                implicitWidth: commentText.implicitWidth + 8 * 2
                                                implicitHeight: commentText.implicitHeight

                                                StyledText {
                                                    id: commentText
                                                    anchors.centerIn: parent
                                                    font.pixelSize: Appearance.font.pixelSize.smaller
                                                    text: modelData.comment
                                                }
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
                                            }
                                        }
                                    }

<<<<<<< HEAD
                                    // Description, fills remaining space
                                    StyledText {
                                        text: modelData.comment
                                        font.pixelSize: Appearance.font.pixelSize.smaller
                                        wrapMode: Text.Wrap
                                        Layout.fillWidth: true
                                    }
=======
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
                                }
                            }
                        }
                    }
<<<<<<< HEAD
                }
            }
        }
    }
=======

                }
            }
            
        }
    }
    
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
}