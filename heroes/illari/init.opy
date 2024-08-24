#!mainFile "../../dev_main.opy"

rule "[illari/init.opy]: Initialize Illari":
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer._call_init

    setCustomHp(ILLARI_HEALTH, 0, 0)
    setUltCost(ILLARI_ULT_COST)

    eventPlayer.setAmmo(0, ILLARI_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, ILLARI_CLIP_SIZE)

    removeSelfHealing()
    eventPlayer._call_init = false

rule "[illari/solar_rifle.opy]:  Solar Rifle 2 multipler damage":
    @Event playerDealtDamage
    @Hero illari
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventWasCriticalHit

    damage(
        victim, 
        attacker, 
        (ILLARI_RIFLE_HEADSHOT_MULTIPLIER \
        * (ILLARI_RIFLE_DAMAGE/OW2_ILLARI_RIFLE_DAMAGE) \
        * (eventDamage/eventPlayer._base_damage_scalar/OW2_ILLARI_RIFLE_HEADSHOT_MULTIPLIER) \
        - eventDamage)/eventPlayer._base_damage_scalar)