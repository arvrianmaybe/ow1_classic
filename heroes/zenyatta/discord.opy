#!mainFile "../../dev_main.opy"

playervar discord_orb_damage

rule "[zenyatta/discord.opy]: Set discord orb":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.setStatusEffect(null, Status.STUNNED, 0.016) # just leave this so they dont accidentally got the wrong target
    eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())).setDamageReceived(percent(ZENYATTA_DISCORD_ORB_TAKEN/OW2_ZENYATTA_DISCORD_ORB_TAKEN))
    eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())).discord_orb_damage = true
    waitUntil(not eventPlayer.isUsingAbility2(), Math.INFINITY)
    getAllPlayers().discord_orb_damage = false

rule "[zenyatta/discord.opy]: stop discord orb if no longer using it.":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.discord_orb_damage
    
    eventPlayer.setDamageReceived(100)