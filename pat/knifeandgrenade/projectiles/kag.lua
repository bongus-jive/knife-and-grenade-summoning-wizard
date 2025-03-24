function init()
  self.aimHeight = config.getParameter("aimHeight")
  if self.aimHeight then
    self.intangible = true
    mcontroller.applyParameters({collisionEnabled = false})
  end
end

function update()
  if not self.intangible then
    return
  end

  local pos = mcontroller.position()
  if pos[2] < self.aimHeight and not world.pointCollision(pos) then
    self.intangible = false
    mcontroller.applyParameters({collisionEnabled = true})
  end
end

function bounce()
  if self.bounced then return end
  self.bounced = true 

  local physics = config.getParameter("bouncePhysics")
  if physics then
    mcontroller.applyParameters(physics)
  end

  local ttl = config.getParameter("bounceTtl")
  if ttl then
    if type(ttl) == "table" then
      ttl = ttl[1] + (math.random() * (ttl[2] - ttl[1]))
    end
    projectile.setTimeToLive(ttl)
  end
end
