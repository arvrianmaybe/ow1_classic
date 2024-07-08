#!mainFile "../../main.opy"

#!include "heroes/mercy/guardian.opy"
#!include "heroes/mercy/resurrect.opy"

rule "[mercy/init.opy]: Initialize Mercy":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer._call_init

    setCustomHp(MERCY_HEALTH, 0, 0)
    setUltCost(MERCY_ULT_COST)
    eventPlayer.setAmmo(0, MERCY_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, MERCY_CLIP_SIZE)

    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ULTIMATE)

    eventPlayer.is_using_guardian_angel = false
    eventPlayer.is_slingshotting = false

    eventPlayer._call_init = false

rule "[mercy/init.opy]: Clean up Mercy":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.MERCY

    waitUntil(eventPlayer.getCurrentHero() != Hero.MERCY, Math.INFINITY)
    hideMercyResHud()