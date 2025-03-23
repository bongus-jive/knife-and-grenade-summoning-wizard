require "/scripts/vec2.lua"

function init()
  local get = config.getParameter

  self.projectileTypes = get("projectileTypes")
  self.projectileCount = get("projectileCount", 1)
  self.spawnHeight = get("spawnHeight", 50)
  self.spawnRadius = get("spawnRadius", 1)
  self.speedRange = get("speedRange")
  self.inaccuracy = get("inaccuracy")
  self.aimVerticalOffset = get("aimVerticalOffset", 0)

  self.cooldownTime = get("cooldownTime")
  self.cooldown = 0

  self.cursors = get("cursors")
  activeItem.setCursor(self.cursors.idle)

  self.ownerId = activeItem.ownerEntityId()
end

function update(dt, fireMode)
  local firing = fireMode ~= "none"

  local aimPos = activeItem.ownerAimPosition()
  local angle, dir = activeItem.aimAngleAndDirection(self.aimVerticalOffset, aimPos)

  activeItem.setArmAngle(angle)
  activeItem.setFacingDirection(firing and dir or 0)
  activeItem.setHoldingItem(firing)
  activeItem.setCursor(firing and self.cursors.firing or self.cursors.idle)

  if self.cooldown > 0 then
    self.cooldown = math.max(0, self.cooldown - dt)
  end

  if firing and self.cooldown == 0 then
    fire()
    self.cooldown = self.cooldownTime
  end
end

function fire()
  local mPos = mcontroller.position()
  local centerPos = {mPos[1], mPos[2] + self.spawnHeight}

  local aimPos = activeItem.ownerAimPosition()
  local aimAngle = math.atan(aimPos[2] - centerPos[2], aimPos[1] - centerPos[1])

  local params = {}
  params.aimHeight = math.max(mPos[2], aimPos[2])
  params.powerMultiplier = activeItem.ownerPowerMultiplier()

  for i = 1, self.projectileCount do
    local spawnPos = randomInRadius(centerPos, self.spawnRadius)

    local angle = aimAngle
    if self.inaccuracy then angle = angle + sb.nrand(self.inaccuracy, 0) end
    local aimVector = {math.cos(angle), math.sin(angle)}

    if self.speedRange then
      params.speed = randomInRange(self.speedRange)
    end

    local pType = self.projectileTypes[math.random(#self.projectileTypes)]
    world.spawnProjectile(pType, spawnPos, self.ownerId, aimVector, false, params)
  end
end

function randomInRadius(center, radius)
  local r = radius * math.sqrt(math.random())
  local t = math.random() * 2 * math.pi
  return {
    center[1] + r * math.cos(t),
    center[2] + r * math.sin(t)
  }
end

function randomInRange(range)
  return range[1] + (math.random() * (range[2] - range[1]))
end
