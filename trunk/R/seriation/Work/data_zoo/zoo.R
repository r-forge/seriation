Zoo <- read.table("zoo.data", sep=",")

names <- as.character(Zoo[,1])
## there are 2 frogs!
names[27] <- "frog2"

Zoo <- Zoo[,-1]
rownames(Zoo) <- names


## col names

#7. Attribute Information: (name of attribute and type of value domain)
#1. animal name:      Unique for each instance
#2. hair       Boolean
#3. feathers        Boolean
#4. eggs     Boolean
#5. milk      Boolean
#6. airborne       Boolean
#7. aquatic     Boolean
#8. predator     Boolean
#9. toothed       Boolean
#10. backbone       Boolean
#11. breathes     Boolean
#12. venomous       Boolean
#13. fins     Boolean
#14. legs       Numeric (set of values: {0,2,4,5,6,8})
#15. tail     Boolean
#16. domestic       Boolean
#17. catsize      Boolean
#18. type       Numeric (integer values in range [1,7])
#

colnames(Zoo) <-
c(
"hair",
"feathers",
"eggs",
"milk",
"airborne",
"aquatic",
"predator",
"toothed",
"backbone",
"breathes",
"venomous",
"fins",
"legs",
"tail",
"domestic",
"catsize",
"type"
)

# classes
#          1 (41) aardvark, antelope, bear, boar, buffalo, calf,
#                  cavy, cheetah, deer, dolphin, elephant,
#                  fruitbat, giraffe, girl, goat, gorilla, hamster,
#                  hare, leopard, lion, lynx, mink, mole, mongoose,
#                  opossum, oryx, platypus, polecat, pony,
#                  porpoise, puma, pussycat, raccoon, reindeer,
#                  seal, sealion, squirrel, vampire, vole, wallaby,wolf
#           2 (20) chicken, crow, dove, duck, flamingo, gull, hawk,
#                  kiwi, lark, ostrich, parakeet, penguin, pheasant,
#                  rhea, skimmer, skua, sparrow, swan, vulture, wren
#           3 (5)  pitviper, seasnake, slowworm, tortoise, tuatara
#           4 (13) bass, carp, catfish, chub, dogfish, haddock,
#                  herring, pike, piranha, seahorse, sole, stingray, tuna
#           5 (4)  frog, frog, newt, toad
#           6 (8)  flea, gnat, honeybee, housefly, ladybird, moth, termite, wasp
#           7 (10) clam, crab, crayfish, lobster, octopus,
#                  scorpion, seawasp, slug, starfish, worm


class <- list(
# mammal
mammal = c("aardvark", "antelope", "bear", "boar", "buffalo", "calf",
 "cavy", "cheetah", "deer", "dolphin", "elephant",
 "fruitbat", "giraffe", "girl", "goat", "gorilla", "hamster",
 "hare", "leopard", "lion", "lynx", "mink", "mole", "mongoose",
 "opossum", "oryx", "platypus", "polecat", "pony",
 "porpoise", "puma", "pussycat", "raccoon", "reindeer",
 "seal", "sealion", "squirrel", "vampire", "vole", "wallaby", "wolf"),
# bird
bird = c(
"chicken", "crow", "dove", "duck", "flamingo", "gull", "hawk",
"kiwi", "lark", "ostrich", "parakeet", "penguin", "pheasant",
"rhea", "skimmer", "skua", "sparrow", "swan", "vulture", "wren"),
# reptile
reptile =
c("pitviper", "seasnake", "slowworm", "tortoise", "tuatara"),
# fish
fish = c("bass", "carp", "catfish", "chub", "dogfish", "haddock",
 "herring", "pike", "piranha", "seahorse", "sole", "stingray", "tuna"),
# amphibian
amphibian = c("frog", "frog2", "newt", "toad"),
# insect
insect = c(
 "flea", "gnat", "honeybee", "housefly", "ladybird", "moth", "termite", "wasp"),
# invertebrate
invertebrate = c(
"clam", "crab", "crayfish", "lobster", "octopus",
  "scorpion", "seawasp", "slug", "starfish", "worm")

)

lapply(class, FUN = function(x) match(x, names))

classnames <- c()
tmp <- lapply(1:length(class), FUN = function(x) {
m <- match(class[[x]],names)
classnames[m] <<- names(class)[x]
m
})


Zoo <- cbind(Zoo, classes = classnames)

save(Zoo, file="Zoo.rda", compress = TRUE)
