#!mainFile "../../dev_main.opy"

rule "[junkrat/init.opy]: Initialize Juno":
    @Event eachPlayer
    @Hero juno
    @Condition eventPlayer._call_init

    setCustomHp(JUNO_HEALTH, 0, JUNO_SHIELD_HEALTH)
    setUltCost(JUNO_ULT_COST)
    removeSelfHealing()

    eventPlayer.setMaxAmmo(0, 150)
    eventPlayer.setAmmo(0, 150)
    
    setBaseDamage(eventPlayer, 0.9)
    setBaseHealing(eventPlayer, 0.85)

    eventPlayer._call_init = false
