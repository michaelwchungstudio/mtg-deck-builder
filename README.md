![Site Landing](/app/assets/siteimg/sitelanding.png)

# Magic: The Gathering Deck Builder Application

Full-stack application that allows users to create, view, and share custom Magic: The Gathering decks.

## How To Use

From the homepage, site visitors can view users and decks from the links in the navigation bar. However, they will be unable to create their own decks until they register an account. After doing so, a user will be able to create a new deck by selecting the 'New Deck' link and naming the deck on the subsequent page.

The deck edit page has many functions (loading may be slower than what can optimally be achieved with a JavaScript framework such as React). Users can search through a vast database of over 40,000 cards depending on card reprints from different sets. Criteria to search for cards includes the name of the card, color (red, white, blue, black, green, neutral), creature type, set, or type. Card search results will display a maximum of 9 per page in the area below; each card will have an image, name of the card, the mana cost to cast the card, a text description of the card, a price (drawn from eBay's API), and the option to add any number of the card to the deck. The current cards for the deck are shown in a list format separated by card type to the right of the card results.

Deck Edit Page:

![Deck Edit Page](/app/assets/siteimg/deckedit.png)

After saving a deck, users can view that specific deck in the redirected page or select the deck from either the user's profile or the site-wide list of decks. Viewing a deck is fairly straightforward. Cards are split by type in the same format as the deck list on the deck edit page. Hovering over a card will change the card image displayed on the right. If you are not a user that created that deck, you will not have the option to edit or delete that deck.

Deck View Page:

![Deck View Page](/app/assets/siteimg/deckshow.png)

## Future Improvements / Bug Fixes

React -> etc.

## Built with

* HTML
* CSS / SASS
* Ruby on Rails
* eBay API
* [Magic: The Gathering Ruby SDK](https://github.com/MagicTheGathering/mtg-sdk-ruby)
* Devise gem

## Authors

* [Michael Chung](https://github.com/michaelwchungstudio)
* [Manuel Ortiz](https://github.com/ManuelAOrtiz)
* [Kyle Hampton](https://github.com/kyle-hampton)
* [Ross Coley](https://github.com/rlcoley)

## Acknowledgments

* Oggi Danailov
* New York Code & Design Academy
* StackOverflow
* [Andrew Backes](https://github.com/adback03)
* Wizards of the Coast
