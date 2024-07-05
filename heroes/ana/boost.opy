#!mainFile "../../dev_main.opy"

playervar nano_boost_speed

rule "[ana/boost.opy]: set nano boost speed":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.nano_boost_speed = eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam())
    eventPlayer.nano_boost_speed.setMoveSpeed(percent(AMA_NANO_BOOST_SPEED_MULTIPLIER*eventPlayer._base_movement_scalar))
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.nano_boost_speed.setMoveSpeed(100)