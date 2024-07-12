#!mainFile "../../dev_main.opy"

playervar cross_fade_stats 
playervar cross_fade_index 
playervar cross_fade_effects

subroutine lucioAura
subroutine cleanUpAura

def lucioAura():
    @Name "[lucio/aura.opy]: lucioAura()"

    eventPlayer.cross_fade_stats = ["Speed", true, "Toggle", [], [], []]

    if (eventPlayer.cross_fade_effects == null): 
    createEffect([player for player in getAllPlayers() if eventPlayer.cross_fade_stats[1] == true], 
            Effect.RING, 
            Color.GREEN if eventPlayer.cross_fade_stats[0] == "Speed" 
            else Color.YELLOW, 
            raycast(eventPlayer.getPosition() + Vector.UP, 
            updateEveryTick(eventPlayer.getPosition()) - vect(0, 99, 0), 
            null, eventPlayer, false).getHitPosition() + Vector.UP * 0.1, LUCIO_AURA_RADIUS, EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR) 
    eventPlayer.cross_fade_effects = getLastCreatedText()

def cleanUpAura():
    @Name "[lucio/aura.opy]: cleanUpAura()"

    destroyEffect(eventPlayer.cross_fade_effects) 
    destroyAllEffects()
    eventPlayer.cross_fade_effects = null

rule "[lucio/aura.opy]: Launch wallride":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isOnWall()
    
    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar*(1-LUCIO_WALLRIDE_SPEED_PENALTY))
    waitUntil(not eventPlayer.isOnWall(), 3)
    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar/(1-LUCIO_WALLRIDE_SPEED_PENALTY))
    if eventPlayer.isOnWall():
        eventPlayer.forceButtonPress(Button.CROUCH)
        wait()
        if eventPlayer.isOnWall():
            eventPlayer.forceButtonPress(Button.JUMP)
    else:
        eventPlayer.applyImpulse(eventPlayer.getVelocity() * -1, 2.5, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)

rule "[lucio/aura.opy]: Cross Fade heal":
    @Event eachPlayer
    @Hero lucio
    @Condition not eventPlayer.isUsingAbility1()
    
    eventPlayer.cross_fade_stats[0] = "Healing"
    wait(OW2_LUCIO_CROSSFADE_CAST_TIME)
    waitUntil(eventPlayer.isUsingAbility1(), Math.INFINITY)


rule "[lucio/aura.opy]: Cross Fade speed":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isUsingAbility1()
    
    eventPlayer.cross_fade_stats[0] = "Speed"
    wait(OW2_LUCIO_CROSSFADE_CAST_TIME)
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    if RULE_CONDITION:
        goto RULE_START


rule "[lucio/aura.opy]: Cross Fade Targets":
    @Event eachPlayer
    @Condition eventPlayer.cross_fade_stats[1]
    
    eventPlayer.cross_fade_stats[4] = getPlayersInRadius(eventPlayer, LUCIO_AURA_RADIUS, eventPlayer.getTeam(), LosCheck.SURFACES_AND_ENEMY_BARRIERS)
    eventPlayer.cross_fade_stats[3].append([i for i in eventPlayer.cross_fade_stats[4] if not i in eventPlayer.cross_fade_stats[3]])
    eventPlayer.cross_fade_stats[5] = []
    for eventPlayer.cross_fade_index in range(len(eventPlayer.cross_fade_stats[3])):
        if eventPlayer.cross_fade_stats[3][eventPlayer.cross_fade_index] in eventPlayer.cross_fade_stats[4] == true:
            eventPlayer.cross_fade_stats[5].append(1)
        else:
            eventPlayer.cross_fade_stats[5].append(eventPlayer.cross_fade_stats[6][eventPlayer.cross_fade_index] - 0.1)
    eventPlayer.cross_fade_stats[6] = eventPlayer.cross_fade_stats[5]
    eventPlayer.cross_fade_stats[3].remove([_ for _, i in eventPlayer.cross_fade_stats[3] if eventPlayer.cross_fade_stats[6][i] <= 0])
    eventPlayer.cross_fade_stats[6].remove([i for i in eventPlayer.cross_fade_stats[6] if i <= 0])
    wait()
    if RULE_CONDITION:
        goto RULE_START


rule "[lucio/aura.opy]: Cross Fade Speed":
    @Event eachPlayer
    @Condition (any([eventPlayer in player.cross_fade_stats[3] and player.cross_fade_stats[0] == "Speed" and player.cross_fade_stats[1] == true for player in getPlayers(eventPlayer.getTeam())])) == true
    
    eventPlayer.setMoveSpeed(percent(OW2_LUCIO_CROSSFADE_INCREASE))
    waitUntil(all([not eventPlayer in player.cross_fade_stats[3] or player.cross_fade_stats[0] != "Speed" or player.cross_fade_stats[1] == false for player in getPlayers(eventPlayer.getTeam())]), Math.INFINITY)
    eventPlayer.setMoveSpeed(100)


rule "[lucio/aura.opy]: Cross Fade Healing":
    @Event eachPlayer
    @Condition (any([eventPlayer in player.cross_fade_stats[3] and player.cross_fade_stats[0] == "Healing" and player.cross_fade_stats[1] == true for player in getPlayers(eventPlayer.getTeam())])) == true
    
    while any([eventPlayer in player.cross_fade_stats[3] and player.cross_fade_stats[0] == "Healing" and player.cross_fade_stats[1] == true for player in getPlayers(eventPlayer.getTeam())]):
        if (([player for player in getPlayers(eventPlayer.getTeam()) if eventPlayer in player.cross_fade_stats[3] and player.cross_fade_stats[0] == "Healing" and player.cross_fade_stats[1] == true])[0]) == eventPlayer and ((len([player for player in getPlayers(eventPlayer.getTeam()) if eventPlayer in player.cross_fade_stats[3] and player.cross_fade_stats[0] == "Healing" and player.cross_fade_stats[1] == true])) == 1):
            heal(eventPlayer, eventPlayer, 1)
        else:
            heal(eventPlayer, [player for player in getPlayers(eventPlayer.getTeam()) if eventPlayer in player.cross_fade_stats[3] and player.cross_fade_stats[0] == "Healing" and player.cross_fade_stats[1] == true], 1.6)
        wait(0.1)


rule "[lucio/aura.opy]: set correct toggle":
    @Event eachPlayer
    @Condition not eventPlayer.isInAlternateForm()
    
    eventPlayer.cross_fade_stats[0] = "Healing"