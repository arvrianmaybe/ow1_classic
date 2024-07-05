#!mainFile "../../dev_main.opy"

globalvar all_packs 
globalvar all_packs1 

playervar armor_packs 

playervar scrap_ready
playervar scrap_target

playervar closest_player

playervar scrap_health 
playervar scrap_timeout 
playervar scrap_position 
playervar scrap_effects 
playervar scrap_orb
playervar scrap_projectile 
playervar scrap_vel 
playervar scrap
playervar scrap_collected

 #!define torbjorScrap()\
 if eventPlayer.scrap_orb == null:\
 createEffect(getPlayersOnHero(Hero.TORBJORN, Team.ALL), Effect.ORB, Color.ORANGE, eventPlayer.scrap_position, 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)\
 eventPlayer.scrap_orb = getLastCreatedEntity()\
 eventPlayer.scrap_collected = false

#!define scrapCollected()\
 destroyEffect(eventPlayer.scrap_orb)\
 eventPlayer.scrap_orb = null

rule "[reaper/reaping.opy]: scrap collected":
    @Event eachPlayer
    @Condition eventPlayer.scrap_collected == true
    @Condition eventPlayer.isDead() == true
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    scrapCollected()

rule "[torbjorn/scrap.opy]: spawn scrap":
    @Event playerDied

    torbjorScrap()
    waitUntil(eventPlayer.isAlive(), Math.INFINITY)
    eventPlayer.scrap_collected = true

rule "[torbjorn/scrap.opy]: unallow armour pack":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.scrap < TORBJORN_SCRAP_ALLOW
     
    eventPlayer.setAbility2Enabled(false)
    wait()
    if RULE_CONDITION:
        goto RULE_START
 
 
rule "[torbjorn/scrap.opy]: allow armour pack":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.scrap >= TORBJORN_SCRAP_ALLOW
     
    eventPlayer.setAbility2Enabled(true)
    wait()
    if RULE_CONDITION:
        goto RULE_START

rule "[torbjorn/scrap.opy]: set armor pack":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == false
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.scrap >= TORBJORN_SCRAP_ALLOW
    @Condition eventPlayer.isAlive() == true
    
    eventPlayer.scrap -= TORBJORN_SCRAP_ALLOW
    createEffect(getPlayers(eventPlayer.getTeam()), Effect.SPHERE, Color.YELLOW, eventPlayer.scrap_position[0], 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.scrap_projectile = getLastCreatedEntity()
    eventPlayer.scrap_position[0] = eventPlayer.getEyePosition()
    smallMessage(getPlayers(eventPlayer.getTeam()), "Armor pack created by {0}".format(eventPlayer))
    if eventPlayer.getVerticalFacingAngle() <= -88.99 or eventPlayer.getVerticalFacingAngle() >= 88.99:
        if eventPlayer.getVerticalFacingAngle() <= -88.99:
            eventPlayer.scrap_vel = Vector.UP * 25
        else:
            eventPlayer.scrap_vel = Vector.DOWN * 25
    else:
        eventPlayer.scrap_vel = (normalize(eventPlayer.getFacingDirection() + Vector.UP * 0.09)) * 25
    eventPlayer.scrap_timeout = 0
    while raycast(eventPlayer.scrap_position[0], eventPlayer.scrap_position[0] + eventPlayer.scrap_vel / 61.881, getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())), null, true).getHitPosition() == eventPlayer.scrap_position[0] + eventPlayer.scrap_vel / 61.881 and eventPlayer.scrap_timeout <= 5:
        eventPlayer.scrap_vel -= vect(0, 0.325, 0)
        eventPlayer.scrap_position[0] += eventPlayer.scrap_vel / 62.5
        eventPlayer.scrap_timeout += 0.016
        wait()
    destroyEffect(eventPlayer.scrap_projectile)
    eventPlayer.armor_packs.append(eventPlayer.scrap_position)
    createEffect(getPlayers(eventPlayer.getTeam()), Effect.SPHERE, Color.YELLOW, eventPlayer.armor_packs[eventPlayer.armor_packs.index(evalOnce(eventPlayer.armor_packs.last()))], 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.scrap_effects.append(getLastCreatedEntity())

rule "[torbjorn/scrap.opy]: get player and append":
    @Event eachPlayer
    @Team 1
    @Hero torbjorn
    @Condition len(eventPlayer.armor_packs) > 0
    @Condition (any([not player in all_packs for player in eventPlayer.armor_packs])) == true
    
    all_packs.append(eventPlayer.armor_packs.exclude(all_packs))
    wait(0.1)
    if RULE_CONDITION:
        goto RULE_START


rule "[torbjorn/scrap.opy]: get player and append":
    @Event eachPlayer
    @Team 2
    @Hero torbjorn
    @Condition len(eventPlayer.armor_packs) > 0
    @Condition (any([not player in all_packs1 for player in eventPlayer.armor_packs])) == true
    
    all_packs1.append(eventPlayer.armor_packs.exclude(all_packs1))
    wait(0.1)
    if RULE_CONDITION:
        goto RULE_START


rule "[torbjorn/scrap.opy]: update closest armor":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned() == true
    @Condition getNumberOfHeroes(Hero.TORBJORN, eventPlayer.getTeam()) > 0
    @Condition len(all_packs) > 0
    @Condition eventPlayer.isAlive() == true
    
    wait(0.048, Wait.ABORT_WHEN_FALSE)
    eventPlayer.scrap_ready = sorted(all_packs, lambda player: distance(eventPlayer.getPosition(), player))
    eventPlayer.closest_player = [player for player in getPlayersOnHero(Hero.TORBJORN, Team.ALL) if eventPlayer.scrap_ready in player.armor_packs]
    if RULE_CONDITION:
        goto RULE_START


rule "[torbjorn/scrap.opy]: update closest armor 2":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.hasSpawned() == true
    @Condition getNumberOfHeroes(Hero.TORBJORN, eventPlayer.getTeam()) > 0
    @Condition len(all_packs1) > 0
    @Condition eventPlayer.isAlive() == true
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    eventPlayer.scrap_ready = sorted(all_packs1, lambda player: distance(eventPlayer.getPosition(), player))
    eventPlayer.closest_player = getPlayersOnHero(Hero.TORBJORN, eventPlayer.getTeam())[all_packs1.index(eventPlayer.scrap_ready)]
    if RULE_CONDITION:
        goto RULE_START


rule "[torbjorn/scrap.opy]: give player armor":
    @Event eachPlayer
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition getNumberOfHeroes(Hero.TORBJORN, eventPlayer.getTeam()) > 0
    @Condition distance(eventPlayer.getPosition(), eventPlayer.scrap_ready) < 1
    @Condition any([eventPlayer.scrap_ready in player.armor_packs for player in getPlayersOnHero(Hero.TORBJORN, eventPlayer.getTeam())]) == true
    @Condition eventPlayer.scrap_ready != vect(0, 0, 0)
    @Condition eventPlayer.scrap_ready != 0
    @Condition eventPlayer.getHealthOfType(Health.ARMOR) < eventPlayer._hp_health + TORBJORN_SCRAP_ARMOR
    
    wait(0.048, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.closest_player == eventPlayer:
        smallMessage(eventPlayer, "+75 Armor From your Armor pack")
    else:
        smallMessage(eventPlayer.closest_player, "{0} used your Armor Pack".format(eventPlayer))
        smallMessage(eventPlayer, "+75 Armor From {0}'s Armor Pack".format(eventPlayer.closest_player))
    removeHealthPool(eventPlayer.scrap_health)
    eventPlayer.scrap_target = TORBJORN_SCRAP_ARMOR
    eventPlayer.addHealthPool(Health.ARMOR, eventPlayer.scrap_target, false, true)
    eventPlayer.scrap_health = getLastCreatedHealthPool()
    destroyEffect(eventPlayer.closest_player.scrap_effects[eventPlayer.closest_player.armor_packs.index(eventPlayer.scrap_ready)])
    eventPlayer.closest_player.armor_packs[eventPlayer.closest_player.armor_packs.index(eventPlayer.scrap_ready)] = vect(0, -500, 0)
    if eventPlayer.getTeam() == Team.1:
        all_packs.remove(eventPlayer.scrap_ready)
    else:
        all_packs1.remove(eventPlayer.scrap_ready)

rule "[torbjorn/scrap.opy]: scrap never overflow":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.scrap > TORBJORN_SCRAP_MAX
    
    eventPlayer.scrap = TORBJORN_SCRAP_MAX
    wait()
    if RULE_CONDITION:
        goto RULE_START


rule "[torbjorn/scrap.opy]:  scrap magnet":
    @Event eachPlayer
    @Condition eventPlayer.isDead() == true
    @Condition eventPlayer.scrap_collected != true
    @Condition getPlayersOnHero(Hero.TORBJORN, Team.ALL) > 0
    @Condition (any([player.isAlive() and player.scrap < TORBJORN_SCRAP_MAX and player != eventPlayer and distance(eventPlayer.getPosition(), player.getPosition()) < 5 for player in getPlayersOnHero(Hero.TORBJORN, Team.ALL)])) == true
    
    chase(eventPlayer.orb_pos, ((sorted([player for player in getPlayersOnHero(Hero.TORBJORN, Team.ALL) if player.isAlive() and player.scrap < TORBJORN_SCRAP_MAX and player != eventPlayer], lambda i: distance(eventPlayer.getPosition(), i.getPosition())))[0]).getPosition(), rate=8, ChaseReeval.DESTINATION_AND_RATE)


rule "[torbjorn/scrap.opy]: scrap magnet off":
    @Event eachPlayer
    @Condition (eventPlayer.scrap_collected != true or eventPlayer.isAlive()) == true
    @Condition (any([player.isAlive() and player.scrap < TORBJORN_SCRAP_MAX and player != eventPlayer and distance(eventPlayer.getPosition(), player.getPosition()) > 5 for player in getPlayersOnHero(Hero.TORBJORN, Team.ALL)]) or eventPlayer.isAlive()) == true
    
    stopChasingVariable(eventPlayer.orb_pos)