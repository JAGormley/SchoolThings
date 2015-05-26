:- dynamic 	player/2,
			no_suggestions/0,
			type/2,
			i_have/1,
			number_of_players/1,
			number_of_cards/1,
			player_suggested/4,
			current_player/1,
			current_guess/4,
			showed_card/1.

/* MAIN PROCEDURE */
clue :-
	nl, write('Welcome to Clue! I\'m your Clue Assistant. Let\'s get started. '),
	nl, setup_players.

no_suggestions.

/* UI HELP FOR USER */
help_enter :- write('I only understand words in lower case with no punctuation, followed by a period. ').
help_reenter :- write('Enter words the same way you did before. ').
more_or_end :- write(' (";" for more, "." to exit) ').
digit :- write('Enter a digit, followed by a period: ').
menu_help :- write('Type "menu." at the question mark prompt to see what you can do. Now press Return!').


/* SETTING UP THE GAME */
next_player(X) :- number_of_players(N), X is N+1, nl, setup_suspects.
next_player(N) :-
	write('Whose turn comes after that? Enter their name: '),
	read(Name), assert(player(N,Name)), N1 is N+1, next_player(N1).
setup_players :-
	write('First let\'s set up the players. '), nl, help_enter, nl,
	write('How many players in the game, including you?'), nl,
	digit, read(N), assert(number_of_players(N)), nl,
	assert(player(1,me)),
	write('Now tell the other players\' names. '), nl,
	write('Whose turn comes after yours? Enter their name: '),
	read(P), assert(player(2,P)), next_player(3).

enter_suspect(6) :-
	write('Enter the last suspect\'s name: '),
	read(S), assert(type(S, person)), assert(in_play(S)), nl, setup_weapons.
enter_suspect(X) :-
	write('Enter another suspect\'s name: '),
	read(S), assert(type(S, person)), assert(in_play(S)), X1 is X+1, enter_suspect(X1).
setup_suspects :-
	write('Now let\'s set up the suspects. '), nl, help_enter, nl,
	write('Enter a suspect\'s name: '),
	read(S), assert(type(S, person)), assert(in_play(S)), enter_suspect(2).

enter_weapon(6) :-
	write('Enter the last weapon: '),
	read(W), assert(type(W, weapon)), assert(in_play(W)), nl, setup_rooms.
enter_weapon(X) :-
	write('Enter another weapon: '),
	read(W), assert(type(W, weapon)), assert(in_play(W)), X1 is X+1, enter_weapon(X1).
setup_weapons :- write('Now let\'s set up the weapons. '), nl, help_enter, nl,
	write('Enter a weapon: '),
	read(W), assert(type(W, weapon)), assert(in_play(W)), enter_weapon(2).

enter_room(9) :-
	write('Enter the last room: '),
	read(R), assert(type(R, room)), assert(in_play(R)), nl, setup_cards.
enter_room(X) :-
	write('Enter another room: '),
	read(R), assert(type(R, room)), assert(in_play(R)), X1 is X+1, enter_room(X1).
setup_rooms :-
	write('Now let\'s set up the rooms. '), nl, help_enter, nl,
	write('Enter a room: '),
	read(R), assert(type(R, room)), assert(in_play(R)), enter_room(2).

next_card(N) :-
	number_of_cards(N), write('Enter your last card: '),
	read(Card), assert(i_have(Card)), retract(in_play(Card)), nl, lets_go, who_first, menu_help.
next_card(N) :-
	write('Enter your next card: '),
	read(Card), assert(i_have(Card)), retract(in_play(Card)), N1 is N+1, next_card(N1).
setup_cards :-
	write('I\'ll help you keep track of all the cards you\'ve seen.'), nl,
	write('How many cards do you have in your hand? '), nl, digit,
	read(N), assert(number_of_cards(N)), nl,
	write('Now tell me your cards. '), nl, help_reenter, nl,
	write('Enter your first card: '),
	read(Card), assert(i_have(Card)), retract(in_play(Card)), next_card(2).

lets_go :- write('Alright! I\'m ready. Let\'s start the game. '), nl.

who_first :- write('Who goes first? '), read(CurrentPlayer), who_goes_next(StartPlayer, CurrentPlayer), assert(current_player(StartPlayer)).

menu :-
	write('Type "start_turn." for the next player\'s turn.'), nl,
	write('Type "whose_turn." to see whose turn it is.'), nl,
	write('Type "players." to see the names of all the players.'), nl,
	write('Type "cards." to see the cards you have.'), nl,
	write('Type "suspects." to see suspect names.'), nl,
	write('Type "rooms." to see room names.'), nl,
	write('Type "weapons." to see weapon names.'), nl,
	write('Type "my_suggestions." to see the suggestions you\'ve already made.'), nl,
	write('Type "known." to see what I know so far.'), nl,
	write('Type "docs." to read about what I can do.').

/* VIEW THE CONTENTS OF THE DATABASE */
known :- players, nl, known_turn, nl, cards, nl, in_play, nl,
	known_suspects, nl, known_rooms, nl, known_weapons, nl.
known_turn :- write('It is currently '), current_player(X), write(X), write('\'s turn.').
known_suspects :- suspects, best_suspect(Y), write('The current best suspect is '), write(Y), write('.').
known_rooms :- rooms.
known_weapons :- weapons, best_weapon(Y), write('The current best weapon is '), write(Y), write('.').


/* INFO ABOUT PLAYERS */
number_of_players :-
	write('There are '), number_of_players(X), write(X),
	write(' players in this game.'), nl.
players :- number_of_players, write('The players are... '), get_player_list(Y), write(Y).

/* INFO ABOUT CARDS YOU HAVE */
number_of_cards :- write('You have '), number_of_cards(X), write(X),
	write(' cards.'), nl.
cards :- number_of_cards, write('Your cards are... '), findall(X, i_have(X), X), write(X).

/* GET INFO ABOUT A SUBSET OF GAME CARDS */
suspects :- suspects(X), write(X), nl.
suspects(X) :- findall(X, type(X, person), X), write('The names of the suspects are... ').
rooms :- rooms(X), write(X).
rooms(X) :- findall(X, type(X, room), X), write('The names of the rooms are... ').
weapons :- weapons(X), write(X), nl.
weapons(X) :- findall(X, type(X, weapon), X), write('The names of the weapons are... ').
in_play :- findall(X, in_play(X), X), write('The cards still in play are... '), write(X).


/* WHOSE TURN IS IT? WHAT ABOUT AFTER THAT? */
whose_turn :- current_player(me), write('Whose turn is it? Great question. It\'s your turn. ').
whose_turn :- current_player(Name), write('Whose turn is it? Great question. It\'s '),  write(Name), write('\'s turn. ').
who_goes_next(Name, me) :- number_of_players(N), player(N, Name).
who_goes_next(me, Next) :- player(2, Next).
who_goes_next(Name, Next) :- player(N,Name), N1 is N+1, player(N1, Next).

/* WHICH SUGGESTIONS HAVE BEEN MADE? */
remove_no_suggestions(me) :- retract(no_suggestions).
remove_no_suggestions(Player).
suggested :-
	write('Who made a suggestion? Type "me." if it was you. '), read(Player),
	write('Okay, now tell me the suggestion. '), nl, help_enter, nl,
	write('Which suspect got named? '), read(S),
	write('Which room got named? '), read(R),
	write('Which weapon got named? '), read(W),
	assert(player_suggested(Player,S,R,W)), remove_no_suggestions(Player).

/* WHICH SUGGESTIONS HAVE I MADE*/
get_my_suggestions :-
	player_suggested(me,S,R,W), write(S), write(', '), write(R), write(', '), write(W), nl.
my_suggestions :- no_suggestions, write('You haven\'t made any suggestions yet. ').
my_suggestions :-
	write('Here are the suggestions you\'ve made: '),
	nl, get_my_suggestions, nl, more_or_end.

/* DOCUMENTATION ABOUT THE CLUE ASSISTANT */
docs :-
	write('Welcome to the Clue Assistant! I help you look good when you\'re playing Clue. '), nl,
	write('As your assistant, I do game setup and tracking, including everything listed when you type "menu." '), nl,
	write('Most importantly, I can tell you what to suggest when it\'s your turn'), nl,
	write('Sadly, I can\'t do much that isn\'t listed under the "menu." '), nl,
	write('I also can\'t help you if you don\'t tell me what happens in the game. '), nl,
	write('So keep me updated! '), nl, help_enter, nl,
	write('How does it work? I use a simple strategy to deduce which cards are in the envelope. '), nl,
	write('For instance, if you\'ve seen all the suspect cards except one, I know that last one is the killer. '), nl,
	write('I use a heuristic algorithm to track the likelihood that each card is in the envelope. '), nl,
	write('I do this by tracking when players show a card or pass given a suggestion mentioning that card.'),
	write('I\'d tell you more about how I work... but then I\'d have to kill you.'), nl,
	write('Haha, just kidding! (I think.)'), nl,
	write('Okay, let\'s get back to the game.'), nl,
	menu_help, nl.

/* THINGS CHANGE AT PLAYER TURN HANDOFF */


change_turn(Next) :- current_player(Name), who_goes_next(Name, Next), change_current_player(Next).
start_turn :- change_turn(Next), take_turn(Next), menu.

/* WHAT A TURN LOOKS LIKE FOR ME */
take_turn(me) :- write('Your turn! '), get_room.
get_room :- write('What room are you in? Enter the room name or else enter "corridor." '),
	read(Room), room_check(Room).

/* check if in corridor */
room_check(Room) :- (Room = corridor -> roll_dice ; check_valid_room(Room)).
/* if not, check if room is still in play (if yes, make suggestion) */
check_valid_room(Room) :- (check_room_validity(Room) -> advise_me; roll_dice).
/* if not, roll the dice */
roll_dice :- write('Okay, roll the dice. '), get_room_again.
get_room_again :- write('What room are you in? Enter the room name or else enter "corridor." '),
	read(Room), room_check_again(Room).
/* repeat room check // validation */
room_check_again(Room) :- (Room = corridor -> write('Your turn is over') ; check_valid_room_again(Room)).
check_valid_room_again(Room) :- (check_room_validity(Room) -> advise_me; write('Your turn is over')).


/* Make Suggestion path */
advise_me :- suggest_guess(S,R,W), write('You should suggest "It was '),
				write(S), write(', in the '), write(R), write(', with the '), write(W), write('".\n'),
				change_current_guess(S,R,W), learned.
learned :- write('Who showed a card? '), read(Player), player_showed_card_to_you(Player),
		write('What card? '), read(Card), eliminate_card(Card), nl.


/* WHAT A TURN LOOKS LIKE FOR OTHER PLAYERS */
take_turn(NotMe) :- get_others_suggestion, you_show_a_card.
get_others_suggestion :-
	current_player(Name), write(Name), write('\'s turn!'), nl,
	write('What suspect did they suggest? '), read(Suspect),
	write('What room did they suggest? '), read(Room),
	write('What weapon did they suggest? '), read(Weapon),
	change_current_guess(Suspect, Room, Weapon).
you_show_a_card :- write('Do you need to show a card ("yes." or "no.")? '),
	read(Answer), get_response(Answer).
get_response(yes) :- write('Okay, you should show this card: '), best_card_to_show(Card), write(Card), nl, nl.
get_response(no) :- write('Who did show a card? '), read(Player), player_showed_card_to_other(Player), nl, nl.
