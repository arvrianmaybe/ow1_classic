#!mainFile "../../dev_main.opy"

#!include "heroes/ramattra/annahilation.opy"
    

rule "[ramattra/init.opy]: Initialize Ramattra":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer._call_init

    setCustomHp(RAMATTRA_HEALTH, RAMATTRA_ARMOR, RAMATTRA_SHIELDS)
    setUltCost(RAMATTRA_ULT_COST)

    removeTankPassive()
    removeSelfHealing()
    eventPlayer._call_init = false