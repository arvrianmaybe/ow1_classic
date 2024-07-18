#!mainFile "../../dev_main.opy"

playervar tree_pvar
#!defineMember _tree_hp tree_pvar [0]
#!defineMember _lifeweaver_hp tree_pvar [1]

subroutine setTreeHP
subroutine clearTreeHP

rule "[lifeweaver/tree.opy]: Allow self healing during Tree of Life":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer.isUsingUltimate()

    pushSelfHealing(Button.ULTIMATE)
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    popSelfHealing(Button.ULTIMATE)

rule "[lifeweaver/tree.opy]: Set Tree of life HP":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer.isUsingUltimate()

    setTreeHP()
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    clearTreeHP()

def setTreeHP():
    @Name "[lifeweaver/tree.opy]: setTreeHP()"

    eventPlayer.setMaxHealth(percent(LIFEWEAVER_TREE_OF_LIFE_HEALTH/LIFEWEVER_INCORRECT_TREE_HEALTH))

    wait() # Do not remove?? this wont reset the hp if you dont remove it for SOME reason
    setCustomHp(LIFEWEAVER_HEALTH, 0, 0)

    eventPlayer._tree_hp = true

def clearTreeHP():
    @Name "[lifeweaver/tree.opy]: clearTreeHP()"

    eventPlayer.setMaxHealth(100)
    wait() # Do not remove?? this wont reset the hp if you dont remove it for SOME reason
    eventPlayer._lifeweaver_hp = eventPlayer.getHealthOfType(Health.NORMAL)
    setCustomHp(LIFEWEAVER_HEALTH, 0, 0)
    eventPlayer.setHealth(min(LIFEWEAVER_HEALTH, eventPlayer._lifeweaver_hp))

    eventPlayer._tree_hp = false