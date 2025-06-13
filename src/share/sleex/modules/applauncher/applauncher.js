const { query } = await Service.import("applications")
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
const { Box, Label, Icon, Button, Entry, Scrollable } = Widget;

const AppItem = (app) => Button({
    onClicked: () => {
        App.closeWindow("applauncher");
        app.launch()
    },
    attribute: { app },
    className: "applauncher-item",
    child: Box({
        children: [
            Icon({
                icon: app.icon_name || "",
                size: 42,
            }),
            Label({
                className: "applauncher-title",
                label: app.name,
                xalign: 0,
                vpack: "center",
                truncate: "end",
            }),
        ],
    }),
})

export default () => {
    let applications = query("").map(AppItem)

    const list = Box({
        vertical: true,
        children: applications,
    })

    function repopulate() {
        applications = query("").map(AppItem)
        list.children = applications
    }

    const entry = Entry({
        hexpand: true,
        className: "applauncher-entry",
        
        onAccept: () => {
	        const results = applications.filter((item) => item.visible);
            if (results[0]) {
                App.toggleWindow('applauncher');
                results[0].attribute.app.launch()
            }
        },

        onChange: ({ text }) => applications.forEach(item => {
            item.visible = item.attribute.app.match(text ?? "")
        }),
    })

    return Box({
        vertical: true,
        className: "applauncher",
        children: [
            entry,
            Scrollable({
                hscroll: "never",
                vexpand: true,
                child: list,
            }),
        ],
        setup: self => self.hook(App, (_, windowName, visible) => {
            if (windowName !== "applauncher")
                return

            // when the applauncher shows up
            if (visible) {
                repopulate()
                entry.text = ""
                entry.grab_focus()
            }
        }),
    })

}