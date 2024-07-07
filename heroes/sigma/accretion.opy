#!mainFile "../../dev_main.opy"

rule "[sigma/accretion.opy]: set sigma stun":
    @Event playerDealtDamage
    @Hero sigma
    @Condition eventAbility == Button.ABILITY_2
    
    if victim.hasStatusEffect(Status.KNOCKED_DOWN) == true:
        victim.setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, abs(distance(victim, eventPlayer)) * 0.25)