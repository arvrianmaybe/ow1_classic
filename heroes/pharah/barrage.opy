#!mainFile "../../dev_main.opy"

playervar pharah_ammo

rule "[pharah/barrage.opy]: get barrage ammo":
    @Event eachPlayer
    @Condition eventPlayer.pharah_ammo != eventPlayer.getAmmo(0)
    @Condition not eventPlayer.isUsingUltimate()
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    eventPlayer.pharah_ammo = eventPlayer.getAmmo(0)
        
rule "[pharah/barrage.opy]: set barrage ammo":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.isUsingUltimate()
    
    eventPlayer.setAmmo(0, eventPlayer.pharah_ammo)