#!mainFile "../../dev_main.opy"

rule "[soldier/sprint.opy]: set cast time on sprint":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)
    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar*(1-SOLDIER_SPRINT_SPEED))

    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)
    wait(SOLDIER_SPRINT_CAST_TIME, Wait.RESTART_WHEN_TRUE)
    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar/(1-SOLDIER_SPRINT_SPEED))
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)
    startFiring()