#!mainFile "../../dev_main.opy"

playervar soul_pvar
#!defineMember _reaper_soul_orb soul_pvar[0]
#!defineMember _orb_collected soul_pvar[1]
playervar orb_pos

#!define reaperSoulOrb()\
 if eventPlayer._reaper_soul_orb == null:\
     createEffect(getPlayersOnHero(Hero.REAPER, getOppositeTeam(eventPlayer.getTeam())), Effect.ORB, Color.RED, updateEveryTick(eventPlayer.getPosition()) + vect(0, 1, 0), 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)\
 eventPlayer._reaper_soul_orb = getLastCreatedEntity()\
 eventPlayer._orb_collected = false

#!define soulOrbCollected()\
 destroyEffect(eventPlayer._reaper_soul_orb)\
 eventPlayer._reaper_soul_orb = null

rule "[reaper/reaping.opy]: if orb collected remove.":
    @Event eachPlayer
    @Condition eventPlayer._orb_collected == true
    
    soulOrbCollected()


rule "[reaper/reaping.opy]: spawn soul orb":
    @Event playerDied

    reaperSoulOrb()
    waitUntil(eventPlayer.isAlive(), Math.INFINITY)
    eventPlayer._orb_collected = true


rule "[reaper/reaping.opy]: collect orb":
    @Event eachPlayer
    @Hero reaper
    @Condition getNumberOfDeadPlayers(getOppositeTeam(eventPlayer.getTeam())) > 0
    @Condition (distance(eventPlayer.getPosition(), ((sorted([player for player in getDeadPlayers(Team.ALL) if not player._orb_collected]))[0]).getPosition())) < 1.5
    @Condition any([player._orb_collected != true for player in getPlayers(getOppositeTeam(eventPlayer.getTeam()))]) == true
    @Condition eventPlayer.getNormalizedHealth() < 1
    
    sorted(getDeadPlayers(getOppositeTeam(eventPlayer.getTeam())), lambda player: distance(eventPlayer.getPosition(), player.getPosition()))[0]._orb_collected = true
    heal(eventPlayer, null, REAPER_SOUL_ORB_HEALING)
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    if RULE_CONDITION:
        goto RULE_START


rule "[reaper/reaping.opy]: orb collected":
    @Event eachPlayer
    @Condition eventPlayer._orb_collected == true
    @Condition eventPlayer.isDead() == true
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    soulOrbCollected()
    eventPlayer.stopForcingPosition()
    eventPlayer.teleport(vect(0, -500, 0))


rule "[reaper/reaping.opy]: follow players":
    @Event eachPlayer
    @Condition eventPlayer.isDead() == true
    @Condition eventPlayer._orb_collected != true
    @Condition getNumberOfHeroes(Hero.REAPER, getOppositeTeam(eventPlayer.getTeam())) > 0
    @Condition (any([player.isAlive() and distance(eventPlayer.getPosition(), player.getPosition()) < 5 and player.getNormalizedHealth() < 1 for player in getPlayersOnHero(Hero.REAPER, getOppositeTeam(eventPlayer.getTeam()))])) == true
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    eventPlayer.orb_pos = eventPlayer.getPosition()
    eventPlayer.startForcingPosition(eventPlayer.orb_pos, true)
    chase(eventPlayer.orb_pos, ((sorted([player for player in getPlayersOnHero(Hero.REAPER, getOppositeTeam(eventPlayer.getTeam())) if player.isAlive() and player.getNormalizedHealth() < 1], lambda i: distance(eventPlayer.getPosition(), i.getPosition())))[0]).getPosition(), rate=8, ChaseReeval.DESTINATION_AND_RATE)


rule "[reaper/reaping.opy]: stop following":
    @Event eachPlayer
    @Condition (eventPlayer._orb_collected != true or eventPlayer.isAlive()) == true
    @Condition (any([player.isAlive() and distance(eventPlayer.getPosition(), player.getPosition()) < 5 and player.getNormalizedHealth() < 1 for player in getPlayersOnHero(Hero.REAPER, getOppositeTeam(eventPlayer.getTeam()))]) or eventPlayer.isAlive()) == false
    
    eventPlayer.stopForcingPosition()
    stopChasingVariable(eventPlayer.orb_pos)
    if eventPlayer.isAlive() and not eventPlayer.isInSpawnRoom():
        wait(0.1)
        if not eventPlayer.hasStatusEffect(Status.BURNING):
            eventPlayer.teleport(random.choice(getSpawnPoints(eventPlayer.getTeam())))