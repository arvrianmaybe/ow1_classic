#!mainFile "../../dev_main.opy"

rule "[symmetra/orb.opy]: set turret speed":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.setProjectileSpeed(1000)
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.setProjectileSpeed(100)

rule "[symmetra/orb.opy]: symmetra allow turrets":
    @Event eachPlayer
    @Hero symmetra
    @Condition distance(eventPlayer.getEyePosition(), raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + 6 * eventPlayer.getFacingDirection(), null, eventPlayer, false).getHitPosition()) < 5
    
    eventPlayer.setAbility1Enabled(true)
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    if RULE_CONDITION:
        goto RULE_START

rule "[symmetra/orb.opy]: symettra disallow turrets":
    @Event eachPlayer
    @Hero symmetra
    @Condition distance(eventPlayer.getEyePosition(), raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + 6 * eventPlayer.getFacingDirection(), null, eventPlayer, false).getHitPosition()) > 5
    
    eventPlayer.setAbility1Enabled(false)
    if eventPlayer.isUsingAbility1():
        eventPlayer.cancelPrimaryAction()
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    if RULE_CONDITION:
        goto RULE_START
