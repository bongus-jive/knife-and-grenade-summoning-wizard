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
