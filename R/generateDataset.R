# first <- c("Fear", "Frontier", "Nanny", "Job", "Yard", "Airport", "Half Pint", "Commando", "Fast Food", "Basketball", "Bachelorette", "Diva", "Baggage", "College", "Octane", "Clean", "Sister", "Army", "Drama", "Backyard", "Pirate", "Shark", "Project", "Model", "Survival", "Justice", "Mom", "New York", "Jersey", "Ax", "Warrior", "Ancient", "Pawn", "Throttle", "The Great American", "Knight", "American", "Outback", "Celebrity", "Air", "Restaurant", "Bachelor", "Family", "Royal", "Surf", "Ulitmate", "Date", "Operation", "Fish Tank", "Logging", "Hollywood", "Amateur", "Craft", "Mystery", "Intervention", "Dog", "Human", "Rock", "Ice Road", "Shipping", "Modern", "Crocodile", "Farm", "Amish", "Single", "Tool", "Boot Camp", "Pioneer", "Kid", "Action", "Bounty", "Paradise", "Mega", "Love", "Style", "Teen", "Pop", "Wedding", "An American", "Treasure", "Myth", "Empire", "Motorway", "Room", "Casino", "Comedy", "Undercover", "Millionaire", "Chopper", "Space", "Cajun", "Hot Rod", "The", "Colonial", "Dance", "Flying", "Sorority", "Mountain", "Auction", "Extreme", "Whale", "Storage", "Cake", "Turf", "UFO", "The Real", "Wild", "Duck", "Queer", "Voice", "Fame", "Music", "Rock Star", "BBQ", "Spouse", "Wife", "Road", "Star", "Renovation", "Comic", "Chef", "Band", "House", "Sweet")
#
# second <- c("Hunters", "Hoarders", "Contest", "Party", "Stars", "Truckers", "Camp", "Dance Crew", "Casting Call", "Inventor", "Search", "Pitmasters", "Blitz", "Marvels", "Wedding", "Crew", "Men", "Project", "Intervention", "Celebrities", "Treasure", "Master", "Days", "Wishes", "Sweets", "Haul", "Hour", "Mania", "Warrior", "Wrangler", "Restoration", "Factor", "Hot Rod", "of Love", "Inventors", "Kitchen", "Casino", "Queens", "Academy", "Superhero", "Battles", "Behavior", "Rules", "Justice", "Date", "Discoveries", "Club", "Brother", "Showdown", "Disasters", "Attack", "Contender", "People", "Raiders", "Story", "Patrol", "House", "Gypsies", "Challenge", "School", "Aliens", "Towers", "Brawlers", "Garage", "Whisperer", "Supermodel", "Boss", "Secrets", "Apprentice", "Icon", "House Party", "Pickers", "Crashers", "Nation", "Files", "Office", "Wars", "Rescue", "VIP", "Fighter", "Job", "Experiment", "Girls", "Quest", "Eats", "Moms", "Idol", "Consignment", "Life", "Dynasty", "Diners", "Chef", "Makeover", "Ninja", "Show", "Ladies", "Dancing", "Greenlight", "Mates", "Wives", "Jail", "Model", "Ship", "Family", "Videos", "Repo", "Rivals", "Room", "Dad", "Star", "Exes", "Island", "Next Door", "Missions", "Kings", "Loser", "Shore", "Assistant", "Comedians", "Rooms", "Boys")
#
# Dosimeter <- stringi::stri_rand_strings(50, 6)
#
# ListDepartment <- random::randomStrings(n=10, len=3, digits=FALSE,
#                                      upperalpha=TRUE,loweralpha=FALSE, unique=TRUE, check=TRUE)
#
# CNR <- sample(12425123:32276422,50,replace=FALSE)
#
# Badge <- sample(56:450,50,replace=FALSE)
#
# set.seed(1324)
# first.Name <- sample(first,50,replace = FALSE)
# Name <- sample(second, 50,replace = FALSE)
# DCE_B <- round(runif(30, 0, 1.4), digits=2)
# DCE_A <- round(runif(20, 0, 4.5), digits=2)
#
# DP_B <- round(runif(30, 0, 450), digits = 0)
# DP_A <- round(runif(20,0,1900), digits = 0)
# Cat_B <- rep( 'B', 30)
# Cat_A <- rep('A', 20)
#
#
# # unique order of columns
# set.seed(23)
# first.Name <- sample(first,50,replace = FALSE)
# Name <- sample(second, 50,replace = FALSE)
# CNR <- sample(12425123:32276422,50,replace=FALSE)
# Categories <- sample(c(Cat_B, Cat_A))
# Badge <- sample(56:450,50,replace=FALSE)
# Department <-  sample(ListDepartment, 50, replace = TRUE)
# ## 2 random Dosimeters
# #set.seed(432)
# set.seed (567)
# Dosimeter <- stringi::stri_rand_strings(50, 6)
# ## 3 samples date Range
# #set.seed(1234)
# #set.seed (3542)
# #set.seed(9862)
# set.seed(7023)
# DCE <- sample(c(DCE_A, DCE_B))
# DP <- sample(c(DP_A, DP_B))
# Date <- rep(radiant.data::as_ymd('2015-01-26'),50)
#
# dat4 <-data_frame(first.Name, Name, CNR, Categories, Badge,Department, Dosimeter, DCE, DP, Date)
#
# dosimetry <- rbind(dat1,dat2,dat3,dat4)
