extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var file = 'res://Questions.csv'
var question_list = []
var answer
onready var style_1 = $Antwort1.get_stylebox("AnswersStyle")
onready var style_2 = $Antwort2.get_stylebox("AnswersStyle")
onready var style_3 = $Antwort3.get_stylebox("AnswersStyle")
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	load_questions()

func new_round():
	$Richtig1.hide()
	$Richtig2.hide()
	$Richtig3.hide()
	var question_data = rand_question()
	var q_text = question_data[0]
	$Question.text = q_text
	$Antwort1.text = question_data[1]
	$Antwort2.text = question_data[2]
	$Antwort3.text = question_data[3]
	answer = question_data[4]
	print(question_data[0])

func load_questions():
	var f = File.new()
	f.open(file, File.READ)
	while !f.eof_reached(): # iterate through all lines until the end of file is reached
		var question_set = Array(f.get_csv_line())
		question_list.append(question_set)
	f.close()
	print(question_list)
	return question_list

func rand_question():
	var rand_i = rand_range(0,question_list.size())
	var question = question_list[rand_i]
	print (question)
	return question

func show_answer():
	if answer == "1":
		style_1.set_bg_color(Color("65d139"))
		$Richtig1.show()
	if answer == "2":
		style_2.set_bg_color(Color("65d139"))
		$Richtig2.show()
	if answer == "3":
		style_2.set_bg_color(Color("65d139"))
		$Richtig3.show()


func _on_Button_pressed():
	get_node("../").get_tree().quit()


func _on_Button2_pressed():
	new_round()


func _on_Button3_pressed():
	show_answer()
