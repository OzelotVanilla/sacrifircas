`sacrifircas`
========

Gameplay
--------

Enter your player code and play the game.

The `player_code` follows this format: `${level_name}_${level_variation}_${player_side}`.

`level_name` could be (unless marked, levels are made for 2-players):

* `ld`: Last Dose.
* `ts`: Threshold (3-players).

`level_variation` is a `int` value.

`player_side` is either 1 or 2 (or 3 if 3-players game).

The choice player made was saved to a dict,
 and the choice could either be:
* `0`. Timeout and nothing chose.
* `1`. Choosed first option.
* `2`. Choosed second option.
