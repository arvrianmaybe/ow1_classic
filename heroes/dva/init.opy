#!mainFile "../../dev_main.opy"

#!include "heroes/dva/hp.opy"
#!include "heroes/dva/gun.opy"
#!include "heroes/dva/booster.opy"
#!include "heroes/dva/bomb.opy"
#!include "heroes/dva/matrix.opy"
#!include "heroes/dva/micro_missiles.opy"
#!include "heroes/dva/remech.opy"

rule "[dva/init.opy]: Initialize DVa":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer._call_init

    eventPlayer.setAbility2Enabled(false)

    setUltCost(DVA_ULT_COST)
    removeTankPassive()
    removeSelfHealing()
    eventPlayer._call_init = false