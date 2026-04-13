extends Ability
class_name Major_Silver

func setup(t_: tower):
	type = Util.ABILITY_TYPES.MAJOR_SILVER
	super.setup(t_)

func cast():
	ControllerManager.silver += DataManager.abilities[type].gain_silver
