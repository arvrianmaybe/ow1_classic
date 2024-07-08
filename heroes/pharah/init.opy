#!mainFile "../../dev_main.opy"

#!include "heroes/pharah/rocket_launcher.opy"
#!include "heroes/pharah/concussive.opy"
#!include "heroes/pharah/barrage.opy"

rule "[pharah/init.opy]: Initialize Pharah":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer._call_init

    setCustomHp(PHARAH_HEALTH, 0, 0)
    setUltCost(PHARAH_ULT_COST)
    removeSelfHealing()

    eventPlayer.setSecondaryFireEnabled(false)

    eventPlayer.setKnockbackDealt(percent(PHARAH_CONCUSSIVE_BLAST_KNOCKBACK/OW2_PHARAH_CONCUSSIVE_BLAST_KNOCKBACK))

    eventPlayer._call_init = false
