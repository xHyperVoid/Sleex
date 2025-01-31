// Import
import App from 'resource:///com/github/Aylur/ags/app.js'
// Widgets
import Overview from './modules/overview/main.js';
import { COMPILED_STYLE_DIR } from './init.js';

handleStyles(true);

App.config({
    css: `${COMPILED_STYLE_DIR}/style.css`,
    stackTraceOnError: true,
    windows: [
        Overview(),
    ],
});
