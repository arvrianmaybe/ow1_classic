#!mainFile "../../dev_main.opy"

rule "[doomfist/cannon.opy]: Deal launch hand cannon damage":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, eventDamage*(DOOMFIST_HAND_CANNON_DAMAGE/OW2_DOOMFIST_HAND_CANNON_DAMAGE)-eventDamage) # Deal additional damage to match OW1 damage