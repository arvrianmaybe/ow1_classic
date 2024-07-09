#!mainFile "../../dev_main.opy"

rule "[kiriko/suzu.opy]: Cleanse out hard stun effects":
    @Event eachPlayer
    @Condition eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN)

    eventPlayer.clearStatusEffect(Status.KNOCKED_DOWN)
    wait(KIRIKO_KNOCKED_DOWN_DURATION)
    if eventPlayer.hasStatusEffect(Status.PHASED_OUT):
        eventPlayer.setStatusEffect(null, Status.PHASED_OUT, KIRIKO_SUZU_DURATION)
    

rule "[kiriko/suzu.opy]: Remove initial burst healing from suzu":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.setHealingDealt(0)
    waitUntil(not eventPlayer.isUsingAbility2(), Math.INFINITY)
    eventPlayer.setHealingDealt(100)


rule "[kiriko/suzu.opy]: Allow self healing during suzu":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.isUsingAbility2()

    pushSelfHealing(Button.ABILITY_2)
    wait(KIRIKO_SUZU_DURATION, Wait.RESTART_WHEN_TRUE)
    popSelfHealing(Button.ABILITY_2)


rule "[kiriko/suzu.opy]: ow2 suzu hps":
    @Event playerDealtHealing
    @Hero kiriko
    @Condition eventAbility == Button.ABILITY_2
    
    if healee == healer: # self healing
        heal(
            healee, 
            healer, 
            ((eventHealing/eventPlayer._base_healing_scalar)*(KIRIKO_SUZU_SELF_HPS/OW2_KIRIKO_SUZU_SELF_HPS) - eventHealing))
    else: # ally healing
        heal(
            healee, 
            healer, 
            ((eventHealing/eventPlayer._base_healing_scalar)*(KIRIKO_SUZU_ALLY_HPS/OW2_KIRIKO_SUZU_ALLY_HPS) - eventHealing))