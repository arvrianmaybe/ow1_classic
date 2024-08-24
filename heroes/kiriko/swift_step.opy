#!mainFile "../../dev_main.opy"

rule "[kiriko/swift_step.opy]: Heal when using Swift Step":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.isUsingAbility1()

    heal(eventPlayer, eventPlayer, KIRIKO_SWIFT_STEP_HEALING)
