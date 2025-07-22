// ~~stolen~~ inspired by Noctalia by Ly-sec

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import Quickshell.Wayland
import Quickshell
import Quickshell.Services.Pam
import Quickshell.Io
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.mediaControls

WlSessionLock {
    id: lock

    property string errorMessage: ""
    property bool authenticating: false
    property string password: ""
    property bool pamAvailable: typeof PamContext !== "undefined"
    property var weatherData: Weather.raw
    locked: GlobalStates.screenLocked

    // On component completed, fetch weather data

    function materialSymbolForCode(code) {
        if (code === 0)
            return "sunny";
        if (code === 1 || code === 2)
            return "partly_cloudy_day";
        if (code === 3)
            return "cloud";
        if (code >= 45 && code <= 48)
            return "foggy";
        if (code >= 51 && code <= 67)
            return "rainy";
        if (code >= 71 && code <= 77)
            return "weather_snowy";
        if (code >= 80 && code <= 82)
            return "rainy";
        if (code >= 95 && code <= 99)
            return "thunderstorm";
        return "cloud";
    }

    // Authentication function
    function unlockAttempt() {
        console.log("Unlock attempt started");
        if (!pamAvailable) {
            lock.errorMessage = "PAM authentication not available.";
            console.log("PAM not available");
            return;
        }
        if (!lock.password) {
            lock.errorMessage = "Password required.";
            console.log("No password entered");
            return;
        }
        console.log("Starting PAM authentication...");
        lock.authenticating = true;
        lock.errorMessage = "";

        console.log("[LockScreen] About to create PAM context with userName:", Quickshell.env("USER"));
        var pam = Qt.createQmlObject('import Quickshell.Services.Pam; PamContext { config: "login"; user: "' + Quickshell.env("USER") + '" }', lock);
        console.log("PamContext created", pam);

        pam.onCompleted.connect(function (result) {
            console.log("PAM completed with result:", result);
            lock.authenticating = false;
            if (result === PamResult.Success) {
                console.log("Authentication successful, unlocking...");
                GlobalStates.screenLocked = false;
                lock.password = "";
                lock.errorMessage = "";
            } else {
                console.log("Authentication failed");
                lock.errorMessage = "Authentication failed.";
                lock.password = "";
            }
            pam.destroy();
        });

        pam.onError.connect(function (error) {
            console.log("PAM error:", error);
            lock.authenticating = false;
            lock.errorMessage = pam.message || "Authentication error.";
            lock.password = "";
            pam.destroy();
        });

        pam.onPamMessage.connect(function () {
            console.log("PAM message:", pam.message, "isError:", pam.messageIsError);
            if (pam.messageIsError) {
                lock.errorMessage = pam.message;
            }
        });

        pam.onResponseRequiredChanged.connect(function () {
            console.log("PAM response required:", pam.responseRequired);
            if (pam.responseRequired && lock.authenticating) {
                console.log("Responding to PAM with password");
                pam.respond(lock.password);
            }
        });

        var started = pam.start();
        console.log("PAM start result:", started);
    }

    // Lock surface
    WlSessionLockSurface {
        // Blurred wallpaper background
        Image {
            id: lockBgImage
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            source: Config.options.background.wallpaperPath
            cache: true
            smooth: false
            visible: true // Show the original for FastBlur input

            Rectangle {
                anchors.fill: parent
                color: "#80000000" // semi-transparent black overlay
                z: 1
            }
        }

        FastBlur {
            anchors.fill: parent
            source: lockBgImage
            radius: 100
            visible: true
        }

        // Main content container (moved up, Rectangle removed)
        ColumnLayout {
            anchors.centerIn: parent
            anchors.margins: 32
            spacing: 32
            width: Math.min(parent.width * 0.8, 400)

            // User avatar/icon
            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                width: 150
                height: 150
                radius: Appearance.rounding.full
                color: Appearance.colors.colLayer1

                Image {
                    id: avatarImage
                    anchors.fill: parent
                    source: Config.options.dashboard.avatarPath
                    fillMode: Image.PreserveAspectCrop
                    visible: false // Only show the masked version
                    asynchronous: true
                }
                OpacityMask {
                    anchors.fill: avatarImage
                    source: avatarImage
                    maskSource: Rectangle {
                        width: avatarImage.width
                        height: avatarImage.height
                        radius: avatarImage.width / 2
                        visible: false
                    }
                    visible: Config.options.dashboard.avatarPath !== ""
                }
                // Fallback icon
                Text {
                    anchors.centerIn: parent
                    text: "person"
                    font.family: "Material Symbols Outlined"
                    font.pixelSize: 32
                    color: Appearance.colors.colOnLayer1
                    visible: Config.options.dashboard.avatarPath === ""
                }
            }

            // Username
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: Quickshell.env("USER")
                font.pixelSize: Appearance.font.pixelSize.title
                color: Appearance.colors.colPrimary
            }

            // Error message
            Rectangle {
                id: errorMessageRect
                Layout.alignment: Qt.AlignHCenter
                width: parent.width * 0.8
                height: 44
                color: "transparent"
                visible: lock.errorMessage !== ""
                
                Text {
                    anchors.centerIn: parent
                    text: lock.errorMessage
                    color: Appearance.m3colors.m3error
                    font.pixelSize: 14
                    opacity: 1
                    visible: lock.errorMessage !== ""
                }
            }
            
            // Password input container
            Rectangle {
                Layout.fillWidth: true
                height: 50
                radius: Appearance.rounding.normal
                color: lock.errorMessage !== "" ? "#33ff0000" : "transparent"
                opacity: passwordInput.activeFocus ? 0.8 : 0.3
                border.color: passwordInput.activeFocus ? Appearance.colors.colPrimary : "transparent"
                border.width: 2

                StyledTextInput {
                    id: passwordInput
                    anchors.fill: parent
                    anchors.margins: 15
                    verticalAlignment: TextInput.AlignVCenter
                    horizontalAlignment: TextInput.AlignHCenter
                    font.pixelSize: 16
                    color: Appearance.colors.colOnLayer1
                    echoMode: TextInput.Password
                    passwordCharacter: "●"
                    passwordMaskDelay: 0

                    text: lock.password
                    onTextChanged: lock.password = text

                    // Placeholder text
                    Text {
                        anchors.centerIn: parent
                        text: "Enter password..."
                        color: Appearance.colors.colOnLayer1
                        font.pixelSize: 16
                        visible: !passwordInput.text && !passwordInput.activeFocus
                    }

                    // Handle Enter key
                    Keys.onPressed: function (event) {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            lock.unlockAttempt();
                        }
                    }

                    Component.onCompleted: {
                        forceActiveFocus();
                    }
                }
            }

            // Unlock button
            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                width: 120
                height: 44
                radius: Appearance.rounding.normal
                opacity: unlockButtonArea.containsMouse ? 0.8 : 0.5
                color: "transparent"
                border.color: unlockButtonArea.containsMouse ? Appearance.colors.colPrimary : "transparent"
                border.width: 2
                enabled: !lock.authenticating

                Text {
                    id: unlockButtonText
                    anchors.centerIn: parent
                    text: lock.authenticating ? "..." : "Unlock"
                    font.pixelSize: 16
                    font.bold: true
                    color: unlockButtonArea.containsMouse ? Appearance.colors.colPrimary : Appearance.colors.colOnLayer1
                }

                MouseArea {
                    id: unlockButtonArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        if (!lock.authenticating) {
                            lock.unlockAttempt();
                        }
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }
                }
            }

        }

        // Top-center info panel (clock + weather)
        ColumnLayout {
            visible: true // TODO
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 40
            spacing: 8

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

            // Weather info (centered, no city)
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
        }

        // System control buttons (bottom right)
        ColumnLayout {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 32
            spacing: 12

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

        ColumnLayout {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.margins: 32
            spacing: 12

            MediaControls {
                Layout.preferredHeight: 150
            }

        }
    }
}