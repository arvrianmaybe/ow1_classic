#!mainFile "../../dev_main.opy"

#!define restartTurret()\
eventPlayer.allowButton(Button.INTERACT) \
eventPlayer.forceButtonPress(Button.INTERACT) \
eventPlayer.disallowButton(Button.INTERACT) \
eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0) \
eventPlayer.forceButtonPress(Button.ABILITY_1)

#!define restartTurretProgress()\
eventPlayer.turret_progress -= 100\
eventPlayer.turret_position = vect(0, -500, 0) \
eventPlayer.turret_level = 1 \
eventPlayer.turret_progress = 0 \
clearTurretHealth()

playervar turret_pvar
#!defineMember turret_position turret_pvar [0]
#!defineMember turret_level turret_pvar [1]
#!defineMember turret_progress turret_pvar [2]

subroutine setTurretHealth
subroutine clearTurretHealth


rule "[torbjorn/turret.opy]: Set turret":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.isOnGround()
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0
    
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.setProjectileGravity(Math.INFINITY)
    eventPlayer.setProjectileSpeed(0)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    eventPlayer.turret_level = 1
    eventPlayer.turret_position = raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + 10 * Vector.DOWN, null, null, true).getHitPosition() + vect(0, 0.1, 0)
    wait(0.1) # Small grace period
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setProjectileGravity(100)
    eventPlayer.disallowButton(Button.ABILITY_1)    
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, TORBJORN_TURRET_COOLDOWN)

rule "[torbjorn/turret.opy]: set turret if using it":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isUsingAbility1()
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0

    restartTurretProgress()
    restartTurret()

rule "[torbjorn/turret.opy]: reset turret":
    @Event eachPlayer
    @Hero torbjorn
    @Condition not eventPlayer.isUsingAbility1()

    restartTurretProgress()


rule "[torbjorn/turret.opy]: build turret":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.getCurrentWeapon() == 2
    @Condition eventPlayer.isFiringPrimaryFire() or eventPlayer.isHoldingButton(Button.MELEE)
    @Condition eventPlayer.turret_level < TORBJORN_TURRET_LEVEL_ULTIMATE
    @Condition (eventPlayer.turret_level < TOBRJORN_TURRET_LEVEL or eventPlayer.isUsingAbility2())
    
    wait(TICK_DURATION if eventPlayer.isUsingAbility2() else TICK_DURATION, Wait.ABORT_WHEN_FALSE)
    waitUntil(distance(eventPlayer.getPosition(), eventPlayer.turret_position) < TOBRJORN_TURRET_LEVEL and eventPlayer.isInViewAngle(eventPlayer.turret_position, 40), 0.192)
    if distance(eventPlayer.getPosition(), eventPlayer.turret_position) < TOBRJORN_TURRET_LEVEL and eventPlayer.isInViewAngle(eventPlayer.turret_position, 40):
        eventPlayer.turret_progress += TORBJORN_TURRET_UPGRADE_HIT


rule "[torbjorn/turret.opy]: upgrade turret":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.turret_progress >= 100
    
    if eventPlayer.isUsingAbility2():
        eventPlayer.turret_level = TORBJORN_TURRET_LEVEL_ULTIMATE
        smallMessage(eventPlayer, "Turret Supercharged")
    else:
        eventPlayer.turret_level += 1
        smallMessage(eventPlayer, "Turret Upgraded to level {0}".format(eventPlayer.turret_level))
        setTurretHealth()

rule "[torbjorn/turret.opy]: remove upgrade to level 2 if turret finished":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.turret_level >= TORBJORN_TURRET_LEVEL_ULTIMATE
    @Condition not eventPlayer.isUsingAbility2()
    
    eventPlayer.turret_level = TOBRJORN_TURRET_LEVEL
    setTurretHealth()
    
rule "[torbjorn/turret.opy]: instantly upgrade to level 3":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isUsingAbility2()
    @Condition eventPlayer.turret_level == TOBRJORN_TURRET_LEVEL
    
    eventPlayer.turret_level = TORBJORN_TURRET_LEVEL_ULTIMATE

def setTurretHealth():
    @Name "[torbjorn/turret.opy]: setTurretHealth()"

    eventPlayer.setMaxHealth(percent(TORBJORN_TURRET_HEALTH_LEVEL_2/TORBJORN_TURRET_HEALTH))

    wait() # Do not remove?? this wont reset the hp if you dont remove it for SOME reason
    setCustomHp(TORBJORN_HEALTH, 0, 0)

def clearTurretHealth():
    @Name "[torbjorn/turret.opy]: clearTurretHealth()"

    eventPlayer.setMaxHealth(100)
    wait() # Do not remove?? this wont reset the hp if you dont remove it for SOME reason
    setCustomHp(TORBJORN_HEALTH, 0, 0)

    eventPlayer.turret_level = 1