#!mainFile "../../dev_main.opy"

playervar rally_hot_id

playervar fake_rally

playervar rally_armor

playervar fake_rally_effects_pvar
#!defineMember fake_rally_id fake_rally_effects_pvar [0]
#!defineMember fake_rally_id1 fake_rally_effects_pvar [1]
#!defineMember fake_rally_id2 fake_rally_effects_pvar [2]

playervar rally_pvar
#!defineMember _is_using_fake_rally rally_pvar[0]
#!defineMember _brig_hp rally_pvar [1]
#!defineMember _brig_armor rally_pvar [2]
#!defineMember _repair_cooldown rally_pvar [3]
#!defineMember _whip_cooldown rally_pvar [4]
#!defineMember _bash_cooldown rally_pvar [5]

subroutine launchRally

subroutine startRally
subroutine endRally

rule "[brigitte/rally.opy]: brigitte died":
    @Event playerDied
    @Hero brigitte
    @Condition eventPlayer.fake_rally

    endRally()
    eventPlayer.respawn()
    eventPlayer.startForcingHero(Hero.ANA)
    eventPlayer.stopForcingCurrentHero()
    eventPlayer.startForcingHero(Hero.BRIGITTE)
    eventPlayer.stopForcingCurrentHero()
    kill(eventPlayer,null)
    eventPlayer._call_init = true # reinit player

rule "[brigitte/rally.opy]: launch Rally":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate()

    wait(1) # Raly voice line
    launchRally()

# Switch to Ana temporarily to reset ultimate and use fake rally.
def launchRally():
    @Name "[brigitte/rally.opy]: launchRally()"

    
    # Save brig state
    eventPlayer._brig_hp = eventPlayer.getHealthOfType(Health.NORMAL)
    eventPlayer._brig_armor = eventPlayer.getHealthOfType(Health.ARMOR)
    eventPlayer._whip_cooldown = eventPlayer.getAbilityCooldown(Button.ABILITY_1)
    eventPlayer._repair_cooldown = eventPlayer.getAbilityCooldown(Button.ABILITY_2)
    eventPlayer._bash_cooldown = eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE)

    eventPlayer._is_using_fake_rally = true
    eventPlayer.startForcingHero(Hero.ANA)
    eventPlayer.stopForcingCurrentHero()

# Switch back to brig after entering ana
rule "[brigitte/rally.opy]: Go back to brigitte":
    @Event eachPlayer
    @Condition eventPlayer._is_using_fake_rally

    eventPlayer.startForcingHero(Hero.BRIGITTE)
    eventPlayer.stopForcingCurrentHero()

    # Restore brig state
    setCustomHp(BRIGITTE_RALLY_HEALTH, BRIGITTE_RALLY_ARMOR, 0)
    eventPlayer.setHealth(min(BRIGITTE_HEALTH, eventPlayer._brig_hp) + eventPlayer._brig_armor)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, eventPlayer._whip_cooldown)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer._repair_cooldown)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, eventPlayer._bash_cooldown)

    eventPlayer.fake_rally = true

    eventPlayer._is_using_fake_rally = false

rule "[brigitte/rally.opy]: Fake rally start":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.fake_rally

    startRally()
    wait(BRIGITTE_RALLY_DURATION)
    endRally()

def startRally():
    @Name "[brigitte/rally.opy]: startRally()"

    eventPlayer.fake_rally = true

    eventPlayer.setUltEnabled(false)
    eventPlayer.setMoveSpeed(percent(BRIGITTE_RALLY_SPEED_BUFF/OW2_BRIGITTE_RALLY_SPEED_BUFF)) # 30% movement speed buff during ralley
    damage(eventPlayer, null, BRIGITTE_RALLY_ARMOR_EXTRA) # Remove Rally instant armor
    eventPlayer.startHoT(null, Math.INFINITY, BRIGITTE_RALLY_HEAL_RATE)
    eventPlayer.rally_hot_id = getLastHoT()

    if eventPlayer.fake_rally_id == null:
        createEffect(getAllPlayers(), 
                     Effect.LIGHT_SHAFT, 
                     Color.YELLOW, 
                     updateEveryTick(eventPlayer.getPosition()), 
                     1, 
                     EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.fake_rally_id = getLastCreatedEntity()

    if eventPlayer.fake_rally_id1 == null:
        createEffect(getAllPlayers(), 
                     Effect.SPARKLES, 
                     Color.YELLOW, 
                     updateEveryTick((eventPlayer.getEyePosition()+eventPlayer.getPosition())/2), 
                     0.7, 
                     EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.fake_rally_id1 = getLastCreatedEntity()

    if eventPlayer.fake_rally_id2 == null:
        createEffect(getAllPlayers(), 
                     Effect.RING, 
                     Color.YELLOW, 
                     updateEveryTick((eventPlayer.getEyePosition()+eventPlayer.getPosition())/2), 
                     BRIGITTE_RALLY_EFFECT, 
                     EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.fake_rally_id2 = getLastCreatedEntity()

    eventPlayer.addHealthPool(Health.ARMOR, BRIGITTE_RALLY_ARMOR_EXTRA, true, true)
    eventPlayer.rally_armor = getLastCreatedHealthPool()

rule "[brigitte/rally.opy]: Fake rally healing inspire":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventPlayer.fake_rally

    heal(getPlayersInRadius(updateEveryTick(eventPlayer.getPosition()), BRIGITTE_RALLY_EFFECT, eventPlayer.getTeam(), LosCheck.SURFACES), eventPlayer, BRIGITTE_INSPIRE_HEALING)

def endRally():
    @Name "[brigitte/rally.opy]: endRally()"

    destroyEffect(eventPlayer.fake_rally_id)
    eventPlayer.fake_rally_id = null
    destroyEffect(eventPlayer.fake_rally_id1)
    eventPlayer.fake_rally_id1 = null
    destroyEffect(eventPlayer.fake_rally_id2)
    eventPlayer.fake_rally_id2 = null

    eventPlayer.setUltEnabled(true)
    eventPlayer.setMoveSpeed(100)
    stopHoT(eventPlayer.rally_hot_id)
    removeHealthPool(eventPlayer.rally_armor)
    eventPlayer.fake_rally = false
