#!mainFile "../../dev_main.opy"

#!include "heroes/bastion/configuration.opy"
#!include "heroes/bastion/repair.opy"
#!include "heroes/bastion/machine_gun.opy"

rule "[bastion/init.opy]: Initialize Bastion":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer._call_init

    setCustomHp(BASTION_HEALTH, BASTION_ARMOR, 0)
    setUltCost(BASTION_ULT_COST)
    eventPlayer.machine_gun_ammo = BASTION_SENTRY_CONFIG_CLIP_SIZE
    eventPlayer.machine_gun_reload_timer = 0

    eventPlayer.setMaxAmmo(0, BASTION_CLIP_SIZE)
    eventPlayer.setAmmo(0, BASTION_CLIP_SIZE)

    eventPlayer.disallowButton(Button.SECONDARY_FIRE)

    removeSelfHealing()
    eventPlayer._call_init = false


rule "[bastion/init.opy]: Clean up Bastion":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.BASTION
    
    waitUntil(eventPlayer.getCurrentHero() != Hero.BASTION, Math.INFINITY)
    removeHealthPool(eventPlayer.tank_armor)
    hideMachineGunAmmo()
    hideSelfRepairRing()