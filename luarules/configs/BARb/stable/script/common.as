namespace Side {

/*
 * Register factions
 */
TypeMask ARMADA = aiSideMasker.GetTypeMask("armada");
TypeMask CORTEX = aiSideMasker.GetTypeMask("cortex");
TypeMask LEGION = aiSideMasker.GetTypeMask("legion");

}  // namespace Side

namespace Init {

const float WALL_THREAT_KERNEL = 0.01f;
const float HIGH_VALUE_ECON_THREAT_KERNEL = 0.01f;
const int SIM_FRAMES_PER_SECOND = 30;
const int SMALL_T1_IGNORE_FRAME = 10 * 60 * SIM_FRAMES_PER_SECOND;

bool smallT1Ignored = false;

SCategoryInfo InitCategories()
{
	SCategoryInfo category;
	category.air   = "VTOL NOTSUB";
	category.land  = "SURFACE NOTSUB";
	category.water = "UNDERWATER NOTHOVER";
	category.bad   = "MINE";
	category.good  = "";
	return category;
}

SArmorInfo InitArmordef()
{
	// NOTE: Intentionally unsorted as it is in bar.sdd/gamedata/armordefs.lua
	//       Replicates engine's string<=>int assignment
	//       Must not include "default" keyword
	array<string> armors = {
		"commanders",
		"scavboss",
		"indestructable",
		"crawlingbombs",
		"walls",
		"standard",
		"space",
		"mines",
		"nanos",
		"vtol",
		"shields",
		"lboats",
		"hvyboats",
		"subs",
		"raptor"
	};
	armors.sortAsc();
	armors.insertAt(0, "default");

	dictionary armorTypes;
	for (uint i = 0; i < armors.length(); ++i) {
		armorTypes[armors[i]] = i;
	}

	array<string> airTypes = {"vtol"};
	array<string> surfaceTypes = {"default"};
	array<string> waterTypes = {"subs"};

	SArmorInfo armor;
	for (uint i = 0; i < airTypes.length(); ++i) {
		armor.AddAir(int(armorTypes[airTypes[i]]));
	}
	for (uint i = 0; i < surfaceTypes.length(); ++i) {
		armor.AddSurface(int(armorTypes[surfaceTypes[i]]));
	}
	for (uint i = 0; i < waterTypes.length(); ++i) {
		armor.AddWater(int(armorTypes[waterTypes[i]]));
	}
	return armor;
}

void SetFireStateForUnits(const array<string>& in units, int fireState)
{
	for (uint i = 0; i < units.length(); ++i) {
		CCircuitDef@ cdef = ai.GetCircuitDef(units[i]);
		if (cdef !is null) {
			cdef.SetFireState(fireState);
		}
	}
}

void SetIgnoreForUnits(const array<string>& in units, bool ignore)
{
	for (uint i = 0; i < units.length(); ++i) {
		CCircuitDef@ cdef = ai.GetCircuitDef(units[i]);
		if (cdef !is null) {
			cdef.SetIgnore(ignore);
		}
	}
}

array<string> GetSmallT1IgnoreUnits()
{
	array<string> units = {
		"armpw", "armflea", "armfav", "armflash", "armpincer",
		"corak", "corfav", "corgator", "corraid",
		"leggob", "legscout", "leghades"
	};
	return units;
}

array<string> GetHyperAggressiveT1T2CombatUnits()
{
	array<string> units = {
		// T1 land, sea, and hover combat
		"armfav", "armpw", "armrock", "armham", "armjeth", "armflash", "armstump", "armart", "armwar",
		"armflea", "armfboy", "armaser", "armmark", "armfast", "armsptk", "armscab",
		"corak", "corstorm", "corthud", "corcrash", "corraid", "cormist", "cormart", "coraak",
		"legkoda", "legshot", "legaa", "legraider", "leginf", "legart", "legcen", "legbal",
		"legkark", "leglob", "leggob",
		"armpt", "armsub", "armroy", "armpship",
		"corpt", "corsub", "corroy", "corpship",
		"legnavyscout", "legnavyfrigate", "legnavydestro", "legnavysub", "legnavyaaship", "legnavyartyship",
		"armsh", "armmh", "armanac", "armah",
		"corsh", "cormh", "corsnap", "corah",
		"legsh", "legmh", "legner", "legah",

		// T2 land and hover combat
		"armfast", "armamph", "armzeus", "armfboy", "armmav", "armfido", "armvader", "armaak",
		"armlatnk", "armbull", "armmanni", "armmart", "armmerl", "armyork",
		"cortermite", "corpyro", "corsumo", "corcan", "cormort", "corhrk", "coraak", "coramph",
		"corseal", "corparrow", "correap", "corgol", "cormart", "corsent", "corvroc", "corban", "cortrem",
		"legstr", "leginc", "legshot", "legsrail", "leghrk", "legamph", "legadvaabot",
		"legamphtank", "leggat", "leghelios", "legbar", "legrail", "legfloat", "legaskirmtank", "legmrv",
		"legaheattank", "legamcluster", "legavroc", "legmed",

		// T2 naval combat
		"armaas", "armcrus", "armmship", "armbats",
		"corarch", "corcrus", "cormship", "corbats", "corshark", "corssub",
		"leganavycruiser", "leganavymissileship", "leganavybattleship", "leganavyartyship",
		"leganavyaaship", "leganavybattlesub", "leganavyheavysub"
	};
	return units;
}

array<string> GetHyperAggressiveT1T2PushUnits()
{
	array<string> units = {
		// T1 land, sea, and hover shove units
		"armfav", "armpw", "armrock", "armham", "armflash", "armstump", "armart", "armwar", "armflea", "armfboy",
		"corak", "corstorm", "corthud", "corraid", "cormart",
		"legkoda", "legshot", "legraider", "leginf", "legart", "legcen", "legbal", "legkark", "leglob", "leggob",
		"armpt", "armsub", "armroy", "armpship",
		"corpt", "corsub", "corroy", "corpship",
		"legnavyscout", "legnavyfrigate", "legnavydestro", "legnavysub", "legnavyartyship",
		"armsh", "armmh", "armanac", "corsh", "cormh", "corsnap", "legsh", "legmh", "legner",

		// T2 land and hover shove units
		"armfast", "armamph", "armzeus", "armfboy", "armmav", "armfido", "armvader",
		"armlatnk", "armbull", "armmanni", "armmart", "armmerl",
		"cortermite", "corpyro", "corsumo", "corcan", "cormort", "corhrk", "coramph",
		"corseal", "corparrow", "correap", "corgol", "cormart", "corvroc", "corban", "cortrem",
		"legstr", "leginc", "legshot", "legsrail", "leghrk", "legamph",
		"legamphtank", "leggat", "leghelios", "legbar", "legrail", "legfloat", "legaskirmtank", "legmrv",
		"legaheattank", "legamcluster", "legavroc", "legmed",

		// T2 naval shove units
		"armcrus", "armmship", "armbats",
		"corcrus", "cormship", "corbats", "corshark", "corssub",
		"leganavycruiser", "leganavymissileship", "leganavybattleship", "leganavyartyship",
		"leganavybattlesub", "leganavyheavysub"
	};
	return units;
}

array<string> GetHyperAggressiveT1DefencePushUnits()
{
	array<string> units = {
		// T1 land, sea, and hover units that should bias into static defenses
		"armfav", "armpw", "armrock", "armham", "armflash", "armstump", "armart", "armwar", "armflea",
		"corak", "corstorm", "corthud", "corraid", "cormart",
		"legkoda", "legshot", "legraider", "leginf", "legart", "legcen", "legbal", "legkark", "leglob", "leggob",
		"armpt", "armsub", "armroy", "armpship",
		"corpt", "corsub", "corroy", "corpship",
		"legnavyscout", "legnavyfrigate", "legnavydestro", "legnavysub", "legnavyartyship",
		"armsh", "armmh", "armanac", "corsh", "cormh", "corsnap", "legsh", "legmh", "legner"
	};
	return units;
}

array<string> GetHyperAggressiveT3Units()
{
	array<string> units = {
		// Armada late-game mobile combat
		"armmar", "armraz", "armvang", "armbanth", "armlun", "armthor",
		"armcroc", "armmls", "armserp", "armaas", "armcrus", "armcarry", "armmship", "armbats", "armepoch",

		// Cortex late-game mobile combat
		"corsok", "corshiva", "corkarg", "corcat", "corkorg", "corjugg",
		"cormls", "corseal", "corshark", "corssub", "corarch", "corcrus", "corcarry", "cormship", "corbats", "corblackhy",

		// Legion late-game mobile combat
		"leginfestor", "legsrail", "leginc", "legkeres", "legfort",
		"leganavyantiswarm", "leganavycruiser", "leganavymissileship", "leganavybattleship", "leganavyartyship",
		"leganavyflagship", "leganavybattlesub", "leganavyheavysub",

		// Extra T4 combat units
		"armmeatball", "armassimilator", "armpwt4", "armsptkt4", "armvadert4", "armrattet4",
		"corakt4", "corthermite", "corgolt4",
		"leggobt3", "legpede", "legsrailt4"
	};
	return units;
}

array<string> GetHyperAggressiveLandPushUnits()
{
	array<string> units = {
		"armmar", "armraz", "armvang", "armbanth", "armlun", "armthor",
		"corsok", "corshiva", "corkarg", "corcat", "corkorg", "corjugg",
		"leginfestor", "legsrail", "leginc", "legkeres",
		"armmeatball", "armassimilator", "armpwt4", "armsptkt4", "armvadert4", "armrattet4",
		"corakt4", "corthermite", "corgolt4",
		"leggobt3", "legpede", "legsrailt4"
	};
	return units;
}

array<string> GetAllHyperAggressiveLandCombatUnits()
{
	array<string> units = {
		// T1 land and hover combat
		"armfav", "armpw", "armrock", "armham", "armjeth", "armflash", "armstump", "armart", "armwar",
		"armflea", "armfboy", "armaser", "armmark", "armfast", "armsptk", "armscab",
		"corak", "corstorm", "corthud", "corcrash", "corraid", "cormist", "cormart", "coraak",
		"legkoda", "legshot", "legaa", "legraider", "leginf", "legart", "legcen", "legbal",
		"legkark", "leglob", "leggob",
		"armsh", "armmh", "armanac", "armah",
		"corsh", "cormh", "corsnap", "corah",
		"legsh", "legmh", "legner", "legah",

		// T2 land and hover combat
		"armamph", "armzeus", "armmav", "armfido", "armvader", "armaak",
		"armlatnk", "armbull", "armmanni", "armmart", "armmerl", "armyork",
		"cortermite", "corpyro", "corsumo", "corcan", "cormort", "corhrk", "coramph",
		"corseal", "corparrow", "correap", "corgol", "corsent", "corvroc", "corban", "cortrem",
		"legstr", "leginc", "legsrail", "leghrk", "legamph", "legadvaabot",
		"legamphtank", "leggat", "leghelios", "legbar", "legrail", "legfloat", "legaskirmtank", "legmrv",
		"legaheattank", "legamcluster", "legavroc", "legmed",

		// T3/T4 land combat
		"armmar", "armraz", "armvang", "armbanth", "armlun", "armthor",
		"corsok", "corshiva", "corkarg", "corcat", "corkorg", "corjugg",
		"leginfestor", "legsrail", "leginc", "legkeres", "legfort",
		"armmeatball", "armassimilator", "armpwt4", "armsptkt4", "armvadert4", "armrattet4",
		"corakt4", "corthermite", "corgolt4",
		"leggobt3", "legpede", "legsrailt4"
	};
	return units;
}

array<string> GetBehemothPushUnits()
{
	array<string> units = {
		"armbanth", "corjugg", "corkorg", "armmeatball"
	};
	return units;
}

array<string> GetLongRangeCannonUnits()
{
	array<string> units = {
		"armbrtha", "armvulc",
		"corint", "corbuzz",
		"leglrpc"
	};
	return units;
}

array<string> GetHighValueEconomyTargets()
{
	array<string> units = {
		// Armada high-value economy
		"armmoho", "armuwmme", "armgeo", "armageo", "armadvsol",
		"armfus", "armafus", "armuwfus", "armckfus",
		"armestor", "armuwes", "armmstor", "armuwadvms",
		"armmakr", "armmmkr", "armfmkr", "armuwmmm",

		// Cortex high-value economy
		"cormoho", "coruwmme", "corgeo", "corageo", "coradvsol",
		"corfus", "corafus", "coruwfus",
		"corestor", "coruwes", "cormstor", "coruwadvms",
		"cormakr", "cormmkr", "corfmkr", "coruwmmm",

		// Legion high-value economy
		"legmoho", "leggeo", "legageo", "legadvsol",
		"legfus", "legafus", "leganavalfusion",
		"legestor", "leguwestore", "legmstor", "leguwmstore", "legadvestore",
		"legeconv", "legadveconv", "leganavaleconv"
	};
	return units;
}

array<string> GetAggressiveAirFighterUnits()
{
	array<string> units = {
		"armfig", "armhawk",
		"corveng", "corvamp",
		"legfig", "legafigdef", "legvenator", "legspfighter"
	};
	return units;
}

void AddAttributeForUnits(const array<string>& in units, int attr)
{
	for (uint i = 0; i < units.length(); ++i) {
		CCircuitDef@ cdef = ai.GetCircuitDef(units[i]);
		if (cdef !is null) {
			cdef.AddAttribute(attr);
		}
	}
}

void EnableWallBreakingFireState()
{
	array<string> units = {
		// Barb3 FRONT role T1 land combat units
		"armfav", "armpw", "armrock", "armham", "armjeth", "armflash", "armstump", "armart", "armwar",
		"armflea", "armfboy", "armaser", "armmark", "armfast", "armsptk", "armscab",
		"corak", "corstorm", "corthud", "corcrash", "corraid", "cormist", "cormart", "coraak",
		"legkoda", "legshot", "legaa", "legraider", "leginf", "legart", "legcen", "legbal",
		"legkark", "leglob", "leggob",

		// Barb3 SEA role T1 naval combat units
		"armpt", "armsub", "armroy", "armpship",
		"corpt", "corsub", "corroy", "corpship",
		"legnavyscout", "legnavyfrigate", "legnavydestro", "legnavysub", "legnavyaaship", "legnavyartyship",

		// Barb3 HOVER_SEA role T1 hover combat units
		"armsh", "armmh", "armanac", "armah",
		"corsh", "cormh", "corsnap", "corah",
		"legsh", "legmh", "legner", "legah"
	};

	SetFireStateForUnits(units, 3);
}

void EnableDefenceFireState()
{
	array<string> units = {
		// Armed Armada static defenses
		"armllt", "armtl", "armrl", "armbeamer", "armhlt", "armclaw", "armcir", "armferret",
		"armpb", "armatl", "armflak", "armamb", "armanni", "armguard", "armamd", "armtarg",
		"armbrtha", "armvulc",
		"armgate", "armemp", "armfhlt",

		// Armed Cortex static defenses
		"corllt", "cortl", "corrl", "corhllt", "corhlt", "cormaw", "cormadsam", "corvipe",
		"coratl", "corflak", "cortoast", "cordoom", "corpun", "corfmd", "cortarg", "corgate",
		"corint", "corbuzz",
		"cortron", "corfhlt",

		// Armed Legion static defenses
		"leglht", "legtl", "legrl", "legmg", "leghive", "legdtr", "legrhapsis", "leglupara",
		"legapopupdef", "legflak", "legacluster", "legbastion", "legcluster", "legabm", "legtarg",
		"legfmg", "legperdition", "leglrpc", "leganavalaaturret", "leganavalatorpturret", "leganavaldefturret"
	};

	SetFireStateForUnits(units, 3);
}

void EnableLongRangeCannonEconomyPressure()
{
	array<string> cannons = GetLongRangeCannonUnits();
	array<string> economyTargets = GetHighValueEconomyTargets();

	SetFireStateForUnits(cannons, 3);
	AddAttributeForUnits(cannons, Unit::Attr::ANTI_STAT.type);

	for (uint i = 0; i < economyTargets.length(); ++i) {
		CCircuitDef@ cdef = ai.GetCircuitDef(economyTargets[i]);
		if (cdef !is null) {
			cdef.SetIgnore(false);
			cdef.SetThreatKernel(HIGH_VALUE_ECON_THREAT_KERNEL);
		}
	}
}

void EnableAggressiveAirFighters()
{
	array<string> fighters = GetAggressiveAirFighterUnits();
	SetFireStateForUnits(fighters, 3);
	AddAttributeForUnits(fighters, Unit::Attr::SOLO.type);
}

void EnableHyperAggressiveT3Units()
{
	array<string> units = GetHyperAggressiveT3Units();
	AddAttributeForUnits(units, Unit::Attr::SOLO.type);
	AddAttributeForUnits(GetHyperAggressiveLandPushUnits(), Unit::Attr::ANTI_STAT.type);
	SetFireStateForUnits(units, 3);
}

void EnableAllLandUnitsHardPush()
{
	array<string> units = GetAllHyperAggressiveLandCombatUnits();
	AddAttributeForUnits(units, Unit::Attr::SOLO.type);
	AddAttributeForUnits(units, Unit::Attr::ANTI_STAT.type);
	SetFireStateForUnits(units, 3);
}

void EnableBehemothsHardPush()
{
	array<string> units = GetBehemothPushUnits();
	AddAttributeForUnits(units, Unit::Attr::SOLO.type);
	AddAttributeForUnits(units, Unit::Attr::ANTI_STAT.type);
	AddAttributeForUnits(units, Unit::Attr::NO_STRAFE.type);
	SetFireStateForUnits(units, 3);
}

void EnableHyperAggressiveT1T2Units()
{
	array<string> units = GetHyperAggressiveT1T2CombatUnits();
	AddAttributeForUnits(GetHyperAggressiveT1T2PushUnits(), Unit::Attr::SOLO.type);
	AddAttributeForUnits(GetHyperAggressiveT1DefencePushUnits(), Unit::Attr::ANTI_STAT.type);
	SetFireStateForUnits(units, 3);
}

void EnableLateGameIgnoreForSmallT1()
{
	if (smallT1Ignored || (ai.frame < SMALL_T1_IGNORE_FRAME))
		return;

	SetIgnoreForUnits(GetSmallT1IgnoreUnits(), true);
	smallT1Ignored = true;
}

void EnableWallTargets()
{
	array<string> walls = {
		"armdrag", "armfdrag", "armfort",
		"cordrag", "corfdrag", "corfort",
		"legdrag", "legfdrag", "legforti", "legrwall",
		"armdrag_scav", "armfdrag_scav", "armfort_scav",
		"cordrag_scav", "corfdrag_scav", "corfort_scav",
		"corscavdrag", "corscavdrag_scav", "corscavfort", "corscavfort_scav"
	};

	for (uint i = 0; i < walls.length(); ++i) {
		CCircuitDef@ cdef = ai.GetCircuitDef(walls[i]);
		if (cdef !is null) {
			cdef.SetIgnore(false);
			cdef.SetThreatKernel(WALL_THREAT_KERNEL);
		}
	}

	// BarbWalls has no Barb3-style role init hooks, so apply the same aggressive
	// default fire state here for T1 combat units that need to clear walls.
	EnableWallBreakingFireState();
	EnableHyperAggressiveT1T2Units();
	EnableAllLandUnitsHardPush();
	EnableBehemothsHardPush();
	EnableDefenceFireState();
	EnableLongRangeCannonEconomyPressure();
	EnableAggressiveAirFighters();
	EnableHyperAggressiveT3Units();
	SetIgnoreForUnits(GetSmallT1IgnoreUnits(), false);
}

}  // namespace Init
