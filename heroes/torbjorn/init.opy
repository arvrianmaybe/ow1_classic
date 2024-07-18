#!mainFile "../../dev_main.opy"

#!include "heroes/torbjorn/scrap.opy"
#!include "heroes/torbjorn/turret.opy"
#!include "heroes/torbjorn/rivet.opy"
#!include "heroes/torbjorn/overload.opy"

rule "[torbjorn/init.opy]: Initialize Torbjorn":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer._call_init

    setCustomHp(TORBJORN_HEALTH, 0, 0)
    setUltCost(TORBJORN_ULT_COST)
    removeSelfHealing()

    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.INTERACT)
    eventPlayer.disallowButton(Button.ULTIMATE)

    progressBarHud(eventPlayer, eventPlayer._scrap_allowance / TORBJORN_SCRAP_MAX * 100, "Scrap {0}".
        format(eventPlayer._scrap_allowance), 
        HudPosition.TOP, 
        1, 
        Color.YELLOW, 
        Color.WHITE, 
        ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR, 
        SpecVisibility.DEFAULT)
    eventPlayer._scrap_hud = getLastCreatedText()

    eventPlayer._call_init = false


rule "[torbjorn/init.opy]: Clean up Torbjorn":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.TORBJORN

    waitUntil(eventPlayer.getCurrentHero() != Hero.TORBJORN, Math.INFINITY)
    destroyProgressBarHud(eventPlayer._scrap_hud)