#!mainFile "../../dev_main.opy"

rule "[soldier/pulse_rifle.opy]: Deal OW1 soldier primary fire damage":
    @Event playerDealtDamage
    @Hero soldier
    @Condition eventAbility == Button.PRIMARY_FIRE

    heal(victim,null, eventDamage)
    # damage(victim, attacker, eventDamage*(SOLDIER_HEAVY_PULSE_RIFLE_DAMAGE/OW2_SOLDIER_HEAVY_PULSE_RIFLE_DAMAGE)-eventDamage)

rule "[solder/pulse_rifle.opy]: Set critical hit damage":
    @Event playerDealtDamage
    @Hero soldier
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventWasCriticalHit

    heal(victim,null, eventDamage)
    damage(victim, eventPlayer, SOLDIER_HEAVY_PULSE_RIFLE_DAMAGE_CRITICAL_HJT)


rule "[soldier/pulse_rifle.opy]: Set pulse rifle projectile":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isFiringPrimaryFire()
    
    wait()
    if not RULE_CONDITION:
        return
    createProjectile(Projectile.ORB, eventPlayer, raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + ((directionTowards(eventPlayer.getEyePosition(), 
        eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 5 + Vector.UP * random.uniform(-0.1, 0.1) + Vector.RIGHT * random.uniform(-0.1, 0.1))) * 100), 
        getPlayers(getOppositeTeam(eventPlayer.getTeam())), null, true).getHitPosition() - eventPlayer.getFacingDirection(), 
        null, 
        Relativity.TO_WORLD, 
        ModifyHealth.DAMAGE, 
        getOppositeTeam(eventPlayer.getTeam()), 
        SOLDIER_HEAVY_PULSE_RIFLE_DAMAGE, 
        2, 
        0, 
        DynamicEffect.BAD_EXPLOSION, 
        DynamicEffect.EXPLOSION_SOUND, 
        0, Math.INFINITY, 
        5, 
        0, 
        0, 
        0)
    wait()
    if RULE_CONDITION:
        goto RULE_START