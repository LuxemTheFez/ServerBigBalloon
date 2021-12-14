extends Node

var network = NetworkedMultiplayerENet.new()
var port:int = 1770
var maxPlayers:int = 2
var playerStateCollection = {}
var playerId = []

func _ready():
	network.create_server(port, maxPlayers)
	get_tree().set_network_peer(network)
	print("server lancé")
	
	
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")


func _player_connected(id):
	print("Le joueur d'id : ", id, " s'est connecté")
	playerId.append(id)

func _player_disconnected(id):
	print("Le joueur d'id : ", id, " s'est deconnecté")
	playerId.erase(id)

remote func spawnBalloon(type,path,idBalloon, offset):
	print("on spawn des balloons let's go server :")
	print(path)
	var id = get_tree().get_rpc_sender_id()
	for player in playerId:
		if player!=id:
			rpc_id(player, "spawnBalloon3D", type,path,idBalloon,offset)

remote func receiveKillBalloon(parentPath,balloonId):
	var id = get_tree().get_rpc_sender_id()
	for player in playerId:
		if player!=id:
			rpc_id(player, "killBalloon", parentPath,balloonId)

remote func remotePop(path,idBalloon,damage):
	var id = get_tree().get_rpc_sender_id()
	for player in playerId:
		if player!=id:
			rpc_id(player, "receivePop", path,idBalloon,damage)
