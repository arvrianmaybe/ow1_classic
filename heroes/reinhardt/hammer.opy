#!mainFile "../../dev_main.opy"

rule "[reinhardt/hammer.opy]: Correct Hammer damage":
    @Event playerDealtDamage
    @Hero reinhardt
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(
        victim, 
        attacker, 
        ((REINHARDT_HAMMER_DAMAGE/OW2_REINHARDT_HAMMER_DAMAGE) \
        * (eventDamage/eventPlayer._base_damage_scalar) \
        - eventDamage)/eventPlayer._base_damage_scalar)

rule "[reinhardt/hammer.opy]: Set move penalty for reinhardt":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isFiringPrimaryFire()

    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar*(1-REINHARDT_HAMMER_MOVE_PENALTY))
    waitUntil((not eventPlayer.isFiringPrimaryFire()), Math.INFINITY)
    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar/(1-REINHARDT_HAMMER_MOVE_PENALTY))
