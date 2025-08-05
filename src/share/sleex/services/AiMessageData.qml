<<<<<<< HEAD
import qs.modules.common
=======
import "root:/modules/common"
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
import QtQuick;

/**
 * Represents a message in an AI conversation. (Kind of) follows the OpenAI API message structure.
 */
QtObject {
    property string role
    property string content
    property string model
    property bool thinking: true
    property bool done: false
    property var annotations: []
    property var annotationSources: []
    property string functionName
    property string functionCall
    property string functionResponse
    property bool visibleToUser: true
}
