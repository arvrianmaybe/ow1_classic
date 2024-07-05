#!mainFile "../../dev_main.opy"

rule "[torbjorn/rivet.opy]: 3 rivet ammo consumption.":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    waitUntil(not eventPlayer.isFiringSecondaryFire(), Math.INFINITY)
    eventPlayer.setAmmo(0, max(0, eventPlayer.getAmmo(0) + OW2_TORBJORN_RIVET_GUN_AMMO_CONSUMPTION))
    eventPlayer.setAmmo(0, max(0, eventPlayer.getAmmo(0) - TORBJORN_RIVET_GUN_AMMO_CONSUMPTION))