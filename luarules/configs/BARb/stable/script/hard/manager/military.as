#include "../../define.as"
#include "../../task.as"
#include "../../unit.as"


namespace Military {

const string LEGION_STARFALL = "legstarfall";
const string LEGION_ENERGY_STORE = "legestor";
const uint LEGION_STARFALL_STORE_COUNT = 10;

IUnitTask@ AiMakeTask(CCircuitUnit@ unit)
{
	return aiMilitaryMgr.DefaultMakeTask(unit);
}

void AiTaskAdded(IUnitTask@ task)
{
}

void AiTaskRemoved(IUnitTask@ task, bool done)
{
}

void AiUnitAdded(CCircuitUnit@ unit, Unit::UseAs usage)
{
	const CCircuitDef@ cdef = unit.circuitDef;
	if ((cdef is null) || (cdef.GetName() != LEGION_STARFALL))
		return;

	CCircuitDef@ storeDef = ai.GetCircuitDef(LEGION_ENERGY_STORE);
	if (storeDef is null)
		return;

	const AIFloat3 pos = unit.GetPos(ai.frame);
	for (uint i = 0; i < LEGION_STARFALL_STORE_COUNT; ++i) {
		aiBuilderMgr.Enqueue(TaskB::Common(Task::BuildType::STORE, Task::Priority::HIGH, storeDef, pos));
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

void AiMakeDefence(int cluster, const AIFloat3& in pos)
{
	if ((ai.frame > 5 * MINUTE)
		|| (aiEconomyMgr.metal.income > 10.f)
		|| (aiEnemyMgr.mobileThreat > 0.f))
	{
		aiMilitaryMgr.DefaultMakeDefence(cluster, pos);
	}
}

/*
 * anti-air threat threshold;
 * air factories will stop production when AA threat exceeds
 */
// FIXME: Remove/replace, deprecated.
bool AiIsAirValid()
{
	return aiEnemyMgr.GetEnemyThreat(Unit::Role::AA.type) <= 80.f;
}

}  // namespace Military
