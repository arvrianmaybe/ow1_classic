#!mainFile "../../dev_main.opy"

globalvar slam_i

playervar slam_to_use
playervar proto_indicator_slam_position
playervar indicator_slam_position
playervar slam_damage

playervar slam_victims

playervar slam_velocity_correction
playervar stop_slam

playervar slam_indicator_beam_id
playervar slam_indicator_ring_id

subroutine initSlam
subroutine executeSlam
subroutine startSlamAnimation

subroutine createSlamIndicatorGui
subroutine destroySlamIndicatorGui

enum SlamType:
    GROUND,
    INDICATOR

# First raycast max range towards the direction the crosshair is aimed at
#!define findProtoIndicatorPosition() \
(raycast( \
    eventPlayer.getEyePosition(), \
    eventPlayer.getEyePosition() + DOOMFIST_SEISMIC_SLAM_RADIUS * eventPlayer.getFacingDirection(), \
    null, \
    getAllPlayers(), \
    false).getHitPosition())

# Then drop straight down vertically to find the final indicator position
#!define findIndicatorPosition() \
(raycast(\
    eventPlayer.proto_indicator_slam_position, \
    eventPlayer.proto_indicator_slam_position + DOOMFIST_INDICATOR_SEISMIC_SLAM_MARGIN*Vector.DOWN, \
    null, \
    getAllPlayers(), \
    false).getHitPosition() \
if distance(eventPlayer.getEyePosition(), eventPlayer.proto_indicator_slam_position) >= DOOMFIST_SEISMIC_SLAM_RADIUS \
else eventPlayer.proto_indicator_slam_position)

#!define indicatorSlamValid() \
    ((distance(eventPlayer.indicator_slam_position, eventPlayer.proto_indicator_slam_position) < DOOMFIST_INDICATOR_SEISMIC_SLAM_MARGIN) \
and (angleBetweenVectors(Vector.DOWN, eventPlayer.getFacingDirection()) <= (90 + DOOMFIST_SLAM_PITCH_ANGLE)))

#!define isIndicatorVisible() \
    ((indicatorSlamValid()) \
and (eventPlayer.slam_to_use == SlamType.INDICATOR) \
and (eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0) \
and (not eventPlayer.isFiringSecondaryFire()) \
and (not eventPlayer.isUsingAbility1()) \
and (not eventPlayer.isUsingUltimate()))

#Conditions for when to stop an indicator slam and drop the player
#!define impulseTrainActive() \
   ((distance(eventPlayer.getPosition(), eventPlayer.indicator_slam_position) > 2) \
and (eventPlayer.isUsingAbility1()) \
and (eventPlayer.getSpeed() > 2) \
and not eventPlayer.stop_slam) \

#!define initSlam() \
    eventPlayer.disallowButton(Button.ABILITY_1) \
    eventPlayer.slam_damage = 0 \
    createSlamIndicatorGui()


rule "[doomfist/slam.opy]: Execute slam":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0
    @Condition not eventPlayer.isMeleeing()
    @Condition not isCCd(eventPlayer)
    @Condition not eventPlayer.is_ultimate_locked
    @Condition not eventPlayer.is_uppercut_locked
    @Condition not eventPlayer.isCommunicatingEmote()

    eventPlayer.slam_victims = [] # clear slammed victims

    if eventPlayer.slam_to_use == SlamType.INDICATOR:
        if indicatorSlamValid():
            # Initiate Indicator Slam
            stopChasingVariable(eventPlayer.proto_indicator_slam_position)
            stopChasingVariable(eventPlayer.indicator_slam_position)
            eventPlayer.stop_slam = false
            eventPlayer.proto_indicator_slam_position = findProtoIndicatorPosition()
            eventPlayer.indicator_slam_position = findIndicatorPosition()
            eventPlayer.setGravity(0)
            eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0)
            startSlamAnimation()
            while(impulseTrainActive()):
                eventPlayer.slam_velocity_correction = DOOMFIST_INDICATOR_SEISMIC_SLAM_SPEED * directionTowards(eventPlayer.getPosition(), 
                                                                                                                    eventPlayer.indicator_slam_position) \
                                                       - eventPlayer.getVelocity()
                eventPlayer.applyImpulse(eventPlayer.slam_velocity_correction, 
                                         magnitude(eventPlayer.slam_velocity_correction), 
                                         Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
                wait()
            eventPlayer.setGravity(100)
            waitUntil(eventPlayer.isOnGround() or not eventPlayer.isUsingAbility1(), Math.INFINITY)
            cancelMomentum(eventPlayer)
            eventPlayer.stopForcingThrottle()

    else if eventPlayer.slam_to_use == SlamType.GROUND:
        # Initiate Ground Slam
        eventPlayer.setGravity(0)
        eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0)
    
        startSlamAnimation()
        eventPlayer.applyImpulse(getForwardDirection(eventPlayer) + 0.075*Vector.UP, 16, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION) # apply custom momentum
        wait(0.3)
        eventPlayer.setGravity(100)
        waitUntil(eventPlayer.isOnGround() or not eventPlayer.isUsingAbility1(), Math.INFINITY)
        eventPlayer.stopForcingThrottle()


rule "[doomfist/slam.opy]: Check for LOS during indicator":
    @Event eachPlayer
    @Hero doomfist
    @Condition impulseTrainActive()
    @Condition not isInLoS(eventPlayer.getEyePosition(), eventPlayer.indicator_slam_position, BarrierLos.PASS_THROUGH_BARRIERS)
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.stop_slam = true


def startSlamAnimation():
    @Name "[doomfist/slam.opy]: startSlamAnimation()"

    # Start slam animation
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_1)

    wait()
    cancelMomentum(eventPlayer)


rule "[doomfist/slam.opy]: Detect ground slam":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.getAltitude() < DOOMFIST_GROUND_SLAM_HEIGHT
    
    eventPlayer.slam_to_use = SlamType.GROUND


rule "[doomfist/slam.opy]: Detect indicator slam":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.getAltitude() >= DOOMFIST_INDICATOR_SLAM_HEIGHT

    eventPlayer.slam_to_use = SlamType.INDICATOR


rule "[doomfist/slam.opy]: Start tracking indicator slam destination":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.slam_to_use == SlamType.INDICATOR
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0
    @Condition not eventPlayer.isUsingAbility1()

    chase(eventPlayer.proto_indicator_slam_position, findProtoIndicatorPosition(), rate=Math.INFINITY, ChaseReeval.DESTINATION_AND_RATE)
    chase(eventPlayer.indicator_slam_position, findIndicatorPosition(), rate=Math.INFINITY, ChaseReeval.DESTINATION_AND_RATE)


rule "[doomfist/slam.opy]: Stop tracking indicator slam destination":
    @Event eachPlayer
    @Hero doomfist
    @Condition not ((eventPlayer.slam_to_use == SlamType.INDICATOR) \
                and (eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0) \
                and (not eventPlayer.isUsingAbility1()))

    stopChasingVariable(eventPlayer.proto_indicator_slam_position)
    stopChasingVariable(eventPlayer.indicator_slam_position)


rule "[doomfist/uppercut.opy]: Disable abilities when slamming":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isUsingAbility1()
    
    eventPlayer.setMeleeEnabled(false) # Doomfist cannot melee during uppercut
    eventPlayer.setPrimaryFireEnabled(false) # Doomfist cannot shoot during slam
    eventPlayer.setSecondaryFireEnabled(false) # Doomfist cannot punch during slam
    eventPlayer.setAbility2Enabled(false) # Doomfist cannot uppercut during slam
    waitUntil(eventPlayer.isOnGround() or not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.setMeleeEnabled(true)
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.setAbility2Enabled(true)

# maybe not here im not sure
rule "[doomfist/slam.opy]: Calculate slam damage based on air time":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isUsingAbility1()
    
    eventPlayer.slam_damage = 0
    waitUntil(not eventPlayer.isOnGround(), Math.INFINITY)
    if eventPlayer.slam_to_use == SlamType.GROUND: # Makes ground slam damage 49    
        wait()
    chase(eventPlayer.slam_damage, DOOMFIST_SLAM_DAMAGE_MAX, rate=DOOMFIST_SEISMIC_SLAM_DAMAGE_RATE, ChaseReeval.NONE)
    waitUntil(eventPlayer.isOnGround() or not eventPlayer.isUsingAbility1(), Math.INFINITY)
    stopChasingVariable(eventPlayer.slam_damage)
    wait(1, Wait.RESTART_WHEN_TRUE)

# Need more permanent/robust solution and also maybe might remove this cause he didnt have his slam indicator back then
rule "[doomfist/slam.opy]: Remove OW2 slam damage":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.ABILITY_1 # Ability used to damage player is Seismic Slam
    
    heal(victim, null, eventDamage)


rule "[doomfist/slam.opy]: Find slammed victims":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.ABILITY_1 # Ability used to damage player is Seismic Slam
    
    if ((DOOMFIST_SLAM_AOE_MIN_RADIUS <= distance(attacker, victim)) \
    and (distance(attacker, victim) <= DOOMFIST_SLAM_AOE_MAX_RADIUS) \
    and true): # [TODO]: add condition to check victim in 60 degree cone
        attacker.slam_victims.append(victim)
        damage(attacker, null, OW2_DOOMFIST_BEST_DEFENSE - DOOMFIST_BEST_DEFENSE)
    else: # Handle OW2 slam victims
        # Transfer shield gained from uppercut to shield gained from OW2 slam victims
        damage(attacker, null, OW2_DOOMFIST_BEST_DEFENSE - min(OW2_DOOMFIST_BEST_DEFENSE, attacker.uppercut_shields))
        attacker.uppercut_shields -= min(OW2_DOOMFIST_BEST_DEFENSE, attacker.uppercut_shields)


rule "[doomfist/slam.opy]: Slammed victims damage + bounce effect":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.ABILITY_1 # Ability used to damage player is Seismic Slam
    @Condition victim in attacker.slam_victims

    damage(victim, attacker, floor(attacker.slam_damage)) # Custom slam damage

    victim.setGravity(50) 
    victim.applyImpulse(Vector.UP, 5.25, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ) # Boop slammed victims up
    victim.applyImpulse(directionTowards(victim, attacker), 1.5*(distance(victim, attacker)-(DOOMFIST_RISING_UPPERCUT_RADIUS-1)), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ) # Push/Pull slammed victims; multiply pull magnitude by 1.5 to counteract air resistance
    victim.setGravity(100)


def createSlamIndicatorGui():
    @Name "[doomfist/slam.opy]: createSlamIndicatorGui()"

    for slam_i in range(DOOMFIST_SLAM_INDICATOR_BEAM_COUNT):
        if eventPlayer.slam_indicator_beam_id[slam_i] == null:
            createBeam(eventPlayer if isIndicatorVisible() else null,
                       Beam.GOOD, 
                       updateEveryTick(eventPlayer.indicator_slam_position + \
                                       DOOMFIST_SLAM_AOE_MIN_RADIUS * \
                                       worldVector(cosDeg(DOOMFIST_SEISMIC_SLAM_FAN_ANGLE/2-evalOnce(slam_i)*DOOMFIST_SEISMIC_SLAM_FAN_ANGLE/(DOOMFIST_SLAM_INDICATOR_BEAM_COUNT-1))*Vector.FORWARD + \
                                                   sinDeg(DOOMFIST_SEISMIC_SLAM_FAN_ANGLE/2-evalOnce(slam_i)*DOOMFIST_SEISMIC_SLAM_FAN_ANGLE/(DOOMFIST_SLAM_INDICATOR_BEAM_COUNT-1))*Vector.LEFT, \
                                                   eventPlayer, \
                                                   Transform.ROTATION)), 
                       updateEveryTick(eventPlayer.indicator_slam_position + \
                                       DOOMFIST_SLAM_AOE_MAX_RADIUS * \
                                       worldVector(cosDeg(DOOMFIST_SEISMIC_SLAM_FAN_ANGLE/2-evalOnce(slam_i)*DOOMFIST_SEISMIC_SLAM_FAN_ANGLE/(DOOMFIST_SLAM_INDICATOR_BEAM_COUNT-1))*Vector.FORWARD + \
                                                   sinDeg(DOOMFIST_SEISMIC_SLAM_FAN_ANGLE/2-evalOnce(slam_i)*DOOMFIST_SEISMIC_SLAM_FAN_ANGLE/(DOOMFIST_SLAM_INDICATOR_BEAM_COUNT-1))*Vector.LEFT, \
                                                   eventPlayer, \
                                                   Transform.ROTATION)), 
                       Color.BLUE, 
                       EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.slam_indicator_beam_id[slam_i] = getLastCreatedEntity()

    for slam_i in range(DOOMFIST_SLAM_INDICATOR_RING_COUNT):
        if eventPlayer.slam_indicator_ring_id[slam_i] == null:
            createEffect(eventPlayer if isIndicatorVisible() else null, 
                         Effect.RING, 
                         Color.BLUE, 
                         updateEveryTick(eventPlayer.indicator_slam_position + \
                                         evalOnce(slam_i+1)*(DOOMFIST_SLAM_AOE_MAX_RADIUS)/DOOMFIST_SLAM_INDICATOR_RING_COUNT * \
                                         worldVector(Vector.FORWARD, 
                                                     eventPlayer, 
                                                     Transform.ROTATION)), 
                         (evalOnce(slam_i+1)*(DOOMFIST_SLAM_AOE_MAX_RADIUS)/DOOMFIST_SLAM_INDICATOR_RING_COUNT)*sinDeg(DOOMFIST_SEISMIC_SLAM_FAN_ANGLE/2), 
                         EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.slam_indicator_ring_id[slam_i] = getLastCreatedEntity()
    
    # Sphere for debugging indicator slam
    # if eventPlayer.slam_indicator_id[0] == null:
    #     createEffect(eventPlayer if isIndicatorVisible() else null, 
    #                 Effect.RING, 
    #                 Color.BLUE, 
    #                 updateEveryTick(eventPlayer.indicator_slam_position), 
    #                 0.5, 
    #                 EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #     eventPlayer.slam_indicator_id[0] = getLastCreatedEntity()


def destroySlamIndicatorGui():
    @Name "[doomfist/slam.opy]: destroySlamIndicatorGui()"

    for slam_i in range(len(eventPlayer.slam_indicator_beam_id)):
        destroyEffect(eventPlayer.slam_indicator_beam_id[slam_i])
        eventPlayer.slam_indicator_beam_id[slam_i] = null

    for slam_i in range(len(eventPlayer.slam_indicator_ring_id)):
        destroyEffect(eventPlayer.slam_indicator_ring_id[slam_i])
        eventPlayer.slam_indicator_ring_id[slam_i] = null
    
    # Sphere for debugging indicator slam
    # destroyEffect(eventPlayer.slam_indicator_id[0])
    # eventPlayer.slam_indicator_id[0] = null
