extends Node

signal change_game_state(new_state) # warning-ignore:unused_signal

signal battleMain_walls_changed(new_wall_type) # warning-ignore:unused_signal

signal terrain_finished(build_points) # warning-ignore:unused_signal

signal turnQueue_tank_spawn_finished() # warning-ignore:unused_signal
signal turnQueue_round_finished(last_tank_ref) # warning-ignore:unused_signal
signal turnQueue_damage_applied() # warning-ignore:unused_signal

signal tank_turn_finished() # warning-ignore:unused_signal
signal tank_activated(power, angle, health, tank_ref) # warning-ignore:unused_signal
signal tank_health_changed(health) # warning-ignore:unused_signal
signal tank_power_changed(power) # warning-ignore:unused_signal
signal tank_angle_changed(angle) # warning-ignore:unused_signal
signal tank_weapon_changed(weapon) # warning-ignore:unused_signal
signal tank_died(tank_ref) # warning-ignore:unused_signal

signal shop_item_selected(item_resource) # warning-ignore:unused_signal

