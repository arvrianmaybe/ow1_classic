#!mainFile "../../dev_main.opy"

playervar fall_off_pvar
#!defineMember _scoped_shot_distance fall_off_pvar [0]
#!defineMember _scoped_damage_base fall_off_pvar [1]
#!defineMember _ow2__scoped_damage_falloff_scalar fall_off_pvar [2]
#!defineMember _scoped_damage_falloff_scalar fall_off_pvar [3]
#!defineMember _expected_scoped_damage fall_off_pvar [4]


# Damage falloff derived from Marblr's "How Damage Falloff is Calculated" video: https://youtu.be/VL2VnkNJPpE
#!define OW1WidowmakerN(d) ((d - WIDOWMAKER_DAMAGE_FALLOFF_START_DISTANCE)/(WIDOWMAKER_DAMAGE_FALLOFF_END_DISTANCE - WIDOWMAKER_DAMAGE_FALLOFF_START_DISTANCE))
#!define OW2WidowmakerN(d) ((d - OW2_WIDOWMAKER_DAMAGE_FALLOFF_START_DISTANCE)/(OW2_WIDOWMAKER_DAMAGE_FALLOFF_END_DISTANCE - OW2_WIDOWMAKER_DAMAGE_FALLOFF_START_DISTANCE))
#!define OW1WidowmakerFalloff(d) ((OW1WidowmakerN(d)) * WIDOWMAKER_DAMAGE_FALLOFF_SCALAR + (1 - OW1WidowmakerN(d)))
#!define OW2WidowmakerFalloff(d) ((OW2WidowmakerN(d)) * OW2_WIDOWMAKER_DAMAGE_FALLOFF_SCALAR + (1 - OW2WidowmakerN(d)))

rule "[widowmaker/init.opy]: Initialize Widowmaker":
    @Event eachPlayer
    @Hero widowmaker
    @Condition eventPlayer._call_init

    setCustomHp(WIDOWMAKER_HEALTH, 0, 0)
    setUltCost(WIDOWMAKER_ULT_COST)
    removePassiveHealing()

    eventPlayer._call_init = false


rule "[widowmaker.opy]: Revert sniper damage falloff":
    @Event playerDealtDamage
    @Hero widowmaker
    @Condition eventPlayer.isFiringSecondaryFire()
    @Condition eventPlayer.isFiringPrimaryFire()
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    eventPlayer._scoped_shot_distance = distance(attacker.getEyePosition(), victim)
    eventPlayer._ow2__scoped_damage_falloff_scalar = OW2WidowmakerFalloff(eventPlayer._scoped_shot_distance)
    # Cap min/max scalar
    if eventPlayer._ow2__scoped_damage_falloff_scalar > 1: # Max damage scalar
        eventPlayer._ow2__scoped_damage_falloff_scalar = 1
    elif eventPlayer._ow2__scoped_damage_falloff_scalar < OW2_WIDOWMAKER_DAMAGE_FALLOFF_SCALAR: # Min damage scalar
        eventPlayer._ow2__scoped_damage_falloff_scalar = OW2_WIDOWMAKER_DAMAGE_FALLOFF_SCALAR

    eventPlayer._scoped_damage_base = eventDamage/eventPlayer._ow2__scoped_damage_falloff_scalar
    
    eventPlayer._scoped_damage_falloff_scalar = OW1WidowmakerFalloff(eventPlayer._scoped_shot_distance)
    # Cap min/max scalar
    if eventPlayer._scoped_damage_falloff_scalar > 1: # Max damage scalar
        eventPlayer._scoped_damage_falloff_scalar = 1
    elif eventPlayer._scoped_damage_falloff_scalar < WIDOWMAKER_DAMAGE_FALLOFF_SCALAR: # Min damage scalar
        eventPlayer._scoped_damage_falloff_scalar = WIDOWMAKER_DAMAGE_FALLOFF_SCALAR

    eventPlayer._expected_scoped_damage = eventPlayer._scoped_damage_base * eventPlayer._scoped_damage_falloff_scalar
    damage(victim, attacker, eventPlayer._expected_scoped_damage - eventDamage)