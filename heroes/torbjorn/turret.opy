#!mainFile "../../dev_main.opy"

#!define restartTurret()\
eventPlayer.allowButton(Button.INTERACT) \
eventPlayer.forceButtonPress(Button.INTERACT) \
eventPlayer.disallowButton(Button.INTERACT) \
eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0) \
eventPlayer.forceButtonPress(Button.ABILITY_1) \

rule "[torbjorn/turret.opy]: Set turret":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0
    
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.setProjectileGravity(Math.INFINITY)
    eventPlayer.setProjectileSpeed(0)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
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

    restartTurret()