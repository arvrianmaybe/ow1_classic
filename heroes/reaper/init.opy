#!mainFile "../../dev_main.opy"

#!include "heroes/reaper/reaping.opy"
#!include "heroes/reaper/wraith.opy"

rule "[reaper/init.opy]: Initialize Reaper":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer._call_init

    setCustomHp(REAPER_HEALTH, 0, 0)
    setUltCost(REAPER_ULT_COST)
    removeSelfHealing()

    eventPlayer._call_init = false