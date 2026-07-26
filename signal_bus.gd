extends Node

signal you_died_signal		#when player dies, remove enemies to not break game, show game over, etc.
signal enemy_died_signal	#when enemy dies, remove it

signal game_start_signal 	#spawn player, start enemy timer
