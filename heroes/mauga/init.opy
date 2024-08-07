#!mainFile "../../dev_main.opy"    

rule "[mauga/init.opy]: Initialize Mauga":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer._call_init

    setCustomHp(MAUGA_HEALTH, MAUGA_ARMOR, 0)
    setUltCost(MAUGA_ULT_COST)

    removeTankPassive()
    removePassiveHealing()

    eventPlayer.setHealingDealt(percent(MAUGA_CARDIAC_OVERDRIVE_HEALING/OW2_MAUGA_CARDIAC_OVERDRIVE_HEALING))
    eventPlayer._call_init = false
