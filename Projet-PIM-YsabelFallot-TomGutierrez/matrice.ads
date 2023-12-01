-- Définition des matrices
generic
	T_Valeur is private;
	
package Matrice is

	type T_Matrice is limited private;
	
	
	-- Initialiser une matrice.
	procedure Initialiser(Mat : out T_Matrice, Taille_Ligne : in Integer, Taille_Colonne : in Integer);
	
	-- Transposer une matrice.
	procedure Transposer(Mat: in out T_Matrice);
	
	-- Transposer une matrice
	function Transposer_f(Mat : in T_Matrice) return T_Matrice;
	
	-- Fait le produit matriciel de deux matrices et le stocke dans une troisième matrice
	procedure Produit(A : in T_Matrice, B : in T_Matrice, Mat_Res : out T_Matrice);
	
	-- Fait le produit matriciel et renvoie la matrice
	function Produit_f(A : in T_Matrice, B : in T_Matrice) return T_Matrice;
	
	-- Copie une matrice dans une autre
	procedure Copier(Mat : in T_Matrice, Copie : out T_Matrice);
	
	-- Copier une matrice dans une autre
	function Copier_f(Mat : in T_Matrice) return T_Matrice:
	
	-- Somme deux matrices et la stocke dans une troisième matrice
	procedure Sommer(A : in T_Matrice, B : in T_Matrice, Mat_Res : out T_Matrice);
	
	-- Somme deux matrices et renvoie le résultat
	function Sommer(A : in T_Matrice, B : in T_Matrice) return T_Matrice;
	
	-- Enregistre la valeur donnée en paramètre au coefficient de coordonnées données
	procedure Enregistrer(Mat : in out T_Matrice, Ind_Ligne : in Integer, Ind_Colonne ; in Integer, Valeur : in T_Reel);
	
	-- Fait le produit d'une constante avec une matrice
	procedure Produit_Const (Const : in T_Reel, Mat : in out T_Matrice);
	
	-- Stock dans Valeur le coefficient de la matrice aux coordonnées données
	procedure Obtenir_Val(Mat: in T_Matrice, Ind_Ligne : in Integer, Ind_Colonne :in Integer, Valeur : out T_Reel);
	
	-- Fait la somme d'une constante avec une matrice
	procedure Sommer_Const(Mat : in out T_Matrice, Const : in T_Reel);
	
	-- Afficher une matrice
	procedure Afficher (Mat : in T_Matrice);
	
	-- Savoir si la ligne de la matrice ne contient que des 0
	function Ligne_Vide (Num_Ligne : in Integer, Mat : in T_Matrice) return Boolean;
	
	-- Récupère le nombre de ligne d'une matrice
	function Nombre_Lignes(Mat : in T_Matrice) return Integer;
	
	-- Récupère le nombre de ligne d'une matrice
	function Nombre_Colonnes(Mat : in T_Matrice) return Integer;
	
private 
	type T_Valeur is array (1.._Num_Ligne) of array (1..Num_Colonne) of T_Reel;
	type T_Martrice is
		record
			Matrice : T_Valeur;
			Nb_Ligne : Integer;
			Nb_Colonne : Integer;
		end record;
		
end Matrice;