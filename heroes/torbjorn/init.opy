#!mainFile "../../dev_main.opy"

##!include "heroes/torbjorn/scrap.opy"
##!include "heroes/torbjorn/turret.opy"
#!include "heroes/torbjorn/rivet.opy"

rule "[torbjorn/init.opy]: Initialize Torbjorn":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer._call_init

    setCustomHp(TORBJORN_HEALTH, TORBJORN_ARMOR, 0)
    setUltCost(TORBJORN_ULT_COST)
    removeSelfHealing()

    eventPlayer._call_init = false