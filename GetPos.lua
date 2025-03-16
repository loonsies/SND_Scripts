function main()
while true do
  currentX = tonumber(GetPlayerRawXPos())
  currentY = tonumber(GetPlayerRawYPos())
  currentZ = tonumber(GetPlayerRawZPos())
print("X: " .. currentX)
print("Y: " .. currentY)
print("Z: " .. currentZ)
print("_")
yield("/wait 2")
end
end

function print(message)
if type(message) ~= "string" then
message = tostring(message)
end
yield("/echo " .. message)
end

main()
