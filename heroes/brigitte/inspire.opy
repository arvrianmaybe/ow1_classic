#!mainFile "../../dev_main.opy"

rule "[brigitte/inspire.opy]: Inspire self healing logic":
    @Event playerDealtDamage
    @Hero brigitte

    pushSelfHealing(Button.MELEE)
    wait(BRIGITTE_INSPIRE_DURATION, Wait.RESTART_WHEN_TRUE)
    popSelfHealing(Button.MELEE)
