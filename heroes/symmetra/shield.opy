#!mainFile "../../dev_main.opy"

playervar hp 
playervar shield_pvar
#!defineMember _shield shield_pvar [0]
#!defineMember _shield_target shield_pvar [1]
#!defineMember _is_shielded shield_pvar [2]
#!defineMember _shield_visual_effect shield_pvar [3]

rule "[symmetra/_shield.opy]: set symmetras _shield":
    @Event eachPlayer
    @Hero symmetra
    @Condition any([i._shield != true for i in getLivingPlayers(eventPlayer.getTeam()).exclude(eventPlayer)])
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0
    @Condition (any([eventPlayer.isInViewAngle(i.getEyePosition(), 45) and distance(eventPlayer.getEyePosition(), i.getEyePosition()) < 20 and isInLoS(eventPlayer.getEyePosition(), i.getEyePosition(), BarrierLos.PASS_THROUGH_BARRIERS) for i in [i for i in ([player for player in getLivingPlayers(eventPlayer.getTeam()) if player._is_shielded != true]).exclude(eventPlayer) if i.hasSpawned()]]))
    @Condition len([player for player in getLivingPlayers(eventPlayer.getTeam()) if player.hasSpawned()]) > 1
    @Condition eventPlayer.isAlive()
    
    eventPlayer._shield_target = (sorted([i for i in getLivingPlayers(eventPlayer.getTeam()).exclude(eventPlayer) if i.hasSpawned() and distance(eventPlayer.getEyePosition(), i.getEyePosition()) < 20 and i._shield!= true], lambda i: distance(raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + 10 * eventPlayer.getFacingDirection(), getPlayers(eventPlayer.getTeam()), eventPlayer, true).getHitPosition(), i.getEyePosition())))[0]
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, eventPlayer.getTeam(), eventPlayer._shield_target.getEyePosition(), 1)

    eventPlayer._shield_target.addHealthPool(Health.NORMAL, SYMMETRA_EXTRA_SHIELDS, false, false)
    eventPlayer._shield_target.hp = getLastCreatedHealthPool()
    eventPlayer._shield_target._is_shielded = true

    smallMessage(eventPlayer._shield_target, "+25 Shield From {}".format(eventPlayer))

    eventPlayer.setAbilityCooldown(Button.ABILITY_2, SYMETTRA_SHIELDS_COOLDOWN)
    if eventPlayer.getAmmo(0) >= 100:
        eventPlayer.setAmmo(0, 99)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.forceButtonPress(Button.RELOAD)
    wait(0.5)
    if eventPlayer.isReloading():
        eventPlayer.cancelPrimaryAction()
    if eventPlayer.getAmmo(0) >= 99:
        eventPlayer.setAmmo(0, 100)
    eventPlayer.allowButton(Button.ABILITY_1)

    wait(SYMMETTRA_SHIELDS_DURATION)
    eventPlayer._shield_target._is_shielded = false
    removeHealthPool(eventPlayer._shield_target.hp)