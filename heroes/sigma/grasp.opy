#!mainFile "../../dev_main.opy"

playervar grasp_pvar
#!defineMember _hp_before_grasp grasp_pvar [0]


rule "[sigma/grasp.opy]: Reduce overall grasp overhealth":
    @Event eachPlayer
    @Hero sigma
    @Condition eventPlayer.isUsingAbility1()
    
    wait(OW2_SIGMA_KINETIC_GRASP_DURATION - 50 * TICK_DURATION, Wait.ABORT_WHEN_FALSE)
    eventPlayer._hp_before_grasp = eventPlayer.getHealth()
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    damage(eventPlayer, null, (1 - SIGMA_KINETIC_GRASP_OVERHEALTH/OW2_SIGMA_KINETIC_GRASP_OVERHEALTH) * (eventPlayer.getHealth() - eventPlayer._hp_before_grasp))