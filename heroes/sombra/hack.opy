#!mainFile "../../dev_main.opy"

playervar hack_timer

#!define isHacked(player) (player.hack_timer > 0)


rule "[sombra/hack.opy]: Apply OW1 hack on top of OW2 hack":
    @Event eachPlayer
    @Condition eventPlayer.hasStatusEffect(Status.HACKED)

    stopChasingVariable(eventPlayer.hack_timer)
    eventPlayer.setStatusEffect(eventPlayer.enemy_sombra_player, Status.HACKED, SOMBRA_HACK_ENEMY_DURATION)
    eventPlayer.hack_timer = SOMBRA_HACK_ENEMY_DURATION
    chase(eventPlayer.hack_timer, 0, rate=1, ChaseReeval.NONE)

rule "[sombra/hack.opy]: Reset hack if has stealth passive":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.isFiringSecondaryFire()

    do:
        wait(3, Wait.ABORT_WHEN_FALSE)
        damage(eventPlayer, null, MIN_DAMAGE)
        heal(eventPlayer, null, MIN_DAMAGE)
        eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0)
    while RULE_CONDITION