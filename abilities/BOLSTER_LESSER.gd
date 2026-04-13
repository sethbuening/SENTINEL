extends Ability
class_name Bolster_Lesser

func setup(t_: tower):
	type = Util.ABILITY_TYPES.BOLSTER_LESSER
	super.setup(t_)

func cast():
	t.health_bar.MAX_HEALTH += DataManager.abilities[type].gain_health
	t.health_bar.current_health += DataManager.abilities[type].gain_health
