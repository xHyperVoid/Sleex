<<<<<<< HEAD
import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
=======
import "root:/"
import "root:/services"
import "root:/modules/common"
import "root:/modules/common/widgets"
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
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

Item {
    id: root
    required property var scopeRoot
    anchors.fill: parent
<<<<<<< HEAD
=======
    property var tabButtonList: [
        {"icon": "neurology", "name": qsTr("Intelligence")},
    ]
    property int selectedTab: 0

    function focusActiveItem() {
        swipeView.currentItem.forceActiveFocus()
    }

    Keys.onPressed: (event) => {
        if (event.modifiers === Qt.ControlModifier) {
            if (event.key === Qt.Key_PageDown) {
                root.selectedTab = Math.min(root.selectedTab + 1, root.tabButtonList.length - 1)
                event.accepted = true;
            } 
            else if (event.key === Qt.Key_PageUp) {
                root.selectedTab = Math.max(root.selectedTab - 1, 0)
                event.accepted = true;
            }
            else if (event.key === Qt.Key_Tab) {
                root.selectedTab = (root.selectedTab + 1) % root.tabButtonList.length;
                event.accepted = true;
            }
            else if (event.key === Qt.Key_Backtab) {
                root.selectedTab = (root.selectedTab - 1 + root.tabButtonList.length) % root.tabButtonList.length;
                event.accepted = true;
            }
        }
    }
>>>>>>> fa28d8f (Initial commit of the quickshell migration)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: sidebarPadding
        
        spacing: sidebarPadding

<<<<<<< HEAD
=======
        PrimaryTabBar { // Tab strip
            id: tabBar
            tabButtonList: root.tabButtonList
            externalTrackedTab: root.selectedTab
            function onCurrentIndexChanged(currentIndex) {
                root.selectedTab = currentIndex
            }
        }

>>>>>>> fa28d8f (Initial commit of the quickshell migration)
        SwipeView { // Content pages
            id: swipeView
            Layout.topMargin: 5
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10
            
<<<<<<< HEAD
=======
            currentIndex: tabBar.externalTrackedTab
            onCurrentIndexChanged: {
                tabBar.enableIndicatorAnimation = true
                root.selectedTab = currentIndex
            }

            clip: true
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: swipeView.width
                    height: swipeView.height
                    radius: Appearance.rounding.small
                }
            }

>>>>>>> fa28d8f (Initial commit of the quickshell migration)
            contentChildren: [
                aiChat.createObject()
            ]
        }

        Component {
            id: aiChat
            AiChat {}
        }        
    }
}