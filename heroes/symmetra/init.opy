#!mainFile "../../dev_main.opy"

#!include "heroes/symmetra/shield.opy"
#!include "heroes/symmetra/beam.opy"
#!include "heroes/symmetra/orb.opy"
#!include "heroes/symmetra/teleporter.opy"

/*
This Support Symettra workshop script is heavily based on
https://workshop.codes/AMSG8    code: AMSG8
created by wadetata#0315
*/

rule "[symmetra/init.opy]: Initialize Symmetra":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer._call_init

    setCustomHp(SYMMETRA_HEALTH, 0, SYMMETRA_SHIELDS)
    setUltCost(SYMMETRA_ULT_COST)
    removeSelfHealing()

    showPhotonProjecterHUD()

    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ULTIMATE)

    eventPlayer._call_init = false

rule "[symmetra/init.opy]: Clean up Symmetra":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.SYMMETRA

    waitUntil(eventPlayer.getCurrentHero() != Hero.SYMMETRA, Math.INFINITY)
    destroyTeleporter()
    hidePhotonProjecterHUD()