#!mainFile "../../dev_main.opy"

playervar scrap_pvar
#!defineMember _scrap scrap_pvar [0]
#!defineMember _allow_scrap scrap_pvar [1]
#!defineMember _scrap_effects scrap_pvar [2]
#!defineMember _scrap_allowance scrap_pvar [3]
#!defineMember _scrap_hud scrap_pvar[4]
#!defineMember _set_scrap_armor scrap_pvar[5] 

#!defineMember _scrap_effects scrap_pvar [6]
#!defineMember _scrap_effects1 scrap_pvar [7]
#!defineMember _scrap_effects2 scrap_pvar [8]
playervar scrap_meter
playervar scrap_position 


rule "[torbjorn/scrap.opy]: Set Torbjorn scrap position":
    @Event eachPlayer
    @Condition teamHasHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam()))
    @Condition getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())).isAlive()
    @Condition eventPlayer.isDead()
    @Condition not isMatchBetweenRounds()
    @Condition getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam()))._scrap_allowance < TORBJORN_SCRAP_MAX
    
    eventPlayer.scrap_position = raycast(eventPlayer.getPosition(), eventPlayer.getPosition() + worldVector(vect(0, 1, 0), eventPlayer, Transform.ROTATION) * 1, null, eventPlayer, false).getHitPosition()
    eventPlayer._allow_scrap = true
    waitUntil(getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())).isDead() or isMatchBetweenRounds() or isInSetup() or teamHasHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())) != true or eventPlayer.isAlive() or getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam()))._scrap_allowance >= TORBJORN_SCRAP_MAX, Math.INFINITY)
    eventPlayer._allow_scrap = 0


rule "[torbjorn/scrap.opy]: start scrap pos":
    @Event eachPlayer
    @Condition eventPlayer._allow_scrap
    
    createEffect(getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())), Effect.GOOD_AURA, Color.WHITE, eventPlayer.scrap_position, 0.4, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer._scrap_effects = getLastCreatedEntity()
    waitUntil(distance(eventPlayer.scrap_position, getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam()))) <= 20 and eventPlayer._allow_scrap or eventPlayer._allow_scrap != true, 10)
    if not eventPlayer._allow_scrap:
        eventPlayer._allow_scrap = 0
        eventPlayer.scrap_position = 0
        destroyEffect(eventPlayer._scrap_effects)
    elif eventPlayer._allow_scrap:
        wait()
        chase(eventPlayer.scrap_position, getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())).getEyePosition(), rate=30, ChaseReeval.DESTINATION_AND_RATE)
        waitUntil(distance(eventPlayer.scrap_position, getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam())).getEyePosition()) <= 2, Math.INFINITY)
        if getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam()))._scrap_allowance >= TORBJORN_SCRAP_MAX:
            goto lbl_0
        getPlayersOnHero(Hero.TORBJORN, getOppositeTeam(eventPlayer.getTeam()))._scrap_allowance += TORBJORN_SCRAP_PIECE
        lbl_0:
    eventPlayer._allow_scrap = 0
    eventPlayer.scrap_position = 0
    destroyEffect(eventPlayer._scrap_effects)

rule "[torbjorn/scrap.opy]: set scrap":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer._scrap_allowance >= TORBJORN_SCRAP_ALLOW
    @Condition distance(raycast(raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 4, null, eventPlayer, false).getHitPosition(), raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 4, null, eventPlayer, false).getHitPosition() + worldVector(vect(0, -1, 0), eventPlayer, Transform.ROTATION) * 100, null, eventPlayer, false).getHitPosition(), eventPlayer) <= 6
    @Condition not isCCd(eventPlayer)
    
    eventPlayer._scrap = 0
    wait()
    eventPlayer.scrap_position = raycast(raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 3, null, eventPlayer, false).getHitPosition(), raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 3, null, eventPlayer, false).getHitPosition() + worldVector(vect(0, -1, 0), eventPlayer, Transform.ROTATION) * 100, null, eventPlayer, false).getHitPosition()
    eventPlayer._scrap = true
    eventPlayer._scrap_allowance -= TORBJORN_SCRAP_ALLOW


rule "[torbjorn/scrap.opy]: armor packs gone":
    @Event eachPlayer
    @Condition eventPlayer._scrap
    
    waitUntil(eventPlayer._scrap == 0, TOBRJORN_SCRAP_DURATION)
    eventPlayer._scrap = 0
    destroyEffect(eventPlayer._scrap_effects)
    eventPlayer._scrap_effects = null
    destroyEffect(eventPlayer._scrap_effects1)
    eventPlayer._scrap_effects1 = null
    destroyEffect(eventPlayer._scrap_effects2)
    eventPlayer._scrap_effects2 = null


rule "[torbjorn/scrap.opy]: set armor packs effects":
    @Event eachPlayer
    @Condition eventPlayer._scrap
    
    if (eventPlayer._scrap_effects == null):
    createEffect(getPlayers(eventPlayer.getTeam()), 
        Effect.SPHERE, 
        Color.YELLOW, 
        eventPlayer.scrap_position + worldVector(vect(0, 1, 0), 
        eventPlayer, 
        Transform.ROTATION), 
        0.3, 
        EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer._scrap_effects = getLastCreatedEntity()

    if (eventPlayer._scrap_effects1 == null):
    createEffect(getPlayers(eventPlayer.getTeam()), 
        Effect.SPHERE, 
        Color.YELLOW, 
        eventPlayer.scrap_position + worldVector(vect(0, 1, 0), 
        eventPlayer, 
        Transform.ROTATION), 
        0.6, 
        EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer._scrap_effects1 = getLastCreatedEntity()

    if (eventPlayer._scrap_effects2 == null):
    createEffect(getPlayers(eventPlayer.getTeam()), 
    Effect.RING, 
    Color.YELLOW, 
    eventPlayer.scrap_position + worldVector(vect(0, 1, 0), 
    eventPlayer, 
    Transform.ROTATION), 
    1, 
    EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer._scrap_effects2 = getLastCreatedEntity()


rule "[torbjorn/scrap.opy]: Armor Pack Pickup":
    @Event eachPlayer
    @Condition eventPlayer._scrap
    @Condition (len([player for player in getPlayersInRadius(eventPlayer.scrap_position, 1, eventPlayer.getTeam(), LosCheck.SURFACES) if player.isAlive() and player._set_scrap_armor < TORBJORN_SCRAP_ARMOR])) > 0
    
    eventPlayer._scrap = 0
    (([player for player in getPlayersInRadius(eventPlayer.scrap_position, 1, eventPlayer.getTeam(), LosCheck.SURFACES) if player.isAlive() and player._set_scrap_armor < TORBJORN_SCRAP_ARMOR]))._set_scrap_armor = 0
    wait()
    (([player for player in getPlayersInRadius(eventPlayer.scrap_position, 1, eventPlayer.getTeam(), LosCheck.SURFACES) if player.isAlive() and player._set_scrap_armor < TORBJORN_SCRAP_ARMOR]))._set_scrap_armor = TORBJORN_SCRAP_ARMOR
    getPlayersInRadius(eventPlayer, 5, eventPlayer.getTeam(), LosCheck.SURFACES).addHealthPool(Health.NORMAL, TORBJORN_SCRAP_ARMOR, false, true)