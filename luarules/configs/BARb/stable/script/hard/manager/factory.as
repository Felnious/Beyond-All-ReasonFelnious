#include "../../define.as"
#include "../../unit.as"
#include "../../task.as"
#include "../misc/commander.as"


namespace Factory {

enum Attr {
	T1 = 0x0001, T2 = 0x0002, T3 = 0x0004, T4 = 0x0008
}

class SUserData {
	SUserData(int a) {
		attr = a;
	}
	SUserData() {}
	int attr = 0;
}

// Example of userData per UnitDef
array<SUserData> userData(ai.GetDefCount() + 1);

string armlab  ("armlab");
string armalab ("armalab");
string armvp   ("armvp");
string armavp  ("armavp");
string armsy   ("armsy");
string armasy  ("armasy");
string armap   ("armap");
string armaap  ("armaap");
string armshltx("armshltx");

string corlab  ("corlab");
string coralab ("coralab");
string corvp   ("corvp");
string coravp  ("coravp");
string corsy   ("corsy");
string corasy  ("corasy");
string corap   ("corap");
string coraap  ("coraap");
string corgant ("corgant");

string leglab  ("leglab");
string legalab ("legalab");
string legvp   ("legvp");
string legavp  ("legavp");
string legap   ("legap");
string legsy   ("legsy");
string legadvshipyard   ("legadvshipyard");
string legaap  ("legaap");
string leggant ("leggant");

float switchLimit = MakeSwitchLimit();

IUnitTask@ AiMakeTask(CCircuitUnit@ unit)
{
	return aiFactoryMgr.DefaultMakeTask(unit);
}

void AiTaskAdded(IUnitTask@ task)
{
}

void AiTaskRemoved(IUnitTask@ task, bool done)
{
}

void AiUnitAdded(CCircuitUnit@ unit, Unit::UseAs usage)
{
	if (usage != Unit::UseAs::FACTORY)
		return;

	const CCircuitDef@ facDef = unit.circuitDef;

	const array<Opener::SO>@ opener = Opener::GetOpener(facDef);
	if (opener is null)
		return;

	const AIFloat3 pos = unit.GetPos(ai.frame);
	for (uint i = 0, icount = opener.length(); i < icount; ++i) {
		CCircuitDef@ buildDef = aiFactoryMgr.GetRoleDef(facDef, opener[i].role);
		if ((buildDef is null) || !buildDef.IsAvailable(ai.frame))
			continue;

		Task::Priority priority;
		Task::RecruitType recruit;
		if (opener[i].role == Unit::Role::BUILDER.type) {
			priority = Task::Priority::NORMAL;
			recruit  = Task::RecruitType::BUILDPOWER;
		} else {
			priority = Task::Priority::HIGH;
			recruit  = Task::RecruitType::FIREPOWER;
		}
		for (uint j = 0, jcount = opener[i].count; j < jcount; ++j)
			aiFactoryMgr.Enqueue(TaskS::Recruit(recruit, priority, buildDef, pos, 64.f));
	}
}

void AiUnitRemoved(CCircuitUnit@ unit, Unit::UseAs usage)
{
}

void AiLoad(IStream& istream)
{
}

void AiSave(OStream& ostream)
{
}

/*
 * New factory switch condition; switch event is also based on eco + caretakers.
 */
bool AiIsSwitchTime(int lastSwitchFrame)
{
	const float value = pow((ai.frame - lastSwitchFrame), 0.9) * aiEconomyMgr.metal.income + (aiEconomyMgr.metal.current * 7);
	if (value > switchLimit) {
		switchLimit = MakeSwitchLimit();
		return true;
	}
	return false;
}

bool AiIsSwitchAllowed(CCircuitDef@ facDef)
{
	return true;
}

CCircuitDef@ AiGetFactoryToBuild(const AIFloat3& in pos, bool isStart, bool isReset)
{
	CCircuitDef@ buildDef = aiFactoryMgr.DefaultGetFactoryToBuild(pos, isStart, isReset);
	if ((buildDef !is null) && !IsLeadAirTeam() && IsAirFactoryDef(buildDef)) {
		CCircuitDef@ fallback = GetNonAirFactoryFallback(buildDef);
		if ((fallback !is null) && fallback.IsAvailable(ai.frame))
			return fallback;
	}
	return buildDef;
}

/* --- Utils --- */

bool IsLeadAirTeam()
{
	return ai.teamId == ai.GetLeadTeamId();
}

bool IsAirFactoryDef(const CCircuitDef@ facDef)
{
	if (facDef is null)
		return false;

	const string name = facDef.GetName();
	return (name == armap) || (name == armaap)
		|| (name == corap) || (name == coraap)
		|| (name == legap) || (name == legaap);
}

CCircuitDef@ GetNonAirFactoryFallback(const CCircuitDef@ facDef)
{
	const string name = facDef.GetName();
	string fallbackName;
	if (name == armap) {
		fallbackName = armvp;
	} else if (name == armaap) {
		fallbackName = armavp;
	} else if (name == corap) {
		fallbackName = corvp;
	} else if (name == coraap) {
		fallbackName = coravp;
	} else if (name == legap) {
		fallbackName = legvp;
	} else if (name == legaap) {
		fallbackName = legavp;
	}

	return (fallbackName.length() > 0) ? ai.GetCircuitDef(fallbackName) : null;
}

float MakeSwitchLimit()
{
	return AiRandom(8000, 12000) * SECOND;
}

}  // namespace Factory
