#!mainFile "../../dev_main.opy"

#!include "heroes/lucio/soundwave.opy"
#!include "heroes/lucio/aura.opy"
#!include "heroes/lucio/sound_barrier.opy"

rule "[lucio/init.opy]: Initialize Lucio":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer._call_init

    
    setCustomHp(LUCIO_HEALTH, 0, 0)
    setUltCost(LUCIO_ULT_COST)
    removeSelfHealing()

    eventPlayer.cross_fade_stats = ["Speed", true, "Toggle", [], [], []]
    lbl_0:
    createEffect([player for player in getPlayers(eventPlayer.getTeam()) if eventPlayer.cross_fade_stats[1] == true], Effect.RING, Color.GREEN if eventPlayer.cross_fade_stats[0] == "Speed" else Color.YELLOW, updateEveryTick(eventPlayer.getPosition()), 30, EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR)
    eventPlayer.cross_fade_stats[7] = getLastCreatedEntity()

    createInWorldText(getPlayersOnHero(Hero.LUCIO, Team.ALL), "{0}".format(len([i for i in localPlayer.cross_fade_stats[4] if i.isAlive()].exclude(localPlayer))), updateEveryTick(localPlayer.getEyePosition() + (150 * (0 * worldVector(Vector.RIGHT, localPlayer, Transform.ROTATION) + (-0.3 * (angleToDirection(horizontalAngleOfDirection(localPlayer.getFacingDirection()), verticalAngleOfDirection(localPlayer.getFacingDirection()) - 90))) + 3 * localPlayer.getFacingDirection()))), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.WHITE, SpecVisibility.DEFAULT)

    setBaseDamage(eventPlayer, LUCIO_SOUND_GUN_DAMAGE/OW2_LUCIO_SOUND_GUN_DAMAGE)
    eventPlayer.setKnockbackDealt(percent(LUCIO_SOUNDWAVE_KNOCKBACK/OW2_LUCIO_SOUNDWAVE_KNOCKBACK))
    eventPlayer._call_init = false

rule "[lucio/init.opy]: Clean up Lucio":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.LUCIO

    waitUntil(eventPlayer.getCurrentHero() != Hero.LUCIO, Math.INFINITY)

    destroyEffect(eventPlayer.cross_fade_stats[7])