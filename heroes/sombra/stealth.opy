#!mainFile "../../dev_main.opy"

playervar stealth_pvar
#!defineMember _is_using_stealth stealth_pvar [0]
#!defineMember _stealth_hud_id stealth_pvar [1]
#!defineMember _stealth_hud_progress_id stealth_pvar [3]

playervar stealth_timer

subroutine enterStealth
subroutine exitStealth
subroutine showStealthHud


rule "[sombra/stealth.opy]: Remove Stealth passive":
    @Event eachPlayer
    @Hero sombra
    @Condition not eventPlayer._is_using_stealth
    @Condition not eventPlayer.isFiringPrimaryFire()
    @Condition not eventPlayer.isFiringSecondaryFire()
    @Condition not eventPlayer.isMeleeing()

    do:
        damage(eventPlayer, null, MIN_DAMAGE)
        wait(cosDeg(1), Wait.ABORT_WHEN_FALSE) # some irrational value
        # explanation: since stealth passive activates every 3.5 seconds
        # damage must be applied in a way that never synchronizes with passive stealth activation
    while RULE_CONDITION:


rule "[sombra/stealth.opy]: Bind Ability 1 to stealth":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0
    @Condition not eventPlayer._is_using_stealth

    enterStealth()


def enterStealth():
    @Name "[sombra/stealth.opy]: enterStealth()"

    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setSecondaryFireEnabled(false) # Disable hacking during invis
    wait(SOMBRA_STEALTH_CAST_TIME)
    showStealthHud()
    eventPlayer.setInvisibility(Invis.ENEMIES)
    eventPlayer.setMoveSpeed(percent(SOMBRA_STEALTH_MOVEMENT_BONUS))
    eventPlayer._is_using_stealth = true
    damage(eventPlayer, null, 0.01)
    heal(eventPlayer, null, 0.01)
    wait(OW2_SOMBRA_STEALTH_COOLDOWN)
    eventPlayer.setInvisibility(Invis.NONE)
    eventPlayer.setMoveSpeed(percent(SOMBRA_STEALTH_MOVEMENT_BONUS/OW2_SOMBRA_STEALTH_MOVEMENT_BONUS))
    exitStealth()


rule "[sombra/stealth.opy]: Exit Stealth when shooting":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer._is_using_stealth
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) \
            or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) \
            or eventPlayer.isHoldingButton(Button.MELEE) \
            or eventPlayer.isHoldingButton(Button.ABILITY_1) \
            or eventPlayer.isHoldingButton(Button.ULTIMATE)

    exitStealth()
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, SOMBRA_STEALTH_COOLDOWN)


rule "[sombra/stealth.opy]: Exit Stealth when taking damage":
    @Event playerTookDamage
    @Hero sombra
    @Condition eventPlayer._is_using_stealth

    exitStealth()
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, SOMBRA_STEALTH_COOLDOWN)


def exitStealth():
    @Name "[sombra/stealth.opy]: exitStealth()"

    destroyEffect(eventPlayer._stealth_hud_id)
    eventPlayer._stealth_hud_id = null
    
    destroyProgressBarInWorldText(eventPlayer._stealth_hud_progress_id)
    eventPlayer._stealth_hud_progress_id = null

    stopChasingVariable(eventPlayer.stealth_timer)

    damage(eventPlayer, null, 0.01)
    heal(eventPlayer, null, 0.01)
    eventPlayer.setSecondaryFireEnabled(true) # Enable hacking after exiting invis
    eventPlayer.setInvisibility(Invis.NONE)
    eventPlayer.setMoveSpeed(100)
    wait(SOMBRA_STEALTH_RECOVERY_TIME)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, SOMBRA_STEALTH_COOLDOWN)
    eventPlayer._is_using_stealth = false


def showStealthHud():
    @Name "[sombra/stealth.opy]: showStealthHud()"

    eventPlayer.stealth_timer =+ 100
    chase(eventPlayer.stealth_timer, 0, rate=30, ChaseReeval.DESTINATION_AND_RATE)

    
    if eventPlayer._stealth_hud_id == null:
        createEffect(eventPlayer, Effect.SPHERE, rgb(100, 68, 179), eventPlayer, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer._stealth_hud_id = getLastCreatedEntity()

    if eventPlayer._stealth_hud_progress_id == null:
        createProgressBarInWorldText(eventPlayer, eventPlayer.stealth_timer, "INVISIBLE", 
            updateEveryTick(eventPlayer.getEyePosition() + ((angleToDirection(eventPlayer.getHorizontalFacingAngle(), eventPlayer.getVerticalFacingAngle() + -18)) * 50)), 
            1, 
            Clip.NONE, 
            Color.PURPLE, 
            Color.WHITE, 
            ProgressWorldTextReeval.VISIBILITY_POSITION_VALUES_AND_COLOR, 
            SpecVisibility.DEFAULT)
    eventPlayer._stealth_hud_progress_id = getLastCreatedText()