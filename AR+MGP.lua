target = "Out on a Limb Machine"
bell = "Summoning Bell"
useMGPBoost = true
goHomeCommand = "/li auto"
stopNeeded = false

CharacterCondition = {
    craftingMode = 5,
    casting = 27,
    occupiedInQuestEvent = 32,
    occupiedMateriaExtractionAndRepair = 39,
    executingCraftingSkill = 40,
    craftingModeIdle = 41,
    betweenAreas = 45,
    betweenAreas51 = 51,
    occupiedSummoningBell = 50,
    beingMoved = 70
}

function checkAlreadyInHouse()
    yield("/target " .. target)
    yield("/wait 1")
    local target1 = GetTargetName()

    yield("/target " .. bell)
    yield("/wait 1")
    local target2 = GetTargetName()

    if target1 == target and target2 == bell then
        return true
    else
        return false
    end
end

function GoToTarget(targetToGoTo)
    yield("/target " .. targetToGoTo)
    yield("/wait 1")
    if (GetDistanceToTarget() >= 5) then
        yield("/echo Target too far, moving closer...")
        PathfindAndMoveTo(GetTargetRawXPos(), GetTargetRawYPos(), GetTargetRawZPos())
        yield("/wait 1")
        while (IsMoving() or PathIsRunning()) do
            if (GetDistanceToTarget() < 5) then
                PathStop()
                yield("/echo Close enough to interact with target. Aborting movement.")
                break
            end
            yield("/wait 0.05")
        end
    end
end

-- Main Logic Begins
if (not checkAlreadyInHouse()) then
    yield(goHomeCommand)
    while (LifestreamIsBusy() or PathfindInProgress() or PathIsRunning() or IsPlayerCasting()
        or GetCharacterCondition(CharacterCondition.betweenAreas)
        or GetCharacterCondition(CharacterCondition.betweenAreas51)
        or GetCharacterCondition(CharacterCondition.beingMoved)) do
        yield("/wait 5")
    end

    if (not checkAlreadyInHouse()) then
        yield("/echo Target or bell not targetable. Aborting.")
        return
    end
end

GoToTarget(target)

yield("/target " .. bell)
yield("/wait 1")
if (GetDistanceToTarget() >= 6.5) then
    yield("/echo Bell too far, move it closer to target and try again. Aborting.")
    return
end

yield("/interact")
yield("/wait 1")
if (not IsAddonVisible("RetainerList")) then
    yield("/echo RetainerList not visible. Aborting.")
    return
end

-- Infinite loop begins
while (true) do
    if (ARRetainersWaitingToBeProcessed() == true and stopNeeded == false) then
        yield("/echo Retainers are waiting to be processed. stopNeeded set to true.")
        stopNeeded = true
    end

    if ((not HasTarget() or GetTargetName() ~= target)
        and ARRetainersWaitingToBeProcessed() == false
        and not GetCharacterCondition(CharacterCondition.occupiedInQuestEvent)
        and not IsAddonVisible("RetainerList")) then

        yield("/target " .. target)
        yield("/wait 0.5")
        yield("/interact")

    elseif ((not HasTarget() or GetTargetName() ~= bell)
        and ARRetainersWaitingToBeProcessed() == true
        and not GetCharacterCondition(CharacterCondition.occupiedSummoningBell)
        and not IsAddonVisible("RetainerList")) then

        yield("/target " .. bell)
        yield("/wait 0.5")
        yield("/interact")
    end

    if (HasTarget() and GetTargetName() == target and stopNeeded == false) then
        if (not GetCharacterCondition(CharacterCondition.occupiedInQuestEvent)) then
            if (useMGPBoost and not HasStatus("Gold Saucer VIP Card")) then
                yield("/echo Using MGP Boost.")
                yield("/item " .. "Gold Saucer VIP Card")
                while (not HasStatus("Gold Saucer VIP Card")) do
                    yield("/echo Waiting for MGP Boost...")
                    yield("/wait 2")
                end
            end
            yield("/interact")
            yield("/wait 0.5")
        end

    elseif (HasTarget() and GetTargetName() == bell) then
        if (ARRetainersWaitingToBeProcessed() == true) then
            if not (GetCharacterCondition(CharacterCondition.occupiedSummoningBell)) then
                yield("/interact")
            elseif IsAddonVisible("RetainerList") then
                yield("/ays e")
                yield("/wait 1")
            end
        elseif (GetCharacterCondition(CharacterCondition.occupiedSummoningBell)
            and IsAddonVisible("RetainerList")) then
            yield("/callback RetainerList true -1")
            yield("/wait 0.5")
        end
    end

    if (stopNeeded == true
        and GetCharacterCondition(CharacterCondition.occupiedSummoningBell)
        and ARRetainersWaitingToBeProcessed() == false) then
        yield("/echo Retainers are done processing. stopNeeded set to false.")
        stopNeeded = false
    end

    yield("/wait 0.5")
end

