require "/scripts/vec2.lua"

function init()
end

function update()
  if world.pointCollision(vec2.add(mcontroller.position(), {0, -4})) then
		local pos = vec2.add(mcontroller.position(), {0, -4})
		local opos = world.entityPosition(projectile.sourceEntity())
		
		if pos[2] < opos[2] then
			projectile.die()
		end
  end
end
