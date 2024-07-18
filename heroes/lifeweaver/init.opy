#!mainFile "../../dev_main.opy"

#!include "heroes/lifeweaver/dash.opy"
#!include "heroes/lifeweaver/tree.opy"
#!include "heroes/lifeweaver/parting_gift.opy"

rule "[lifeweaver/init.opy]: Initialize Lifeweaver":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer._call_init

    setCustomHp(LIFEWEAVER_HEALTH, 0, 0)
    setUltCost(LIFEWEAVER_ULT_COST)
    removePassiveHealing() # Still automatically self heals
    eventPlayer._call_init = false