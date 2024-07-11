#!mainFile "../../dev_main.opy"


rule "[cassidy/deadeye.opy]: OW1 deadeye damage + remove OW2 damage reduction during deadeye":
    @Event eachPlayer
    @Hero cassidy
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.setDamageDealt(percent(CASSIDY_DEADEYE_DAMAGE/OW2_CASSIDY_DEADEYE_DAMAGE))
    eventPlayer.setDamageReceived(percent(100/(100-OW2_CASSIDY_DEADEYE_DAMAGE_REDUCTION)))
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.setDamageDealt(percent(eventPlayer._base_damage_scalar))
    eventPlayer.setDamageReceived(100)
