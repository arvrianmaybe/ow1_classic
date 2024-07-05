#!mainFile "../../dev_main.opy"


rule "[mccree/fan_hammer.opy]: Launch Fan the Hammer damage":
    @Event playerDealtDamage
    @Hero mccree
    @Condition eventAbility == Button.SECONDARY_FIRE

    damage(victim, attacker, eventDamage*(MCCREE_FAN_THE_HAMMER_DAMAGE/OW2_MCCREE_FAN_THE_HAMMER_DAMAGE) - eventDamage)
