#!mainFile "../../dev_main.opy"

#!include "heroes/symmetra/shield.opy"
#!include "heroes/symmetra/beam.opy"
#!include "heroes/symmetra/orb.opy"
#!include "heroes/symmetra/teleporter.opy"

/*
This Support Symettra workshop script is heavily based on
https://workshop.codes/AMSG8    code: AMSG8
created by wadetata#0315
*/

rule "[symmetra/init.opy]: Initialize Symmetra":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer._call_init

    setCustomHp(SYMMETRA_HEALTH, 0, SYMMETRA_SHIELDS)
    setUltCost(SYMMETRA_ULT_COST)
    removeSelfHealing()

    shield_gen = []
    radius = true


    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ULTIMATE)

    createBeam(getPlayersOnHero(Hero.SYMMETRA, Team.ALL).beam_visibility, Beam.GOOD, updateEveryTick(eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() + worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) * 0.28 + normalize(crossProduct(eventPlayer.getFacingDirection(), worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION))) * 0.19), (((sorted([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if player.hasSpawned() and eventPlayer.isInViewAngle(player.getEyePosition(), 60)], lambda i: distance(eventPlayer.getEyePosition(), i.getEyePosition())))[0]).getEyePosition()) + vect(0, -0.3, 0) if entityExists((sorted([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if eventPlayer.hasSpawned() and isInLoS(eventPlayer.getEyePosition(), player.getEyePosition(), BarrierLos.PASS_THROUGH_BARRIERS) and eventPlayer.isInViewAngle(player.getEyePosition(), 60) and distance(eventPlayer.getEyePosition(), player.getEyePosition()) < 5], lambda i: distance(eventPlayer.getEyePosition(), i.getEyePosition())))[0]) else updateEveryTick(raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + 3 * eventPlayer.getFacingDirection(), null, null, false).getHitPosition()), eventPlayer.getTeam(), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.beam_effect = getLastCreatedEntity()
    createEffect(getPlayersOnHero(Hero.SYMMETRA, Team.ALL).beam_visibility, Effect.ENERGY_SOUND, eventPlayer.getTeam(), updateEveryTick(eventPlayer.getEyePosition()), 100, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.beam_effect1 = getLastCreatedEntity()
    eventPlayer.beam_multiplier_dmg = 1

    createInWorldText(getPlayersOnHero(Hero.SYMMETRA, Team.ALL) if localPlayer.isAlive() else [], 
        "[{0}]".format(floor(localPlayer.beam_multiplier_dmg)), 
        updateEveryTick(localPlayer.getEyePosition() + (150 * (1.3 * worldVector(Vector.RIGHT, 
        localPlayer, 
        Transform.ROTATION) + (-0.5 * (angleToDirection(horizontalAngleOfDirection(localPlayer.getFacingDirection()), 
        verticalAngleOfDirection(localPlayer.getFacingDirection()) - 90))) + 3 * localPlayer.getFacingDirection()))), 
        2, 
        Clip.NONE, 
        WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, 
        Color.WHITE, 
        SpecVisibility.DEFAULT)

    eventPlayer._call_init = false

rule "[symmetra/init.opy]: Clean up Symmetra":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.SYMMETRA

    waitUntil(eventPlayer.getCurrentHero() != Hero.SYMMETRA, Math.INFINITY)
    destroyTeleporter()

    shield_gen = []
    radius = false
