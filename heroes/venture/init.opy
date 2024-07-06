#!mainFile "../../dev_main.opy"

rule "[venture/init.opy]: Initialize Venture":
    @Event eachPlayer
    @Hero venture
    @Condition eventPlayer._call_init
    setCustomHp(VENTURE_HEALTH, 0, 0)
    setUltCost(VENTURE_ULT_COST)
    removeTankPassive()
    removeSelfHealing()

    eventPlayer._call_init = false