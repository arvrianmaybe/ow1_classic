#!mainFile "../../dev_main.opy"

#!include "heroes/symmetra/shield.opy"
#!include "heroes/symmetra/beam.opy"
#!include "heroes/symmetra/orb.opy"

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

    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.disallowButton(Button.ABILITY_2)
    # eventPlayer.disallowButton(Button.ULTIMATE) No teleporter cause it completly breaks everything for no reason. (it wont compile.)

    createBeam(eventPlayer.beam_visibility, Beam.GOOD, updateEveryTick(eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() + worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) * 0.28 + normalize(crossProduct(eventPlayer.getFacingDirection(), worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION))) * 0.19), (((sorted([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if player.hasSpawned() and eventPlayer.isInViewAngle(player.getEyePosition(), 60)], lambda i: distance(eventPlayer.getEyePosition(), i.getEyePosition())))[0]).getEyePosition()) + vect(0, -0.3, 0) if entityExists((sorted([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if eventPlayer.hasSpawned() and isInLoS(eventPlayer.getEyePosition(), player.getEyePosition(), BarrierLos.PASS_THROUGH_BARRIERS) and eventPlayer.isInViewAngle(player.getEyePosition(), 60) and distance(eventPlayer.getEyePosition(), player.getEyePosition()) < 5], lambda i: distance(eventPlayer.getEyePosition(), i.getEyePosition())))[0]) else updateEveryTick(raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + 3 * eventPlayer.getFacingDirection(), null, null, false).getHitPosition()), eventPlayer.getTeam(), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.beam_effect = getLastCreatedEntity()
    createEffect(eventPlayer.beam_visibility, Effect.ENERGY_SOUND, eventPlayer.getTeam(), updateEveryTick(eventPlayer.getEyePosition()), 100, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.beam_effect1 = getLastCreatedEntity()
    eventPlayer.beam_multiplier_dmg = 1

    eventPlayer._call_init = false
