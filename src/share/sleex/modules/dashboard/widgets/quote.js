import Widget from 'resource:///com/github/Aylur/ags/widget.js';
const { Box, Label } = Widget;
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'

const MakeRequest = async () => {
    try {
        const response = await Utils.fetch("https://quotes-api-self.vercel.app/quote");
        const data = await response.json();
        return {
            quote: data.quote, 
            author: data.author
        };
    } catch (error) {
        console.error('Error fetching quote:', error);
        return { 
            quote: 'Unable to fetch quote', 
            author: 'Unknown' 
        };
    }
};

export const QuoteWidget = () => {
    const quoteLabel = new Label({
        wrap: true,
        hpack: 'center',
        className: 'txt txt-medium',
        label: 'Loading...'
    });

    const authorLabel = new Label({
        hpack: 'center',
        className: 'txt txt-small txt-bold txt-quote-author',
        label: 'Loading...'
    });

    // Immediately invoke async function to update labels
    (async () => {
        const { quote, author } = await MakeRequest();
        quoteLabel.label = quote;
        authorLabel.label = author;
        // console.log('Quote:', quote);
        // console.log('Author:', author);
    })();

    return new Box({
        vertical: true,
        className: 'spacing-v-5 dash-widget quote-widget',
        children: [
            quoteLabel,
            authorLabel
        ]
    })
};