import Widget from 'resource:///com/github/Aylur/ags/widget.js';
const { Box, Scrollable } = Widget;
import ColorPicker from './tools/colorpicker.js';
import Quote from './tools/quote.js';
import Name from './tools/name.js';
import Timer from './tools/timer.js';

export default Scrollable({
    hscroll: "never",
    vscroll: "automatic",
    child: Box({
        vertical: true,
        className: 'spacing-v-10',
        children: [
            ColorPicker(),
            Quote(),
            Timer(),
            Box({ vexpand: true }),
            Name(),
        ]
    })
});
