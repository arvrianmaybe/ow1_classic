#!mainFile "../../dev_main.opy"

playervar jq_self_heal_id
    
rule "[junkerqueen/init.opy]: Initialize Junker Queen":
    @Event eachPlayer
    @Hero junkerQueen
    @Condition eventPlayer._call_init

    setCustomHp(JUNKERQUEEN_HEALTH, JUNKERQUEEN_ARMOR, 0)
    setBaseDamage(eventPlayer, JUNKERQUEEN_RAMPAGE_WOUND_DAMAGE/OW2_JUNKERQUEEN_RAMPAGE_WOUND_DAMAGE)
    setUltCost(JUNKERQUEEN_ULT_COST)

    startHealingModification(eventPlayer, eventPlayer, percent(JUNKERQUEEN_ADRENALINE/OW2_JUNKERQUEEN_ADRENALINE), HealingReeval.NONE)
    eventPlayer.jq_self_heal_id = getLastHealingModification()

    removeTankPassive()
    removePassiveHealing()
    eventPlayer._call_init = false


rule "[junkerqueen/init.opy]: Clean up Junker Queen":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.JUNKER_QUEEN

    waitUntil(eventPlayer.getCurrentHero() != Hero.JUNKER_QUEEN, Math.INFINITY)
    stopHealingModification(eventPlayer.jq_self_heal_id)


rule "[junkerqueen/init.opy]: Compensate Junkerqueen global damage reduction":
    @Event playerDealtDamage
    @Hero junkerQueen
    @Condition eventAbility in [Button.MELEE, Button.PRIMARY_FIRE, Button.SECONDARY_FIRE, Button.ABILITY_2]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)