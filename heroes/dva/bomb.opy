#!mainFile "../../dev_main.opy"

globalvar radius 

playervar bomb_pvar
#!defineMember _point_position bomb_pvar [0]
#!defineMember _hit_normal bomb_pvar [1]
#!defineMember _center_point bomb_pvar [2]
#!defineMember _eye_posiiton bomb_pvar [3]
#!defineMember _init_normal bomb_pvar [4]

playervar ultimate_duration

subroutine normalTracking 
subroutine downwardsTracking 

rule "[dva/bomb.opy]: Force reset ult charge when DVa pops out of Mech":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isInAlternateForm()

    if eventPlayer.isUsingUltimate(): return
    eventPlayer.setUltCharge(0)


rule "[dva/bomb.opy]: set bomb position":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition eventPlayer.isUsingUltimate()
    
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer._eye_posiiton = eventPlayer.getEyePosition() + worldVector(Vector.BACKWARD, eventPlayer, Transform.ROTATION)
    eventPlayer._point_position = raycast(eventPlayer._eye_posiiton, eventPlayer._eye_posiiton + worldVector(vect(0, 0, 3), eventPlayer, Transform.ROTATION), eventPlayer, null, true).getHitPosition()
    eventPlayer._hit_normal = raycast(eventPlayer._eye_posiiton, eventPlayer._eye_posiiton + worldVector(vect(0, 0, 3), eventPlayer, Transform.ROTATION), eventPlayer, null, true).getNormal()
    eventPlayer._center_point = eventPlayer._point_position + eventPlayer._hit_normal * radius * -1
    if eventPlayer.getFacingDirection().y < -0.2:
        eventPlayer._init_normal = Vector.UP
        downwardsTracking()
    else:
        eventPlayer._init_normal = eventPlayer._hit_normal * vect(1, 0, 1)
        normalTracking()
    wait()
    eventPlayer.allowButton(Button.ULTIMATE)


rule "[dva/bomb.opy]: Kill dva from bomb":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.ultimate_duration >= 65
    @Condition isInLoS(eventPlayer, eventPlayer._center_point, BarrierLos.PASS_THROUGH_BARRIERS)
    @Condition distance(eventPlayer._center_point, eventPlayer) < 20.5
    
    eventPlayer.applyImpulse(directionTowards(eventPlayer._center_point, eventPlayer) + (vect(0, 0.5 - directionTowards(eventPlayer._center_point, eventPlayer).y, 0)), 22.1, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    damage(eventPlayer, null, (min(DVA_BOMB_DAMAGE, DVA_BOMB_DAMAGE - (59.375 * (distance(eventPlayer._center_point, eventPlayer) - 4.5)))) * (distance(eventPlayer._center_point, eventPlayer) <= 20.5))


def normalTracking():
    @Name "[dva/bomb.opy]: normalTracking()"
    
    for eventPlayer.ultimate_duration in range(65):
        eventPlayer._point_position = raycast(eventPlayer._center_point + eventPlayer._init_normal * radius, eventPlayer._center_point + eventPlayer._init_normal * -1 * 0.5, eventPlayer, null, true).getHitPosition()
        eventPlayer._hit_normal = raycast(eventPlayer._point_position + eventPlayer._init_normal * 0.3, eventPlayer._point_position + eventPlayer._init_normal * -1, eventPlayer, null, true).getNormal()
        eventPlayer._center_point = eventPlayer._point_position + eventPlayer._hit_normal * radius * -1
        wait(false)
    wait()
    eventPlayer.ultimate_duration = 0


def downwardsTracking():
    @Name "[dva/bomb.opy]: downwardsTracking()"
    
    for eventPlayer.ultimate_duration in range(65):
        if eventPlayer.ultimate_duration > 160:
            eventPlayer._point_position = raycast(eventPlayer._center_point + eventPlayer._init_normal * 2, eventPlayer._center_point + eventPlayer._init_normal * -1 * 2, eventPlayer, null, true).getHitPosition()
            eventPlayer._hit_normal = raycast(eventPlayer._point_position + eventPlayer._init_normal * 0.3, eventPlayer._point_position + eventPlayer._init_normal * -1, eventPlayer, null, true).getNormal()
            eventPlayer._center_point = eventPlayer._point_position + eventPlayer._hit_normal * radius * -1
        else:
            eventPlayer._point_position = raycast(eventPlayer._center_point + eventPlayer._init_normal, eventPlayer._center_point + eventPlayer._init_normal * -1, eventPlayer, null, true).getHitPosition()
            eventPlayer._hit_normal = raycast(eventPlayer._point_position + eventPlayer._init_normal * 0.3, eventPlayer._point_position + eventPlayer._init_normal * -1, eventPlayer, null, true).getNormal()
            eventPlayer._center_point = eventPlayer._point_position + eventPlayer._hit_normal * radius * -1
        wait(false)
    wait()
    eventPlayer.ultimate_duration = 0
