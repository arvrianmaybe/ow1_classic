#!mainFile "../../dev_main.opy"

#!include "heroes/torbjorn/scrap.opy"
#!include "heroes/torbjorn/turret.opy"
#!include "heroes/torbjorn/rivet.opy"
#!include "heroes/torbjorn/overload.opy"

rule "[torbjorn/init.opy]: Initialize Torbjorn":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer._call_init

    setCustomHp(TORBJORN_HEALTH, 0, 0)
    setUltCost(TORBJORN_ULT_COST)
    removeSelfHealing()

    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.INTERACT)
    eventPlayer.disallowButton(Button.ULTIMATE)

    progressBarHud(eventPlayer, eventPlayer._scrap_allowance / TORBJORN_SCRAP_MAX * 100, "Scrap {0}".
        format(eventPlayer._scrap_allowance), 
        HudPosition.TOP, 
        1, 
        Color.YELLOW, 
        Color.WHITE, 
        ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR, 
        SpecVisibility.DEFAULT)
    eventPlayer._scrap_hud = getLastCreatedText()

    createProgressBarInWorldText([player for player in getPlayersOnHero(Hero.TORBJORN, Team.ALL) if player.turret_position != vect(0, -500, 0)], localPlayer.turret_progress, "{0}".format(localPlayer.turret_level), updateEveryTick(localPlayer.getEyePosition() + (100 * (2 * worldVector(Vector.LEFT, localPlayer, Transform.ROTATION) + (-1.5 * (angleToDirection(horizontalAngleOfDirection(localPlayer.getFacingDirection()), verticalAngleOfDirection(localPlayer.getFacingDirection()) - 90))) + 3 * localPlayer.getFacingDirection()))), 1, Clip.NONE, Color.WHITE, Color.WHITE, ProgressWorldTextReeval.VISIBILITY_POSITION_VALUES_AND_COLOR, SpecVisibility.DEFAULT)

    eventPlayer.turret_level = 1

    eventPlayer._call_init = false


rule "[torbjorn/init.opy]: Clean up Torbjorn":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.TORBJORN

    waitUntil(eventPlayer.getCurrentHero() != Hero.TORBJORN, Math.INFINITY)
    destroyProgressBarHud(eventPlayer._scrap_hud)

rule "[torbjorn/init.opy]: OW1 Torbjorn fire rate":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.getCurrentWeapon() == 2
    @Condition eventPlayer.isFiringPrimaryFire()
    @Condition not eventPlayer.isUsingAbility2()

    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    wait(TORBJORN_HAMMER_RECOVERY_TIME)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)

rule "[torbjorn/init.opy]: OW1 Torbjorn fire rate melee":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.getCurrentWeapon() == 2
    @Condition eventPlayer.isHoldingButton(Button.MELEE) # For some reason it wont let me do isMeleeing()
    @Condition not eventPlayer.isUsingAbility2()

    eventPlayer.disallowButton(Button.MELEE)
    wait(TORBJORN_HAMMER_RECOVERY_TIME)
    eventPlayer.allowButton(Button.MELEE)
    if eventPlayer.isHoldingButton(Button.MELEE):
        eventPlayer.forceButtonPress(Button.MELEE)