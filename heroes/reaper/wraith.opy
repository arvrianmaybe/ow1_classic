#!mainFile "../../dev_main.opy"

rule "[reaper/wraith.opy]: set reaper wraith":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingAbility1()
    

    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar*(1-OW2_REAPER_WRAITH_MOVEMENT_INCREASE))
    eventPlayer.setAmmo(0, eventPlayer.ammo)
    waitUntil((not eventPlayer.isUsingAbility1()), Math.INFINITY)
    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar/(1-OW2_REAPER_WRAITH_MOVEMENT_INCREASE))
