extends Node


var bad_words = [
	"2 girls 1 cup",
	"acrotomophilia",
	"alabama hot pocket",
	"alaskan pipeline",
	"anal",
	"anilingus",
	"anus",
	"arsehole",
	"asshole",
	"assmunch",
	"auto erotic",
	"autoerotic",
	"babeland",
	"baby batter",
	"baby juice",
	"ball gag",
	"ball gravy",
	"ball kicking",
	"ball licking",
	"ball sack",
	"ball sucking",
	"bangbros",
	"bareback",
	"barely legal",
	"barenaked",
	"bastard",
	"bastardo",
	"bastinado",
	"bdsm",
	"beaner",
	"beaners",
	"beaver cleaver",
	"beaver lips",
	"bestiality",
	"big black",
	"big breasts",
	"big knockers",
	"big tits",
	"bimbos",
	"birdlock",
	"bitch",
	"bitches",
	"black cock",
	"blonde action",
	"blonde on blonde action",
	"blowjob",
	"blow job",
	"blow your load",
	"blue waffle",
	"blumpkin",
	"bollocks",
	"bondage",
	"boner",
	"boob",
	"boobs",
	"booty call",
	"brown showers",
	"brunette action",
	"bukkake",
	"bulldyke",
	"bullet vibe",
	"bung hole",
	"bunghole",
	"busty",
	"buttcheeks",
	"butthole",
	"camel toe",
	"camgirl",
	"camslut",
	"camwhore",
	"carpet muncher",
	"carpetmuncher",
	"chocolate rosebuds",
	"circlejerk",
	"cleveland steamer",
	"clit",
	"clitoris",
	"clover clamps",
	"cock",
	"cocks",
	"coprolagnia",
	"coprophilia",
	"cornhole",
	"coon",
	"coons",
	"creampie",
	"cum",
	"cumming",
	"cunnilingus",
	"cunt",
	"darkie",
	"date rape",
	"daterape",
	"deep throat",
	"deepthroat",
	"dendrophilia",
	"dick",
	"dildo",
	"dingleberry",
	"dingleberries",
	"dirty pillows",
	"dirty sanchez",
	"doggie style",
	"doggiestyle",
	"doggy style",
	"doggystyle",
	"dog style",
	"dolcett",
	"domination",
	"dominatrix",
	"dommes",
	"donkey punch",
	"double dong",
	"double penetration",
	"dp action",
	"dry hump",
	"dvda",
	"eat my ass",
	"ecchi",
	"ejaculation",
	"erotic",
	"erotism",
	"escort",
	"eunuch",
	"fag",
	"faggot",
	"fecal",
	"felch",
	"fellatio",
	"feltch",
	"female squirting",
	"femdom",
	"figging",
	"fingerbang",
	"fingering",
	"fisting",
	"foot fetish",
	"footjob",
	"frotting",
	"fucktards",
	"fudge packer",
	"fudgepacker",
	"futanari",
	"gang bang",
	"gay sex",
	"genitals",
	"giant cock",
	"girl on",
	"girl on top",
	"girls gone wild",
	"goatcx",
	"goatse",
	"gokkun",
	"golden shower",
	"goodpoop",
	"goo girl",
	"goregasm",
	"grope",
	"group sex",
	"g-spot",
	"guro",
	"hand job",
	"handjob",
	"hard core",
	"hardcore",
	"hentai",
	"homoerotic",
	"honkey",
	"hooker",
	"hot carl",
	"hot chick",
	"huge fat",
	"humping",
	"incest",
	"intercourse",
	"jack off",
	"jail bait",
	"jailbait",
	"jelly donut",
	"jerk off",
	"jigaboo",
	"jiggaboo",
	"jiggerboo",
	"jizz",
	"juggs",
	"kike",
	"kinbaku",
	"kinkster",
	"kinky",
	"knobbing",
	"leather restraint",
	"leather straight jacket",
	"lemon party",
	"lolita",
	"lovemaking",
	"make me come",
	"male squirting",
	"masturbate",
	"menage a trois",
	"milf",
	"missionary position",
	"mound of venus",
	"mr hands",
	"muff diver",
	"muffdiving",
	"nambla",
	"nawashi",
	"negro",
	"neonazi",
	"nigga",
	"nigger",
	"nig nog",
	"nimphomania",
	"nipple",
	"nipples",
	"nsfw images",
	"nude",
	"nudity",
	"nympho",
	"nymphomania",
	"octopussy",
	"omorashi",
	"one cup two girls",
	"one guy one jar",
	"orgasm",
	"orgy",
	"paedophile",
	"paki",
	"panties",
	"panty",
	"pedobear",
	"pedophile",
	"pegging",
	"penis",
	"phone sex",
	"piece of shit",
	"pissing",
	"piss pig",
	"pisspig",
	"playboy",
	"pleasure chest",
	"pole smoker",
	"ponyplay",
	"poof",
	"poon",
	"poontang",
	"punany",
	"poop chute",
	"poopchute",
	"porn",
	"porno",
	"pornography",
	"prince albert piercing",
	"pthc",
	"pubes",
	"pussy",
	"queaf",
	"queef",
	"quim",
	"raghead",
	"raging boner",
	"rape",
	"raping",
	"rapist",
	"rectum",
	"reverse cowgirl",
	"rimjob",
	"rimming",
	"rosy palm",
	"rosy palm and her 5 sisters",
	"rusty trombone",
	"sadism",
	"santorum",
	"scat",
	"schlong",
	"scissoring",
	"semen",
	"sex",
	"sexo",
	"sexy",
	"shaved beaver",
	"shaved pussy",
	"shemale",
	"shibari",
	"shitblimp",
	"shota",
	"shrimping",
	"skeet",
	"slanteye",
	"slut",
	"s&m",
	"snatch",
	"snowballing",
	"sodomize",
	"sodomy",
	"splooge",
	"splooge moose",
	"spooge",
	"spread legs",
	"spunk",
	"strap on",
	"strapon",
	"strappado",
	"strip club",
	"style doggy",
	"suck",
	"sucks",
	"suicide girls",
	"sultry women",
	"swastika",
	"swinger",
	"tainted love",
	"taste my",
	"tea bagging",
	"threesome",
	"throating",
	"tied up",
	"tight white",
	"tits",
	"titties",
	"titty",
	"tongue in a",
	"topless",
	"tosser",
	"towelhead",
	"tranny",
	"tribadism",
	"tub girl",
	"tubgirl",
	"tushy",
	"twat",
	"twink",
	"twinkie",
	"two girls one cup",
	"undressing",
	"upskirt",
	"urethra play",
	"urophilia",
	"vagina",
	"venus mound",
	"vibrator",
	"violet wand",
	"vorarephilia",
	"voyeur",
	"vulva",
	"wank",
	"wetback",
	"wet dream",
	"white power",
	"wrapping men",
	"wrinkled starfish",
	"xxx",
	"yaoi",
	"yellow showers",
	"yiffy",
	"zoophilia",
	"ahole",
	"anus",
	"ash0le",
	"ash0les",
	"asholes",
	"Ass Monkey",
	"Assface",
	"assh0le",
	"assh0lez",
	"asshole",
	"assholes",
	"assholz",
	"asswipe",
	"azzhole",
	"bassterds",
	"bastard",
	"bastards",
	"bastardz",
	"basterds",
	"basterdz",
	"Biatch",
	"bitch",
	"bitches",
	"Blow Job",
	"boffing",
	"butthole",
	"buttwipe",
	"c0ck",
	"c0cks",
	"c0k",
	"Carpet Muncher",
	"cawk",
	"cawks",
	"Clit",
	"cnts",
	"cntz",
	"cock",
	"cockhead",
	"cock-head",
	"cocks",
	"CockSucker",
	"cock-sucker",
	"cum",
	"cunt",
	"cunts",
	"cuntz",
	"dick",
	"dild0",
	"dild0s",
	"dildo",
	"dildos",
	"dilld0",
	"dilld0s",
	"dominatricks",
	"dominatrics",
	"dominatrix",
	"dyke",
	"enema",
	"fag",
	"fag1t",
	"faget",
	"fagg1t",
	"faggit",
	"faggot",
	"fagg0t",
	"fagit",
	"fags",
	"fagz",
	"faig",
	"faigs",
	"fart",
	"Fudge Packer",
	"Fukah",
	"Fuken",
	"fuker",
	"Fukin",
	"Fukk",
	"Fukkah",
	"Fukken",
	"Fukker",
	"Fukkin",
	"g00k",
	"h00r",
	"h0ar",
	"h0re",
	"hells",
	"jackoff",
	"jap",
	"japs",
	"jerk-off",
	"jisim",
	"jiss",
	"jizm",
	"jizz",
	"knob",
	"knobs",
	"knobz",
	"kunt",
	"kunts",
	"kuntz",
	"Lezzian",
	"Lipshits",
	"Lipshitz",
	"masochist",
	"masokist",
	"massterbait",
	"masstrbait",
	"masstrbate",
	"masterbaiter",
	"masterbate",
	"masterbates",
	"Motha Fucker",
	"Motha Fuker",
	"Motha Fukkah",
	"Motha Fukker",
	"Mother Fucker",
	"Mother Fukah",
	"Mother Fuker",
	"Mother Fukkah",
	"Mother Fukker",
	"mother-fucker",
	"Mutha Fucker",
	"Mutha Fukah",
	"Mutha Fuker",
	"Mutha Fukkah",
	"Mutha Fukker",
	"fuck you",
	"fuck u",
	"fuck",
	"shit",
	"n1gr",
	"nastt",
	"nigger;",
	"nigur;",
	"niiger;",
	"niigr;",
	"orafis",
	"orgasm",
	"orgasum",
	"oriface",
	"orifice",
	"orifiss",
	"packie",
	"packy",
	"pakie",
	"paky",
	"peeenus",
	"peeenusss",
	"peenus",
	"peinus",
	"pen1s",
	"penas",
	"penis",
	"penis-breath",
	"penus",
	"penuus",
	"Phuc",
	"Phuck",
	"Phuk",
	"Phuker",
	"Phukker",
	"Poonani",
	"pr1c",
	"pr1ck",
	"pr1k",
	"pusse",
	"pussee",
	"pussy",
	"puuke",
	"puuker",
	"recktum",
	"rectum",
	"retard",
	"sadist",
	"scank",
	"schlong",
	"screwing",
	"semen",
	"sexy",
	"Sh!t",
	"sh1t",
	"sh1ter",
	"sh1ts",
	"sh1tter",
	"sh1tz",
	"shits",
	"shitter",
	"shitz",
	"Shyt",
	"Shyte",
	"Shytty",
	"Shyty",
	"skanck",
	"skank",
	"skankee",
	"skankey",
	"skanks",
	"Skanky",
	"slag",
	"slut",
	"sluts",
	"Slutty",
	"slutz",
	"son-of-a-bitch",
	"va1jina",
	"vag1na",
	"vagiina",
	"vagina",
	"vaj1na",
	"vajina",
	"w0p",
	"wh00r",
	"wh0re",
	"whore",
	"xrated",
	"xxx",
	"b!+ch",
	"bitch",
	"blowjob",
	"clit",
	"arschloch",
	"asshole",
	"b!tch",
	"b17ch",
	"b1tch",
	"bastard",
	"bi+ch",
	"boiolas",
	"buceta",
	"c0ck",
	"chink",
	"cipa",
	"clits",
	"cock",
	"cum",
	"cunt",
	"dildo",
	"dirsa",
	"ejakulate",
	"fatass",
	"fcuk",
	"fux0r",
	"jism",
	"kawk",
	"l3itch",
	"l3i+ch",
	"masturbate",
	"masterbat*",
	"masterbat3",
	"s.o.b.",
	"mofo",
	"nazi",
	"nigga",
	"nigger",
	"nutsack",
	"phuck",
	"pimpis",
	"pusse",
	"pussy",
	"scrotum",
	"sh!t",
	"shemale",
	"shi+",
	"sh!+",
	"slut",
	"teets",
	"tits",
	"boobs",
	"b00bs",
	"teez",
	"testical",
	"testicle",
	"w00se",
	"jackoff",
	"wank",
	"whoar",
	"whore",
	"*dyke",
	"@$$",
	"dra åt helvete",
	"fitta",
	"fittig",
	"för helvete",
	"helvete",
	"hård",
	"jävlar",
	"knulla",
	"kuk",
	"kötthuvud",
	"köttnacke",
	"nigger",
	"neger",
	"olla",
	"pippa",
	"runka",
	"röv",
	"rövhål",
	"rövknulla",
	"skit ner dig",
	"hora",
	"horunge"
]


func filter(string: String) -> String:
	for bad_word in bad_words:
		if randf() > 0.9:
			string = string.replacen(bad_word, "*%gloob!€")
		else:
			string = string.replacen(bad_word, "€*%#!")
	
	return string
