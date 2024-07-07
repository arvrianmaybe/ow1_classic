#!mainFile "../../dev_main.opy"


rule "[sigma/accretion.opy]: Set sigma barrier cooldown":
    @Event eachPlayer
    @Hero sigma
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 0
    
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0.2)