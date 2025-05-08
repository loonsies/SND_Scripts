maxAttempts = 10
target = "<target>" -- Replace with the name of the target you want to ride pillion with
targetId = -1
followAfterRiding = true

if (GetCharacterCondition(10)) then
  yield("/echo You are already riding pillion.")
  return
end

function ridePillion()
  yield("/ridepillion <t>")
  yield("/wait 0.1")
end

for i = 0, 7 do
  if (GetPartyMemberName(i) == target) then
    targetId = i
    yield("/echo " .. target .. " found in party, attempting to target...")
    break
  end
  if i == 7 then
    yield("/echo " .. target .. " not found in party. Aborting.")
    return
  end
end

attempts = 1
while (not HasTarget() or GetTargetName() ~= target) do
  if (attempts > maxAttempts) then
    yield("/echo Target not found, max attempts reached. Aborting.")
    return
  end

  yield("/target " .. target)
  yield("/wait 0.15")

  if (HasTarget() and GetTargetName() == target) then
    yield("/echo Target found, attempting to ride pillion...")
    yield("/wait 0.5")
    break
  else
    yield("/echo Target not found, waiting... (" .. attempts .. "/" .. maxAttempts .. ") attempts")
    yield("/wait 1")
  end
  attempts = attempts + 1
end

if (GetDistanceToPartyMember(targetId) >= 5) then
  yield("/echo Target too far, moving closer...")
  PathfindAndMoveTo(GetPartyMemberRawXPos(targetId), GetPartyMemberRawYPos(targetId), GetPartyMemberRawZPos(targetId))
  yield("/wait 1")
  while (IsMoving() or PathIsRunning()) do
    if (GetDistanceToPartyMember(targetId) < 5) then
      PathStop()
      yield("/echo Close enough to ride pillion. Aborting movement.")
      break
    end
    yield("/wait 0.05")
  end
end

attempts = 1
while not GetCharacterCondition(10) do
  if (attempts > maxAttempts) then
    yield("/echo Couldn\"t ride pillion, max attempts reached. Aborting.")
    return
  end
  if (IsTargetMounted()) then
    ridePillion()
    yield("/wait 0.5")
  else
    yield("/echo Target not mounted, waiting... (" .. attempts .. "/" .. maxAttempts .. ") attempts")
    yield("/wait 1")
  end
  attempts = attempts + 1
end

if (GetCharacterCondition(10)) then
  yield("/p vroom :3 <se.3>")
  if (followAfterRiding) then
    yield("/bmrai follow " .. target)
  end
  return
end
