# Constants
#!include "constant/owc_constant.opy"
#!include "constant/ow2_constant.opy"
#!include "utilities/macro.opy"

# Game Lobby
#!include "lobby/owc_lobby.opy"

##!obfuscate noRuleFilling noConstantObfuscation

#!suppressWarnings w_type_check w_unsuitable_event

# Passives
# Remove damage passive
#!include "passives/damage/damage_passive.opy"
# Remove tank passive
#!include "passives/tank/headshot.opy"
#!include "passives/tank/knockback.opy"
#!include "passives/tank/ult_charge.opy"
# Remove support passive
#!include "passives/support/self_heal.opy"

# Utilities
#!include "utilities/stat_helper.opy"
#!include "utilities/custom_hp.opy"
#!include "utilities/reset.opy"
#!include "utilities/hero_switch.opy"
##!include "utilities/hero_roster.opy"
##!include "utilities/role_lock.opy"
#!include "utilities/ready.opy"
#!include "utilities/hit_detection.opy"
#!include "utilities/anti_crash.opy"

# Hero specific logic
#!include "heroes/bastion/init.opy"
#!include "heroes/cassidy/init.opy"
#!include "heroes/dva/init.opy"
#!include "heroes/genji/init.opy"
#!include "heroes/hanzo/init.opy"
#!include "heroes/junkrat/init.opy"
#!include "heroes/lucio/init.opy"
#!include "heroes/mei/init.opy"
#!include "heroes/mercy/init.opy"
#!include "heroes/pharah/init.opy"  
#!include "heroes/roadhog/init.opy"
#!include "heroes/reaper/init.opy"
#!include "heroes/reinhardt/init.opy"
#!include "heroes/soldier/init.opy"
#!include "heroes/symmetra/init.opy"
#!include "heroes/tracer/init.opy"
#!include "heroes/torbjorn/init.opy"
#!include "heroes/winston/init.opy"
#!include "heroes/widowmaker/init.opy"
#!include "heroes/zarya/init.opy"
#!include "heroes/zenyatta/init.opy"

# Include debug at the end so any variable can be viewed
##!include "utilities/debug.opy"

#!include "utilities/watermark.opy"