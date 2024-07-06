#!mainFile "../../dev_main.opy"

#!include "heroes/lifeweaver/dash.opy"
#!include "heroes/lifeweaver/tree.opy"
#!include "heroes/lifeweaver/parting_gift.opy"

rule "[lifeweaver/init.opy]: Initialize Lifeweaver":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer._call_init

    setCustomHp(LIFEWEAVER_HEALTH, 0, LIFEWEAVER_SHIELD_HP)
    setUltCost(LIFEWEAVER_ULT_COST)
    removeSelfHealing()
    eventPlayer._call_init = false