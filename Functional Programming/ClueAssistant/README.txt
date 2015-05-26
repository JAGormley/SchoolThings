%%%%% CLUE ASSISTANT %%%%%
%%%%% Susannah Kirby %%%%%
%%%%% Andrew Gormley %%%%%


Welcome to the Clue Assistant! This system uses Prolog to 
do all the "heavy lifting" of playing Clue. Start it up by 
typing "clue."... then sit back and look smart!


Here's what the Clue Assistant can do that makes it awesome:

* Heuristic-based gameplay advice
  - The Assistant tracks game play to assess what your best move 
    is at any time. 
  - Its heuristic algorithm works by using knowledge about which 
  	cards are still "in play" (i.e. those that haven't been seen)  
    and how many "hits" and "misses" those cards have had so far. 
    These are calculated based on how many people there are 
    between the suggester and the person who shows a card - if 
    anyone does show a card.
  - At any moment, the Assistant knows which is the best suspect,
    room, and weapon to suggest, and this is updated at each
    player's turn.
  - Additionally, if any player previously "passed" on 2 of the 3
    cards contained in the suggesting player's 3-card guess-set,
    then shows that player a card, the algorithm eliminates from
    play the card that they had not previously passed on.
  - When it's your turn, the Assistant will tell you what to do.
  - When it's not your turn, and you must show a card, the 
    Assistant will tell you which card is the best one to show.

* "Behind-the-scenes" action, with the option of transparency
  - The Assistant does a lot of its logical work behind the  
    scenes, without requiring significant user input. 
  - If the user wants a more hands-on approach, the Assistant 
    can also provide access to the contents of its database on
    demand.

* Clear, easy-to-understand user interface
  - Text-based guidance helps user with input format. 
  - Menu options are easily accessible.
  - No knowledge of Prolog assumed or needed!

* Dynamic game setup
  - Accommodates the traditional suspects, rooms, and weapons...
   	or newfangled ones!
  - Allows game play with a variable number of 2-6 players.
