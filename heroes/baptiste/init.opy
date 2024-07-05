#!mainFile "../../dev_main.opy"

#!include "heroes/baptiste/regen_burst.opy"

rule "[baptiste/init.opy]: Initialize Baptiste":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer._call_init

    setCustomHp(BAPTISTE_HEALTH, 0, 0)
    setUltCost(BAPTISTE_ULT_COST)

    setBaseDamage(eventPlayer, BAPTISTE_PRIMARY_DAMAGE/OW2_BAPTISTE_PRIMARY_DAMAGE)

    eventPlayer.setAmmo(0, BAPTISTE_CLIP1_SIZE)
    eventPlayer.setMaxAmmo(0, BAPTISTE_CLIP1_SIZE)

    eventPlayer.setAmmo(1, BAPTISTE_CLIP2_SIZE)
    eventPlayer.setMaxAmmo(1, BAPTISTE_CLIP2_SIZE)

    removeSelfHealing()

    eventPlayer._call_init = false
