#!mainFile "../../dev_main.opy"

playervar beam_visibility

playervar beam_multiplier_dmg

playervar beam_effects
#!defineMember beam_effect beam_effects [0]
#!defineMember beam_effect1 beam_effects [1]

rule "[symmetra/beam.opy]: set sym primary fire":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    @Condition eventPlayer.isAlive()
    @Condition not eventPlayer.isMeleeing()
    @Condition not eventPlayer.isFiringSecondaryFire()
    @Condition not eventPlayer.isReloading()
    @Condition not isCCd(eventPlayer)
    
    eventPlayer.setAmmo(0, eventPlayer.getAmmo(0) - 1)
    damage((sorted([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if eventPlayer.hasSpawned() and isInLoS(eventPlayer.getEyePosition(), 
    player.getEyePosition(), 
    BarrierLos.PASS_THROUGH_BARRIERS) and eventPlayer.isInViewAngle(player.getEyePosition(), 60) and distance(eventPlayer.getEyePosition(), 
    player.getEyePosition()) < 5], 
    lambda i: distance(eventPlayer.getEyePosition(), 
    i.getEyePosition())))[0], 
    eventPlayer, 
    floor(eventPlayer.beam_multiplier_dmg) * SYMETTRA_BEAM_DAMAGE)
    wait(SYMETRA_BEAM_INCREASE_PS)
    if RULE_CONDITION:
        goto RULE_START

rule "[symmetra/beam.opy]: make beam visible":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    @Condition not eventPlayer.isMeleeing()
    @Condition not eventPlayer.isFiringSecondaryFire()
    @Condition not eventPlayer.isReloading()
    
    eventPlayer.beam_visibility = getAllPlayers()

rule "[symmetra/beam.opy]: make beam not visible":
    @Event eachPlayer
    @Hero symmetra
    @Condition not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    @Condition not eventPlayer.isMeleeing()
    @Condition not eventPlayer.isFiringSecondaryFire()
    @Condition eventPlayer.isReloading()
    
    eventPlayer.beam_visibility = null

rule "[symmetra/beam.opy]: beam multiplier start":
    @Event playerDealtDamage
    @Hero symmetra
    @Condition eventAbility != Button.SECONDARY_FIRE
    @Condition eventAbility != Button.ABILITY_1
    @Condition eventAbility != Button.MELEE
    
    stopChasingVariable(eventPlayer.beam_multiplier_dmg)
    eventPlayer.beam_multiplier_dmg += SYMETRA_BEAM_INCREASE
    wait(SYMETRA_BEAM_INCREASE_PS, Wait.RESTART_WHEN_TRUE)
    chase(eventPlayer.beam_multiplier_dmg, 1, rate=SYMETTRA_BEAM_RATE, ChaseReeval.DESTINATION_AND_RATE)

rule "[symmetra/beam.opy]: symmetra multipier correction":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.beam_multiplier_dmg >= SYMETTRA_MAX_LEVEL
    
    eventPlayer.beam_multiplier_dmg = 3.9