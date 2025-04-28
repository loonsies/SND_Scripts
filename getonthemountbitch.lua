yield('/target Luna Tombeneige')
if (not HasTarget() or GetTargetName() ~= 'Luna Tombeneige') then
  return
end
yield('/wait 0.5')
yield('/follow <t>')
while not (GetCharacterCondition(10)) do
  yield('/snd run vroom2')
  yield('/wait 0.5')
end