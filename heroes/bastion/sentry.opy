#!mainFile "../../dev_main.opy"

#!defineMember bastionCastTime() \
if eventPlayer.isUsingAbility1(): \
    eventPlayer.disallowButton(Button.ABILITY_1) \
    eventPlayer.setPrimaryFireEnabled(false) \
    wait(BASTION_SENTRY_CAST_TIME) \
    eventPlayer.allowButton(Button.ABILITY_1) \
    eventPlayer.setPrimaryFireEnabled(true) \
    startFiring()

#!defineMember stopFiring() \
if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE): \
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)


rule "[bastion/sentry.opy]: Initialize sentry mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isInAlternateForm()
    @Condition eventPlayer.current_configuration == Configuration.RECON # Sentry mode can only be entered from recon mode
    @Condition eventPlayer.current_configuration != Configuration.TANK # prevents incorrectly identifying tank as sentry
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.current_configuration = Configuration.SENTRY

    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)

    eventPlayer.setDamageReceived(percent(BASTION_ICONCLAD_DAMAGE_REDUCTION/OW2_BASTION_ICONCLAD_DAMAGE_REDUCTION))
    setBaseDamage(eventPlayer, BASTION_SENTRY_CONFIG_DAMAGE/OW2_BASTION_ASSAULT_CONFIG_DAMAGE)
    eventPlayer.setStatusEffect(null, Status.ROOTED, Math.INFINITY)
    eventPlayer.setKnockbackReceived(0)
    
    wait(BASTION_SENTRY_CAST_TIME)
    bastionCastTime()

    waitUntil(eventPlayer.isOnGround(), Math.INFINITY)
    if eventPlayer.current_configuration == Configuration.SENTRY:
        eventPlayer.setMoveSpeed(0)


rule "[bastion/sentry.opy]: Extend sentry mode": # thanks to Wadetata for this wonderful piece of code that Ciach795 rewrote to OverPy: https://workshop.codes/AMSG8
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY
    @Condition eventPlayer.current_configuration != Configuration.TANK
    @Condition eventPlayer.isUsingAbility1()

    do:
        wait(1, Wait.IGNORE_CONDITION)
        waitUntil(not eventPlayer.isUsingAbility1(), 4.984) # 6 second total time - 1 second - 1 tick
        waitUntil(eventPlayer.isHoldingButton(Button.ABILITY_1) or not eventPlayer.isUsingAbility1(), 1)
        if eventPlayer.isUsingAbility1() and not eventPlayer.isHoldingButton(Button.ABILITY_1):
            wait(TICK_DURATION, Wait.IGNORE_CONDITION)
            eventPlayer.cancelPrimaryAction()
            eventPlayer.forceButtonPress(Button.ABILITY_1)
            eventPlayer.setKnockbackReceived(0)
            eventPlayer.setStatusEffect(null, Status.ROOTED, Math.INFINITY)
            waitUntil(eventPlayer.isOnGround(), Math.INFINITY)
            eventPlayer.setMoveSpeed(0)
    while RULE_CONDITION

rule "[bastion/sentry.opy]: Stop using sentry if player dealt cc":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY
    @Condition eventPlayer.current_configuration != Configuration.TANK
    @Condition eventPlayer.isUsingAbility1()
    @Condition isCCd(eventPlayer)
    
    waitUntil(not isCCd(eventPlayer), Math.INFINITY)
    eventPlayer.forceButtonPress(Button.ABILITY_1)

def startFiring():
    @Name "startFiring()" # No name include cause this for global

    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE): 
        eventPlayer.startForcingButton(Button.PRIMARY_FIRE) 
        waitUntil(not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE), Math.INFINITY) 
        eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)