require "/scripts/util.lua"
require "/scripts/vec2.lua"
require "/scripts/interp.lua"

-- Base gun fire ability
GunFire = WeaponAbility:new()

function GunFire:init()
  self.weapon:setStance(self.stances.idle)

  self.cooldownTimer = 0

  self.weapon.onLeaveAbility = function()
    self.weapon:setStance(self.stances.idle)
  end
end

function GunFire:update(dt, fireMode, shiftHeld)
  WeaponAbility.update(self, dt, fireMode, shiftHeld)

  self.cooldownTimer = math.max(0, self.cooldownTimer - self.dt)

  if self.fireMode == "primary"
  and self.cooldownTimer == 0
  and not self.weapon.currentAbility
  and not status.resourceLocked("energy") then
		self:setState(self.fire)
  end
end

function GunFire:fire()
	local pos = vec2.add(mcontroller.position(), {0, 50})
	local apos = activeItem.ownerAimPosition()
	
	local rot = math.atan(apos[2] - pos[2], apos[1] - pos[1])
	
	local pos1 = vec2.add(pos, {2, 0})
	local pos2 = vec2.add(pos, {-2, 0})
	
	local params = {}
	
	for i = 1, 2 do
		world.spawnProjectile(
			self.projectiles[math.random(#self.projectiles)],
			vec2.lerp(math.random(), pos1, pos2),
			activeItem.ownerEntityId(),
			vec2.rotate({1, 0}, rot),
			false,
			params
		)
	end
	
	self.cooldownTimer = 0.05
end

function GunFire:uninit()
end