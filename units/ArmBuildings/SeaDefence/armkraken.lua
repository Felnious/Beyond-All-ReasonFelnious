return {
	armkraken = {
		activatewhenbuilt = true,
		buildangle = 16384,
		buildpic = "ARMKRAKEN.DDS",
		buildtime = 20000,
		canrepeat = false,
		collisionvolumeoffsets = "0 -15 0",
		collisionvolumescales = "84 60 84",
		collisionvolumetype = "CylY",
		corpse = "DEAD",
		energycost = 13000,
		explodeas = "largeBuildingexplosiongeneric",
		footprintx = 5,
		footprintz = 5,
		health = 4450,
		idleautoheal = 5,
		idletime = 1800,
		maxacc = 0,
		maxdec = 0,
		metalcost = 1000,
		minwaterdepth = 2,
		nochasecategory = "MOBILE",
		objectname = "Units/ARMKRAKEN.s3o",
		script = "Units/ARMKRAKEN.cob",
		seismicsignature = 0,
		selfdestructas = "largeBuildingExplosionGenericSelfd",
		sightdistance = 700,
		waterline = 3,
		yardmap = "wwwww wwwww wwwww wwwww wwwww",
		customparams = {
			model_author = "Zecrus",
			normaltex = "unittextures/Arm_normal.dds",
			removewait = true,
			subfolder = "ArmBuildings/SeaDefence",
			techlevel = 2,
			unitgroup = "weapon",
		},
		featuredefs = {
			dead = {
				blocking = false,
				category = "corpses",
				collisionvolumeoffsets = "0 -15 0",
				collisionvolumescales = "84 60 84",
				collisionvolumetype = "Box",
				damage = 4000,
				featuredead = "HEAP",
				footprintx = 5,
				footprintz = 5,
				height = 20,
				metal = 500,
				object = "Units/armkraken_dead.s3o",
				reclaimable = true,
			},
			heap = {
				blocking = false,
				category = "heaps",
				collisionvolumescales = "55.0 4.0 6.0",
				collisionvolumetype = "cylY",
				damage = 1000,
				footprintx = 3,
				footprintz = 3,
				height = 4,
				metal = 250,
				object = "Units/cor3X3E.s3o",
				reclaimable = true,
				resurrectable = 0,
			},
		},
		sfxtypes = {
			pieceexplosiongenerators = {
				[1] = "deathceg2",
				[2] = "deathceg3",
				[3] = "deathceg4",
			},
		},
		sounds = {
			canceldestruct = "cancel2",
			cloak = "kloak1",
			uncloak = "kloak1un",
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
				[1] = "twractv3",
			},
			select = {
				[1] = "twractv3",
			},
		},
		weapondefs = {
			armmech_cannon = {
				areaofeffect = 12,
				avoidfeature = false,
				cegtag = "arty-small",
				craterareaofeffect = 0,
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 0.15,
				explosiongenerator = "custom:genericshellexplosion-medium",
				firestarter = 5,
				impulsefactor = 0.123,
				name = "Rapid-fire gauss cannon",
				noselfdamage = true,
				range = 800,
				reloadtime = 0.35,
				soundhit = "xplomed2",
				soundhitwet = "splshbig",
				soundstart = "cannhvy2",
				targetmoveerror = 0.15,
				turret = true,
				weapontimer = 2,
				weapontype = "Cannon",
				weaponvelocity = 600,
				damage = {
					default = 180,
					vtol = 50,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "GROUNDSCOUT",
				def = "ARMMECH_CANNON",
				onlytargetcategory = "SURFACE",
			},
		},
	},
}
