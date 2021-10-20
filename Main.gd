extends Node2D

onready var file = 'res://Questions.csv'
var question_list = []
var answer
onready var default_stylebox = $Antwort1.get_stylebox("normal")

var state = State.Title

enum State {
	Title,
	Question,
	Answer
}

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	load_questions()

func new_round():
	$Antwort1.add_stylebox_override("normal", default_stylebox)
	$Antwort2.add_stylebox_override("normal", default_stylebox)
	$Antwort3.add_stylebox_override("normal", default_stylebox)
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
	var answer_label
	if answer == "1":
		answer_label = $Antwort1
	if answer == "2":
		answer_label = $Antwort2
	if answer == "3":
		answer_label = $Antwort3

	var new_stylebox_normal = answer_label.get_stylebox("normal").duplicate()
	new_stylebox_normal.set_bg_color(Color("65d139"))
	answer_label.add_stylebox_override("normal", new_stylebox_normal)

func _on_Button_pressed():
	get_node("../").get_tree().quit()


func _on_Button2_pressed():
	if state == State.Title:
		$Question.show()
	if state == State.Question:
		show_answer()
		state = State.Answer
	else:
		new_round()
		state = State.Question
