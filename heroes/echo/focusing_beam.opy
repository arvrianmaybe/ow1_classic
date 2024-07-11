#!mainFile "../../dev_main.opy"


rule "[echo/focusing_beam.opy]: Deal OW1 echo focusing beam under 50% hp":
    @Event playerDealtDamage
    @Hero echo
    @Condition eventPlayer.isUsingAbility2()
    @Condition percent(victim.getHealth()/victim.getMaxHealth()) < ECHO_FOCUSING_BEAM_TRESHOLD 

    damage(victim, attacker, eventDamage*(ECHO_FOCUSING_BEAM_DMG/OW2_ECHO_FOCUSING_BEAM_DMG)-eventDamage)
