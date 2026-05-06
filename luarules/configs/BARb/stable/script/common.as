namespace Side {

/*
 * Register factions
 */
TypeMask ARMADA = aiSideMasker.GetTypeMask("armada");
TypeMask CORTEX = aiSideMasker.GetTypeMask("cortex");
TypeMask LEGION = aiSideMasker.GetTypeMask("legion");

}  // namespace Side

namespace Init {

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
		if (cdef !is null)
			cdef.SetIgnore(false);
	}
}

}  // namespace Init
