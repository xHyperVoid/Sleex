import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Lockscreen from '../../services/lockscreen.js';
import Layer from 'gi://GtkLayerShell';
import GLib from 'gi://GLib';
import { BarBattery } from '../bar/normal/spaceright.js';

const PasswordEntry = () => Widget.Box({
    children: [
        Widget.Entry({
            setup: self => self.hook(Lockscreen, () => self.text = '', 'lock'),
            visibility: false,
            placeholder_text: 'Password',
            on_accept: ({ text }) => Lockscreen.auth(text || ''),
            hexpand: true,
        }),
    ],
});

const time = Variable("", {
    poll: [
      userOptions.time.interval,
      () => GLib.DateTime.new_now_local().format(userOptions.time.format),
    ],
});

const TopBar = () => Widget.Box({
    children: [
        Widget.Label({label: time.bind()}),
        Widget.Box({ hexpand: true }),
        BarBattery(),
    ]
});

const username = () => {
    const user = GLib.get_user_name();
    return user.charAt(0).toUpperCase() + user.slice(1);
}
const iconFile = `/var/lib/AccountsService/icons/${GLib.get_user_name()}`;

const LockscreenBox = () => Widget.Box({
    className: 'lockscreen-container',
    vertical: true,
    children: [
        TopBar(),
        Widget.Box({
            css: `background-image: url('${iconFile}');`,
            className: 'avatar',
            hpack: 'center',
            vpack: 'center',
        }),
        Widget.Label({
            label: `Welcome back, ${username()}`,
            className: 'txt txt-larger',
            css: 'margin: 0 2rem 0 2rem;',
        }),
        PasswordEntry(),
    ],
});

export default (monitor = 0) => {
    const win = Widget.Window({
        name: `lockscreen${monitor}`,
        className: 'lockscreen',
        monitor,
        layer: 'overlay',
        visible: false,
        setup: self => self.hook(Lockscreen, (_, lock) => self.visible = lock, 'lock'),
        child: Widget.Overlay({
            child: Widget.Box({
                css: 'min-width: 3000px; min-height: 2000px;',
                child: Widget.Box({
                    className: 'content',
                    vertical: true,
                    hexpand: true,
                    vexpand: true,
                    hpack: 'center',
                    vpack: 'center',
                    children: [
                        LockscreenBox(),
                    ],
                }),
            }),
        }),
    });

    Layer.set_keyboard_mode(win, Layer.KeyboardMode.EXCLUSIVE);
    return win;
};