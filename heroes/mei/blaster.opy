#!mainFile "../../dev_main.opy"

playervar freeze_progress
playervar freeze_slow_linger_time
playervar freeze_move_penalty

subroutine clearFreezeEffect

rule "[mei/blaster.opy]: 15 icicle ammo consumption.":
    @Event eachPlayer
    @Hero mei
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    waitUntil(not eventPlayer.isFiringSecondaryFire(), Math.INFINITY)
    eventPlayer.setAmmo(0, max(0, eventPlayer.getAmmo(0) + OW2_MEI_ICICLE_AMMO_CONSUMPTION))
    eventPlayer.setAmmo(0, max(0, eventPlayer.getAmmo(0) - MEI_ICICLE_AMMO_CONSUMPTION))


rule "[mei/blaster.opy]: Track freezing on enemy":
    @Event playerDealtDamage
    @Hero mei
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition victim.freeze_progress < 100

    stopChasingVariable(victim.freeze_slow_linger_time)

    if victim.freeze_progress == 0: # victims started taking freeze damage
        victim.freeze_progress = MEI_MINIMUM_FREEZE
    else:
        victim.freeze_progress += MEI_FREEZE_PERCENT_PER_TICK # 2.85% each tick from wiki

    victim.freeze_move_penalty = victim.freeze_progress if victim.freeze_progress < MEI_FREEZE_MAX_SLOW else MEI_FREEZE_MAX_SLOW
    # victim.setMoveSpeed(100-victim.freeze_move_penalty)
    
    victim.freeze_slow_linger_time = 0
    chase(victim.freeze_slow_linger_time, MEI_FREEZE_SLOW_LINGER_DURATION, rate=1, ChaseReeval.NONE)


rule "[mei/blaster.opy]: Freeze enemy":
    @Event playerTookDamage
    @Hero all
    @Condition victim.freeze_progress >= 100

    victim.setStatusEffect(eventPlayer, Status.FROZEN, 1*MEI_FREEZE_DURATION) # 1x feels too short for some reason
    waitUntil(not victim.hasStatusEffect(Status.FROZEN), Math.INFINITY)
    clearFreezeEffect()
    

rule "[mei/blaster.opy]: clear freeze after exceeding linger time":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.freeze_slow_linger_time >= MEI_FREEZE_SLOW_LINGER_DURATION

    clearFreezeEffect()


def clearFreezeEffect():
    @Name "[mei/blaster.opy]: clearFreezeEffect()"
    
    stopChasingVariable(eventPlayer.freeze_slow_linger_time)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.freeze_progress = 0


rule "[mei/blaster.opy]: OW1 blaster damage":
    @Event playerDealtDamage
    @Hero mei
    @Condition eventAbility == Button.PRIMARY_FIRE

    heal(victim, null, eventDamage - (eventDamage/eventPlayer._base_damage_scalar) * (MEI_BLASTER_DAMAGE_RATE/OW2_MEI_BLASTER_DAMAGE_RATE))
