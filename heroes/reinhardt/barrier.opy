#!mainFile "../../dev_main.opy"

rule "[reinhardt/barrier.opy]: Slow down Reinhardt when using barrier":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isFiringSecondaryFire()

    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar*(1-REINHARDT_BARRIER_MOVEMENT_PENALTY))
    waitUntil((not eventPlayer.isFiringSecondaryFire()), Math.INFINITY)
    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar/(1-REINHARDT_BARRIER_MOVEMENT_PENALTY))
