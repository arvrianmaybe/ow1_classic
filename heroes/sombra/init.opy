#!mainFile "../../dev_main.opy"

#!include "heroes/sombra/emp.opy"
#!include "heroes/sombra/hack.opy"
#!include "heroes/sombra/stealth.opy"
#!include "heroes/sombra/translocator.opy"
#!include "heroes/sombra/opportunist.opy"

rule "[sombra/init.opy]: Initialize Sombra":
    @Event eachPlayer
    @Hero sombra

    setCustomHp(SOMBRA_HEALTH, 0, 0)
    setUltCost(SOMBRA_ULT_COST)

    getPlayers(eventPlayer.getTeam()).friendly_sombra_player = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).enemy_sombra_player = eventPlayer
    
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)

    eventPlayer._is_using_stealth = false
    # removeSelfHealing()

    eventPlayer._call_init = false


rule "[sombra/init.opy]: Clean up Sombra":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.SOMBRA

    waitUntil(eventPlayer.getCurrentHero() != Hero.SOMBRA, Math.INFINITY)
    exitStealth()
    destroyTranslocator()
#!mainFile "../../dev_main.opy"

#!include "heroes/sombra/emp.opy"
#!include "heroes/sombra/hack.opy"
#!include "heroes/sombra/stealth.opy"
#!include "heroes/sombra/translocator.opy"
#!include "heroes/sombra/opportunist.opy"

rule "[sombra/init.opy]: Initialize Sombra":
    @Event eachPlayer
    @Hero sombra

    setCustomHp(SOMBRA_HEALTH, 0, 0)
    setUltCost(SOMBRA_ULT_COST)

    getPlayers(eventPlayer.getTeam()).friendly_sombra_player = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).enemy_sombra_player = eventPlayer
    
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)

    eventPlayer._is_using_stealth = false
    # removeSelfHealing()

    eventPlayer._call_init = false


rule "[sombra/init.opy]: Clean up Sombra":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.SOMBRA

    waitUntil(eventPlayer.getCurrentHero() != Hero.SOMBRA, Math.INFINITY)
    exitStealth()
    destroyTranslocator()

rule"[sombra/init.opy]: Hard code disallow sombra":
    @Event eachPlayer
    @Hero sombra
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingAbility2())
    
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
