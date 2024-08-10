#!mainFile "../../dev_main.opy"

globalvar ULT_DURATION_WORKSHOP_SETTINGS = createWorkshopSetting(int[1:20], "Ramattra", "Annihilation duration", 4, 0)
globalvar ULT_DURATION_MAX = ULT_DURATION_WORKSHOP_SETTINGS 

playervar ult_duration 
playervar ram_progress_bar 

#!define startAnnihilation()\
eventPlayer.ult_duration = ULT_DURATION_WORKSHOP_SETTINGS \
progressBarHud(eventPlayer, eventPlayer.ult_duration * (100 / ULT_DURATION_MAX), "{}s".format(round(eventPlayer.ult_duration)), \
    HudPosition.TOP, \
    1000, \
    Color.WHITE, \
    Color.WHITE, \
    ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR, \
    SpecVisibility.NEVER) \
eventPlayer.ram_progress_bar = getLastCreatedText() \
chase(eventPlayer.ult_duration, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)
 
#!define stopAnnihilation()\
    stopChasingVariable(eventPlayer.ult_duration)\
    destroyProgressBarHud(eventPlayer.ram_progress_bar)\
    eventPlayer.ult_duration = ULT_DURATION_WORKSHOP_SETTINGS

rule "[ramattra/annihilation.opy]: start ult and chase variables":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer.isUsingUltimate()
    
    startAnnihilation()
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    stopAnnihilation()


rule "[ramattra/annihilation.opy]: dealt dmg stop chase variables":
    @Event playerDealtDamage
    @Hero ramattra
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventAbility != Button.PRIMARY_FIRE
    @Condition eventAbility != Button.ABILITY_2
    @Condition eventAbility != Button.MELEE
    @Condition eventAbility != null
    
    stopChasingVariable(eventPlayer.ult_duration)
    wait(TICK_DURATION, Wait.RESTART_WHEN_TRUE)
    chase(eventPlayer.ult_duration, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)


rule "[ramattra/annihilation.opy]: stop ult if varb hits 0":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer.ult_duration <= 0
    @Condition eventPlayer.isUsingUltimate()
    
    do:
        eventPlayer.forceButtonPress(Button.ABILITY_1)
        wait()
    while RULE_CONDITION
