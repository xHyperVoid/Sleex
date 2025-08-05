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
import "root:/modules/common/functions/string_utils.js" as StringUtils
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
import "./quickToggles/"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import Quickshell.Io
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
<<<<<<< HEAD
    property int dashboardWidth: Appearance.sizes.dashboardWidth
    property int dashboardPadding: 15

    PanelWindow {
        id: dashboardRoot
=======
    property int sidebarWidth: Appearance.sizes.sidebarWidth
    property int sidebarPadding: 15

    PanelWindow {
        id: sidebarRoot
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
        visible: GlobalStates.dashboardOpen

        function hide() {
            GlobalStates.dashboardOpen = false
        }

        exclusiveZone: 0
        implicitWidth: 1500
        implicitHeight: 900
        WlrLayershell.namespace: "quickshell:dashboard"
        // Hyprland 0.49: Focus is always exclusive and setting this breaks mouse focus grab
        // WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
        color: "transparent"

        HyprlandFocusGrab {
            id: grab
<<<<<<< HEAD
            windows: [ dashboardRoot ]
            active: GlobalStates.dashboardOpen
            onCleared: () => {
                if (!active) dashboardRoot.hide()
            }
        }


        Loader {
            id: dashboardContentLoader
=======
            windows: [ sidebarRoot ]
            active: GlobalStates.dashboardOpen
            onCleared: () => {
                if (!active) sidebarRoot.hide()
            }
        }

        Loader {
            id: sidebarContentLoader
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
            active: GlobalStates.dashboardOpen
            anchors {
                top: parent.top
                bottom: parent.bottom
                right: parent.right
                left: parent.left
                topMargin: Appearance.sizes.hyprlandGapsOut
                rightMargin: Appearance.sizes.hyprlandGapsOut
                bottomMargin: Appearance.sizes.hyprlandGapsOut
                leftMargin: Appearance.sizes.elevationMargin
            }
<<<<<<< HEAD
            width: dashboardWidth - Appearance.sizes.hyprlandGapsOut - Appearance.sizes.elevationMargin
=======
            width: sidebarWidth - Appearance.sizes.hyprlandGapsOut - Appearance.sizes.elevationMargin
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
            height: parent.height - Appearance.sizes.hyprlandGapsOut * 2

            focus: GlobalStates.dashboardOpen
            Keys.onPressed: (event) => {
                if (event.key === Qt.Key_Escape) {
<<<<<<< HEAD
                    dashboardRoot.hide();
=======
                    sidebarRoot.hide();
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
                }
            }

            sourceComponent: Item {
                implicitHeight: dashboardBackground.implicitHeight
                implicitWidth: dashboardBackground.implicitWidth

                StyledRectangularShadow {
                    target: dashboardBackground
<<<<<<< HEAD
                    visible: Config.options.appearance.transparency
=======
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
                }
                Rectangle {
                    id: dashboardBackground

                    anchors.fill: parent
                    implicitHeight: parent.height - Appearance.sizes.hyprlandGapsOut * 2
<<<<<<< HEAD
                    implicitWidth: dashboardWidth - Appearance.sizes.hyprlandGapsOut * 2
=======
                    implicitWidth: sidebarWidth - Appearance.sizes.hyprlandGapsOut * 2
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
                    color: Appearance.colors.colLayer0
                    radius: Appearance.rounding.screenRounding - Appearance.sizes.hyprlandGapsOut + 1

                    ColumnLayout {
<<<<<<< HEAD
                        spacing: dashboardPadding
                        anchors.fill: parent
                        anchors.margins: dashboardPadding
=======
                        spacing: sidebarPadding
                        anchors.fill: parent
                        anchors.margins: sidebarPadding
>>>>>>> fa28d8f (Initial commit of the quickshell migration)

                        RowLayout {
                            Layout.fillHeight: false
                            spacing: 10
                            Layout.margins: 10
                            Layout.topMargin: 5
                            Layout.bottomMargin: 0

                            Item {
                                implicitWidth: distroIcon.width
                                implicitHeight: distroIcon.height
                                CustomIcon {
                                    id: distroIcon
<<<<<<< HEAD
                                    width: 30
                                    height: 30
=======
                                    width: 25
                                    height: 25
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
                                    source: SystemInfo.distroIcon
                                }
                                ColorOverlay {
                                    anchors.fill: distroIcon
                                    source: distroIcon
                                    color: Appearance.colors.colOnLayer0
                                }
                            }

                            StyledText {
                                font.pixelSize: Appearance.font.pixelSize.normal
                                color: Appearance.colors.colOnLayer0
                                text: StringUtils.format(qsTr("Uptime: {0}"), DateTime.uptime)
<<<<<<< HEAD
=======
                                textFormat: Text.MarkdownText
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
                            }

                            Item {
                                Layout.fillWidth: true
                            }

                            ButtonGroup {
                                QuickToggleButton {
                                    toggled: false
                                    buttonIcon: "restart_alt"
                                    onClicked: {
                                        Hyprland.dispatch("reload")
                                        Quickshell.reload(true)
                                    }
                                    StyledToolTip {
                                        content: qsTr("Reload Hyprland & Quickshell")
                                    }
                                }
                                QuickToggleButton {
                                    toggled: false
                                    buttonIcon: "settings"
                                    onClicked: {
<<<<<<< HEAD
                                        Hyprland.dispatch(`exec qs -p /usr/share/sleex/settings.qml`)
                                        Hyprland.dispatch(`global quickshell:dashboardClose`)
                                    }
                                    StyledToolTip {
                                        content: qsTr("Settings")
=======
                                        Hyprland.dispatch(`exec ${ConfigOptions.apps.settings}`)
                                        Hyprland.dispatch(`global quickshell:dashboardClose`)
                                    }
                                    StyledToolTip {
                                        content: qsTr("Plasma Settings")
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
                                    }
                                }
                                QuickToggleButton {
                                    toggled: false
                                    buttonIcon: "power_settings_new"
                                    onClicked: {
                                        Hyprland.dispatch("global quickshell:sessionOpen")
                                    }
                                    StyledToolTip {
                                        content: qsTr("Session")
                                    }
                                }
                            }
                            ButtonGroup {
                                Layout.alignment: Qt.AlignHCenter
                                spacing: 5
                                padding: 5
                                color: Appearance.colors.colLayer1

                                NetworkToggle {}
                                BluetoothToggle {}
                                NightLight {}
                                IdleInhibitor {}
                            }

                        }


                        // Center widget group
                        DashboardTabs {
                            id: dashboardTabs
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.preferredHeight: 600
<<<<<<< HEAD
                            Layout.preferredWidth: dashboardWidth - dashboardPadding * 2
=======
                            Layout.preferredWidth: sidebarWidth - sidebarPadding * 2
>>>>>>> fa28d8f (Initial commit of the quickshell migration)

                            onCurrentTabChanged: {
                                if (currentTab === "greetings") {
                                    Notifications.timeoutAll();
                                }
                            }
                        }
                    }
                }
            }
        }


    }

    IpcHandler {
        target: "dashboard"

        function toggle(): void {
            GlobalStates.dashboardOpen = !GlobalStates.dashboardOpen;
            if(GlobalStates.dashboardOpen) Notifications.timeoutAll();
        }

        function close(): void {
            GlobalStates.dashboardOpen = false;
        }

        function open(): void {
            GlobalStates.dashboardOpen = true;
            Notifications.timeoutAll();
        }
    }

    GlobalShortcut {
        name: "dashboardToggle"
<<<<<<< HEAD
        description: qsTr("Toggles dashboard on press")
=======
        description: qsTr("Toggles right sidebar on press")
>>>>>>> fa28d8f (Initial commit of the quickshell migration)

        onPressed: {
            GlobalStates.dashboardOpen = !GlobalStates.dashboardOpen;
            if(GlobalStates.dashboardOpen) Notifications.timeoutAll();
        }
    }
    GlobalShortcut {
        name: "dashboardOpen"
<<<<<<< HEAD
        description: qsTr("Opens dashboard on press")
=======
        description: qsTr("Opens right sidebar on press")
>>>>>>> fa28d8f (Initial commit of the quickshell migration)

        onPressed: {
            GlobalStates.dashboardOpen = true;
            Notifications.timeoutAll();
        }
    }
    GlobalShortcut {
        name: "dashboardClose"
<<<<<<< HEAD
        description: qsTr("Closes dashboard on press")
=======
        description: qsTr("Closes right sidebar on press")
>>>>>>> fa28d8f (Initial commit of the quickshell migration)

        onPressed: {
            GlobalStates.dashboardOpen = false;
        }
    }

}
