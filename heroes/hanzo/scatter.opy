#!mainFile "../../dev_main.opy"


# Scatter Arrow Code by Josbird https://workshop.codes/NWHYT

playervar scatter_pvar
#!defineMember _scatter_time scatter_pvar [0]
#!defineMember _scatter_velocity scatter_pvar [1] 
#!defineMember _scatter_position scatter_pvar [2]
playervar scatter_time
playervar extend_player_collection 

subroutine fireScatterArrow 


def fireScatterArrow():
    @Name "[hanzo/scatter.opy]:  fireScatterArrow()"
    
    waitUntil(raycast(eventPlayer._scatter_position + (eventPlayer._scatter_velocity * (getTotalTimeElapsed() - eventPlayer._scatter_time - 0.032)) + ((0.5 * 9.82 * Vector.DOWN * (getTotalTimeElapsed() - eventPlayer._scatter_time - 0.032)) * (getTotalTimeElapsed() - eventPlayer._scatter_time - 0.032)), eventPlayer._scatter_position + (eventPlayer._scatter_velocity * (getTotalTimeElapsed() - eventPlayer._scatter_time)) + ((0.5 * 9.82 * Vector.DOWN * (getTotalTimeElapsed() - eventPlayer._scatter_time)) * (getTotalTimeElapsed() - eventPlayer._scatter_time)), getPlayers(getOppositeTeam(eventPlayer.getTeam())), getPlayers(eventPlayer.getTeam()), true).getHitPosition() != eventPlayer._scatter_position + (eventPlayer._scatter_velocity * (getTotalTimeElapsed() - eventPlayer._scatter_time)) + ((0.5 * 9.82 * Vector.DOWN * (getTotalTimeElapsed() - eventPlayer._scatter_time)) * (getTotalTimeElapsed() - eventPlayer._scatter_time)), 100)
    eventPlayer.extend_player_collection = raycast(eventPlayer._scatter_position + (eventPlayer._scatter_velocity * (getTotalTimeElapsed() - eventPlayer._scatter_time - 0.032)) + ((0.5 * 9.82 * Vector.DOWN * (getTotalTimeElapsed() - eventPlayer._scatter_time - 0.032)) * (getTotalTimeElapsed() - eventPlayer._scatter_time - 0.032)), eventPlayer._scatter_position + (eventPlayer._scatter_velocity * (getTotalTimeElapsed() - eventPlayer._scatter_time)) + ((0.5 * 9.82 * Vector.DOWN * (getTotalTimeElapsed() - eventPlayer._scatter_time)) * (getTotalTimeElapsed() - eventPlayer._scatter_time)), getPlayers(getOppositeTeam(eventPlayer.getTeam())), getPlayers(eventPlayer.getTeam()), true).getHitPosition()
    eventPlayer.extend_player_collection = raycast(eventPlayer._scatter_position + (eventPlayer._scatter_velocity * (getTotalTimeElapsed() - eventPlayer._scatter_time - 0.032)) + ((0.5 * 9.82 * Vector.DOWN * (getTotalTimeElapsed() - eventPlayer._scatter_time - 0.032)) * (getTotalTimeElapsed() - eventPlayer._scatter_time - 0.032)), eventPlayer._scatter_position + (eventPlayer._scatter_velocity * (getTotalTimeElapsed() - eventPlayer._scatter_time)) + ((0.5 * 9.82 * Vector.DOWN * (getTotalTimeElapsed() - eventPlayer._scatter_time)) * (getTotalTimeElapsed() - eventPlayer._scatter_time)), getPlayers(getOppositeTeam(eventPlayer.getTeam())), getPlayers(eventPlayer.getTeam()), true).getNormal()
    eventPlayer.extend_player_collection = eventPlayer._scatter_velocity + (9.82 * Vector.DOWN * (getTotalTimeElapsed() - eventPlayer._scatter_time)) - ((2 * (dotProduct(eventPlayer._scatter_velocity + (9.82 * Vector.DOWN * (getTotalTimeElapsed() - eventPlayer._scatter_time)), normalize(eventPlayer.extend_player_collection)))) * normalize(eventPlayer.extend_player_collection))
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.TEAM_1 if eventPlayer.getTeam() == Team.1 else Color.TEAM_2, eventPlayer.extend_player_collection, 0.7)
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.WHITE, eventPlayer.extend_player_collection, 70)
    eventPlayer.extend_player_collection = 0
    while eventPlayer.extend_player_collection < HANZO_SCATTER_ARROW_ARROWS - 1:
        createProjectile(Projectile.ORB, eventPlayer, eventPlayer.extend_player_collection, angleToDirection(horizontalAngleOfDirection(eventPlayer.extend_player_collection) - (HANZO_SCATTER_ARROW_RICOCHET_AMMOUNT * (cosDeg(90 + (eventPlayer.extend_player_collection * (360 / (HANZO_SCATTER_ARROW_ARROWS - 1)))))), verticalAngleOfDirection(eventPlayer.extend_player_collection) - (HANZO_SCATTER_ARROW_RICOCHET_AMMOUNT * (sinDeg(90 + (eventPlayer.extend_player_collection * (360 / (HANZO_SCATTER_ARROW_ARROWS - 1))))))), Relativity.TO_WORLD, ModifyHealth.DAMAGE, getOppositeTeam(eventPlayer.getTeam()), HANZO_SCATTER_ARROW_DAMAGE, HANZO_SCATTER_ARROW_SPREAD, 0, DynamicEffect.BAD_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 0, 110, 3, 0, HANZO_SCATTER_ARROW_DAMAGE, 9.82)
        eventPlayer.extend_player_collection += 1


rule "[hanzo/scatter.opy]: fire scatter arrow":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    @Condition not isCCd(eventPlayer)
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    
    waitUntil(eventPlayer.isUsingAbility2(), 0.3)
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        async(fireScatterArrow, AsyncBehavior.NOOP)
        eventPlayer.disallowButton(Button.PRIMARY_FIRE)
        eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
        while eventPlayer.isUsingAbility2():
            eventPlayer.forceButtonPress(Button.ABILITY_2)
            wait()
        eventPlayer.setAbilityCooldown(Button.ABILITY_2, HANZO_SCATTER_ARROW_COOLDOWN)
    else:
        waitUntil(eventPlayer.isFiringPrimaryFire() or not eventPlayer.isUsingAbility2(), 5)
        if eventPlayer.isFiringPrimaryFire():
            async(fireScatterArrow, AsyncBehavior.NOOP)
            eventPlayer.disallowButton(Button.PRIMARY_FIRE)
            eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
            while eventPlayer.isUsingAbility2():
                eventPlayer.forceButtonPress(Button.ABILITY_2)
                wait()
            eventPlayer.setAbilityCooldown(Button.ABILITY_2, HANZO_SCATTER_ARROW_COOLDOWN)
        else:
            eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0.2)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)

rule "[hanzo/scatter.opy]: remove scatter arrow critical hit":
    @Event playerDealtDamage
    @Hero hanzo
    @Condition eventWasCriticalHit
    @Condition eventPlayer.isUsingAbility2()

    heal(victim, null, eventDamage)
    damage(victim, eventPlayer, HANZO_SCATTER_ARROW_DAMAGE)

rule "[hanzo/scatter.opy]: Slow down hanzo when using scatter":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.isUsingAbility2()

    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar*(1-HANZO_SCATTER_ARROW_MOVE_PENALTY))
    waitUntil((not eventPlayer.isUsingAbility2()), Math.INFINITY)
    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar/(1-HANZO_SCATTER_ARROW_MOVE_PENALTY))
