#!mainFile "../../dev_main.opy"

#!include "heroes/zarya/self_bubble.opy"
#!include "heroes/zarya/ally_bubble.opy"


rule "[zarya/init.opy]: Initialize Zarya":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer._call_init
    @Condition not eventPlayer._is_exiting_wholehog # guards against initialization when exiting wholehog

    setCustomHp(ZARYA_HEALTH, 0, ZARYA_SHIELDS)
    setUltCost(ZARYA_ULT_COST)
    setBaseDamage(eventPlayer, ZARYA_CANNON_DAMAGE_MAX/OW2_ZARYA_CANNON_DAMAGE_MAX)
    removeSelfHealing()
    removeTankPassive()

    initSelfBubble()
    initAllyBubble()
    eventPlayer._call_init = false


rule "[zarya/init.opy]: Clean up Zarya":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.ZARYA

    waitUntil(eventPlayer.getCurrentHero() != Hero.ZARYA, Math.INFINITY)
    hideSelfBubbleCD()
    hideAllyBubbleCD()


rule "[zarya/init.opy]: Compensate zarya global damage reduction":
    @Event playerDealtDamage
    @Hero zarya
    @Condition eventAbility in [Button.SECONDARY_FIRE, Button.ULTIMATE]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)


