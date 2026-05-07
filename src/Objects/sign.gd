extends Node

@export var promptPanel : Panel
@export var detailPanel : Panel
@export var promptLabel : Label
@export var detailLabel : Label
@export_multiline var detailText : String

var showPrompt : bool = false
var showDetail : bool = false

func _ready() -> void:
	promptPanel.visible = showPrompt
	detailPanel.visible = showDetail
	detailLabel.text = detailText

func _input(event):
	
	if Input.is_action_just_pressed("interact"):
		if showPrompt == true and showDetail == false:
			showPrompt = false
			showDetail = true
			promptPanel.visible = showPrompt
			detailPanel.visible = showDetail
		elif showPrompt == false and showDetail == true:
			showPrompt = true
			showDetail = false
			promptPanel.visible = showPrompt
			detailPanel.visible = showDetail

func _on_area_entered(area):
	showPrompt = true
	promptPanel.visible = showPrompt

func _on_area_exited(area):
	showPrompt = false
	showDetail = false
	promptPanel.visible = showPrompt
	detailPanel.visible = showDetail
