aetheryte = "Leatherworkers' Guild & Shaded Bower"
summoningBell = "Sonnette"
occupiedSummoningBell = 50
retainerBell = {x = 168.72, y = 15.5, z = -100.06}

if GetCharacterCondition(occupiedSummoningBell) then
  return
end

yield("/li " .. aetheryte)

while (LifestreamIsBusy() or PathfindInProgress() or PathIsRunning()) do
  yield("/wait 1")
end
  

PathfindAndMoveTo(
    retainerBell.x,
    retainerBell.y,
    retainerBell.z
)

while (LifestreamIsBusy() or PathfindInProgress() or PathIsRunning()) do
  yield("/wait 1")
end

yield("/wait 0.5")
yield("/target " .. summoningBell)
yield("/wait 0.5")
yield("/interact")