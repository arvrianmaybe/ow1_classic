#!mainFile "../../dev_main.opy"


rule "[cassidy/fan_hammer.opy]: Launch Fan the Hammer damage":
    @Event playerDealtDamage
    @Hero cassidy
    @Condition eventAbility == Button.SECONDARY_FIRE

    damage(victim, attacker, eventDamage*(CASSIDY_FAN_THE_HAMMER_DAMAGE/OW2_CASSIDY_FAN_THE_HAMMER_DAMAGE) - eventDamage)
