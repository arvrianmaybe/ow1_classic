#!mainFile "../../dev_main.opy"    

rule "[mauga/init.opy]: Initialize Mauga":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer._call_init

    setCustomHp(MAUGA_HEALTH, 0, 0)
    setUltCost(MAUGA_ULT_COST)

    removeTankPassive()
    removePassiveHealing()
    eventPlayer._call_init = false
