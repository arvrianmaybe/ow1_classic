#!mainFile "../../dev_main.opy"

playervar parting_pvar
#!defineMember _lifeweaver_parting_gift parting_pvar[0]
#!defineMember _gift_collected parting_pvar[1]

playervar parting_gift_position

#!define lifeWeaverPartingGift()\
 createEffect(getPlayersOnHero(Hero.LIFEWEAVER, getOppositeTeam(eventPlayer.getTeam())), Effect.ORB, Color.YELLOW, updateEveryTick(eventPlayer.getPosition()) + vect(0, 1, 0), 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)\
 eventPlayer._lifeweaver_parting_gift = getLastCreatedEntity()\
 eventPlayer._gift_collected = false

#!define partingGiftCollected()\
 destroyEffect(eventPlayer._lifeweaver_parting_gift)\
 eventPlayer._lifeweaver_parting_gift = null

rule "[lifeweaver/parting_gift.opy]: if parting gift collected remove.":
    @Event eachPlayer
    @Condition eventPlayer._gift_collected == true
    
    partingGiftCollected()


rule "[lifeweaver/parting_gift.opy]: spawn soul parting gift":
    @Hero lifeweaver
    @Event playerDied

    lifeWeaverPartingGift()
    waitUntil(eventPlayer.isAlive(), Math.INFINITY)
    eventPlayer._gift_collected = true


rule "[lifeweaver/parting_gift.opy]: collect parting gift":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition getNumberOfDeadPlayers(getOppositeTeam(eventPlayer.getTeam())) > 0
    @Condition (distance(eventPlayer.getPosition(), ((sorted([player for player in getDeadPlayers(Team.ALL) if not player._gift_collected]))[0]).getPosition())) < 1.5
    @Condition any([player._gift_collected != true for player in getPlayers(getOppositeTeam(eventPlayer.getTeam()))]) == true
    @Condition eventPlayer.getNormalizedHealth() < 1
    
    sorted(eventPlayer.isDead(), lambda i: distance(getClosestPlayer(eventPlayer.getPosition(), eventPlayer.getTeam()), i.getPosition()))[0]._gift_collected = true
    heal(eventPlayer, null, LIFEWEAVER_PARTING_GIFT_HEALING)
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    if RULE_CONDITION:
        goto RULE_START


rule "[lifeweaver/parting_gift.opy]: parting gift collected":
    @Event eachPlayer
    @Condition eventPlayer._gift_collected == true
    @Condition eventPlayer.isDead() == true
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    partingGiftCollected()
    eventPlayer.stopForcingPosition()
    eventPlayer.teleport(vect(0, -500, 0))


rule "[lifeweaver/parting_gift.opy]: follow players":
    @Event eachPlayer
    @Condition eventPlayer.isDead() == true
    @Condition eventPlayer._gift_collected != true
    @Condition getNumberOfHeroes(Hero.LIFEWEAVER, getOppositeTeam(eventPlayer.getTeam())) > 0
    @Condition (any([player.isAlive() and distance(eventPlayer.getPosition(), player.getPosition()) < 5 and player.getNormalizedHealth() < 1 for player in getPlayersOnHero(Hero.LIFEWEAVER, getOppositeTeam(eventPlayer.getTeam()))])) == true
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    eventPlayer.parting_gift_position = eventPlayer.getPosition()
    eventPlayer.startForcingPosition(eventPlayer.parting_gift_position, true)
    chase(eventPlayer.parting_gift_position, ((sorted([player for player in getPlayersOnHero(Hero.LIFEWEAVER, getOppositeTeam(eventPlayer.getTeam())) if player.isAlive() and player.getNormalizedHealth() < 1], lambda i: distance(eventPlayer.getPosition(), i.getPosition())))[0]).getPosition(), rate=8, ChaseReeval.DESTINATION_AND_RATE)


rule "[lifeweaver/parting_gift.opy]: stop following":
    @Event eachPlayer
    @Condition (eventPlayer._gift_collected != true or eventPlayer.isAlive()) == true
    @Condition (any([player.isAlive() and distance(eventPlayer.getPosition(), player.getPosition()) < 5 and player.getNormalizedHealth() < 1 for player in getPlayersOnHero(Hero.LIFEWEAVER, getOppositeTeam(eventPlayer.getTeam()))]) or eventPlayer.isAlive()) == false
    
    eventPlayer.stopForcingPosition()
    stopChasingVariable(eventPlayer.parting_gift_position)
    if eventPlayer.isAlive() and not eventPlayer.isInSpawnRoom():
        wait(0.1)
        if not eventPlayer.hasStatusEffect(Status.BURNING):
            eventPlayer.teleport(random.choice(getSpawnPoints(eventPlayer.getTeam())))
