#!mainFile "../../dev_main.opy"

playervar halt_pvar
#!defineMember _is_using_halt halt_pvar [0]
#!defineMember _is_snared halt_pvar[1]
#!defineMember _halt_victims halt_pvar[2]
#!defineMember _halt_orb_id halt_pvar[3]
# #!defineMember _halt_orb_id1 halt_pvar[4]
#!defineMember _halt_snare_line_id halt_pvar[5]
playervar position

playervar halt_position
playervar halt_ending_position

subroutine shootHalt
subroutine explodeHalt
subroutine showSnareLine
subroutine hideSnareLine

#!define snareVisible(player) \
    (player.enemy_orisa_player._is_using_halt \
 and distance(centerMass(player), player.enemy_orisa_player.halt_position) <= ORISA_HALT_AOE_RADIUS \
 and isInLoS(centerMass(player), player.enemy_orisa_player.halt_position, BarrierLos.BLOCKED_BY_ALL_BARRIERS) \
 and player.isAlive())


rule "[orisa/halt.opy]: Trigger Halt ability":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) <= 0
    @Condition eventPlayer.isAlive()
    @Condition not isCCd(eventPlayer)

    shootHalt()
    waitUntil(not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), Math.INFINITY) # Ensure player releases right click
    waitUntil(updateEveryTick((eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) and eventPlayer.isAlive() and not isCCd(eventPlayer)) \
                           or (eventPlayer.halt_position == eventPlayer.halt_ending_position)), Math.INFINITY) # Detect halt pull activation on right click
    explodeHalt()

    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, ORISA_HALT_COOLDOWN_TIME)


def shootHalt():
    @Name "[orisa/halt.opy]: Shoot Halt Orb"

    eventPlayer._is_using_halt = true # Start halt

    # Halt orb visuals
    if (eventPlayer._halt_orb_id == null):
        createEffect(getAllPlayers(), Effect.SPHERE, Color.LIME_GREEN, eventPlayer.halt_position, 1*ORISA_HALT_PROJECTILE_RADIUS, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer._halt_orb_id = getLastCreatedEntity()

    # Halt orb sounds
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.LIME_GREEN, eventPlayer, 100)
    
    # Calculate starting/ending positions
    eventPlayer.halt_position = eventPlayer.getEyePosition()
    eventPlayer.halt_ending_position = raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + 1000*eventPlayer.getFacingDirection(), null, null, true).getHitPosition()

    getPlayers(getOppositeTeam(eventPlayer.getTeam()))._is_snared = false
    wait(ORISA_HALT_LAUNCH_CAST_TIME)

    # Start flying halt orb
    chase(eventPlayer.halt_position, eventPlayer.halt_ending_position, rate=ORISA_HALT_PROJECTILE_SPEED, ChaseReeval.DESTINATION_AND_RATE)


def explodeHalt():
    @Name "[orisa/halt.opy]: Explode Halt Orb"

    stopChasingVariable(eventPlayer.halt_position)
    wait(ORISA_HALT_ACTIVATION_TIME)
    eventPlayer._halt_victims = getPlayersInRadius(eventPlayer.halt_position, 
                                                  ORISA_HALT_AOE_RADIUS, 
                                                  getOppositeTeam(eventPlayer.getTeam()), 
                                                  LosCheck.SURFACES_AND_ALL_BARRIERS)
    eventPlayer._halt_victims._is_snared = true
    eventPlayer._halt_victims.setEnvironmentalKillCreditor(eventPlayer)

    # Halt orb explosion sounds
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.LIME_GREEN, eventPlayer, 100)

    # Clear visuals
    destroyEffect(eventPlayer._halt_orb_id)
    eventPlayer._halt_orb_id = null

    eventPlayer._is_using_halt = false


rule "[orisa/halt.opy]: Slow down snared enemies":
    @Event eachPlayer
    @Condition eventPlayer._is_snared

    eventPlayer.setMoveSpeed(100-ORISA_HALT_SNARE_MOVE_PENALTY)
    wait(ORISA_HALT_SNARE_DURATION)
    eventPlayer.setMoveSpeed(100)


rule "[orisa/halt.opy]: Pull halted victims":
    @Event eachPlayer
    @Condition eventPlayer._is_snared

    eventPlayer.position = eventPlayer.getPosition()
    eventPlayer.startForcingPosition(eventPlayer.position, true)
    chase(eventPlayer.position, eventPlayer.enemy_orisa_player.halt_position, rate=ORISA_HALT_PULL_SPEED, ChaseReeval.DESTINATION_AND_RATE)
    waitUntil(eventPlayer.position == eventPlayer.enemy_orisa_player.halt_position, Math.INFINITY)
    stopChasingVariable(eventPlayer.position)
    eventPlayer.stopForcingPosition()
    cancelMomentum(eventPlayer)
    eventPlayer._is_snared = false


rule "[orisa/halt.opy]: Halt snare line VFX":
    @Event eachPlayer
    @Condition snareVisible(eventPlayer)

    # Halt orb explosion sounds
    showSnareLine()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.LIME_GREEN, eventPlayer, 100)
    
    waitUntil(not (snareVisible(eventPlayer)), Math.INFINITY)
    hideSnareLine()


def showSnareLine():
    @Name "[orisa/halt.opy]: showSnareLine()"

    if (eventPlayer._halt_snare_line_id == null):
        createBeam(getAllPlayers() if snareVisible(eventPlayer) else null, 
                   Beam.GOOD, 
                   eventPlayer.enemy_orisa_player.halt_position, 
                   centerMass(eventPlayer), 
                   Color.GREEN if eventPlayer._is_snared else Color.WHITE, 
                   EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR)
        eventPlayer._halt_snare_line_id = getLastCreatedEntity()


def hideSnareLine():
    @Name "[orisa/halt.opy]: hideSnareLine()"

    destroyEffect(eventPlayer._halt_snare_line_id)
    eventPlayer._halt_snare_line_id = null


rule "[orisa/halt.opy]: Destroy Halt pull line vfx when halt starts":
    @Event eachPlayer
    @Condition eventPlayer.enemy_orisa_player._is_using_halt

    destroyEffect(eventPlayer._halt_snare_line_id)
    eventPlayer._halt_snare_line_id = null


rule "[orisa/halt.opy]: Destroy Halt pull line vfx when halt is over":
    @Event eachPlayer
    @Condition not eventPlayer.enemy_orisa_player._is_using_halt

    destroyEffect(eventPlayer._halt_snare_line_id)
    eventPlayer._halt_snare_line_id = null


rule "[orisa/halt.opy]: Destroy Halt pull line vfx when dead":
    @Event playerDied
    @Condition eventPlayer.enemy_orisa_player._is_using_halt

    destroyEffect(eventPlayer._halt_snare_line_id)
    eventPlayer._halt_snare_line_id = null
