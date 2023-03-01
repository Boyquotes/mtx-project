extends Control

func _update_text():
	$MainSelect/CurrencyMonitor.update_values()
	$MainSelect/EuroSpent/Label.text = "Total euro spent: €" + str(Currency.total_euro_spent)
	
func _ready():
	_update_text()
	MainMenuMusic.stop_main_music()

func _on_BuyLB_c0_pressed():
	if Currency.current_crystals < 50: return
	Currency.current_crystals -= 50
	get_tree().change_scene("res://src/scenes/lootbox_scene/LootBoxOpen.tscn")
	_update_text()

func _on_BuyLB_c1_pressed():
	if Currency.current_coinels < 700: return
	Currency.current_coinels -= 700
	get_tree().change_scene("res://src/scenes/lootbox_scene/LootBoxOpen.tscn")
	_update_text()

func _on_Buy2_pressed():
	Currency.current_crystals += 190
	Currency.total_euro_spent += 2
	_update_text()

func _on_Buy5_pressed():
	Currency.current_crystals += 490
	Currency.total_euro_spent += 5
	_update_text()

func _on_Buy10_pressed():
	Currency.current_crystals += 1040
	Currency.total_euro_spent += 10
	_update_text()

func _on_Buy20_pressed():
	Currency.current_crystals += 2190
	Currency.total_euro_spent += 20
	_update_text()

func _on_BuyLB_pressed():
	$LootBox_Purchase.visible = true

func _on_LB_close_pressed():
	$LootBox_Purchase.visible = false

func _on_Back_pressed():
	get_tree().change_scene("res://src/scenes/title_screen/TitleScreen.tscn")
