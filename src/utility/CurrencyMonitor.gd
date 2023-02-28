extends Control

func update_values():
	$Currency/Coingels.text = str(Currency.current_coinels)
	$Currency/Crystals.text = str(Currency.current_crystals)
