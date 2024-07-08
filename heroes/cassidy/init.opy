#!mainFile "../../dev_main.opy"

#!include "heroes/cassidy/fan_hammer.opy"
#!include "heroes/cassidy/flashbang.opy"
#!include "heroes/cassidy/roll.opy"
#!include "heroes/cassidy/deadeye.opy"

rule "[cassidy/init.opy]: Initialize Cassidy":
    @Event eachPlayer
    @Hero cassidy
    @Condition eventPlayer._call_init

    setCustomHp(MCCREE_HEALTH, 0, 0)
    setUltCost(MCCREE_ULT_COST)
    setUltCost(MCCREE_ULT_COST)

    removeSelfHealing()
    eventPlayer._call_init = false
