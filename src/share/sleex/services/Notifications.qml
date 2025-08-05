pragma Singleton
pragma ComponentBehavior: Bound

<<<<<<< HEAD
import qs.modules.common
import qs
=======
import "root:/modules/common"
import "root:/"
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

/**
 * Provides extra features not in Quickshell.Services.Notifications:
 *  - Persistent storage
 *  - Popup notifications, with timeout
 *  - Notification groups by app
 */
Singleton {
	id: root
<<<<<<< HEAD

    component Notif: QtObject {
        id: wrapper
        required property int notificationId // Could just be `id` but it conflicts with the default prop in QtObject
=======
    component Notif: QtObject {
        required property int id
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
        property Notification notification
        property list<var> actions: notification?.actions.map((action) => ({
            "identifier": action.identifier,
            "text": action.text,
        })) ?? []
        property bool popup: false
        property string appIcon: notification?.appIcon ?? ""
        property string appName: notification?.appName ?? ""
        property string body: notification?.body ?? ""
        property string image: notification?.image ?? ""
        property string summary: notification?.summary ?? ""
        property double time
        property string urgency: notification?.urgency.toString() ?? "normal"
        property Timer timer
<<<<<<< HEAD

        onNotificationChanged: {
            if (notification === null) {
                root.discardNotification(notificationId);
            }
        }
=======
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
    }

    function notifToJSON(notif) {
        return {
<<<<<<< HEAD
            "notificationId": notif.notificationId,
=======
            "id": notif.id,
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
            "actions": notif.actions,
            "appIcon": notif.appIcon,
            "appName": notif.appName,
            "body": notif.body,
            "image": notif.image,
            "summary": notif.summary,
            "time": notif.time,
            "urgency": notif.urgency,
        }
    }
    function notifToString(notif) {
        return JSON.stringify(notifToJSON(notif), null, 2);
    }

    component NotifTimer: Timer {
<<<<<<< HEAD
        required property int notificationId
        interval: 5000
        running: true
        onTriggered: () => {
            root.timeoutNotification(notificationId);
=======
        required property int id
        interval: 5000
        running: true
        onTriggered: () => {
            root.timeoutNotification(id);
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
            destroy()
        }
    }

    property bool silent: false
    property var filePath: Directories.notificationsPath
    property list<Notif> list: []
    property var popupList: list.filter((notif) => notif.popup);
<<<<<<< HEAD
    property bool popupInhibited: (GlobalStates?.sidebarRightOpen ?? false) || silent
=======
    property bool popupInhibited: (GlobalStates?.dashboardOpen ?? false) || silent
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
    property var latestTimeForApp: ({})
    Component {
        id: notifComponent
        Notif {}
    }
    Component {
        id: notifTimerComponent
        NotifTimer {}
    }

    function stringifyList(list) {
        return JSON.stringify(list.map((notif) => notifToJSON(notif)), null, 2);
    }
    
    onListChanged: {
        // Update latest time for each app
        root.list.forEach((notif) => {
            if (!root.latestTimeForApp[notif.appName] || notif.time > root.latestTimeForApp[notif.appName]) {
                root.latestTimeForApp[notif.appName] = Math.max(root.latestTimeForApp[notif.appName] || 0, notif.time);
            }
        });
        // Remove apps that no longer have notifications
        Object.keys(root.latestTimeForApp).forEach((appName) => {
            if (!root.list.some((notif) => notif.appName === appName)) {
                delete root.latestTimeForApp[appName];
            }
        });
    }

    function appNameListForGroups(groups) {
        return Object.keys(groups).sort((a, b) => {
            // Sort by time, descending
            return groups[b].time - groups[a].time;
        });
    }

    function groupsForList(list) {
        const groups = {};
        list.forEach((notif) => {
            if (!groups[notif.appName]) {
                groups[notif.appName] = {
                    appName: notif.appName,
                    appIcon: notif.appIcon,
                    notifications: [],
                    time: 0
                };
            }
            groups[notif.appName].notifications.push(notif);
            // Always set to the latest time in the group
            groups[notif.appName].time = latestTimeForApp[notif.appName] || notif.time;
        });
        return groups;
    }

    property var groupsByAppName: groupsForList(root.list)
    property var popupGroupsByAppName: groupsForList(root.popupList)
    property var appNameList: appNameListForGroups(root.groupsByAppName)
    property var popupAppNameList: appNameListForGroups(root.popupGroupsByAppName)

    // Quickshell's notification IDs starts at 1 on each run, while saved notifications
    // can already contain higher IDs. This is for avoiding id collisions
    property int idOffset
    signal initDone();
    signal notify(notification: var);
<<<<<<< HEAD
    signal discard(id: int);
=======
    signal discard(id: var);
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
    signal discardAll();
    signal timeout(id: var);

	NotificationServer {
        id: notifServer
        // actionIconsSupported: true
        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        bodySupported: true
        imageSupported: true
        keepOnReload: false
        persistenceSupported: true

        onNotification: (notification) => {
            notification.tracked = true
            const newNotifObject = notifComponent.createObject(root, {
<<<<<<< HEAD
                "notificationId": notification.id + root.idOffset,
=======
                "id": notification.id + root.idOffset,
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
                "notification": notification,
                "time": Date.now(),
            });
			root.list = [...root.list, newNotifObject];

            // Popup
            if (!root.popupInhibited) {
                newNotifObject.popup = true;
                newNotifObject.timer = notifTimerComponent.createObject(root, {
<<<<<<< HEAD
                    "notificationId": newNotifObject.notificationId,
=======
                    "id": newNotifObject.id,
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
                    "interval": notification.expireTimeout < 0 ? 5000 : notification.expireTimeout,
                });
            }

            root.notify(newNotifObject);
            // console.log(notifToString(newNotifObject));
            notifFileView.setText(stringifyList(root.list));
        }
    }

    function discardNotification(id) {
<<<<<<< HEAD
        console.log("[Notifications] Discarding notification with ID: " + id);
        const index = root.list.findIndex((notif) => notif.notificationId === id);
=======
        const index = root.list.findIndex((notif) => notif.id === id);
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
        const notifServerIndex = notifServer.trackedNotifications.values.findIndex((notif) => notif.id + root.idOffset === id);
        if (index !== -1) {
            root.list.splice(index, 1);
            notifFileView.setText(stringifyList(root.list));
            triggerListChange()
        }
        if (notifServerIndex !== -1) {
            notifServer.trackedNotifications.values[notifServerIndex].dismiss()
        }
<<<<<<< HEAD
        root.discard(id); // Emit signal
=======
        root.discard(id);
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
    }

    function discardAllNotifications() {
        root.list = []
        triggerListChange()
        notifFileView.setText(stringifyList(root.list));
        notifServer.trackedNotifications.values.forEach((notif) => {
            notif.dismiss()
        })
        root.discardAll();
    }

    function timeoutNotification(id) {
<<<<<<< HEAD
        const index = root.list.findIndex((notif) => notif.notificationId === id);
=======
        const index = root.list.findIndex((notif) => notif.id === id);
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
        if (root.list[index] != null)
            root.list[index].popup = false;
        root.timeout(id);
    }

    function timeoutAll() {
        root.popupList.forEach((notif) => {
<<<<<<< HEAD
            root.timeout(notif.notificationId);
=======
            root.timeout(notif.id);
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
        })
        root.popupList.forEach((notif) => {
            notif.popup = false;
        });
    }

    function attemptInvokeAction(id, notifIdentifier) {
<<<<<<< HEAD
        console.log("[Notifications] Attempting to invoke action with identifier: " + notifIdentifier + " for notification ID: " + id);
        const notifServerIndex = notifServer.trackedNotifications.values.findIndex((notif) => notif.id + root.idOffset === id);
        console.log("Notification server index: " + notifServerIndex);
        if (notifServerIndex !== -1) {
            const notifServerNotif = notifServer.trackedNotifications.values[notifServerIndex];
            const action = notifServerNotif.actions.find((action) => action.identifier === notifIdentifier);
            console.log("Action found: " + JSON.stringify(action));
            action.invoke()
        } 
        else {
            console.log("Notification not found in server: " + id)
        }
        root.discardNotification(id);
=======
        const notifServerIndex = notifServer.trackedNotifications.values.findIndex((notif) => notif.id + root.idOffset === id);
        if (notifServerIndex !== -1) {
            const notifServerNotif = notifServer.trackedNotifications.values[notifServerIndex];
            const action = notifServerNotif.actions.find((action) => action.identifier === notifIdentifier);
            action.invoke()
        } 
        // else console.log("Notification not found in server: " + id)
        // root.discard(id);
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
    }

    function triggerListChange() {
        root.list = root.list.slice(0)
    }

    function refresh() {
        notifFileView.reload()
    }

    Component.onCompleted: {
        refresh()
    }

    FileView {
        id: notifFileView
        path: Qt.resolvedUrl(filePath)
        onLoaded: {
            const fileContents = notifFileView.text()
            root.list = JSON.parse(fileContents).map((notif) => {
                return notifComponent.createObject(root, {
<<<<<<< HEAD
                    "notificationId": notif.notificationId,
                    "actions": [], // Notification actions are meaningless if they're not tracked by the server or the sender is dead
=======
                    "id": notif.id,
                    "actions": notif.actions,
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
                    "appIcon": notif.appIcon,
                    "appName": notif.appName,
                    "body": notif.body,
                    "image": notif.image,
                    "summary": notif.summary,
                    "time": notif.time,
                    "urgency": notif.urgency,
                });
            });
<<<<<<< HEAD
            // Find largest notificationId
            let maxId = 0
            root.list.forEach((notif) => {
                maxId = Math.max(maxId, notif.notificationId)
=======
            // Find largest id
            let maxId = 0
            root.list.forEach((notif) => {
                maxId = Math.max(maxId, notif.id)
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
            })

            console.log("[Notifications] File loaded")
            root.idOffset = maxId
            root.initDone()
        }
        onLoadFailed: (error) => {
            if(error == FileViewError.FileNotFound) {
                console.log("[Notifications] File not found, creating new file.")
                root.list = []
                notifFileView.setText(stringifyList(root.list));
            } else {
                console.log("[Notifications] Error loading file: " + error)
            }
        }
    }
<<<<<<< HEAD
}
=======
}
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
