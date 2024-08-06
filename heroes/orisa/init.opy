#!mainFile "../../dev_main.opy"

#!include "heroes/orisa/fortify.opy"
#!include "heroes/orisa/fusion_driver.opy"
#!include "heroes/orisa/barrier.opy"
#!include "heroes/orisa/halt.opy"
#!include "heroes/orisa/supercharger.opy"

rule "[orisa/init.opy]: Initialize Orisa":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer._call_init

    setCustomHp(ORISA_HEALTH, ORISA_ARMOR, 0)
    setUltCost(ORISA_ULT_COST)

    # Below variables are also declared and initialized in reset_hero.opy
    getPlayers(eventPlayer.getTeam()).friendly_orisa_player = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).enemy_orisa_player = eventPlayer
    
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer._is_using_supercharger = false

    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer._is_using_halt = false

    eventPlayer.disallowButton(Button.ABILITY_2)

    resetFusionDriver()
    showOrisaAmmoHud()
    eventPlayer._is_orisa_reloading = false
    setBaseDamage(eventPlayer, ORISA_FUSION_DRIVER_DAMAGE/OW2_ORISA_FUSION_DRIVER_DAMAGE)
    eventPlayer.setProjectileSpeed(percent(ORISA_GUN_PROJECTILE_SPEED/OW2_ORISA_GUN_PROJECTILE_SPEED))

    removeTankPassive()

    removeSelfHealing()

rule "[orisa/init.opy]: Clean up Orisa":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.ORISA

    waitUntil(eventPlayer.getCurrentHero() != Hero.ORISA, Math.INFINITY)
    destroyBarrier()
    endSupercharger()
    hideOrisaAmmoHud()


rule"[orisa/init.opy]: Hard code disallow orisa":
    @Event eachPlayer
    @Hero orisa
    @Condition (eventPlayer.isUsingAbility2() or eventPlayer.isFiringSecondaryFire())
    
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
