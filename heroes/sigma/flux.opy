#!mainFile "../../dev_main.opy"


rule "[sigma/flux.opy]: Set move penalty gravity flux":
    @Event eachPlayer
    @Hero sigma
    @Condition eventPlayer.isUsingUltimate()

    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar*(1-SIGMA_GRAVITY_FLUX_MOVEMENT_PENALTY))
    waitUntil((not eventPlayer.isUsingUltimate()), Math.INFINITY)
    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar/(1-SIGMA_GRAVITY_FLUX_MOVEMENT_PENALTY))


rule "[sigma/flux.opy]: Set move penalty gravity flux victims":
    @Event playerTookDamage
    @Condition eventAbility == Button.ULTIMATE
    @Condition attacker.getCurrentHero() == Hero.SIGMA
    
    wait()
    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar*(1-SIGMA_GRAVITY_FLUX_MOVEMENT_PENALTY))
    wait(2)
    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar/(1-SIGMA_GRAVITY_FLUX_MOVEMENT_PENALTY))