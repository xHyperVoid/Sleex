import Widget from 'resource:///com/github/Aylur/ags/widget.js';
const { Box } = Widget;
import { userWidget } from '../widgets/user_widget.js';
import { clockWidget } from '../widgets/clock.js';
import { QuoteWidget } from '../widgets/quote.js';
import { MusicWidget } from '../widgets/music.js';
import { WeatherWidget } from '../widgets/weather.js';
import { githubWidget } from '../widgets/github.js';
import { timerWidget } from '../widgets/timer.js';
import ModuleNotificationList from "../centermodules/notificationlist.js";



export default () => Box({ 
    vertical: true,
    children: [
        Box({
            children: [
                Box({
                    vertical: true,
                    children: [
                        userWidget(),
                        clockWidget(),
                        githubWidget()
                    ]
                }),
                Box({
                    vertical: true,
                    children: [
                        Box({
                            children: [
                                Box({
                                    vertical: true,
                                    children: [
                                        ModuleNotificationList(),
                                    ]
                                }),
                                Box({
                                    vertical: true,
                                    children: [
                                        MusicWidget(),
                                        WeatherWidget(),
                                        timerWidget(),
                                    ]
                                })
                            ]
                        }),
                    ]
                })

            ]
        }),
        QuoteWidget()
    ]
});