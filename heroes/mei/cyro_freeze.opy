#!mainFile "../../dev_main.opy"


rule "[mei/cryo_freeze.opy]: OW1 Cryo-Freeze healing":
    @Event playerDealtHealing
    @Hero mei
    @Condition eventAbility == Button.ABILITY_1
    
    if healee == healer:
        heal(
            healee, 
            healer, 
            ((eventHealing/eventPlayer._base_healing_scalar)*(MEI_CRYO_HEALING/OW2_MEI_CRYO_HEALING) - eventHealing))

rule "[mei/cryo_freeze.opy]: Allow self healing during Cryo-Freeze":
    @Event eachPlayer
    @Hero mei
    @Condition eventPlayer.isUsingAbility1()

    pushSelfHealing(Button.ABILITY_1)
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    popSelfHealing(Button.ABILITY_1)
