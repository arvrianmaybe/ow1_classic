#!mainFile "../../main.opy"

playervar hammond_shield_pvar

#!defineMember ow2_adaptive_shield_n hammond_shield_pvar [0]
#!defineMember ow1_adaptive_shield_n hammond_shield_pvar [1]

#!define getOW1AdaptiveShields(n) (WRECKING_BALL_SHIELD_PER_TARGET*n + WRECKING_BALL_ADAPTIVE_SHIELD_BASE)
#!define getOW2AdaptiveShields(n) (OW2_WRECKING_BALL_SHIELD_PER_TARGET*n + OW2_WRECKING_BALL_ADAPTIVE_SHIELD_BASE)

rule "[hammond/shields.opy]: OW1 Adaptive Shields":
    @Event eachPlayer
    @Hero hammond
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.ow2_adaptive_shield_n = len(getPlayersInRadius(eventPlayer.getEyePosition(), 
                                                               OW2_WRECKING_BALL_ADAPTIVE_SHIELD_RADIUS, 
                                                               getOppositeTeam(eventPlayer.getTeam()), 
                                                               LosCheck.SURFACES_AND_ALL_BARRIERS))
    eventPlayer.ow1_adaptive_shield_n = len(getPlayersInRadius(eventPlayer.getEyePosition(), 
                                                               WRECKING_BALL_ADAPTIVE_SHIELD_RADIUS, 
                                                               getOppositeTeam(eventPlayer.getTeam()), 
                                                               LosCheck.SURFACES_AND_ALL_BARRIERS))

    damage(eventPlayer, null, getOW2AdaptiveShields(eventPlayer.ow2_adaptive_shield_n) - getOW1AdaptiveShields(eventPlayer.ow1_adaptive_shield_n))


rule "[hammond/shields.opy]: Disable OW2 shield transfer":
    @Event eachPlayer
    @Hero hammond
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.disallowButton(Button.ABILITY_2)
    wait(OW2_WRECKING_BALL_ADAPTIVE_SHIELD_DURATION)
    eventPlayer.allowButton(Button.ABILITY_2)