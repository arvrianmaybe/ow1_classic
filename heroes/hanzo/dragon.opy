#!mainFile "../../dev_main.opy"

rule"[hanzo/dragon.opy]: Set dragon speed":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.setProjectileSpeed(222.8) # arbitrarily decided based on trial and error
    waitUntil(eventPlayer.isUsingUltimate(), 1)
    eventPlayer.setProjectileSpeed(100)