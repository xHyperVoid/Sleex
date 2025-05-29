import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
const { Box, Button, EventBox, Label, Overlay, Stack } = Widget;
import { MaterialIcon } from './materialicon.js';
import { NavigationIndicator } from './cairo_navigationindicator.js';
import { setupCursorHover } from '../.widgetutils/cursorhover.js';
import { DoubleRevealer } from '../.widgethacks/advancedrevealers.js';

export const TabContainer = ({ icons, children, className = '', setup = () => { }, ...rest }) => {
    const shownIndex = Variable(0);
    let previousShownIndex = 0;
    const count = Math.min(icons.length, children.length);
    const tabs = Box({
        vertical: true,
        homogeneous: true,
        children: Array.from({ length: count }, (_, i) => Button({ // Tab button
            className: 'tab-btn-vertical',
            onClicked: () => shownIndex.value = i,
            setup: setupCursorHover,
            child: Box({
                className: 'spacing-h-5 txt-small',
                children: [
                    MaterialIcon(icons[i], 'norm'),
                ]
            })
        })),
        setup: (self) => self.hook(shownIndex, (self) => {
            self.children[previousShownIndex].toggleClassName('tab-btn-active', false);
            self.children[shownIndex.value].toggleClassName('tab-btn-active', true);
            previousShownIndex = shownIndex.value;
        }),
    });
    const tabIndicatorLine = Box({
        vertical: true,
        homogeneous: true,
        setup: (self) => self.hook(shownIndex, (self) => {
            self.children[0].css = `font-size: ${shownIndex.value}px;`;
        }),
        children: [NavigationIndicator({
            className: 'tab-indicator',
            count: count,
            css: `font-size: ${shownIndex.value}px;`,
        })],
    });
    const tabSection = Box({
        homogeneous: true,
        children: [EventBox({
            onScrollUp: () => mainBox.prevTab(),
            onScrollDown: () => mainBox.nextTab(),
            child: Box({
                vertical: false, // Changed to horizontal to place tabs and indicator side by side
                children: [
                    tabs,
                    tabIndicatorLine
                ]
            })
        })]
    });
    const contentStack = Stack({
        transition: 'slide_up_down',
        children: children.reduce((acc, currentValue, index) => {
            acc[index] = currentValue;
            return acc;
        }, {}),
        setup: (self) => self.hook(shownIndex, (self) => {
            self.shown = `${shownIndex.value}`;
        }),
    });
    const mainBox = Box({
        attribute: {
            children: children,
            shown: shownIndex,
        },
        vertical: false, // Changed to horizontal - tabs on left, content on right
        className: `spacing-h-5 ${className}`, // Changed to horizontal spacing
        setup: (self) => {
            self.pack_start(tabSection, false, false, 0);
            self.pack_end(contentStack, true, true, 0);
            setup(self);
        },
        ...rest,
    });
    mainBox.nextTab = () => shownIndex.value = Math.min(shownIndex.value + 1, count - 1);
    mainBox.prevTab = () => shownIndex.value = Math.max(shownIndex.value - 1, 0);
    mainBox.cycleTab = () => shownIndex.value = (shownIndex.value + 1) % count;

    return mainBox;
}


export const IconTabContainer = ({
    iconWidgets, names, children, className = '',
    setup = () => { }, onChange = () => { },
    tabsVpack = 'start', tabSwitcherClassName = '', // Changed from tabsHpack to tabsVpack
    ...rest
}) => {
    const shownIndex = Variable(0);
    let previousShownIndex = 0;
    const count = Math.min(iconWidgets.length, names.length, children.length);
    const tabs = Box({
        vertical: true, // Keep vertical for vertical tab arrangement
        vpack: tabsVpack, // Changed from hpack to vpack
        className: `spacing-v-5 ${tabSwitcherClassName}`, // Changed to vertical spacing
        children: iconWidgets.map((icon, i) => Button({
            className: 'tab-icon',
            tooltipText: names[i],
            child: icon,
            setup: setupCursorHover,
            onClicked: () => shownIndex.value = i,
        })),
        setup: (self) => self.hook(shownIndex, (self) => {
            self.children[previousShownIndex].toggleClassName('tab-icon-active', false);
            self.children[shownIndex.value].toggleClassName('tab-icon-active', true);
            previousShownIndex = shownIndex.value;
        }),
    });
    const tabSection = Box({
        homogeneous: true,
        children: [EventBox({
            onScrollUp: () => mainBox.prevTab(),
            onScrollDown: () => mainBox.nextTab(),
            child: Box({
                vertical: true,
                children: [
                    tabs,
                ]
            })
        })]
    });
    const contentStack = Stack({
        transition: 'slide_left_right', // Keep left_right since content area is beside tabs
        children: children.reduce((acc, currentValue, index) => {
            acc[index] = currentValue;
            return acc;
        }, {}),
        setup: (self) => self.hook(shownIndex, (self) => {
            self.shown = `${shownIndex.value}`;
        }),
    });
    const mainBox = Box({
        attribute: {
            children: children,
            shown: shownIndex,
            names: names,
        },
        vertical: false, // Changed to horizontal - tabs on left, content on right
        className: `spacing-h-5 ${className}`, // Changed to horizontal spacing
        setup: (self) => {
            self.pack_start(tabSection, false, false, 0);
            self.pack_end(contentStack, true, true, 0);
            setup(self);
            self.hook(shownIndex, (self) => onChange(self, shownIndex.value));
        },
        ...rest,
    });
    mainBox.nextTab = () => shownIndex.value = Math.min(shownIndex.value + 1, count - 1);
    mainBox.prevTab = () => shownIndex.value = Math.max(shownIndex.value - 1, 0);
    mainBox.cycleTab = () => shownIndex.value = (shownIndex.value + 1) % count;
    mainBox.shown = shownIndex;

    return mainBox;
}

export const ExpandingIconTabContainer = ({
    icons, names, children, className = '',
    setup = () => { }, onChange = () => { },
    tabsVpack = 'start', tabSwitcherClassName = '', // Changed from tabsHpack to tabsVpack
    transitionDuration = userOptions.animations.durationLarge,
    ...rest
}) => {
    const shownIndex = Variable(0);
    let previousShownIndex = 0;
    const count = Math.min(icons.length, names.length, children.length);
    const tabs = Box({
        vertical: true, // Keep vertical for vertical tab arrangement
        vpack: tabsVpack, // Changed from hpack to vpack
        className: `spacing-v-5 ${tabSwitcherClassName}`, // Changed to vertical spacing
        children: icons.map((icon, i) => {
            const tabIcon = MaterialIcon(icon, 'norm', { vexpand: true }); // Changed from hexpand to vexpand
            const tabName = DoubleRevealer({
                transition1: 'slide_right', // Keep slide_right for expanding to the right
                transition2: 'crossfade',
                duration1: 0,
                duration2: 0,
                // duration1: userOptions.animations.durationSmall,
                // duration2: userOptions.animations.durationSmall,
                child: Label({
                    className: 'margin-left-5 txt-small', // Keep margin-left for text to the right
                    label: names[i],
                }),
                revealChild: i === shownIndex.value,
            })
            const button = Button({
                className: 'tab-icon-expandable',
                tooltipText: names[i],
                child: Box({
                    homogeneous: true,
                    children: [Box({
                        hpack: 'start', // Changed to hpack start for left alignment
                        vertical: false, // Changed back to horizontal for icon + text layout
                        children: [
                            tabIcon,
                            tabName,
                        ]
                    })],
                }),
                setup: setupCursorHover,
                onClicked: () => shownIndex.value = i,
            });
            button.toggleFocus = (value) => {
                tabIcon.hexpand = !value; // Changed back to hexpand for horizontal expansion
                button.toggleClassName('tab-icon-expandable-active', value);
                tabName.toggleRevealChild(value);
            }
            return button;
        }),
        setup: (self) => self.hook(shownIndex, (self) => {
            self.children[previousShownIndex].toggleFocus(false);
            self.children[shownIndex.value].toggleFocus(true);
            previousShownIndex = shownIndex.value;
        }),
    });
    const tabSection = Box({
        homogeneous: true,
        children: [EventBox({
            onScrollUp: () => mainBox.prevTab(),
            onScrollDown: () => mainBox.nextTab(),
            child: Box({
                vertical: true,
                vexpand: true, // Keep vexpand for full height
                children: [
                    tabs,
                ]
            })
        })]
    });
    const contentStack = Stack({
        transition: 'slide_left_right', // Keep left_right since content area is beside tabs
        transitionDuration: transitionDuration,
        children: children.reduce((acc, currentValue, index) => {
            acc[index] = currentValue;
            return acc;
        }, {}),
        setup: (self) => self.hook(shownIndex, (self) => {
            self.shown = `${shownIndex.value}`;
        }),
    });
    const mainBox = Box({
        attribute: {
            children: children,
            shown: shownIndex,
            names: names,
        },
        vertical: false,
        className: `spacing-h-5 ${className}`,
        setup: (self) => {
            self.pack_start(tabSection, false, false, 0);
            self.pack_end(contentStack, true, true, 0);
            setup(self);
            self.hook(shownIndex, (self) => onChange(self, shownIndex.value));
        },
        ...rest,
    });
    mainBox.nextTab = () => shownIndex.value = Math.min(shownIndex.value + 1, count - 1);
    mainBox.prevTab = () => shownIndex.value = Math.max(shownIndex.value - 1, 0);
    mainBox.cycleTab = () => shownIndex.value = (shownIndex.value + 1) % count;
    mainBox.focusName = (name) => {
        const focusIndex = names.indexOf(name);
        if (focusIndex !== -1) {
            shownIndex.value = focusIndex;
        }
    }
    mainBox.shown = shownIndex;

    return mainBox;
}