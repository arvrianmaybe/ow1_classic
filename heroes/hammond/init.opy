#!mainFile "../../main.opy"

#!include "heroes/hammond/shields.opy"
#!include "heroes/hammond/grapple.opy"


rule "[hammond/init.opy]: Initialize Wrecking Ball":
    @Event eachPlayer
    @Hero hammond
    @Condition eventPlayer._call_init

    setCustomHp(WRECKING_BALL_HEALTH, WRECKING_BALL_ARMOR, WRECKING_BALL_SHIELDS)
    setUltCost(WRECKING_BALL_ULT_COST)
    removeTankPassive()
    removePassiveHealing()

    eventPlayer._call_init = false