#!mainFile "../dev_main.opy"

# Universal

#!define SETUP_BUFFER_TIME 5
#!define CRITICAL_HIT_MULTIPLIER 2
#!define MELEE_DAMAGE 30
#!define ULT_CHARGE_PER_SECOND 5
#!define MIN_DAMAGE 0.000001
#!define BASE_DAMAGE 100
#!define JUMP_SPEED 6

# Ana
#!define ANA_CLIP_SIZE 6
#!define ANA_SLEEP_DART_DAMAGE 10
#!define ANA_SLEEP_DART_COOLDOWN 12
#!define ANA_BIOTIC_GRENADE_HEALING 125
#!define ANA_BIOTIC_GRENADE_COOLDOWN 10
#!define ANA_BIOTIC_GRENADE_DAMAGE 100
#!define ANA_SLEEP_DART_SLEEP_DURATION 5
#!define ANA_HEALTH 200
#!define AMA_NANO_BOOST_SPEED_MULTIPLIER 1.3
#!define ANA_ULT_COST 2100

# Ashe
#!define ASHE_BOB_DAMAGE 16
#!define ASHE_BOB_HEALTH 1200
#!define ASHE_HEALTH 200
#!define ASHE_ULT_COST 2240

# Baptiste
#!define BAPTISTE_CLIP1_SIZE 45
#!define BAPTISTE_CLIP2_SIZE 16
#!define BAPTISTE_HEALTH 200
#!define BAPTISTE_LAMP_COOLDOWN_TIME 30
#!define BAPTISTE_LAMP_HP 200
#!define BAPTISTE_PRIMARY_DAMAGE 30
#!define BAPTISTE_ULT_COST 2310
#!define BAPTISTE_REGEN_BURST_DURATION 5
#!define BAPTISTE_REGEN_BURST_ALLY_HPS (60/4)
#!define BAPTISTE_REGEN_BURST_SELF_HPS (140/4)

# Brigitte
#!define BRIGITTE_HEALTH 200
#!define BRIGITTE_ARMOR 50
#!define BRIGITTE_ULT_COST 1900
#!define BRIGITTE_BARRIER_HEALTH 600

#!define BRIGITTE_FLAIL_DAMAGE 30

#!define BRIGITTE_WHIPSHOT_DAMAGE 95
#!define BRIGITTE_WHIPSHOT_COOLDOWN 4

#!define BRIGITTE_RALLY_DURATION 10
#!define BRIGITTE_RALLY_HEAL_RATE 15
#!define BRIGITTE_RALLY_SPEED_BUFF 1.3
#!define BRIGITTE_RALLY_EFFECT 10

#!define BRIGITTE_RALLY_INACCURATE_ARMOR 1680
#!define BRIGITTE_RALLY_HEALTH 200
#!define BRIGITTE_RALLY_ARMOR 100
#!define BRIGITTE_RALLY_ARMOR_EXTRA 50

#!define BRIGITTE_INSPIRE_DURATION 5
#!define BRIGITTE_INSPIRE_HEALING 15

#!define BRIGITTE_REPAIR_PACK_INSTANT_HEAL 150
#!define BRIGITTE_REPAIR_PACK_ARMOR 75
#!define BRIGITTE_REPAIR_PACK_COOLDOWN 6
#!define BRIGITTE_REPAIR_PACK_RANGE 20

#!define BRIGITTE_SHIELD_BASH_DAMAGE 20
#!define BRIGITTE_SHIELD_BASH_KNOCKBACK 2
#!define BRIGITTE_SHIELD_BASH_COOLDOWN 5
#!define BRIGITTE_SHIELD_BASH_STUN_DURATION 1

# Bastion
#!define BASTION_HEALTH 200
#!define BASTION_ARMOR 100
#!define BASTION_CLIP_SIZE 20
#!define BASTION_ICONCLAD_DAMAGE_REDUCTION 100
#!define BASTION_ULT_COST 2310

#!define BASTION_TANK_HEALTH 200
#!define BASTION_TANK_ARMOR 250

#!define BASTION_MAX_SELF_REPAIR_DURATION (10/3)
#!define BASTION_SELF_REPAIR_CAST_TIME 0.7
#!define BASTION_SELF_REPAIR_COOLDOWN_TIME 0.7
#!define BASTION_SELF_REPAIR_HEALING_RATE 90
#!define BASTION_SELF_REPAIR_HEAL_INCREMENT 7
#!define BASTION_SELF_REPAIR_RECHARGE_DURATION 7 

#!define BASTION_SENTRY_CAST_TIME 1
#!define BASTION_SENTRY_COOLDOWN 0
#!define BASTION_SENTRY_CONFIG_DAMAGE 15
#!define BASTION_SENTRY_CONFIG_RELOAD_TIME 1.984
#!define BASTION_SENTRY_CONFIG_CLIP_SIZE 200
#!define BASTION_SENTRY_CONFIG_FIRE_RATE 30

#!define BASTION_TANK_CONFIG_TRANSFORM_TIME 1
#!define BASTION_TANK_COOLDOWN 0.5
#!define BASTION_TANK_CONFIG_DAMAGE 250
#!define BASTION_TANK_CONFIG_MOVE_SPEED (1/0.65)
#!define BASTION_TANK_CONFIG_PROJECTILE_SPEED 60
#!define BASTION_TANK_CONFIG_SHELL_RELOAD_TIME (6/8)
#!define BASTION_TANK_CONFIG_DURATION 8

# DVA
#!define DVA_MOVE_PENALTY 0.5
#!define DVA_HEALTH 300
#!define DVA_ARMOR 300

#!define DVA_MATRIX_COOLDOWN 10

#!define DVA_MICRO_MISSILES_DAMAGE 8.5

#!define DVA_BOMB_DAMAGE 1000

#!define DVA_REMECH_DAMAGE 50

#!define DVA_SELF_DESTRUCT_DURATION 3

#!define DVA_BOOSTERS_DAMAGE 20
#!define DVA_ULT_COST 1989
#!define DVA_MICRO_MISSILES_COOLDOWN_TIME 12
#!define DVA_BOOSTER_COOLDOWN_TIME 7
#!define DVA_MATRIX_DURATION 4
#!define DVA_PILOT_HEALTH 150

# DOOMFIST
#!define DOOMFIST_HEALTH 250
#!define DOOMFIST_PUNCH_COOLDOWN_DEFAULT 4
globalvar DOOMFIST_PUNCH_COOLDOWN = createWorkshopSetting(float[0:12], 'Doomfist', 'Cooldown - Punch', 4)
#!define DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MAX 1.4
#!define DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MIN 0.192
#!define DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MAX 1
#!define DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MIN 0.2
#!define DOOMFIST_ROCKET_PUNCH_IMPACT_DAMAGE_MIN 50
#!define DOOMFIST_ROCKET_PUNCH_IMPACT_DAMAGE_MAX 100
#!define DOOMFIST_ROCKET_PUNCH_WALL_SLAM_DAMAGE_MIN 50
#!define DOOMFIST_ROCKET_PUNCH_WALL_SLAM_DAMAGE_MAX 150
#!define DOOMFIST_PUNCH_KNOCKBACK_MIN 15
#!define DOOMFIST_PUNCH_KNOCKBACK_MAX 30
#!define DOOMFIST_BEST_DEFENSE 30
#!define DOOMFIST_BEST_DEFENSE_LINGER 1
#!define DOOMFIST_BEST_DEFENSE_DECAY_RATE 3
#!define DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MAX_DAMAGE 200
#!define DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MIN_DAMAGE 15
#!define DOOMFIST_METEOR_STRIKE_INNER_SPHERE_DAMAGE 10
#!define DOOMFIST_METEOR_STRIKE_SLOW 0.5
#!define DOOMFIST_METEOR_STRIKE_SLOW_DURATION 3
#!define DOOMFIST_METEOR_STRIKE_INNER_SPHERE_RADIUS 2
#!define DOOMFIST_HAND_CANNON_DAMAGE 80
#!define DOOMFIST_SLAM_DAMAGE 100
#!define DOOMFIST_RISING_UPPERCUT_AIR_LOCK_TIME 3
#!define DOOMFIST_UPPERCUT_COOLDOWN_DEFAULT 7
globalvar DOOMFIST_UPPERCUT_COOLDOWN = createWorkshopSetting(float[0:12], 'Doomfist', 'Cooldown - Uppercut', DOOMFIST_UPPERCUT_COOLDOWN_DEFAULT)
#!define DOOMFIST_RISING_UPPERCUT_DAMAGE 50
#!define DOOMFIST_RISING_UPPERCUT_RADIUS 5
#!define DOOMFIST_SLAM_COOLDOWN 7
#!define DOOMFIST_SEISMIC_SLAM_DAMAGE_RATE 100
globalvar DOOMFIST_SLAM_DAMAGE_MAX = createWorkshopSetting(int[0:1000], 'Doomfist', 'Slam Max Damage', 125)
#!define DOOMFIST_SEISMIC_SLAM_FAN_ANGLE 60
#!define DOOMFIST_SLAM_AOE_MAX_RADIUS 8
#!define DOOMFIST_SLAM_AOE_MIN_RADIUS 1
#!define DOOMFIST_SLAM_INDICATOR_BEAM_COUNT 0
#!define DOOMFIST_SLAM_INDICATOR_RING_COUNT 6
#!define DOOMFIST_GROUND_SLAM_HEIGHT 1
#!define DOOMFIST_HAND_CANNON_DAMAGE 66
#!define DOOMFIST_INDICATOR_SLAM_HEIGHT 3
#!define DOOMFIST_INDICATOR_SEISMIC_SLAM_MARGIN 5
#!define DOOMFIST_INDICATOR_SEISMIC_SLAM_SPEED 25
globalvar DOOMFIST_SLAM_PITCH_ANGLE = createWorkshopSetting(float[-90:90], 'Doomfist', 'Max Indicator Slam Pitch', 10)
globalvar DOOMFIST_SEISMIC_SLAM_RADIUS = createWorkshopSetting(float[0:30], 'Doomfist', 'Max Indicator Slam Range', 15)
#!define DOOMFIST_ULT_COST 1600

# Echo
#!define ECHO_HEALTH 200
#!define ECHO_DUPLICATE_DURATION 15
#!define ECHO_DUPLICATE_ULT_CHARGE_MULTIPLIER 6.5
#!define ECHO_FOCUSING_BEAM_TRESHOLD 50
#!define ECHO_FOCUSING_BEAM_DMG 200
#!define ECHO_ULT_COST 2000

# Genji
#!define GENJI_CLIP_SIZE 24
#!define GENJI_HEALTH 200
#!define GENJI_BLADE_DURATION 8
#!define GENJI_SHURIKEN_DAMAGE 30
#!define GENJI_ULT_COST 2400

# Hanzo
#!define HANZO_ARROW_DAMAGE 130
#!define HANZO_HEALTH 200
#!define HANZO_STORM_COOLDOWN 10
#!define HANZO_STORM_DAMAGE 90

#!define HANZO_SONIC_ARROW_COOLDOWN 20

#!define HANZO_SCATTER_ARROW_ARROWS 6
#!define HANZO_SCATTER_ARROW_DAMAGE 75
#!define HANZO_SCATTER_ARROW_COOLDOWN 10    
#!define HANZO_SCATTER_ARROW_RICOCHET_AMMOUNT 4
#!define HANZO_SCATTER_ARROW_SPREAD 15
#!define HANZO_SCATTER_ARROW_MOVE_PENALTY 0.4

#!define HANZO_ULT_COST 1600

# Illari
#!define ILLARI_SUNSTRUCK_DAMAGE 150
#!define ILLARI_HEALTH 200
#!define ILLARI_OUTBURST_COOLDOWN 9.7
#!define ILLARI_OUTBURST_DAMAGE 55
#!define ILLARI_PYLON_COOLDOWN 17
#!define ILLARI_PYLON_HP 100
#!define ILLARI_RIFLE_DAMAGE 100
#!define ILLARI_RIFLE_HEADSHOT_MULTIPLIER 2
#!define ILLARI_CLIP_SIZE 12
#!define ILLARI_ULT_COST 2400

# JunkerQueen
#!define JUNKERQUEEN_ARMOR 0
#!define JUNKERQUEEN_BLADE_COOLDOWN 7
#!define JUNKERQUEEN_HEALTH 400
#!define JUNKERQUEEN_ADRENALINE 200
#!define JUNKERQUEEN_SHIELDS 0
#!define JUNKERQUEEN_SHOUT_COOLDOWN 15
#!define JUNKERQUEEN_CARNAGE_COOLDOWN_TIME 9
#!define JUNKERQUEEN_RAMPAGE_WOUND_DAMAGE 70
#!define JUNKERQUEEN_MELEE_DAMAGE 40
#!define JUNKERQUEEN_ULT_COST 2600

# Junkrat
#!define JUNKRAT_CONCUSSION_MINE_COOLDOWN 7
#!define JUNKRAT_CONCUSSION_MINE_MAX_DAMAGE 15
#!define JUNKRAT_CONCUSSION_MINE_MIN_DAMAGE 40
#!define JUNKRAT_HEALTH 200
#!define JUNKRAT_FRAG_LAUNCHER_DAMAGE 100
#!define JUNKRAT_TIRE_HEALTH 100
#!define JUNKRAT_BOMB_SPEED 30
#!define JUNKRAT_BOMB_DAMAGE 100
#!define JUNKRAT_BOMB_RANGE 5
#!define JUNKRAT_BOMB_COOLDOWN 10
#!define JUNKRAT_BOMB_RADIUS 3
#!define JUNKRAT_ULT_COST 2200

# Juno
#!define JUNO_HEALTH 25
#!define JUNO_SHIELD_HEALTH 175
#!define JUNO_MEDIBLASTER_DAMAGE 100
#!define JUNO_ULT_COST 1850

# Kiriko
#!define KIRIKO_HEALTH 200
#!define KIRIKO_KUNAI_DAMAGE 50
#!define KIRIKO_KUNAI_HEADSHOT_DAMAGE (KIRIKO_KUNAI_DAMAGE * KIRIKO_KUNAI_HEADSHOT_MULTIPLIER)
#!define KIRIKO_KUNAI_HEADSHOT_MULTIPLIER 2.5
#!define KIRIKO_KUNAI_RECOVERY_TIME 0.65
#!define KIRIKO_SUZU_DURATION 0.65
#!define KIRKIO_OFUDA_HEALING 25
#!define KIRIKO_SUZU_COOLDOWN 15
#!define KIRIKO_SUZU_ALLY_HPS (80/1.5)
#!define KIRIKO_SUZU_SELF_HPS (100/1)
#!define KIRIKO_SWIFT_STEP_COOLDOWN 9
#!define KIRIKO_SWIFT_STEP_HEALING 50
#!define KIRIKO_ULT_COST 2900

# Lifeweaver
#!define LIFEWEAVER_TREE_OF_LIFE_HEALTH 1000
#!define LIFEWEVER_INCORRECT_TREE_HEALTH 400
#!define LIFEWEAVER_LIFEGRIP_COOLDOWN 19
#!define LIFEWEAVER_HEALTH 199.98
#!define LIFEWEAVER_PARTING_GIFT_HEALING 200
#!define LIFEWEAVER_PARTING_GIFT_HEALING_ENEMY 75
#!define LIFEWEAVER_PETAL_HP 100
#!define LIFEWEAVER_ULT_COST 1600

# Lucio|
#!define LUCIO_HEALTH 200
#!define LUCIO_ULT_COST 3000
#!define LUCIO_SOUND_GUN_DAMAGE 20

#!define LUCIO_AURA 24
#!define LUCIO_AURA_RADIUS 30

#!define LUCIO_AMP_HEALING 35.5
#!define LUCIO_AMP_COOLDOWN 12
#!define LUCIO_AMP_INCREASE 50
#!define LUCIO_SELF_HEALING 13

#!define LUCIO_WALLRIDE_SPEED_PENALTY 0.231

#!define LUCIO_SOUND_BARRIER_OVERHEALTH 500
#!define LUCIO_SOUND_BARRIER_AREA_OF_EFFECT 30

#!define LUCIO_SOUNDWAVE_AMMO_CONSUMPTION 4
#!define LUCIO_SOUNDWAVE_DAMAGE 30
#!define LUCIO_SOUNDWAVE_KNOCKBACK 1.5

# Mauga
#!define MAUGA_HEALTH 300
#!define MAUGA_ARMOR 200
#!define MAUGA_OVERRUN_DAMAGE 90
#!define MAUGA_OVERRUN_COOLDOWN 10
#!define MAUGA_CARDIAC_OVERDRIVE_HEALING 60
#!define MAUGA_CAGE_FIGHT_HEALTH 2500
#!define MAUGA_ULT_COST 1600

# Cassidy
#!define CASSIDY_COMBAT_ROLL_COOLDOWN 8
#!define CASSIDY_DEADEYE_DAMAGE 500
#!define CASSIDY_FLASHBANG_COOLDOWN 10
#!define CASSIDY_FLASHBANG_DAMAGE 25
#!define CASSIDY_FLASHBANG_RECOVERY_TIME 0.35
#!define CASSIDY_FLASHBANG_USAGE_DURATION 1
#!define CASSIDY_FLASHBANG_STUN_DURATION 0.8
#!define CASSIDY_FAN_THE_HAMMER_DAMAGE 50
#!define CASSIDY_HEALTH 200
#!define CASSIDY_ULT_COST 1800

# Mei
#!define MEI_BLASTER_DAMAGE_RATE 55
#!define MEI_CLIP_SIZE 200
#!define MEI_BUFF_CLIP_SIZE 250
#!define MEI_ICICLE_AMMO_CONSUMPTION 15
#!define MEI_CRYO_HEALING 37.5
#!define MEI_FREEZE_DURATION 1
#!define MEI_FREEZE_MAX_SLOW 70
#!define MEI_FREEZE_SLOW_LINGER_DURATION 1
#!define MEI_FREEZE_PERCENT_PER_TICK 2.85
#!define MEI_HEALTH 250
#!define MEI_ICEWALL_HP 200
#!define MEI_ICICLE_DAMAGE 90
#!define MEI_MINIMUM_FREEZE 20
#!define MEI_ULT_COST 1610

# Mercy
#!define MERCY_CLIP_SIZE 20
#!define MERCY_GUARDIAN_ANGEL_COOLDOWN_TIME 1
#!define MERCY_MAX_REGULAR_MOVE_SPEED 5.85
#!define MERCY_GUARDIAN_ANGEL_COOLDOWN 1
#!define MERCY_GUARDIAN_ANGEL_MAX_SPEED 17
#!define MERCY_GUARDIAN_ANGEL_RECOVERY_TIME 1
#!define MERCY_HEALTH 200
#!define MERCY_SLINGSHOT_DURATION 0.33
#!define MERCY_RESURRECT_RADIUS 15
#!define MWECY_RESURRECT_DURATION 2.25
#!define MERCY_ULT_COST 1625

# Moira
#!define MOIRA_BIOTIC_GRASP_DAMAGE 55
#!define MOIRA_BIOTIC_GRASP_HEALING 29
#!define MOIRA_COALESCENCE_SPEED_BUFF 1.3
#!define MOIRA_HEAL_GRASP_AMMO 200
#!define MOIRA_HEAL_GRASP_AMMO_USAGE 9.5
#!define MOIRA_HEALTH 200
#!define MOIRA_ULTIMATE_DURATION 6
#!define MOIRA_ULT_COST 2500

# Orisa
#!define ORISA_HEALTH 200
#!define ORISA_ARMOR 200
#!define ORISA_ULT_COST 1680

#!define ORISA_CLIP_SIZE 200
#!define ORISA_FUSION_DRIVER_DAMAGE 11
#!define ORISA_GUN_FIRE_RATE 12
#!define ORISA_GUN_PROJECTILE_SPEED 120
#!define ORISA_RELOAD_TIME 2.5
#!define ORISA_MOVEMENT_PENALTY 0.3

#!define ORISA_BARRIER_PROJECTILE_SPEED 25
#!define ORISA_PROJECTILE_BARRIER_BLOCK 0.01
#!define ORISA_PROJECTILE_BARRIER_COOLDOWN_TIME 12
#!define ORISA_PROJECTILE_BARRIER_HEALTH 900
#!define ORISA_PROJECTILE_BARRIER_MAX_UPTIME 20
globalvar ORISA_BARRIER_ORB_SIZE = createWorkshopSetting(float[0.1:3], 'Orisa', 'Barrier Orb Radius', 0.25)
#!define ORISA_PROTECTIVE_BARRIER_RADIUS 3.5
globalvar ORISA_BARRIER_ORB_COUNT = createWorkshopSetting(int[100:200], 'Orisa', 'Barrier Orb Count', 140)
globalvar ORISA_BARRIER_LOS_FREQ = createWorkshopSetting(float[0.001:60], "Orisa", "Barrier LOS Polling Frequency (Hz)", 1)

#!define ORISA_SUPERCHARGER_AOE_RADIUS 25
#!define ORISA_SUPERCHARGER_DAMAGE_MULTIPLIER 1.5
#!define ORISA_SUPERCHARGER_HEIGHT 1
#!define ORISA_SUPERCHARGER_LINGER_TIME 1
#!define ORISA_SUPERCHARGER_MAX_DURATION 15

#!define ORISA_HALT_ACTIVATION_TIME 0.45
#!define ORISA_HALT_AOE_RADIUS 7
#!define ORISA_HALT_COOLDOWN_TIME 8
#!define ORISA_HALT_LAUNCH_CAST_TIME 0.1
#!define ORISA_HALT_PROJECTILE_RADIUS 0.6
#!define ORISA_HALT_PROJECTILE_SPEED 25
#!define ORISA_HALT_PULL_SPEED 20
#!define ORISA_HALT_SNARE_DURATION 0.65
#!define ORISA_HALT_SNARE_MOVE_PENALTY 67

# Pharah
#!define PHARAH_CONCUSSIVE_BLAST_COOLDOWN 10
#!define PHARAH_CONCUSSIVE_BLAST_KNOCKBACK 130
#!define PHARAH_CONCUSSIVE_BLAST_DAMAGE 40
#!define PHARAH_HEALTH 200
#!define PHARAH_JUMP_JET_COOLDOWN 11
#!define PHARAH_ROCKET_LAUNCHER_RECOVERY_TIME 0.85
#!define PHARAH_ROCKET_SPEED 40
#!define PHARAH_ULT_COST 2200

# Ramattra
#!define RAMATTRA_SHIELD 100
#!define RAMATTRA_ARMOR 100
#!define RAMATTRA_HEALTH 250
#!define RAMATTRA_BARRIER_HEALTH 1000
#!define RAMATTRA_NEMESIS_ARMOR 150
#!define RAMATTRA_NEMESIS_COOLDOWN 15
#!define RAMATTRA_PUMMEL_DAMAGE 85
#!define RAMATTRA_SHIELDS 100
#!define RAMATTRA_VOID_BARRIER_COOLDOWN 10
#!define RAMATTRA_VOID_BARRIER_HP 600
#!define RAMATTRA_VORTEX_COOLDOWN 12
#!define RAMATTRA_VORTEX_DAMAGE 30
#!define RAMATTRA_NEMESIS_ARMOR 50
#!define RAMTTRA_SHIELDS 150
#!define RAMATTRA_ANNIHILATION_DAMAGE 30
#!define RAMATTRA_ULT_COST 2600

# Reaper
#!define REAPER_DEATH_BLOSSON_DAMAGE 200
#!define REAPER_HEALTH 250
#!define REAPER_SOUL_ORB_HEALING 50
#!define REAPER_HELLFIRE_SHOTGUNS_DAMAGE 140
#!define REAPER_ULT_COST 2000

# Reinhardt
#!define REINHARDT_HEALTH 300
#!define REINHARDT_ARMOR 200
#!define REINHARDT_ULT_COST 1500

#!define REINHARDT_BARRIER_HEALTH 2000
#!define REINHARDT_BARRIER_REGEN 200
#!define REINHARDT_BARRIER_MOVEMENT_PENALTY 0.2

#!define REINHARDT_CHARGE_COOLDOWN_TIME 10
#!define REINHARDT_CHARGE_PIN_DAMAGE 300

#!define REINHARDT_EARTHSHATTER_BASE_DAMAGE 50
#!define REINHARDT_EARTHSHATTER_BONUS_DAMAGE 200
#!define REINHARDT_EARTHSHATTER_KNOCK_DOWN_DURATION 3

#!define REINHARDT_FIRE_STRIKE_COOLDOWN_TIME 6
#!define REINHARDT_FIRESTRIKE_DAMAGE 100
#!define REINHARDT_HAMMER_DAMAGE 110
#!define REINHARDT_HAMMER_MOVE_PENALTY 0.05

# Roadhog
#!define ROADHOG_BREATHER_CAST_TIME 0.5
#!define ROADHOG_BREATHER_COOLDOWN 8
#!define ROADHOG_BREATHER_DAMAGE_REDUCTION 0.5
#!define ROADHOG_BREATHER_DURATION 1
#!define ROADHOG_BREATHER_HEAL_TOTAL 300
#!define ROADHOG_BREATHER_RECOVERY_TIME 0.5
#!define ROADHOG_CLIP_SIZE 4
#!define ROADHOG_HEALTH 600
#!define ROADHOG_HOOK_COOLDOWN_TIME 6
#!define ROADHOG_HOOK_DAMAGE 20
#!define ROADHOG_HOOK_PROXIMITY 1.5
#!define ROADHOG_SCRAP_GUN_DAMAGE 160
#!define ROADHOG_SHIELDS 0
#!define ROADHOG_ULTIMATE_DURATION 6
#!define ROADHOG_WHOLEHOG_DAMAGE 7
#!define ROADHOG_WHOLEHOG_KNOCKBACK 14
#!define ROADHOG_ULT_COST 2240

# Sigma
#!define SIGMA_ACCRETION_DAMAGE 110
#!define ACCERITION_MIN_DOWNTIME 0.5
#!define ACCERETION_DISTANCE_FULL_STUN 45
#!define ACCERETION_MAX_DOWNTIME 3
#!define SIGMA_ARMOR 0
#!define SIGMA_BARRIER_HEALTH 1000
#!define SIGMA_BARRIER_REGEN 70
#!define SIGMA_HEALTH 250
#!define SIGMA_SHIELDS 200
#!define SIGMA_KINETIC_GRASP_COOLDOWN 15
#!define SIGMA_GRAVITY_FLUX_MOVEMENT_PENALTY 0.2
#!define SIGMA_KINETIC_GRASP_OVERHEALTH 0.39
#!define SIGMA_ULT_COST 1600

# Sojourn
#!define SOJOURN_DISRUPTOR_DAMAGE 70
#!define SOJOURN_HEALTH 200
#!define SOJOURN_SLIDE_COOLDOWN 6
#!define SOJOURN_SLIDE_ELIMS_CD 1
#!define SOJOURN_RAILGUN_ALT_DAMAGE_MIN 0
#!define SOJOURN_RAILGUN_ALT_DAMAGE_MAX 135
#!define SOJOURN_GLOBAL_DAMAGE (min((SOJOURN_RAILGUN_ALT_DAMAGE_MAX/OW2_SOJOURN_RAILGUN_ALT_DAMAGE_MAX), (SOJOURN_DISRUPTOR_DAMAGE/OW2_SOJOURN_DISRUPTOR_DAMAGE)))
#!define SOJOURN_RAILGUN_ALT_HEADSHOT_MULTIPLIER 2
#!define SOJOURN_ULT_COST 2500

#!define SOJOURN_PRIMARY_FIRE_DAMAGE 12
#!define SOJOURN_SECONDARY_FIRE_DAMAGE 90

#!define SOJOURN_POWER_SLIDE_COOLDOWN_TIME 10
#!define SOJOURN_DISRUPTOR_SHOT_DAMAGE 30
#!define SOJOURN_DISRUPTOR_SHOT_SLOW 30
# #!define SOJOURN_OVERCLOCK_DAMAGE 200
# #!define SOJOURN_OVERCLOCK_FALLOFF_START_DISTANCE 10
# #!define SOJOURN_OVERCLOCK_FALLOFF_STOP_DISTANCE 30

# Soldier 76
#!define SOLDIER_HEAVY_PULSE_RIFLE_DAMAGE 20
#!define SOLDIER_HEAVY_PULSE_RIFLE_DAMAGE_CRITICAL_HJT 40
#!define SOLDIER_HEAVY_PULSE_RIFLE_FIRERATE 0.1
#!define SOLDIER_BIOTIC_FIELD_HEAL 40
#!define SOLDIER_BIOTIC_FIELD_COOLDOWN 15
#!define SOLDIER_BIOTIC_FIELD_DURATION 5
#!define SOLDIER_SPRINT_CAST_TIME 0.5
#!define SOLDIER_SPRINT_SPEED 0.030
#!define SOLDIER_HELIX_ROCKETS_COOLDOWN 8
#!define SOLDIER_HEALTH 200
#!define SOLDIER_ULT_COST 1750

# Sombra
#!define SOMBRA_EMP_CAST_TIME 0.64
#!define SOMBRA_HACK_COOLDOWN_TIME 12
#!define SOMBRA_HACK_ENEMY_DURATION 6
#!define SOMBRA_HEALTH 200
#!define SOMBRA_MACHINE_PISTOL_DAMAGE 9
#!define SOMBRA_TRANSLOCATOR_COOLDOWN_TIME 6
#!define SOMBRA_TRANSLOCATOR_GRAVITY (-16)
#!define SOMBRA_TRANSLOCATOR_PROJECTILE_SPEED 25
#!define SOMBRA_TRANSLOCATOR_DURATION 15
#!define SOMBRA_STEALTH_CAST_TIME 0.5
#!define SOMBRA_STEALTH_COOLDOWN 6
#!define SOMBRA_STEALTH_MOVEMENT_BONUS 1.75
#!define SOMBRA_STEALTH_RECOVERY_TIME 0.60
#!define SOMBRA_OPPORTUNIST_DAMAGE 0.2
#!define SOMBRA_ULT_COST 2000

# Symmetra
#!define SYMMETRA_ULT_COST 1000
#!define SYMMETRA_HEALTH 100
#!define SYMMETRA_SHIELDS 100

#!define SYMMETRA_EXTRA_SHIELDS 25
#!define SYMETTRA_SHIELDS_COOLDOWN 1.5
#!define SYMMETTRA_SHIELDS_DURATION 5

#!define SYMMETRA_TURRET_HEALTH 30

#!define SYMETRA_BEAM_INCREASE_PS 0.1
#!define SYMETRA_BEAM_INCREASE 0.17
#!define SYMETTRA_BEAM_DAMAGE 11.52
#!define SYMETTRA_BEAM_RATE 1
#!define SYMETTRA_MAX_LEVEL 4

#!define SYMMETRA_TELEPORTER_MAX_USE 6

#!define SYMMETRA_ORB_DAMAGE 140
#!define SYMMETRA_ORB_SPEED 30
#!define SYMMETRA_PROJECTOR_DAMAGE 70

# Torbjorn
#!define TORBJORN_ARMOR 50
#!define TORBJORN_HEALTH 200

#!define TORBJORN_TURRET_DAMAGE 13
#!define TORBJORN_TURRET_HEALTH 150
#!define TORBJORN_TURRET_HEALTH_LEVEL_2 300
#!define TORBJORN_TURRET_HEALTH_ULTIMATE 800

#!define TORBJORN_TURRET_UPGRADE_HIT 10

#!define TORBJORN_TURRET_DEFAULT 1
#!define TOBRJORN_TURRET_LEVEL 2
#!define TORBJORN_TURRET_LEVEL_ULTIMATE 3
#!define TORBJORN_TURRET_COOLDOWN 8

#!define TORBJORN_SCRAP_MAX 200
#!define TORBJORN_SCRAP_ARMOR 75
#!define TORBJORN_SCRAP_ALLOW 50
#!define TORBJORN_SCRAP_PIECE 25
#!define TOBRJORN_SCRAP_DURATION 20

#!define TORBJORN_OVERLOAD_DURATION 20
#!define TORBJORN_OVERLOAD_ARMOR 300
#!define TORBJORN_OVERLOAD_HEALTH 75

#!define TORBJORN_HAMMER_RECOVERY_TIME 0.85
#!define TORBJORN_RIVET_GUN_AMMO_CONSUMPTION 3

#!define TORBJORN_ULT_COST 2200

# Tracer
#!define TRACER_HEALTH 150
#!define TRACER_RECALL_DURATION 1.25
#!define TRACER_PULSE_PISTOL_DAMAGE 6
#!define TRACER_PULSE_BOMB_DAMAGE 300
#!define TRACER_ULT_COST 1500

# Venture
#!define VENTURE_HEALTH 200
#!define VENTURE_ULT_COST 1925

# Widowmaker
#!define WIDOWMAKER_DAMAGE_FALLOFF_SCALAR 0.3
#!define WIDOWMAKER_DAMAGE_FALLOFF_START_DISTANCE 70
#!define WIDOWMAKER_DAMAGE_FALLOFF_END_DISTANCE 100
#!define WIDOWMAKER_HEALTH 200
#!define WIDOWMAKER_ULT_COST 2000

# Winston
#!define WINSTON_ARMOR 150
#!define WINSTON_BARRIER_HEALTH 700
#!define WINSTON_HEALTH 350
#!define WINSTON_JUMP_PACK_COOLDOWN_TIME 6
#!define WINSTON_PRIMAL_ARMOR 150
#!define WINSTON_PRIMAL_DAMAGE 40
#!define WINSTON_PRIMAL_HEALTH 850
#!define WINSTON_PRIMAL_HEALTH_BONUS (WINSTON_PRIMAL_HEALTH - WINSTON_HEALTH)
#!define WINSTON_PRIMAL_JUMP_PACK_COOLDOWN_TIME 2
#!define WINSTON_SHIELDS 0
#!define WINSTON_TESLA_DAMAGE 60
#!define WINSTON_ULT_COST 1400

# Wrecking Ball
#!define WRECKING_BALL_ADAPTIVE_SHIELD_BASE 100
#!define WRECKING_BALL_ADAPTIVE_SHIELD_RADIUS 8
#!define WRECKING_BALL_ARMOR 100
#!define WRECKING_BALL_HEALTH 450
#!define WRECKING_BALL_PILEDRIVER_COOLDOWN_TIME 10
#!define WRECKING_BALL_SHIELDS 100
#!define WRECKING_BALL_SHIELD_PER_TARGET 75
#!define WRECKING_BALL_GRAPPLE_COOLDOWN 5
#!define WRECKING_BALL_ULT_COST 1700

# Zarya
#!define ZARYA_ARMOR 0
#!define ZARYA_BARRIER_HEALTH 200
#!define ZARYA_BUBBLE_DURATION 3
#!define ZARYA_CANNON_DAMAGE_MAX 200
#!define ZARYA_CANNON_DAMAGE_MIN 75
#!define ZARYA_HEALTH 200
#!define ZARYA_SHIELDS 200
#!define ZARYA_PARTICLE_BARRIER_COOLDOWN_TIME 10
#!define ZARYA_PROJECTED_BARRIER_COOLDOWN_TIME 10
#!define ZARYA_ULT_COST 1700

# Zenyatta
#!define ZENYATTA_DISCORD_ORB_TAKEN 1.50
#!define ZENYATTA_CLIP_SIZE 20
#!define ZENYATTA_HEALTH 50
#!define ZENYATTA_KNOCKBACK 100
#!define ZENYATTA_SHIELDS 100
#!define ZENYATTA_ULT_COST 2500