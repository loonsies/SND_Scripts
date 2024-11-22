-- Settings

do_spiritbonding = true     -- Auto spiritbonding
do_repair = true            -- Auto repair
do_move = false				-- Move between fishing spots
repair_threshold = 30       -- Minimum % before repairing gear
check_rate = 5              -- Seconds to wait between each check
interval_rate = 0.2         -- Seconds to wait between each action
interval_move = 5         -- Minutes to wait between each movement
stop_main = false

-- Fishing spots positions to move between
prespot1 = {X = 82.919479370117, Y = -0.11453104019165, Z = 729.27093505859}
spot1 = {X = 84.316375732422, Y = -0.87232160568237, Z = 732.39526367188}
prespot2 = {X = 73.940093994141, Y = -0.81094461679459, Z = 734.09552001953}
spot2 = {X = 75.55126953125, Y = -1.5100334882736, Z = 737.56164550781}

-- Move stuff
should_move = false
move_timer = interval_move * 60
move_direction = false
fishing_start_time = os.time()

-- Functions

function main()
    while not stop_main do
        if isPauseNeeded() then
            print("Pause needed, waiting for player to be available...")
            while not IsPlayerAvailable() and GetCharacterCondition(43) and GetCharacterCondition(6) do
                yield("/wait "..interval_rate)
            end
            while GetCharacterCondition(6) do
                yield("/ac Abandon")
                yield("/wait 1")
            end
            if should_move then
                moveAside()
                should_move = false
            end
            if do_repair and isRepairNeeded() then
                print("Attempting to perform self-repair...")
                repair()
            end
            if do_spiritbonding and CanExtractMateria() then
                print("Attempting to perform spiritbonding...")
                spiritbonding()
            end
        else
            if (GetCharacterCondition(6) and not GetCharacterCondition(43)) or GetCharacterCondition(1) then
				yield("/wait 2")
				if GetCharacterCondition(6) and not GetCharacterCondition(43) or GetCharacterCondition(1) then
                	yield("/ac Pêche")
					yield("/wait" .. interval_rate)
					if GetCharacterCondition(6) and not GetCharacterCondition(43) or GetCharacterCondition(1) then
						print("Couldn't start fishing. Are you fisher and at a fishing spot?")
						yield("/snd stop")
					end
				end
            end
            yield("/wait "..check_rate)
        end
    end
end

function isPauseNeeded()
    return (do_repair and isRepairNeeded())
        or (do_spiritbonding and CanExtractMateria())
        or (needToMove())
end

function isRepairNeeded()
    if do_repair == true then
        repair_threshold = tonumber(repair_threshold) or 99
        if NeedsRepair(repair_threshold) then
            return true
        else
            return false
        end
    end
end

function spiritbonding()
    while CanCharacterDoActions() and not IsAddonVisible("Materialize") and not IsAddonReady("Materialize") do
        yield('/gaction "Matérialisation"')
        repeat
            yield("/wait "..interval_rate)
        until IsPlayerAvailable()
    end
    while CanCharacterDoActions() and CanExtractMateria() do
        
        yield("/wait 0.1")
        yield("/pcall Materialize true 2 0")
        repeat
            if not CanCharacterDoActions() then return end
            yield("/wait 1")
        until not GetCharacterCondition(39)
    end
    while CanCharacterDoActions() and IsAddonVisible("Materialize") do
        yield('/gaction "Matérialisation"')
        repeat
            yield("/wait "..interval_rate)
        until IsPlayerAvailable()
    end
    if CanExtractMateria() then
        print("Failed to fully extract all materia!")
        print("Please check your if you have spare inventory slots,")
        print("Or manually extract any materia.")
        return false
    else
        print("Materia extraction complete!")
    end
end

function repair()
    while CanCharacterDoActions() and not IsAddonVisible("Repair") and not IsAddonReady("Repair") do
        yield('/gaction "Réparation"')
        repeat
            if not CanCharacterDoActions() then return end
            yield("/wait "..interval_rate)
        until IsPlayerAvailable()
    end
    yield("/wait 0.1")
    yield("/pcall Repair true 0")
    repeat
        yield("/wait "..interval_rate)
    until IsAddonVisible("SelectYesno") and IsAddonReady("SelectYesno")
    yield("/pcall SelectYesno true 0")
    repeat
        yield("/wait "..interval_rate)
    until not IsAddonVisible("SelectYesno")
    while GetCharacterCondition(39) do yield("/wait "..interval_rate) end
    while IsAddonVisible("Repair") do
        yield('/gaction "Réparation"')
        repeat
            yield("/wait "..interval_rate)
        until IsPlayerAvailable()
    end
    if NeedsRepair() then
        print("Self-repair failed!")
        print("Please place the appropriate Dark Matter in your inventory,")
        return false
    else
        print("Repairs complete!")
    end
end

function print(message)
    if type(message) ~= "string" then
        message = tostring(message)
    end
    yield("/echo [Autohook-Helper] " .. message)
end

function CanCharacterDoActions()
    return not (GetCharacterCondition(6) or GetCharacterCondition(32) or GetCharacterCondition(45) or GetCharacterCondition(27) or GetCharacterCondition(4))
end

function moveAside()
	print("Moving...")
    if move_direction then
		targetPos = spot1
		targetPrePos = prespot1
    else
		targetPos = spot2
		targetPrePos = prespot2
    end
    move_direction = not move_direction
    PathfindAndMoveTo(targetPrePos.X, targetPrePos.Y, targetPrePos.Z, false)
    VNavMovement()
	PathfindAndMoveTo(targetPos.X, targetPos.Y, targetPos.Z, false)
	VNavMovement()
    fishing_start_time = os.time()
end

function needToMove()
	if not do_move then return false end
    if os.time() >= fishing_start_time + move_timer then
		print("Move timer reached")
        should_move = true
        return true
    else
        return false
    end
end

function VNavMovement()
    repeat
      yield("/wait 0.1")
    until not PathIsRunning()
    yield("/wait 0.5")
  end

main()
