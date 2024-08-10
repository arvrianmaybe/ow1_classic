#!mainFile "../../dev_main.opy"

rule "[lucio/sound_barrier.opy]: sound barrier reduce overhealth if on ground":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isUsingUltimate()
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) > eventPlayer._hp_health + LUCIO_SOUND_BARRIER_OVERHEALTH

    wait()
    waitUntil(eventPlayer.isOnGround(), Math.INFINITY)
    damage(getPlayersInRadius(eventPlayer.getPosition(), LUCIO_SOUND_BARRIER_AREA_OF_EFFECT, eventPlayer.getTeam(), LosCheck.SURFACES_AND_ENEMY_BARRIERS), null, OW2_LUCIO_SOUND_BARRIER_OVERHEALTH - LUCIO_SOUND_BARRIER_OVERHEALTH)
