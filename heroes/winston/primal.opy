playervar primal_pvar
#!defineMember _primal_exit_health primal_pvar[0]
#!defineMember _primal_exit_armor primal_pvar[1]
#!defineMember _primal_hp_id primal_pvar[2]


rule "[primal/init.opy]: Remove bonus Primal Rage health":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer.isUsingUltimate()

    removeHealthPool(eventPlayer._primal_hp_id)
    wait(OW2_WINSTON_PRIMAL_DURATION - 10 * TICK_DURATION)
    eventPlayer._primal_exit_health = eventPlayer.getHealthOfType(Health.NORMAL)
    eventPlayer._primal_exit_armor = eventPlayer.getHealthOfType(Health.ARMOR)
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.addHealthPool(Health.NORMAL, (OW2_WINSTON_PRIMAL_HEALTH_BONUS * (WINSTON_BARRIER_HEALTH/OW2_WINSTON_BARRIER_HEALTH) - WINSTON_PRIMAL_HEALTH_BONUS), true, true)
    eventPlayer._primal_hp_id = getLastCreatedHealthPool()
    eventPlayer.setHealth(min(WINSTON_HEALTH, eventPlayer._primal_exit_health) + eventPlayer._primal_exit_armor)