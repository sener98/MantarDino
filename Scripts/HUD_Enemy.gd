extends CanvasLayer

func update_health(health):
	$ProgressBar.value = health

func show_health(goster):
	$ProgressBar.visible = goster
