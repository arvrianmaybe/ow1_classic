#!mainFile "../../dev_main.opy"

rule "[dva/matrix.opy]: set defense matrix cooldown":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 0
    
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, DVA_MATRIX_COOLDOWN)