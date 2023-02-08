extends Label


func _on_GameManager_money_changed():
	text = str(Global.GameManager.get_current_money())
