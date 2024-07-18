#!mainFile "../../dev_main.opy"


rule "[dva/remech.opy]: set remech damage":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isInAlternateForm()
    
    waitUntil(eventPlayer.isUsingUltimate() or eventPlayer.isDead() or not eventPlayer.isInAlternateForm(), Math.INFINITY)
    if eventPlayer.isInAlternateForm():
        eventPlayer.setDamageDealt(percent(DVA_REMECH_DAMAGE/OW2_DVA_REMECH_DAMAGE))
        waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
        eventPlayer.setDamageDealt(100)