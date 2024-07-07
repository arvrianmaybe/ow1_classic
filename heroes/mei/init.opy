#!mainFile "../../dev_main.opy"

#!include "heroes/mei/blaster.opy"
#!include "heroes/mei/cyro_freeze.opy"

rule "[mei/init.opy]: Initialize Mei":
    @Event eachPlayer
    @Hero mei
    @Condition eventPlayer._call_init

    setCustomHp(MEI_HEALTH, 0, 0)
    setUltCost(MEI_ULT_COST)

    setBaseDamage(eventPlayer, MEI_ICICLE_DAMAGE/OW2_MEI_ICICLE_DAMAGE)

    eventPlayer.setAmmo(0, MEI_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, MEI_CLIP_SIZE)

    removeSelfHealing()
    eventPlayer._call_init = false