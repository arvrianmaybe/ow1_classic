#!mainFile "../../dev_main.opy"

rule "[lucio/soundwave.opy]: OW1 Soundwave damage":
    @Event playerDealtDamage
    @Hero lucio
    @Condition eventAbility == Button.SECONDARY_FIRE
    
    heal(victim, null, eventDamage - eventDamage*(LUCIO_SOUNDWAVE_DAMAGE/OW2_LUCIO_SOUNDWAVE_DAMAGE))

rule "[lucio/soundwave.opy]: consume soundwave ammo":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isFiringSecondaryFire()
    
    eventPlayer.setAmmo(0, max(0, eventPlayer.getAmmo(0) - LUCIO_SOUNDWAVE_AMMO_CONSUMPTION))

rule "[lucio/soundwave.opy]: disallow during reload":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isReloading()

    eventPlayer.setSecondaryFireEnabled(false)
    waitUntil(not eventPlayer.isReloading(), Math.INFINITY)
    eventPlayer.setSecondaryFireEnabled(true)