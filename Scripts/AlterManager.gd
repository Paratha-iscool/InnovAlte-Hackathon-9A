extends Node

var Alters = {};

func addAlter(Alter : Resource):
	Alters[Alter.name] = Alter

func getAlter(name: String):
	return Alters.get(name);
	
func getAllPeople():
	return Alters;
	
func remove_person(name:String):
	Alters.erase(name)
