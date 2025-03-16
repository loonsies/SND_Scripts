channel = "/fc"
delay_modifier = 10
repeat_threshold = 50

jokes = {
  {"Why don’t skeletons fight each other?", "They don’t have the guts."},
  {"Why did the scarecrow win an award?", "Because he was outstanding in his field."},
  {"Why can’t your nose be 12 inches long?", "Because then it would be a foot."},
  {"What do you call cheese that isn't yours?", "Nacho cheese!"},
  {"How do you organize a space party?", "You planet."},
  {"Why did the math book look sad?", "It had too many problems."},
  {"What’s orange and sounds like a parrot?", "A carrot."},
  {"Why are elevator jokes so good?", "They work on many levels."},
  {"What did one ocean say to the other ocean?", "Nothing.", "They just waved."},
  {"Why did the golfer bring two pairs of pants?", "In case he got a hole in one."},
  {"What do you call fake spaghetti?", "An impasta."},
  {"How do you make a tissue dance?", "Put a little boogie in it."},
  {"Why couldn’t the bicycle stand up by itself?", "It was two tired."},
  {"What do you call a factory that makes okay products?", "A satisfactory."},
  {"Why don’t oysters share their pearls?", "Because they’re shellfish."},
  {"Why was the math teacher late to work?", "She took the rhombus."},
  {"Why can’t you trust an atom?", "Because they make up everything."},
  {"Why did the tomato turn red?", "Because it saw the salad dressing."},
  {"Why did the computer go to the doctor?", "It had a virus."},
  {"What do you call an alligator in a vest?", "An investigator."},
  {"Why don’t ants get sick?", "They have tiny ant-bodies."},
  {"Why was the broom late?", "It swept in."},
  {"How do you catch a squirrel?", "Climb a tree and act like a nut."},
  {"What do you call a bear with no teeth?", "A gummy bear."},
  {"Why was the belt arrested?", "It held up a pair of pants."},
  {"Why did the bicycle fall over?", "It was two tired."},
  {"What did the janitor say when he jumped out of the closet?", "Supplies!"},
  {"What do you call a can opener that doesn’t work?", "A can’t opener."},
  {"Why did the frog take the bus?", "Because his car was toad."},
  {"Why was the calendar afraid?", "Its days were numbered."},
  {"What did the baby corn say to the mama corn?", "Where’s popcorn?"},
  {"Why did the stadium get hot after the game?", "All the fans left."},
  {"How do you make holy water?", "You boil the hell out of it."},
  {"What kind of tree fits in your hand?", "A palm tree."},
  {"Why do cows wear bells?", "Because their horns don’t work."},
  {"Why did the musician get locked out of his house?", "He forgot his keys."},
  {"What do you call a snowman with a six-pack?", "An abdominal snowman."},
  {"Why don’t seagulls fly over the bay?", "Because then they’d be bagels."},
  {"Why did the coffee file a police report?", "It got mugged."},
  {"What’s brown and sticky?", "A stick."},
  {"Why do bees have sticky hair?", "Because they use honeycombs."},
  {"What do you call a magician’s dog?", "A labracadabrador."},
  {"Why did the banana go to the doctor?", "It wasn’t peeling well."},
  {"Why did the picture go to jail?", "It was framed."},
  {"What do you call a sleeping bull?", "A bulldozer."},
  {"Why did the grape stop in the middle of the road?", "Because it ran out of juice."},
  {"What kind of shoes do ninjas wear?", "Sneakers."},
  {"Why couldn’t the pirate learn the alphabet?", "He kept getting lost at C."},
  {"What do you call two birds in love?", "Tweethearts."},
  {"Why was the cookie sad?", "Because its friends were crumby."},
  {"Why did the cow go to outer space?", "To see the moooon."},
  {"What do you call a fish with no eyes?", "Fsh."},
  {"How do you throw a space party?", "You rocket."},
  {"Why are ghosts bad liars?", "Because you can see right through them."},
  {"Why did the scarecrow become a successful neurosurgeon?", "Because he was outstanding in his field."},
  {"What do you call a dog magician?", "A labracadabrador."},
  {"Why do ducks have feathers?", "To cover their butt quacks."},
  {"Why don’t skeletons ever use cell phones?", "They don’t have the guts to answer."},
  {"What do you call a pile of cats?", "A meow-tain."},
  {"Why did the math book look sad?", "Because it had too many problems."},
  {"What’s a skeleton’s least favorite room in the house?", "The living room."},
  {"Why was the guitar teacher so good at parties?", "Because he knew how to pick."},
  {"How does a penguin build its house?", "Igloos it together."},
  {"Why don’t you ever see elephants hiding in trees?", "Because they’re really good at it."},
  {"What do you call a group of musical whales?", "An orca-stra."},
  {"Why did the bicycle fall over?", "It was two-tired."},
  {"How does a cucumber become a pickle?", "It goes through a jarring experience."},
  {"Why did the football team go to the bank?", "To get their quarterback."},
  {"What do you call an astronaut’s favorite part of a computer?", "The space bar."},
  {"What did one wall say to the other?", "I’ll meet you at the corner."},
  {"What do you call an elephant that doesn’t matter?", "An irrelephant."},
  {"Why do vampires always seem sick?", "Because they’re always coffin."},
}

next_number = math.random(1,#jokes)

if type(repeat_threshold)=="number" then
  if #jokes<=repeat_threshold then
    yield("/echo repeat_threshold = "..repeat_threshold..", but there's only "..#jokes.." jokes in the list.")
    yield("/echo Are you trying to break things? Stop it.")
    repeat_threshold = #jokes-1
  end
  jokes_told = {}

  ::Load::
  jokes_told_file = os.getenv("appdata").."\\XIVLauncher\\pluginConfigs\\SomethingNeedDoing\\jokes_told.txt"
  f=io.open(jokes_told_file,"r")
  if f~=nil then
    io.close(f)
    jokes_told = {}
    file_jokes_told = io.input(jokes_told_file)
    next_line = file_jokes_told:read("l")
    while next_line do
      table.insert(jokes_told,tostring(next_line))
      next_line = file_jokes_told:read("l")
    end
    file_jokes_told:close()
  end
  if #jokes_told>=#jokes then jokes_told = {} end

  ::Check::
  for _, joke_test in pairs(jokes_told) do
    if tostring(next_number)==joke_test then
      repeat_joke = true
      break
    end
  end
  if repeat_joke then
    next_number = math.random(1,#jokes)
    repeat_joke = false
    goto Check
  end

  ::Save::
  table.insert(jokes_told,tostring(next_number))
  while #jokes_told>repeat_threshold do table.remove(jokes_told, 1) end
  file_jokes_told = io.open(jokes_told_file,"w+")
  for i, joke_test in pairs(jokes_told) do
    file_jokes_told:write(joke_test.."\n")
  end
  io.close(file_jokes_told)

end

tell_joke = jokes[next_number]

for lc, line in pairs(tell_joke) do
  yield(channel.." "..line)
  if tell_joke[lc+1] then
    yield("/wait "..(string.len(line)/100)*delay_modifier)
  end
end
