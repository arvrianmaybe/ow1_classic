#!mainFile "../../dev_main.opy"

#!include "heroes/sigma/flux.opy"
#!include "heroes/sigma/grasp.opy"

playervar accerition_pvar
#!defineMember _accertion_distance_traveled accerition_pvar [0]
#!define accretionDistanceTraveled accerition_pvar [1]
#!define accretionKnockedDownDuration accerition_pvar [12]

rule "[sigma/init.opy]: Initialize Sigma":
    @Event eachPlayer
    @Hero sigma
    @Condition eventPlayer._call_init
    setCustomHp(SIGMA_HEALTH, 0, SIGMA_SHIELDS)
    setUltCost(SIGMA_ULT_COST)
    removeTankPassive()
    removeSelfHealing()

    eventPlayer._call_init = false


rule "[sigma/init.opy]: Change accretion damage":
    @Event playerDealtDamage
    @Hero sigma
    @Condition eventAbility == Button.ABILITY_2
    @Condition eventDamage > OW2_SIGMA_ACCRETION_DIRECT_HIT_DAMAGE # Checks for direct hit vs splash damage

    damage(victim, attacker, eventDamage*(SIGMA_ACCRETION_DAMAGE/OW2_SIGMA_ACCRETION_DAMAGE)-eventDamage)

rule "[sigma/init.opy]: Accretion stun scale upon distance":
    @Event playerDealtDamage
    @Hero sigma
    @Condition eventAbility == Button.ABILITY_2
    
    victim._accertion_distance_traveled = distance(attacker, victim)
    victim.accretionKnockedDownDuration = ACCERETION_MAX_DOWNTIME * (victim._accertion_distance_traveled / ACCERETION_DISTANCE_FULL_STUN)
    if victim.accretionKnockedDownDuration > ACCERETION_MAX_DOWNTIME:
        victim.accretionKnockedDownDuration = ACCERETION_MAX_DOWNTIME
    elif victim.accretionKnockedDownDuration < ACCERITION_MIN_DOWNTIME:
        victim.accretionKnockedDownDuration = ACCERITION_MIN_DOWNTIME
    victim.clearStatusEffect(Status.KNOCKED_DOWN)
    victim.setStatusEffect(attacker, Status.KNOCKED_DOWN, victim.accretionKnockedDownDuration)

rule "[sigma/init.opy]: Set sigma barrier cooldown":
    @Event eachPlayer
    @Hero sigma
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 0
    
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0.2)