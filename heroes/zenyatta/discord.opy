#!mainFile "../../dev_main.opy"

playervar discord_orb_damage

rule "[zenyatta/discord.opy]: Set discord orb":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())).discord_orb_damage = true

rule "[zenyatta/discord.opy]: damage victim.":
    @Event eachPlayer
    @Condition eventPlayer.discord_orb_damage

    eventPlayer.setDamageReceived(120) # I have no idea where do you get that number but it is correct?
    waitUntil(not getPlayersOnHero(Hero.ZENYATTA, getOppositeTeam(eventPlayer.getTeam())).isUsingAbility2(), Math.INFINITY)
    eventPlayer.discord_orb_damage = false
    eventPlayer.setDamageReceived(100)
