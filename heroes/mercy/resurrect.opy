#!mainFile "../../dev_main.opy"

playervar resurrect_pvar

#!defineMember _mercy_hud_text resurrect_pvar [0]
#!defineMember _count_dead_allies resurrect_pvar[1]
#!defineMember _res_allies resurrect_pvar[2]
#!defineMember _dead_allies resurrect_pvar[3]

#!define MERCY_ULT_VOICELINE_DUR 1.635
#!define MERCY_MAS_RES_DURATION 0.65
#!define RES_WAIT 2.25

#!define hideMercyResHud()\
    destroyInWorldText(eventPlayer._mercy_hud_text)\
    eventPlayer._mercy_hud_text = null

playervar is_using_res

playervar mercy_res_id

subroutine startMassRes
subroutine stopMassRes

rule "[mercy/resurrect.opy]: Store dead allies in an array":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.getUltCharge() >= 100
    @Condition not eventPlayer.isInSpawnRoom()
    
    do:
        eventPlayer._dead_allies = [player for player in getPlayersInRadius(worldVector(vect(0, 0, 0), eventPlayer, Transform.ROTATION_AND_TRANSLATION), MERCY_RESURRECT_RADIUS, eventPlayer.getTeam(), LosCheck.OFF) if player.isDead()]
        wait()
    while RULE_CONDITION

def startMassRes():
    @Name "[mercy/resurrect.opy]: startMassRes()"

    # Ult Disable
    eventPlayer.setUltCharge(0)
    eventPlayer.setUltEnabled(false) # Prevent Mercy from getting ult charge
    #eventPlayer.communicate(Comms.VOICE_LINE_UP) # Play ultimate voice line

    # mass res sound eeffects
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.YELLOW, eventPlayer, 5)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.YELLOW, eventPlayer, 5)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.YELLOW, eventPlayer, 5)

    # Res Player Effects
    if (eventPlayer.mercy_res_id == null):
        createEffect(getAllPlayers(), Effect.SPARKLES_SOUND, Color.WHITE, eventPlayer, Math.INFINITY, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.mercy_res_id = getLastCreatedEntity()

    # Effects
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 1)

def stopMassRes():
    @Name "[mercy/resurrect.opy]: stopMassRes()"

    # Ult enable
    eventPlayer.setUltCharge(0)
    eventPlayer.setUltEnabled(true)

    # Gone Effects
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.YELLOW, eventPlayer, 15)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.YELLOW, eventPlayer, 15)

    # Clear res effects
    destroyEffect(eventPlayer.mercy_res_id)
    eventPlayer.mercy_res_id = null

rule "[mercy/resurrect.opy]: Trigger res":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition len(eventPlayer._dead_allies) > 0
    @Condition not isCCd(eventPlayer)
    @Condition not eventPlayer.isDead()
    
    startMassRes()
    eventPlayer._count_dead_allies = 0
    eventPlayer._dead_allies._res_allies = true
    eventPlayer._dead_allies = []
    waitUntil(not eventPlayer.isUsingAbility1(), 5)
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    wait(MERCY_MAS_RES_DURATION)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    stopMassRes()

rule "[mercy/resurrect.opy]: HUD counter":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.getUltCharge() >= 100
    @Condition len(eventPlayer._dead_allies) != eventPlayer._count_dead_allies
    @Condition not eventPlayer.isDead()
    @Condition not eventPlayer.isInSpawnRoom()
    
    do:
        eventPlayer._count_dead_allies = len(eventPlayer._dead_allies)
        if eventPlayer._mercy_hud_text == null:
            createInWorldText(eventPlayer, "       /  \\ \r\n     /      \\ \r\n   /  {0}×{1}\r\n  --------".format(len([i for i in getDeadPlayers(eventPlayer.getTeam()).exclude(eventPlayer) if distance(i.getPosition(), eventPlayer.getPosition()) <= MERCY_RESURRECT_RADIUS]), iconString(Icon.SKULL)),
            updateEveryTick(eventPlayer.getEyePosition() + (100 * (1.5 * worldVector(Vector.UP, eventPlayer, Transform.ROTATION) + (-1.65 * (angleToDirection(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), 
            verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) + 3 * eventPlayer.getFacingDirection()))), 
            2.5, 
            Clip.NONE, 
            WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, 
            Color.YELLOW, 
            SpecVisibility.DEFAULT) 
        eventPlayer._mercy_hud_text = getLastCreatedText()
        waitUntil(not eventPlayer._dead_allies or eventPlayer.getUltCharge() < 100, 5)
        hideMercyResHud()
        wait()
    while RULE_CONDITION


rule "[mercy/resurrect.opy]: Resurrected player":
    @Event eachPlayer
    @Condition eventPlayer._res_allies
    
    eventPlayer.disableRespawn()
    eventPlayer.startCamera(eventPlayer.getEyePosition() + vect(0, 2, 0) + eventPlayer.getFacingDirection() * -2, eventPlayer, 0)
    eventPlayer.resurrect()
    wait()
    eventPlayer.startCamera(eventPlayer.getEyePosition(), eventPlayer.getPosition() + eventPlayer.getFacingDirection() * 100, 3)
    wait()
    eventPlayer.setStatusEffect(null, Status.ROOTED, RES_WAIT)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, RES_WAIT)
    eventPlayer.setStatusEffect(null, Status.BURNING, RES_WAIT)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.YELLOW, eventPlayer, 5)
    wait(RES_WAIT)
    eventPlayer.stopCamera()
    eventPlayer._res_allies = false
    eventPlayer.enableRespawn()


rule "[mercy/resurrect.opy]: Fix bug where rez HUD applied after death":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.getUltCharge() >= 100
    @Condition eventPlayer.isDead()
    @Condition not eventPlayer.isInSpawnRoom()
    
    hideMercyResHud()
    wait(0.064)
    if eventPlayer.isDead():
        goto RULE_START