`sacrifircas`
========

Gameplay
--------

Enter your player code and play the game.

The `player_code` follows this format: `${level_name}_${level_variation}_${player_side}`.

`level_name` could be:

* `ld`: Last Dose.

`level_variation` is a `int` value.

`player_side` is either 1 or 2.

The choice player made was saved to a dict,
 and the choice could either be:
* `0`. Timeout and nothing chose.
* `1`. Choosed first option.
* `2`. Choosed second option.
