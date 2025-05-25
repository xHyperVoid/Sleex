import Widget from 'resource:///com/github/Aylur/ags/widget.js';
const { Box, Label } = Widget;
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'
const { exec } = Utils;


const request = async () => {
    try {
        const url = 'https://github-contributions.vercel.app/api/v1/levraiardox'
        const response = await Utils.fetch(url);
        const data = await response.json();
        return {
            contributions: data.years[0].total
        }
    } catch (error) {
        console.error("Unable to fetch contributions: ", error)
        return {
            contributions: "error"
        }
    }
}

export const githubWidget = () => {
    const contribLabel = new Label({
        className: 'txt txt-contrib',
        hpack: 'center',
        label: `Loading...`,
    });

    (async () => {
        const { contributions } = await request();
        contribLabel.label = `${contributions}`;
    })();

    return new Box({
        vertical: true,
        className: 'github-widget dash-widget spacing-v-5',
        children: [
            contribLabel,
            new Label({
                className: 'txt txt-medium',
                hpack: 'center',
                label: 'contributions this year',
            }),
            new Label({
                className: 'txt txt-author',
                hpack: 'center',
                label: '@levraiardox'
            })
        ],
    });
};