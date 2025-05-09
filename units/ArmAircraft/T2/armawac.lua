return {
	armawac = {
		blocking = false,
		buildpic = "ARMAWAC.DDS",
		buildtime = 12800,
		canfly = true,
		canmove = true,
		collide = false,
		cruisealtitude = 160,
		energycost = 8600,
		explodeas = "mediumexplosiongeneric",
		footprintx = 3,
		footprintz = 3,
		health = 890,
		idleautoheal = 5,
		idletime = 1800,
		maxacc = 0.1575,
		maxaileron = 0.01366,
		maxbank = 0.8,
		maxdec = 0.05,
		maxelevator = 0.00991,
		maxpitch = 0.625,
		maxrudder = 0.00541,
		maxslope = 10,
		maxwaterdepth = 0,
		metalcost = 175,
		objectname = "Units/ARMAWAC.s3o",
		radardistance = 2500,
		script = "Units/ARMAWAC.cob",
		seismicsignature = 0,
		selfdestructas = "mediumExplosionGenericSelfd",
		sightdistance = 1275,
		sonardistance = 1200,
		speed = 317.39999,
		speedtofront = 0.06417,
		turnradius = 64,
		usesmoothmesh = true,
		wingangle = 0.06241,
		wingdrag = 0.135,
		customparams = {
			model_author = "FireStorm",
			normaltex = "unittextures/Arm_normal.dds",
			subfolder = "ArmAircraft/T2",
			techlevel = 2,
			unitgroup = "util",
		},
		sfxtypes = {
			crashexplosiongenerators = {
				[1] = "crashing-small",
				[2] = "crashing-small",
				[3] = "crashing-small2",
				[4] = "crashing-small3",
				[5] = "crashing-small3",
			},
			pieceexplosiongenerators = {
				[1] = "airdeathceg3",
				[2] = "airdeathceg4",
				[3] = "airdeathceg2",
			},
		},
		sounds = {
			canceldestruct = "cancel2",
			underattack = "warning1",
			cant = {
				[1] = "cantdo4",
			},
			count = {
				[1] = "count6",
				[2] = "count5",
				[3] = "count4",
				[4] = "count3",
				[5] = "count2",
				[6] = "count1",
			},
			ok = {
				[1] = "vtolarmv",
			},
			select = {
				[1] = "aaradsel",
			},
		},
	},
}
