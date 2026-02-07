#!/usr/bin/env -S godot --headless -s
@tool
extends "res://addons/gd-plug/plug.gd"


func _plugging():
	plug("ramokz/phantom-camera", {"tag": "v0.10"})
