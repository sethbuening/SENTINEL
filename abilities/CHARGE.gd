extends Ability
class_name Charge

var charge: int = 0

func setup(t_: tower):
	type = Util.ABILITY_TYPES.CHARGE
	super.setup(t_)

func cast():
	charge += 1
