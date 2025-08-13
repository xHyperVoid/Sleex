import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell.Services.UPower
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import qs.modules.bar
import qs.modules.mediaControls

MouseArea {
    id: root
    required property LockContext context
    property bool active: false
    property bool showInputField: active || context.currentText.length > 0

    function forceFieldFocus() {
        passwordBox.forceActiveFocus();
    }

    Component.onCompleted: {
        forceFieldFocus();
    }

    Connections {
        target: context
    }

    Keys.onPressed: (event) => { // Esc to clear
        // console.log("KEY!!")
        if (event.key === Qt.Key_Escape) {
            root.context.currentText = ""
        }
        forceFieldFocus();
    }

    hoverEnabled: true
    acceptedButtons: Qt.LeftButton
    onPressed: (mouse) => {
        forceFieldFocus();
        // console.log("Pressed")
    }
    onPositionChanged: (mouse) => {
        forceFieldFocus();
        // console.log(JSON.stringify(mouse))
    }

    anchors.fill: parent

    // RippleButton {
    //     anchors {
    //         top: parent.top
    //         left: parent.left
    //         leftMargin: 10
    //         topMargin: 10
    //     }
    //     implicitHeight: 40
    //     colBackground: Appearance.colors.colLayer2
    //     onClicked: context.unlocked()
    //     contentItem: StyledText {
    //         text: "Step bro, I'm stuck!"
    //     }
    // }
    

    // Background
    Image {
        id: backgroundImage
        anchors.fill: parent
        source: Config.options.background.wallpaperPath
        fillMode: Image.PreserveAspectCrop
        z: -1 // Make sure it's behind everything
        opacity: 0 // Start fully transparent

        Component.onCompleted: {
            fadeInAnim.start()
        }

        NumberAnimation {
            id: fadeInAnim
            target: backgroundImage
            property: "opacity"
            from: 0
            to: 1
            duration: 600
            easing.type: Easing.OutCubic
        }

        FastBlur {
            anchors.fill: parent
            source: backgroundImage
            radius: 10
            opacity: parent.opacity
        }
    }

    ColumnLayout {
        id: clockWeather
        visible: true
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: -200 // Start off-screen
        spacing: 8

        Component.onCompleted: {
            animIn.running = true
        }

        NumberAnimation {
            id: animIn
            target: clockWeather
            property: "anchors.topMargin"
            from: -200
            to: 40
            duration: 600
            easing.type: Easing.OutCubic
        }
        // Clock
        StyledText {
            id: timeText
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
            font.family: Config.options.background.clockFontFamily ?? "Sans Serif"
            font.pixelSize: 95
            color: Appearance.colors.colPrimary
            style: Text.Raised
            styleColor: Appearance.colors.colShadow
            text: DateTime.time
        }
        StyledText {
            id: dateText
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
            font.family: Config.options.background.clockFontFamily ?? "Sans Serif"
            font.pixelSize: 25
            color: Appearance.colors.colPrimary
            style: Text.Raised
            styleColor: Appearance.colors.colShadow
            text: DateTime.date
        }

        // Weather info
        RowLayout {
            spacing: 6
            Layout.alignment: Qt.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            visible: weatherData

            Text {
                text: Weather.weatherCode ? materialSymbolForCode(Weather.weatherCode) : "cloud"
                font.family: "Material Symbols Outlined"
                font.pixelSize: 28
                color: Appearance.colors.colPrimary
                verticalAlignment: Text.AlignVCenter
            }
            Text {
                text: Weather.temperature || qsTr("--")
                font.pixelSize: 18
                color: Appearance.colors.colPrimary
                verticalAlignment: Text.AlignVCenter
            }
        }

        Behavior on y {
            NumberAnimation { duration: 600; easing.type: Easing.OutCubic }
        }
    }

    // Battery indicator
    BatteryIndicator {
        Layout.alignment: Qt.AlignTop | Qt.AlignRight
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 10
        implicitWidth: 75
        implicitHeight: 23
        borderless: true // Use borderless style
        visible: UPower.displayDevice.isLaptopBattery
    }

    // Hover trigger area (bottom right corner)
    Rectangle {
        id: hoverTrigger
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: 80
        height: 200
        color: "transparent"
        
        MouseArea {
            id: triggerArea
            anchors.fill: parent
            hoverEnabled: true
            
            // System control buttons (bottom right)
            ColumnLayout {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 32
                spacing: 12
                
                opacity: triggerArea.containsMouse ? 1 : 0
                visible: opacity > 0
                
                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutCubic
                    }
                }
                
                // Shutdown
                Rectangle {
                    width: 48
                    height: 48
                    radius: 24
                    color: shutdownArea.containsMouse ? "#53ffb3ab" : "transparent"
                    border.color: Appearance.m3colors.m3error
                    border.width: 1
                    
                    MouseArea {
                        id: shutdownArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            Qt.createQmlObject('import Quickshell.Io; Process { command: ["shutdown", "-h", "now"]; running: true }', lock);
                        }
                    }
                    
                    Text {
                        anchors.centerIn: parent
                        text: "power_settings_new"
                        font.family: "Material Symbols Outlined"
                        font.pixelSize: 24
                        color: Appearance.m3colors.m3error
                    }
                }
                
                // Reboot
                Rectangle {
                    width: 48
                    height: 48
                    radius: 24
                    color: rebootArea.containsMouse ? "#3ed1e8d5" : "transparent"
                    border.color: "#ffD1E8D5"
                    border.width: 1
                    
                    MouseArea {
                        id: rebootArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            Qt.createQmlObject('import Quickshell.Io; Process { command: ["reboot"]; running: true }', lock);
                        }
                    }
                    
                    Text {
                        anchors.centerIn: parent
                        text: "refresh"
                        font.family: "Material Symbols Outlined"
                        font.pixelSize: 24
                        color: "#ffD1E8D5"
                    }
                }
                
                // Logout
                Rectangle {
                    width: 48
                    height: 48
                    radius: 24
                    color: logoutArea.containsMouse ? "#4e6d98d5" : "transparent"
                    border.color: "#6d99cd"
                    border.width: 1
                    
                    MouseArea {
                        id: logoutArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            Qt.createQmlObject('import Quickshell.Io; Process { command: ["loginctl", "terminate-user", "' + Quickshell.env("USER") + '"]; running: true }', lock);
                        }
                    }
                    
                    Text {
                        anchors.centerIn: parent
                        text: "exit_to_app"
                        font.family: "Material Symbols Outlined"
                        font.pixelSize: 24
                        color: "#6d99cd"
                    }
                }
            }
        }
    }
    // Media controls
    MediaControls {
        id: mediaControlsContainer
        implicitHeight: 150
        implicitWidth: 450
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: passwordBoxContainer.top
            bottomMargin: -200 // Start off-screen
        }

        Component.onCompleted: {
            mediaAnimIn.running = true
        }

        NumberAnimation {
            id: mediaAnimIn
            target: mediaControlsContainer
            property: "anchors.bottomMargin"
            from: -200
            to: 20
            duration: 600
            easing.type: Easing.OutCubic
        }
    }

    // Password entry
    Rectangle {
        id: passwordBoxContainer
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: root.showInputField ? 20 : -height
        }
        Behavior on anchors.bottomMargin {
            animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
        }
        radius: Appearance.rounding.full
        color: Appearance.m3colors.m3surfaceContainer
        implicitWidth: 200
        implicitHeight: 50

        StyledTextInput {
            id: passwordBox

            anchors {
                fill: parent
                margins: 10
            }
            clip: true
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            focus: true
            onFocusChanged: root.forceFieldFocus();
            color: Appearance.colors.colOnLayer2
            font {
                pixelSize: 15
            }

            // Password
            enabled: !root.context.unlockInProgress
            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhSensitiveData

            // Synchronizing (across monitors) and unlocking
            onTextChanged: root.context.currentText = this.text
            onAccepted: root.context.tryUnlock()
            Connections {
                target: root.context
                function onCurrentTextChanged() {
                    passwordBox.text = root.context.currentText;
                }
            }
        }
    }

    // RippleButton {
    //     anchors {
    //         verticalCenter: passwordBoxContainer.verticalCenter
    //         left: passwordBoxContainer.right
    //         leftMargin: 5
    //     }

    //     visible: opacity > 0
    //     implicitHeight: passwordBoxContainer.implicitHeight - 12
    //     implicitWidth: implicitHeight
    //     toggled: true
    //     buttonRadius: passwordBoxContainer.radius
    //     colBackground: Appearance.colors.colLayer2
    //     onClicked: root.context.tryUnlock()

    //     contentItem: MaterialSymbol {
    //         anchors.centerIn: parent
    //         horizontalAlignment: Text.AlignHCenter
    //         verticalAlignment: Text.AlignVCenter
    //         iconSize: 24
    //         text: "arrow_right_alt"
    //         color: Appearance.colors.colOnPrimary
    //     }
    // }
}
