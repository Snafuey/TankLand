extends Node

signal change_game_state(new_state)

signal battleMain_walls_changed(new_wall_type)

signal terrain_finished(build_points)

signal turnQueue_tank_spawn_finished()
signal turnQueue_round_finished(last_tank_ref)

signal tank_turn_finished()
signal tank_activated(power, angle, health, tank_ref)
signal tank_health_changed(health)
signal tank_power_changed(power)
signal tank_angle_changed(angle)
signal tank_died(tank_ref)



