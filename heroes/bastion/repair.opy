#!mainFile "../../dev_main.opy"

playervar repair_pvar

#!define isPressingSelfRepairButton(player)\
    (player.isHoldingButton(Button.ABILITY_2))

#!define isUsingSelfRepair(player)\
    ((isPressingSelfRepairButton(player)) \
 and (not player.isFiringPrimaryFire()) \
 and (not player.isMeleeing()) \
 and (not isCCd(player)) \
 and (player.isAlive()) \
 and (player.self_repair_time_left > 0))

# Remove repair sparks and ring vfx
#!define hideSelfRepairRing()\
    destroyEffect(eventPlayer._self_repair_sparkles_upper_gui)\
    eventPlayer._self_repair_sparkles_upper_gui = null\
    destroyEffect(eventPlayer._self_repair_sparkles_lower_gui)\
    eventPlayer._self_repair_sparkles_lower_gui = null\
    destroyEffect(eventPlayer._self_repair_ring_gui)\
    eventPlayer._self_repair_ring_gui = null

playervar self_repair_time_left
#!defineMember self_repair_instance repair_pvar[0]

#!defineMember _self_repair_resource_gui repair_pvar[1]
#!defineMember _self_repair_sparkles_upper_gui repair_pvar[2]
#!defineMember _self_repair_sparkles_lower_gui repair_pvar[3]
#!defineMember _self_repair_ring_gui repair_pvar[4]


rule "[bastion/repair.opy]: Activate self-repair":
    @Event eachPlayer
    @Hero bastion
    @Condition isUsingSelfRepair(eventPlayer)

    wait(BASTION_SELF_REPAIR_CAST_TIME, Wait.ABORT_WHEN_FALSE)

    eventPlayer.setStatusEffect(null, Status.ROOTED, Math.INFINITY)

    # repair sparks and ring vfx
    if eventPlayer._self_repair_sparkles_upper_gui == null:
        createEffect(getAllPlayers(), 
                     Effect.SPARKLES, 
                     Color.YELLOW, 
                     updateEveryTick(eventPlayer.getEyePosition()), 
                     1.5, 
                     EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer._self_repair_sparkles_upper_gui = getLastCreatedEntity()

    if eventPlayer._self_repair_sparkles_lower_gui == null:
        createEffect(getAllPlayers(), 
                     Effect.SPARKLES, 
                     Color.YELLOW, 
                     updateEveryTick((eventPlayer.getEyePosition()+eventPlayer.getPosition())/2), 
                     1.5, 
                     EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer._self_repair_sparkles_lower_gui = getLastCreatedEntity()

    if eventPlayer._self_repair_ring_gui == null:
        createEffect(getAllPlayers(), 
                     Effect.LIGHT_SHAFT, 
                     Color.YELLOW, 
                     updateEveryTick(eventPlayer.getPosition()), 
                     1.5, 
                     EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer._self_repair_ring_gui = getLastCreatedEntity()

    if eventPlayer.self_repair_instance == null:
        eventPlayer.startHoT(eventPlayer, Math.INFINITY, BASTION_SELF_REPAIR_HEALING_RATE)
        eventPlayer.self_repair_instance = getLastHoT()

rule "[bastion/repair.opy]: Deactivate self-repair if player took damage":
    @Event playerTookDamage
    @Hero bastion
    @Condition isUsingSelfRepair(eventPlayer)

    stopHoT(eventPlayer.self_repair_instance) # Stop healing
    eventPlayer.self_repair_instance = null

    eventPlayer.clearStatusEffect(Status.ROOTED)

    hideSelfRepairRing()

rule "[bastion/repair.opy]: Deactivate self-repair":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration != Configuration.SENTRY
    @Condition isPressingSelfRepairButton(eventPlayer) or eventPlayer.isFiringPrimaryFire() or not eventPlayer.hasStatusEffect(Status.ROOTED)


    stopHoT(eventPlayer.self_repair_instance) # Stop healing
    eventPlayer.self_repair_instance = null

    hideSelfRepairRing()
    eventPlayer.clearStatusEffect(Status.ROOTED)

    wait(BASTION_SELF_REPAIR_COOLDOWN_TIME, Wait.ABORT_WHEN_FALSE) # Wait 1 second cooldown before recharging heal resource
    
    chase(eventPlayer.self_repair_time_left, \
          BASTION_MAX_SELF_REPAIR_DURATION, \
          rate=BASTION_MAX_SELF_REPAIR_DURATION/BASTION_SELF_REPAIR_RECHARGE_DURATION, \
          ChaseReeval.DESTINATION_AND_RATE) # Start recharging


rule "[bastion/repair.opy]: Give ult charge for self repair":
    @Event playerDealtHealing
    @Hero bastion
    @Condition healer == healee

    eventPlayer._missing_ult_points += eventHealing
