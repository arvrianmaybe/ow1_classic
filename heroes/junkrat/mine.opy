#!mainFile "../../dev_main.opy"

rule "[junkrat/mine.opy]: Only one mine":
    @Event eachPlayer
    @Hero junkrat
    @Condition eventPlayer.isUsingAbility1()
    
    eventPlayer.disallowButton(Button.ABILITY_1)
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.setAbilityCharge(Button.ABILITY_1, 0)
    wait(JUNKRAT_CONCUSSION_MINE_COOLDOWN)
    eventPlayer.setAbilityCharge(Button.ABILITY_1, 2)
    eventPlayer.allowButton(Button.ABILITY_1)
