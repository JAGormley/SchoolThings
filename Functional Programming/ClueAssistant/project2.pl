% Susannah Kirby
% Andrew Gormley

:- dynamic
      player/2,
      type/2,
      in_room/1,
      i_have/1,
      weapon_evidence/3,
      person_evidence/3,
      room_evidence/3,
      current_room/1,
      player_suggested/4,
      current_player/1,
      current_guess/4,
      no_suggestions/0,
      number_of_players/1,
      number_of_cards/1,
      showed_card/1,
      in_play/1,
      first_player/1,
      not_started/0.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% MAIN PROCEDURE %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clue :-
  nl, write('Welcome to Clue! I\'m your Clue Assistant. Let\'s get started. '),
  nl, setup_players.

/* INITIALIZATIONS NEEDED FOR GAME START */
no_suggestions.
not_started.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% UI CODE %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

who_first :- write('Who goes first? Type "me." if it\'s you. '), read(CurrentPlayer),
        who_goes_next(StartPlayer, CurrentPlayer), assert(current_player(StartPlayer)),
        assert(first_player(CurrentPlayer)).

/* MENU OPTIONS */
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
known_turn :- not_started,  first_player(X), write('It is currently '), write(X), write('\'s turn.').
known_turn :- current_player(me), write('It is currently your turn.').
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
whose_turn :- not_started, first_player(Name),
    write('Whose turn is it? Great question. It\'s '),  write(Name), write('\'s turn. ').
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
  write('Most importantly, I can tell you what to suggest when it\'s your turn. '), nl,
  write('Sadly, I can\'t do much that isn\'t listed under the "menu." '), nl,
  write('I also can\'t help you if you don\'t tell me what happens in the game. '), nl,
  write('So keep me updated! '), nl, help_enter, nl,
  write('How does it work? I use a simple strategy to deduce which cards are in the envelope. '), nl,
  write('For instance, if you\'ve seen all the suspect cards except one, I know that last one is the killer. '), nl,
  write('I use a heuristic algorithm to track the likelihood that each card is in the envelope. '), nl,
  write('I do this by tracking when players show a card or pass given a suggestion mentioning that card. '),
  write('I\'d tell you more about how I work... but then I\'d have to kill you.'), nl,
  write('Haha, just kidding! (I think.) '), nl,
  write('Okay, let\'s get back to the game. '), nl,
  menu_help, nl.

/* THINGS CHANGE AT PLAYER TURN HANDOFF */
change_turn(Next) :- current_player(Name), who_goes_next(Name, Next), change_current_player(Next).
start_turn :- retract(not_started), change_turn(Next), take_turn(Next), menu.
start_turn :- change_turn(Next), take_turn(Next), menu.

/* WHAT A TURN LOOKS LIKE FOR ME */
take_turn(me) :- write('Your turn! '), get_room.
get_room :- write('What room are you in? Enter the room name or else enter "corridor." '),
  read(Room), room_check(Room).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% TURN FLOW LOGIC %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* check if in corridor */
room_check(Room) :- (Room = corridor -> roll_dice ; check_valid_room(Room)).
/* if not, check if room is still in play (if yes, make suggestion) */
check_valid_room(Room) :- (check_room_validity(Room) -> advise_me; roll_dice).
/* if not, roll the dice */
roll_dice :- write('Okay, roll the dice. '), get_room_again.
get_room_again :- write('What room are you in? Enter the room name or else enter "corridor." '),
  read(Room), room_check_again(Room).
/* repeat room check // validation */
room_check_again(Room) :- (Room = corridor -> write('Your turn is over. ') ; check_valid_room_again(Room)).
check_valid_room_again(Room) :- (check_room_validity(Room) -> advise_me; write('Your turn is over. ')).

/* Make Suggestion path */
advise_me :- suggest_guess(S,R,W), write('You should suggest "It was '),
        write(S), write(', in the '), write(R), write(', with the '), write(W), write('".\n'),
        change_current_guess(S,R,W), learned.
learned :- write('Who showed a card? '), read(Player), player_showed_card_to_you(Player),
    write('What card? '), read(Card), eliminate_card(Card), nl.

/* WHAT A TURN LOOKS LIKE FOR OTHER PLAYERS */
take_turn(NotMe) :- get_others_suggestion, you_show_a_card.
get_others_suggestion :-
  current_player(Name), write(Name), write('\'s turn! '), nl,
  write('What suspect did they suggest? '), read(Suspect),
  write('What room did they suggest? '), read(Room),
  write('What weapon did they suggest? '), read(Weapon),
  change_current_guess(Suspect, Room, Weapon).
you_show_a_card :- write('Do you need to show a card ("yes." or "no.")? '),
  read(Answer), get_response(Answer).
get_response(yes) :- write('Okay, you should show this card: '), best_card_to_show(Card), write(Card), nl, nl.
get_response(no) :- write('Who did show a card? '), read(Player), player_showed_card_to_other(Player), nl, nl.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% SUGGEST GUESS FUNCTIONS %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

suggest_guess(Person, Room, Weapon) :- best_suspect(Person), in_room(Room), best_weapon(Weapon).

best_weapon(Weapon) :- examine_weapon_misses(L), sort(L,X), reverse(X,[(Count,Weapon)|T]).
best_suspect(Person) :- examine_people_misses(L), sort(L,X), reverse(X,[(Count,Person)|T]).

/* WHO SHOWED A CARD // WHO PASSED? FUNCTIONS */

/* FILTER PLAYERS WHO EITHER DID NOT PASS ON THIS TURN, OR ARE THE ASKER OR SHOWER (KEEP ONLY PLAYERS WHO PASSED) */
clockwise_player_filter(SPlayer, L) :- rotate_player_list(Y), this_players_turn(CPlayer), get_player_number_mod(Y, CPlayer, N1),  get_player_number_mod(Y, SPlayer, N2), filter_h(Y, L, N1, N2).
filter_h([],[], _, _).
filter_h([(PNum,PName)|Tail], [PName|PTail], N1, N2) :- (PNum > N1), (PNum < N2), filter_h(Tail, PTail,  N1, N2).
filter_h([(PNum,PName)|Tail], PTail, N1, N2) :- (PNum =< N1), filter_h(Tail, PTail,  N1, N2).
filter_h([(PNum,PName)|Tail], PTail, N1, N2) :- (PNum >= N2), filter_h(Tail, PTail,  N1, N2).

/* GET PLAYER NUMBER FROM ROTATED LIST */
get_player_number_mod([], [], _).
get_player_number_mod([(PNum, Player)|T], Player, PNum).
get_player_number_mod([(WPNum, NPlayer)|T], Player, NPNum) :- get_player_number_mod(T, Player, NPNum).


/* ROTATE LIST TO CALCULATE CLOCKWISE ASKING */
rotate_player_list(M) :- get_player_list(PL), current_player(CP), get_player_number(CP, CNum),  (MoveDist is CNum - 1), rotate_player_list_h(L, PL, MoveDist), sort(L, M).
rotate_player_list_h([], [] , _).
rotate_player_list_h([(NewPNum, PName)|T], [(PNum, PName)|PT], MoveDist) :-
                            (SubRes is PNum - MoveDist), (SubRes < 1), (NewPNum is SubRes + 6), rotate_player_list_h(T, PT, MoveDist).
rotate_player_list_h([(NewPNum, PName)|T], [(PNum, PName)|PT], MoveDist) :-
                            (NewPNum is PNum - MoveDist), (NewPNum >= 1), rotate_player_list_h(T, PT, MoveDist).

this_guess(Player, Person, Room, Weapon) :- current_guess(Player, Person, Room, Weapon).
change_current_guess(NewPerson, NewRoom, NewWeapon) :-
        this_players_turn(NewPlayer),
        this_guess(OrigPlayer, OrigRoom, OrigWeapon, OrigPerson),
        retract(current_guess(U, P, R, W)),
        assert(current_guess(NewPlayer, NewPerson, NewRoom, NewWeapon)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% EVIDENCE HEURISTIC FUNCTIONS %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

player_showed_card_to_you(ShowPlayer) :-
        this_guess(Player, Person, Room, Weapon),
        add_misses(ShowPlayer, Person, Room, Weapon).

player_showed_card_to_other(ShowPlayer) :-
        this_guess(Player, Person, Room, Weapon),
        add_room_evidence(ShowPlayer, Room, hit),
        add_weapon_evidence(ShowPlayer, Weapon, hit),
        add_person_evidence(ShowPlayer, Person, hit),
        check_eliminated(ShowPlayer, Person, Room, Weapon),
        add_misses(ShowPlayer, Person, Room, Weapon).

add_misses(SPlayer, Person, Room, Weapon) :- clockwise_player_filter(SPlayer, L), add_misses_h(L, Person, Room, Weapon).
add_misses_h([], _, _, _).
add_misses_h([H|T], Person, Room, Weapon) :-  add_room_evidence(H, Room, miss),
                                              add_weapon_evidence(H, Weapon, miss),
                                              add_person_evidence(H, Person, miss),
                                              check_eliminated(H, Person, Room, Weapon),
                                              add_misses_h(T, Person, Room, Weapon).


add_room_evidence(Player, Room, HitOrMiss) :- assert(room_evidence(Player, Room, HitOrMiss)).
add_weapon_evidence(Player, Weapon, HitOrMiss) :- assert(weapon_evidence(Player, Weapon, HitOrMiss)).
add_person_evidence(Player, Person, HitOrMiss) :- assert(person_evidence(Player, Person, HitOrMiss)).

the_room_evidence(Player, Room, HitOrMiss) :- room_evidence(Player, Room, HitOrMiss).
the_weapon_evidence(Player, Weapon, HitOrMiss) :- weapon_evidence(Player, Weapon, HitOrMiss).
the_person_evidence(Player, Person, HitOrMiss) :- person_evidence(Player, Person, HitOrMiss).


/* MISS COUNTER */

%Count Misses Per Element (by Type)
weapon_miss_counter(Weapon, Count) :- findall(Weapon, the_weapon_evidence(Player, Weapon, miss), R), length(R, Count).
room_miss_counter(Room, Count) :- findall(Room, the_room_evidence(Player, Room, miss), R), length(R, Count).
person_miss_counter(Person, Count) :- findall(Person, the_person_evidence(Player, Person, miss), R), length(R, Count).

examine_weapon_misses(H) :- list_of_inplay_weapons(L), examine_weapon_misses_h(L, H).
examine_weapon_misses_h([], []).
examine_weapon_misses_h([H|T], [(Count,H)|NewH]) :- weapon_miss_counter(H, Count), examine_weapon_misses_h(T, NewH).

examine_people_misses(H) :- list_of_inplay_people(L), examine_people_misses_h(L, H).
examine_people_misses_h([], []).
examine_people_misses_h([H|T], [(Count,H)|NewH]) :- person_miss_counter(H, Count), examine_people_misses_h(T, NewH).


/* HIT COUNTER */

%Count Hits Per Element (by Type)
weapon_hit_counter(Weapon, Count) :- findall(Weapon, the_weapon_evidence(Player, Weapon, hit), R), length(R, Count).
room_hit_counter(Room, Count) :- findall(Room, the_room_evidence(Player, Room, hit), R), length(R, Count).
person_hit_counter(Person, Count) :- findall(Person, the_person_evidence(Player, Person, hit), R), length(R, Count).

examine_weapon_hits(H) :- list_of_inplay_weapons(L), examine_weapon_hits_h(L, H).
examine_weapon_hits_h([], []).
examine_weapon_hits_h([H|T], [(Count,H)|NewH]) :- weapon_hit_counter(H, Count), examine_weapon_hits_h(T, NewH).

examine_people_hits(H) :- list_of_inplay_people(L), examine_people_hits_h(L, H).
examine_people_hits_h([], []).
examine_people_hits_h([H|T], [(Count,H)|NewH]) :- person_hit_counter(H, Count), examine_people_hits_h(T, NewH).

examine_room_hits(H) :- list_of_inplay_rooms(L), examine_room_hits_h(L, H).
examine_room_hits_h([], []).
examine_room_hits_h([H|T], [(Count,H)|NewH]) :- room_hit_counter(H, Count), examine_room_hits_h(T, NewH).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% "SHOW A CARD" FUNCTIONS  %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

best_card_to_show(Card) :- examine_my_cards(L), sort(L,X), reverse(X,R), select_card(R, Card).

select_card([(Count,Card)|T], Card) :- current_guess(_, Card, Y, Z), !.
select_card([(Count,Card)|T], Card) :- current_guess(_, X, Card, Z), !.
select_card([(Count,Card)|T], Card) :- current_guess(_, X, Y, Card), !.
select_card([H|T], Card) :- select_card(T, Card).

list_of_my_cards(L) :- findall(X, i_have(X), L).
examine_my_cards(R) :- list_of_my_cards(L), examine_people_hits_h(L,X), examine_weapon_hits_h(L,Y), examine_room_hits_h(L,Z), append(X,Y,N), append(N,Z,R).



check_eliminated(Player, P,R,W) :-
                check_elim_h(Player, P,R,W).

check_eliminated(P,Q,R,S).

check_elim_h(Player, Person, Room, Weapon) :-
                the_person_evidence(Player, Person, hit),
                not(the_person_evidence(Player, Person, miss)),
                the_room_evidence(Player, Room, miss),
                the_weapon_evidence(Player, Weapon, miss),
                eliminate_card(Person), write(Person), write(' has been eliminated! '), nl.

check_elim_h(Player, Person, Room, Weapon) :-
                the_room_evidence(Player, Room, hit),
                not(the_room_evidence(Player, Room, miss)),
                the_person_evidence(Player, Person, miss),
                the_weapon_evidence(Player, Weapon, miss),
                eliminate_card(Room), write(Room), write(' has been eliminated! '), nl.

check_elim_h(Player, Person, Room, Weapon) :-
                the_weapon_evidence(Player, Weapon, hit),
                not(the_weapon_evidence(Player, Weapon, miss)),
                the_room_evidence(Player, Room, miss),
                the_person_evidence(Player, Person, miss),
                eliminate_card(Weapon), write(Weapon), write(' has been eliminated! '), nl.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% GENERAL HELPERS %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%% ROOM HELPERS %%%%
% make sure current room has not been eliminated
check_room_validity(X) :- change_current_room(X), room_in_play(X).
in_room(X) :- current_room(X).

%% change room you are in
change_current_room(X) :- in_room(Y), retract(current_room(Y)), assert(current_room(X)).

%%%% TURN HELPERS %%%%
this_players_turn(X) :- current_player(X).
change_current_player(X) :- this_players_turn(Y), retract(current_player(Y)), assert(current_player(X)).

%%%%%%%%%%%%%% PLAYER INFO HELPERS %%%%%%%%%%%%%%
get_player_list(Y) :- findall((X,Y), player(X,Y), Y).
get_player_number(Player, X) :- player(X, Player).


%%%% CARD ADD/REMOVE/QUERY HELPERS %%%%

%% show/check cards of a particular type in play
room_in_play(X) :- type(X, room), in_play(X).
weapon_in_play(X) :- type(X, weapon), in_play(X).
person_in_play(X) :- type(X, person), in_play(X).

%Get Lists of Elements Not Eliminated (by Type)
list_of_inplay_weapons(WeaponList) :- findall(X, weapon_in_play(X), WeaponList).
list_of_inplay_rooms(RoomList) :- findall(X, room_in_play(X), RoomList).
list_of_inplay_people(PersonList) :- findall(X, person_in_play(X), PersonList).

%% remove card from play
eliminate_card(X) :- retract(in_play(X)).

%% initialize static data
weapon_evidence([], [], []).
person_evidence([], [], []).
room_evidence([], [], []).
current_room(corridor).
current_guess(init, init, init, init).




