-- Définition des matrices
generic		
	 -- type Float is digits <>; --! type réel de précision quelconque
	  Num_Colonne : Integer; -- Nb maximun de colonne possibles pour les matrices
	 Num_Ligne : Integer; -- Nb maximum de ligne possibles pour les matrices
	
package Matrice is

	type T_Matrice is  private;
	
	
	-- Initialiser une matrice.
	procedure Initialiser(Mat : out T_Matrice; Taille_Ligne : in Integer; Taille_Colonne : in Integer);
	
	-- Transposer une matrice.
	procedure Transposer(Mat: in out T_Matrice);
	
	-- Transposer une matrice
	function Transposer_f(Mat : in T_Matrice) return T_Matrice;
	
	-- Fait le produit matriciel de deux matrices et le stocke dans une troisième matrice
	procedure Produit(A : in T_Matrice; B : in T_Matrice; Mat_Res : out T_Matrice);
	
	-- Fait le produit matriciel et renvoie la matrice
	function Produit_f(A : in T_Matrice; B : in T_Matrice) return T_Matrice;
	
	-- Copie une matrice dans une autre
	procedure Copier(Mat : in T_Matrice; Copie : out T_Matrice);
	
	-- Copier une matrice dans une autre
	function Copier_f(Mat : in T_Matrice) return T_Matrice;
	
	-- Somme deux matrices et la stocke dans une troisième matrice
	procedure Sommer(A : in T_Matrice; B : in T_Matrice; Mat_Res : out T_Matrice);
	
	-- Somme deux matrices et renvoie le résultat
	function Sommer_f(A : in T_Matrice; B : in T_Matrice) return T_Matrice;
	
	-- Enregistre la valeur donnée en paramètre au coefficient de coordonnées données
	procedure Enregistrer(Mat : in out T_Matrice; Ind_Ligne : in Integer;  Ind_Colonne : in Integer; Valeur : in Float);

	-- Fait le produit d'une constante avec une matrice
	procedure Produit_Const (Const : in Float; Mat : in out T_Matrice);
	
	-- Stock dans Valeur le coefficient de la matrice aux coordonnées données
	procedure Obtenir_Val(Mat: in T_Matrice; Ind_Ligne : in Integer; Ind_Colonne :in Integer; Valeur : out Float);
	
	-- Retourne la valeur a des coordonnées données
	function Obtenir_Val_f(Mat: in T_Matrice; Ind_Ligne : in Integer; Ind_Colonne : in Integer) return Float;
	
	-- Fait la somme d'une constante avec une matrice
	procedure Sommer_Const(Const : in Float ; Mat : in out T_Matrice);
	
	-- Afficher une matrice
	procedure Afficher (Mat : in T_Matrice);
	
	-- Savoir si la ligne de la matrice ne contient que des 0
	function Ligne_Vide (Num_Ligne : in Integer; Mat : in T_Matrice) return Boolean;
	
	-- Récupère le nombre de ligne d'une matrice
	function Nombre_Lignes(Mat : in T_Matrice) return Integer;
	
	-- Récupère le nombre de ligne d'une matrice
	function Nombre_Colonnes(Mat : in T_Matrice) return Integer;
	
private 
	--type Integer is integer;
	--Num_Colonne : constant Integer := 10;
	--Num_Ligne : constant Integer := 10;
	type T_Tab_Colonne is array (1..100) of Float;
	type T_Valeur is array (1..100) of T_Tab_Colonne ;
	type T_Matrice is
		record
			Matrice : T_Valeur;
			Nb_Ligne : Integer;
			Nb_Colonne : Integer;
		end record;
		
end Matrice;
