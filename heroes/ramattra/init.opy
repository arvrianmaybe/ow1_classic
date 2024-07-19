#!mainFile "../../dev_main.opy"

#!include "heroes/ramattra/annahilation.opy"
    

rule "[ramattra/init.opy]: Initialize Ramattra":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer._call_init

    setCustomHp(RAMATTRA_HEALTH, RAMATTRA_ARMOR, 0)
    setUltCost(RAMATTRA_ULT_COST)

    removeTankPassive()
    removeSelfHealing()
    eventPlayer._call_init = false

rule "[ramattra/init.opy]: Clean up Ramattra":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.RAMATTRA

    waitUntil(eventPlayer.getCurrentHero() != Hero.RAMATTRA, Math.INFINITY)
    stopAnnihilation()
