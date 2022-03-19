extends Node2D

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

var _position = Vector2.ZERO
var _direction = Vector2.RIGHT
var _boarders = Rect2()
var _stepHistory = []

var _tbOpen = preload("res://walls/TB_Open.tscn")
var _tbClosed = preload("res://walls/TB_Closed.tscn")
var _lrOpen = preload("res://walls/LR_Open.tscn")
var _lrClosed = preload("res://walls/LR_Closed.tscn")

var rooms = []

func loadRooms():
	var path = "res://Rooms"
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			break
		elif !file_name.begins_with(".") and !file_name.ends_with(".import"):
			rooms.append(load(path + "/" + file_name))
	dir.list_dir_end()

func _ready():
	loadRooms()
	
