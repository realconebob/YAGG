extends Node

func handle_collision(collider: KinematicCollision2D, collidee: BaseEntity) -> void:
	# Need to handle collisions between:
		# Walls: Players, Enemies, and Bullets
		# Players: Enemies
		# Enemies: Players, Enemies, and Bullets
		# Bullets: Enemies
		
	if collider.get_collider().has_method("get_type"):
		if (collider.get_collider().call("get_type") as String) == "Wall":
			match collidee.get_type():
				"Bullet":
					collidee.health = 0
					return
				
				"Player", "Zombie":
					# Translate movement to normal without losing speed
					#collidee.accel = (collidee.accel.slide(collider.get_normal()).normalized() * collidee.accel.length())
					#collidee.velocity = collidee.velocity.slide(collider.get_normal()).normalized() * collidee.velocity.length()
					
					# Bounce
					collidee.accel = (collidee.accel.bounce(collider.get_normal()))
					collidee.velocity = collidee.velocity.bounce(collider.get_normal())
					return
			
			return
	
	if collidee.get_type() == "Player":
		if !collider.get_collider().has_method("get_type"): return
		if collider.get_collider().call("get_type") == "Zombie":
				collidee.health = (collidee.health - 1)
				collidee.accel = (collidee.accel.bounce(collider.get_normal()).normalized() * collidee.accel.length() * 100)
				collidee.velocity = collidee.velocity.bounce(collider.get_normal())
				return
			
		return
		
	if collidee.get_type() == "Zombie":
		if !collider.get_collider().has_method("get_type"): return
		match collider.get_collider().call("get_type"):
			"Player":
				var player: BaseEntity = collider.get_collider()
				player.health = (player.health - 1)
				
				collidee.accel = (collidee.accel.bounce(collider.get_normal()).normalized() * collidee.accel.length() * 100)
				collidee.velocity = collidee.velocity.bounce(collider.get_normal()) * 10
				return
				
			"Zombie":
				collidee.accel = (collidee.accel.bounce(collider.get_normal()))
				collidee.velocity = collidee.velocity.bounce(collider.get_normal())
				return
				
			"Bullet":
				var bullet: BaseEntity = collider.get_collider()
				bullet.add_collision_exception_with(collidee)
				
				var zhealth := collidee.health
				var bhealth := bullet.health
				collidee.health = (zhealth - bhealth)
				bullet.health = (bhealth - zhealth)
				return
			
		return
	
	if collidee.get_type() == "Bullet":
		if !collider.get_collider().has_method("get_type"): return
		if collider.get_collider().call("get_type") == "Zombie":
			var zombie: BaseEntity = collider.get_collider()
			collidee.add_collision_exception_with(zombie)
			
			var zhealth := zombie.health
			var bhealth := collidee.health
			zombie.health = (zhealth - bhealth)
			collidee.health = (bhealth - zhealth)
	
	return
