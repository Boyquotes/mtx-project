extends Label


func _on_GameManager_money_changed():
	text = "Dough: " + str(Global.GameManager.get_current_money())
