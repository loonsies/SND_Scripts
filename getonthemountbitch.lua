maxAttempts = 10
target = "" -- Replace with the name of the target you want to ride pillion with
targetId = -1
stopBMRAI = true -- Set to true if you want to temporarily disable BMR AI for pathfinding
followAfterRiding = true -- Set to true if you want to follow the target after riding pillion using BMR

annoyingSentences = {
  "vroom :3 <se.2>",
  "let's ride d8] <se.14>",
  "why is the back seat sticky? <se.6>",
  "turn on AC pls <se.14>",
  "let me put some tune on da radio 8) <se.14>",
  "hope you don't mind my legs on ur lap <se.16>",
  "I can see my house from here <se.14>",
  "fuck speed limit >:3 <se.6>",
  "can we stop to get an icecrem :33c <se.14> <se.14>",
  "oops, I thought this was my Uber >:oc <se.14>",
  "are we there yet? x100 <se.2> <se.2> <se.2>",
  "what does this button do? >:3 <se.14>",
  "my mom said I shouldn’t ride with strangers :c <se.11>",
  "hehehe zoomies time :3 <se.15>",
  "I’m the mount now. jk jk unless? :3 <se.14>",
  "just two beans on wheels~ <se.14>",
  "hope you drive better than you tank....... <se.14>",
  "do I tip at the end? :3 <se.16>",
  "no idea where we’re going, but I’m in 8)) <se.14>",
  "riding in silence? awkward :3 <se.16>",
  "if we die, it’s your fault :3 <se.6>",
}
sentenceId = math.random(1, #annoyingSentences)

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
  if (stopBMRAI) then
    yield("/echo Stopping BMR AI for pathfinding.")
    yield("/bmrai off")
  end
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
  yield("/p " .. annoyingSentences[sentenceId])
  if (followAfterRiding) then
    yield("/echo Enabling BMR AI to follow " .. target .. " after riding pillion.")
    yield("/bmrai follow " .. target)
  end
  return
end
