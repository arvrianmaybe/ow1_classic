#!mainFile "../../dev_main.opy"

playervar rocket_effect

#!define turretLevel()\
 if eventPlayer.rocket_effect == null:\
     createEffect(getAllPlayers() if eventPlayer.turret_level >= 3 else null, \
     Effect.SPHERE, \
     Color.ORANGE, \
     eventPlayer.turret_position + vect(0, 1, 0), 0.3, \
     EffectReeval.VISIBILITY_POSITION_AND_RADIUS) \
 eventPlayer.rocket_effect = getLastCreatedEntity()
