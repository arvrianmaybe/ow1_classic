#!mainFile "../../dev_main.opy"

playervar breather_pvar
#!defineMember _is_using_breather breather_pvar[0]

rule "[roadhog/breather.opy]: OW1 Take a Breather":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0
    @Condition not isCCd(eventPlayer)
    @Condition not eventPlayer.isFiringPrimaryFire()
    @Condition not eventPlayer.isUsingAbility1()
    @Condition not eventPlayer.isUsingUltimate()
    @Condition not eventPlayer.isMeleeing()

    # activate ability
    eventPlayer._is_using_breather = true
    eventPlayer.setStatusEffect(null, Status.ROOTED, Math.INFINITY)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.setDamageReceived(percent((1-ROADHOG_BREATHER_DAMAGE_REDUCTION)/(1-OW2_ROADHOG_BREATHER_DAMAGE_REDUCTION))) # reduce damage intake
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    waitUntil(not eventPlayer.isFiringSecondaryFire(), Math.INFINITY)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.setDamageReceived(100) # reset damage intake
    eventPlayer.clearStatusEffect(Status.ROOTED)
    wait(ROADHOG_BREATHER_RECOVERY_TIME)
    eventPlayer._is_using_breather = false

    # cooldown
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, ROADHOG_BREATHER_COOLDOWN)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, ROADHOG_BREATHER_COOLDOWN)


rule "[roadhog/breather.opy]: Allow self healing during Breather":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer._is_using_breather

    pushSelfHealing(Button.ABILITY_2)
    waitUntil(not eventPlayer._is_using_breather, Math.INFINITY)
    popSelfHealing(Button.ABILITY_2)
