import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "root:/services/"
import "root:/modules/common/"
import "root:/modules/common/widgets/"

ContentPage {
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
}