#!mainFile "../../dev_main.opy"

rule "[genji/init.opy]: Initialize Genji":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer._call_init

    setCustomHp(GENJI_HEALTH, 0, 0)
    setUltCost(GENJI_ULT_COST)

    eventPlayer.setAmmo(0, GENJI_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, GENJI_CLIP_SIZE)

    removeSelfHealing()
    eventPlayer._call_init = false

rule "[genji/init.opy]: Deal OW1 shuriken damage":
    @Event playerDealtDamage
    @Hero genji
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]

    damage(victim, attacker, eventDamage*(GENJI_SHURIKEN_DAMAGE/OW2_GENJI_SHURIKEN_DAMAGE)-eventDamage)