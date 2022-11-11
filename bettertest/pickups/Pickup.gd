extends Area

class_name Pickup

enum PICKUP_TYPES {CANDLE, CANDLE_AMMO, DUALCANDLE, DUALCANDLE_AMMO, 
CENSER, CENSER_AMMO, HEALTH}

export(PICKUP_TYPES) var pickup_type
export var ammo = 10
