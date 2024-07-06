#!mainFile "../../dev_main.opy"

rule "[illari/init.opy]: Initialize Illari":
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer._call_init

    setCustomHp(ILLARI_HEALTH, 0, 0)
    setUltCost(ILLARI_ULT_COST)

    eventPlayer._call_init = false