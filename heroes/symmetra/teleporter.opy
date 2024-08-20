#!mainFile "../../dev_main.opy"

playervar shield_gen

globalvar teleporter1
globalvar teleporter2
globalvar shield_gen 

playervar shield_gen_pvar
#!defineMember shield_gen_effect shield_gen_pvar [0]
#!defineMember shield_gen_effect2 shield_gen_pvar [1]
#!defineMember shield_gen_effect3 shield_gen_pvar [2]
#!defineMember shield_gen_effect4 shield_gen_pvar [3]

#!defineMember shield_gen_position shield_gen_pvar [4]
#!defineMember shiled_gen_owned shield_gen_pvar [5]
#!defineMember shield_gen_facing shield_gen_pvar [6]


playervar cords 
playervar objective 
playervar teleporter_up 
playervar teleporter_used 

subroutine createTeleporter 
subroutine destroyTeleporter 

rule"[symetra/teleporter.opy]: init teleporter":
    @Event global

    chase(teleporter1, raycast(getSpawnPoints(Team.1)[0], getSpawnPoints(Team.1)[0] + getSpawnPoints(Team.1)[0].getFacingDirection() * 8, null, null, false).getHitPosition(), rate=100, ChaseReeval.DESTINATION_AND_RATE)
    chase(teleporter2, raycast(getSpawnPoints(Team.2)[0], getSpawnPoints(Team.2)[0] + getSpawnPoints(Team.2)[0].getFacingDirection() * 8, null, null, false).getHitPosition(), rate=100, ChaseReeval.DESTINATION_AND_RATE)
    createEffect(getAllPlayers() if any([player.getCurrentHero() == Hero.SYMMETRA and player.teleporter_up for player in getPlayers(Team.1)]) else null, Effect.SPHERE, Team.1, teleporter1 + vect(0, 1, 0), 0.75, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers() if any([player.getCurrentHero() == Hero.SYMMETRA and player.teleporter_up for player in getPlayers(Team.2)]) else null, Effect.SPHERE, Team.2, teleporter2 + vect(0, 1, 0), 0.75, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createInWorldText(getAllPlayers() if any([player.getCurrentHero() == Hero.SYMMETRA and player.teleporter_up for player in getPlayers(Team.1)]) else null, "Teleporter by {0}".format(getPlayersOnHero(Hero.SYMMETRA, Team.1)[0]), teleporter1 + vect(0, 1, 0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Team.1, SpecVisibility.DEFAULT)
    createInWorldText(getAllPlayers() if any([player.getCurrentHero() == Hero.SYMMETRA and player.teleporter_up for player in getPlayers(Team.2)]) else null, "Teleporter by {0}".format(getPlayersOnHero(Hero.SYMMETRA, Team.2)[0]), teleporter2 + vect(0, 1, 0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Team.2, SpecVisibility.DEFAULT)


def createTeleporter():
    @Name "[symettra/teleporter.opy]: createTeleporter{}"
    
    eventPlayer.teleporter_up = false
    destroyEffect(eventPlayer.shield_gen_effect2)
    destroyInWorldText(eventPlayer.shield_gen_effect3)
    destroyEffect(eventPlayer.shield_gen_effect4)
    eventPlayer.setUltCharge(0)
    eventPlayer.teleporter_used = SYMMETRA_TELEPORTER_MAX_USE
    eventPlayer.objective = getCurrentObjective()
    eventPlayer.shield_gen = []
    eventPlayer.shiled_gen_owned = eventPlayer
    eventPlayer.shield_gen_position = eventPlayer.getPosition()
    eventPlayer.shield_gen_facing = vect(eventPlayer.getFacingDirection().x, 0, eventPlayer.getFacingDirection().z) * -1

    createEffect(getAllPlayers(), 
        Effect.SPHERE, 
        Color.BLUE, 
        eventPlayer.cords + vect(0, 0.75, 0), 0.75, 
        EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.shield_gen_effect2 = getLastCreatedEntity()

    createInWorldText(getAllPlayers(), "{0}'s Teleporter".format(eventPlayer), 
        eventPlayer.cords + vect(0, 0.75, 0), 
        1, 
        Clip.SURFACES, 
        WorldTextReeval.VISIBILITY_POSITION_AND_STRING, 
        Color.WHITE, 
        SpecVisibility.DEFAULT)
    eventPlayer.shield_gen_effect3 = getLastCreatedText()
    
    smallMessage(getPlayers(eventPlayer.getTeam()), "Teleporter created by {0}".format(eventPlayer))
    eventPlayer.teleporter_up = true


def destroyTeleporter():
    @Name "[symettra/teleporter.opy]: destroyTeleporter()"
    
    eventPlayer.setUltCharge(0)

    destroyEffect(eventPlayer.shield_gen_effect2)
    destroyInWorldText(eventPlayer.shield_gen_effect3)

    smallMessage(getPlayers(eventPlayer.getTeam()), " {0}'s Teleporter has been destroyed".format(eventPlayer))
    eventPlayer.teleporter_up = false
    if not (len(getPlayersInRadius(eventPlayer.shield_gen_position, 
        2, 
        getOppositeTeam(eventPlayer.getTeam()), 
        LosCheck.OFF)) > 0 and getPlayersInRadius(eventPlayer.shield_gen_position, 
        2, 
        getOppositeTeam(eventPlayer.getTeam()), 
        LosCheck.OFF)[0].isHoldingButton(Button.PRIMARY_FIRE)) and eventPlayer.objective != getCurrentObjective():
        eventPlayer.setUltCharge(16.667 * eventPlayer.teleporter_used)
    eventPlayer.teleporter_used = 0


rule "[symettra/teleporter.opy]: spawn teleporter":
    @Event eachPlayer
    @Hero symmetra
    @Condition not any([eventPlayer == player[0] for player in shield_gen])
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isAlive()
    
    
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ULTIMATE)

    eventPlayer.disallowButton(Button.MELEE)
    eventPlayer.disallowButton(Button.JUMP)
    eventPlayer.disallowButton(Button.CROUCH)
    eventPlayer.disallowButton(Button.RELOAD)
    eventPlayer.disallowButton(Button.INTERACT)

    eventPlayer.cords = eventPlayer.getPosition()
    chase(eventPlayer.cords, raycast(raycast(eventPlayer.getEyePosition(), 
        eventPlayer.getEyePosition() + vect(eventPlayer.getFacingDirection().x, 
        0, 
        eventPlayer.getFacingDirection().z) * 
        2.5, 
        null,  
        eventPlayer, true).getHitPosition() + Vector.UP, 
        raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + vect(eventPlayer.getFacingDirection().x, 
        0, 
        eventPlayer.getFacingDirection().z) * 10, 
        null, 
        eventPlayer, true).getHitPosition() + worldVector(vect(false, -100, -20), 
        eventPlayer, 
        Transform.ROTATION), 
        null, 
        eventPlayer, 
        true).getHitPosition(), 
        rate=1000, 
        ChaseReeval.DESTINATION_AND_RATE)
    createEffect(eventPlayer, Effect.SPHERE, Color.BLUE, eventPlayer.cords, 0.75, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.shield_gen_effect2 = getLastCreatedEntity()

    createInWorldText(eventPlayer, 
        "DEPLOY {0} |                     | {1} CANCEL".format(buttonString(Button.PRIMARY_FIRE), 
        buttonString(Button.SECONDARY_FIRE)), 
        updateEveryTick(eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 10 + vect(0, -0.65, 0)), 
        1.3, 
        Clip.NONE, 
        WorldTextReeval.VISIBILITY_POSITION_AND_STRING, 
        Color.WHITE, 
        SpecVisibility.DEFAULT)
    eventPlayer.shield_gen_effect3 = getLastCreatedText()

    createBeam(eventPlayer, 
        Beam.GOOD, 
        eventPlayer.cords + vect(0, 0.3, 0), 
        eventPlayer.cords + vect(0, 0.3, 0) + vect(eventPlayer.getFacingDirection().x, 0, eventPlayer.getFacingDirection().z) * 
        -1.25, 
        Color.BLUE, 
        EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.shield_gen_effect4 = getLastCreatedEntity()

    wait()
    waitUntil(eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) or eventPlayer.isHoldingButton(Button.PRIMARY_FIRE), Math.INFINITY)
    stopChasingVariable(eventPlayer.cords)
    destroyEffect(eventPlayer.shield_gen_effect2)
    destroyInWorldText(eventPlayer.shield_gen_effect3)
    destroyEffect(eventPlayer.shield_gen_effect4)

    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.allowButton(Button.ABILITY_1)

    eventPlayer.allowButton(Button.MELEE)
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.allowButton(Button.CROUCH)
    eventPlayer.allowButton(Button.RELOAD)
    eventPlayer.allowButton(Button.INTERACT)

    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        createTeleporter()
        eventPlayer.forceButtonPress(Button.RELOAD)
        wait(2)
        waitUntil(eventPlayer.isHoldingButton(Button.ULTIMATE) 
        or eventPlayer.teleporter_used <= 0 or len(getPlayersInRadius(eventPlayer.shield_gen, 
        2, 
        getOppositeTeam(eventPlayer.getTeam()), 
        LosCheck.OFF)) > 0 and getPlayersInRadius(eventPlayer.shield_gen, 
        2, 
        getOppositeTeam(eventPlayer.getTeam()), 
        LosCheck.OFF)[0].isHoldingButton(Button.PRIMARY_FIRE) 
        or eventPlayer.objective != getCurrentObjective(), Math.INFINITY)
        destroyTeleporter()


rule "[symettra/teleporter.opy]: remove tp if player left":
    @Event playerLeft
    @Condition eventPlayer.getCurrentHero() == Hero.SYMMETRA
    @Condition any([eventPlayer == player[0] for player in shield_gen])
    
    destroyTeleporter()


rule "[symettra/teleporter.opy]: tp player with tp 1":
    @Event eachPlayer
    @Team 1
    @Condition distance(eventPlayer.getPosition(), teleporter1) < 1
    @Condition getNumberOfHeroes(Hero.SYMMETRA, eventPlayer.getTeam()) > 0
    @Condition getPlayersOnHero(Hero.SYMMETRA, eventPlayer.getTeam())[0].teleporter_up
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isAlive()
    
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, eventPlayer.getTeam(), evalOnce(eventPlayer.getPosition()), 1)
    eventPlayer.teleport(getPlayersOnHero(Hero.SYMMETRA, eventPlayer.getTeam())[0].cords)
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, eventPlayer.getTeam(), eventPlayer.getPosition(), 1)
    getPlayersOnHero(Hero.SYMMETRA, eventPlayer.getTeam())[0].teleporter_used -= 1


rule "[symettra/teleporter.opy]: tp player with tp 2":
    @Event eachPlayer
    @Team 2
    @Condition distance(eventPlayer.getPosition(), teleporter2) < 1
    @Condition getNumberOfHeroes(Hero.SYMMETRA, eventPlayer.getTeam()) > 0
    @Condition getPlayersOnHero(Hero.SYMMETRA, eventPlayer.getTeam())[0].teleporter_up
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isAlive()
    
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, eventPlayer.getTeam(), evalOnce(eventPlayer.getPosition()), 1)
    eventPlayer.teleport(getPlayersOnHero(Hero.SYMMETRA, eventPlayer.getTeam())[0].cords)
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, eventPlayer.getTeam(), eventPlayer.getPosition(), 1)
    getPlayersOnHero(Hero.SYMMETRA, eventPlayer.getTeam())[0].teleporter_used -= 1