import Widget from 'resource:///com/github/Aylur/ags/widget.js';

export default () => {
    return Widget.box({
        name: `workspace-corner`,
        exclusivity: 'ignore',
        visible: true,
    });
}