#!mainFile "../../dev_main.opy"

playervar rally_hot_id

playervar rally_pvar
#!defineMember _brig_detect_rally rally_pvar [0]
#!defineMember _brig_hp rally_pvar [1]
#!defineMember _brig_armor rally_pvar [2]
#!defineMember _brig_barrier_hp rally_pvar [3]

subroutine startRally
subroutine endRally

rule "[brigitte/rally.opy]: rally start":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate()

    startRally()
    waitUntil(not eventPlayer.isUsingUltimate(), BRIGITTE_RALLY_DURATION)
    endRally()

def startRally():
    @Name "[brigitte/rally.opy]: startRally()"

    eventPlayer._brig_detect_rally = true

    eventPlayer._brig_barrier_hp = 0.1
    eventPlayer.setMaxHealth(eventPlayer._brig_barrier_hp) # 604 is the least amount i could do, sorry i tried.

    eventPlayer.startScalingBarriers(0.75, false) # Set brig barrier scale

    eventPlayer.setMoveSpeed(percent(BRIGITTE_RALLY_SPEED_BUFF/OW2_BRIGITTE_RALLY_SPEED_BUFF)) # 30% movement speed buff during rally

    setCustomHp(BRIGITTE_RALLY_HEALTH, BRIGITTE_RALLY_ARMOR, 0)

    damage(eventPlayer, null, BRIGITTE_RALLY_ARMOR_EXTRA) # Remove Rally instant armor

    eventPlayer.startHoT(null, Math.INFINITY, BRIGITTE_RALLY_HEAL_RATE)
    eventPlayer.rally_hot_id = getLastHoT()

def endRally():
    @Name "[brigitte/rally.opy]: endRally()"

    eventPlayer.stopScalingBarriers()

    eventPlayer._brig_hp = eventPlayer.getHealthOfType(Health.NORMAL)
    eventPlayer._brig_armor = eventPlayer.getHealthOfType(Health.ARMOR)
    eventPlayer.setMaxHealth(100) # Keep this on for correct regenaration https://us.forums.blizzard.com/en/overwatch/t/shield-health-recharge/588713
    setCustomHp(BRIGITTE_HEALTH, BRIGITTE_ARMOR, 0)
    eventPlayer.setHealth(min(BRIGITTE_HEALTH, eventPlayer._brig_hp) + eventPlayer._brig_armor)

    eventPlayer.setMoveSpeed(100)
    stopHoT(eventPlayer.rally_hot_id)

    eventPlayer._brig_detect_rally = false

rule "[brigitte/rally.opy]: Reset rally if player died":
    @Event playerDied
    @Condition eventPlayer._brig_detect_rally

    waitUntil(eventPlayer.isAlive(), Math.INFINITY)
    endRally()
