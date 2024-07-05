#!mainFile "../../dev_main.opy"

#!include "heroes/reinhardt/hammer.opy"
#!include "heroes/reinhardt/firestrike.opy"
#!include "heroes/reinhardt/charge.opy"
#!include "heroes/reinhardt/shatter.opy"
#!include "heroes/reinhardt/barrier.opy"

rule "[reinhardt/init.opy]: Initialize Reinhardt":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer._call_init

    setCustomHp(REINHARDT_HEALTH, REINHARDT_ARMOR, 0)
    setUltCost(REINHARDT_ULT_COST)
    setBaseDamage(eventPlayer, REINHARDT_FIRESTRIKE_DAMAGE/OW2_REINHARDT_FIRESTRIKE_DAMAGE)

    removeSelfHealing()
    removeTankPassive() # No steadfast passive at launch
    eventPlayer._call_init = false
