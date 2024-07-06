#!mainFile "../../dev_main.opy"

playervar rally_hot_id

playervar rally_pvar
#!defineMember _is_using_fake_rally rally_pvar[0]
#!defineMember _brig_hp rally_pvar [1]
#!defineMember _brig_armor rally_pvar [2]
#!defineMember _repair_cooldown rally_pvar [3]
#!defineMember _whip_cooldown rally_pvar [4]
#!defineMember _bash_cooldown rally_pvar [5]
#!defineMember _brig_barrier_hp rally_pvar [6]

subroutine startRally
subroutine endRally

rule "[brigitte/rally.opy]: rally start":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate()

    startRally()
    wait(BRIGITTE_RALLY_DURATION)
    endRally()

def startRally():
    @Name "[brigitte/rally.opy]: startRally()"


    eventPlayer._brig_barrier_hp = 0.1
    eventPlayer.setMaxHealth(eventPlayer._brig_barrier_hp) # 604 is the least amount i could do, sorry i tried.

    eventPlayer.startScalingBarriers(0.75, false) # Set brig barrier scale

    eventPlayer.setUltEnabled(false)
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
    setCustomHp(BRIGITTE_HEALTH, BRIGITTE_ARMOR, 0)
    eventPlayer.setHealth(min(BRIGITTE_HEALTH, eventPlayer._brig_hp) + eventPlayer._brig_armor)

    eventPlayer.setMoveSpeed(100)
    stopHoT(eventPlayer.rally_hot_id)
