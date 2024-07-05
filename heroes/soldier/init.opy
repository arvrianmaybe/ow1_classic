#!mainFile "../../dev_main.opy"

rule "[soldier/init.opy]: Initialize Soldier: 76":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer._call_init

    setCustomHp(SOLDIER_HEALTH, 0, 0)
    setUltCost(SOLDIER_ULT_COST)
    removeSelfHealing()
    eventPlayer._call_init = false
