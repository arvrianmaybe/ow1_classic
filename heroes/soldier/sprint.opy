#!mainFile "../../dev_main.opy"

rule "[soldier/sprint.opy]: set cast time on sprint":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)

    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)
    wait(SOLDIER_SPRINT_CAST_TIME, Wait.RESTART_WHEN_TRUE)
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)
    startFiring()