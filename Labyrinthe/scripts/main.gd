extends Node2D

# Cases
onready var cases = [$case0, $case1, $case2, $case3, $case4, $case5, $case6, $case7, $case8, $case9, $case10, $case11, $case12, $case13, $case14, $case15, $case16, $case17, $case18, $case19, $case20, $case21, $case22, $case23, $case24]

# Variables
var nb_colonnes #nombre de colonnes dans le labyrinthe
var i_depart #index de la case départ
var i_arrivee #index de la case d'arrivée

# Called when the node enters the scene tree for the first time.
func _ready():
	nb_colonnes = 5
	i_depart = 0
	i_arrivee = 9
	
	# Place les murs
	_set_murs([1, 6, 8, 13, 16, 18])
	
	# Place le départ et l'arrivée
	_set_depart_arrive(i_depart, i_arrivee)
	
	# Initialise les voisins
	_set_voisins()
	
	# Pause de 3 secondes pour afficher le labyrinthe initial
	print("Départ du parcours dans 3 secondes")
	yield(get_tree().create_timer(3.0), "timeout")
	
	# Parcours le labyrinthe en largeur jusqu'à temps que toutes les cases aient été visitées
	_parcours_largeur()
	

# Change le type des cases pour des murs aux index passés en paramètres
# tab_index: tableau contenant les indexes des cases à transformer en murs
func _set_murs(tab_index):
	for i in range(tab_index.size()):
		cases[tab_index[i]]._set_type('mur')

# Change le type des cases pour le départ et l'arrivée aux index passés en paramètres
# index_depart: index de la case de départ
# index_arrive: index de la case d'arrivée
func _set_depart_arrive(index_depart, index_arrivee):
	cases[index_depart]._set_type('depart')
	cases[index_arrivee]._set_type('arrivee')

# Attribue les voisins de chaque case dans cet ordre: [gauche, haut, droite et bas]
func _set_voisins():
	var indexes_voisins = []
	var g = -1 #gauche
	var h = -1 #haut
	var d = -1 #droite
	var b = -1 #bas
	
	# pour chaque case du labyrinthe
	for i in range(cases.size()):
		g = i - 1
		h = i - nb_colonnes
		d = i + 1
		b = i + nb_colonnes
		
		# Si on est pas dans la première ou derniere colonne
		if (i % nb_colonnes != 0) and (i % nb_colonnes != (nb_colonnes -1)):
			# mur de gauche
			if _is_mur(g):
				g = 'mur'
			
			# mur du haut
			if h >= 0:
				if _is_mur(h):
					h = 'mur'
			else:
				h = 'vide'
			
			# mur de droite
			if _is_mur(d):
				d = 'mur'
			
			# mur du bas
			if b <= (cases.size() - 1): # si l'indice du voisin en bas est en dehors du tableau
				if _is_mur(b):
					b = 'mur'
			else:
				b = 'vide'
		else:
			# si on est dans la première colonne (pas de voisin de gauche)
			if i % nb_colonnes == 0:
				# mur de gauche
				g = 'vide'
				
				# mur du haut
				if h >= 0:
					if _is_mur(h):
						h = 'mur'
				else:
					h = 'vide'
				
				# mur de droite
				if _is_mur(d):
					d = 'mur'
				
				# mur du bas
				if b <= 24:
					if _is_mur(b):
						b = 'mur'
				else:
					b = 'vide'
				
			# si on est dans la dernière colonne (pas de voisin de droite)
			elif i % nb_colonnes == (nb_colonnes -1):
				# mur de gauche
				if _is_mur(g):
					g = 'mur'
				
				# mur du haut
				if h >= 0:
					if _is_mur(h):
						h = 'mur'
				else:
					h = 'vide'
				
				# mur de droite
				d = 'vide'
				
				# mur du bas
				if b <= 24:
					if _is_mur(b):
						b = 'mur'
				else:
					b = 'vide'
		
		# mise à jour des index des voisins
		indexes_voisins = [g, h, d, b]
		cases[i]._set_voisins(indexes_voisins)
		indexes_voisins = []

# Vérifie que la case passée en paramètre est un mur
# c: index de la case à vérifier
func _is_mur(c):
	if cases[c].type == 'mur':
		return true
	else:
		return false

# Fonction qui parcours le labyrinthe en largeur
func _parcours_largeur():
	var parent = cases[i_depart] #case de départ
	var file = [] #file des cases à marquer
	var compteur = 0 #compteur du nombre de boucles
	
	# ajoute le parent dans la file des cases à marquer
	file.append(parent)
	
	# marque la case de départ
	parent._set_visite()
	
	# Tant que la file des cases à afficher n'est pas vide
	while file.size() > 0:
		print("Boucle: ", compteur)
		
		# le parent est le premier élément dans la file
		parent = file[0]
		
		# enlève le parent de la file, car il sera marqué
		file.erase(parent)
		
		#
		for i in range(parent.voisins_accessibles.size()):
			if cases[parent.voisins_accessibles[i]].visite == false:
				file.append(cases[parent.voisins_accessibles[i]])
				cases[parent.voisins_accessibles[i]]._set_visite()
				print("Marquage de ", parent.voisins_accessibles[i])
				if cases[parent.voisins_accessibles[i]].type == 'arrivee':
					print("Arrivé à la fin du labyrinthe")
		
		# Fait une pause de 1 seconde
		yield(get_tree().create_timer(1.0), "timeout")
		compteur += 1
		
	print("Terminé")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
