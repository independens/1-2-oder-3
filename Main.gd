extends Node2D

onready var file = 'res://Questions.csv'
var question_list = []
var answer
var timer
var previous_highlighted_answer = -1

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
	$Timer.connect("timeout", self, "_on_timer")
	$Question.hide()

func new_round():
	$Antwort1.highlight = false
	$Antwort2.highlight = false
	$Antwort3.highlight = false
	var question_data = rand_question()
	var q_text = question_data[0]
	$Question.text = q_text
	$Antwort1.text = question_data[1]
	$Antwort2.text = question_data[2]
	$Antwort3.text = question_data[3]
	answer = question_data[4]
	$Timer.start()

func load_questions():
	var f = File.new()
	f.open(file, File.READ)
	while !f.eof_reached(): # iterate through all lines until the end of file is reached
		var question_set = Array(f.get_csv_line())
		if question_set.size() == 5:
			question_list.append(question_set)
	f.close()
	print(question_list)
	return question_list

func rand_question():
	var rand_i = randi() % question_list.size()
	var question = question_list[rand_i]
	return question

func show_answer():
	$Timer.stop()
	_clear_colors()
	var answer_node
	if answer == "1":
		answer_node = $Antwort1
	if answer == "2":
		answer_node = $Antwort2
	if answer == "3":
		answer_node = $Antwort3
	$DMXControl.call_alarm()
	answer_node.set_highlight(true)

func _on_Button2_pressed():
	if state == State.Title:
		$Question.show()
	if state == State.Question:
		show_answer()
		state = State.Answer
	else:
		new_round()
		state = State.Question

func _on_timer():
	_clear_colors()
	var answer_index = previous_highlighted_answer
	while answer_index == previous_highlighted_answer:
		answer_index = randi() % 3
	_get_answer_by_index(answer_index).set_highlight(true)
	previous_highlighted_answer = answer_index

func _get_answer_by_index(index):
	return get_node("Antwort%s" % (index + 1))

func _clear_colors():
	for i in range(0, 3):
		_get_answer_by_index(i).set_highlight(false)
	
