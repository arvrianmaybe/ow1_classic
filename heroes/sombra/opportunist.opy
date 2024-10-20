#!mainFile "../../dev_main.opy"

# rule "[sombra/opportunist.opy]: Detect opportunist damage":
    # @Event playerDealtDamage
    # @Hero sombra
    # @Condition victim.hasStatusEffect(Status.HACKED)
    # @Condition eventAbility != Button.ULTIMATE
    # @Condition (eventAbility == Button.PRIMARY_FIRE or eventAbility == Button.MELEE or eventAbility == Button.ABILITY_1)
    
    # damage(victim, attacker, eventDamage * SOMBRA_OPPORTUNIST_DAMAGE)
