-- Définition des matrices
generic		
	 type T_Reel is digits <>; --! type réel de précision quelconque
	 Num_Colonne : Integer; -- Nombre maximum de colonne possibles pour les matrices
	 Num_Ligne : Integer; -- Nombre maximum de ligne possibles pour les matrices
	
package Matrice is

	type T_Matrice is  private;
	
	-- Initialiser une matrice.avec tous ses coefficients qui valent Val
	procedure Initialiser(Mat : out T_Matrice; Taille_Ligne : in Integer; Taille_Colonne : in Integer; Val : in T_Reel);
	
	-- Transposer une matrice.
	procedure Transposer(Mat: in out T_Matrice);
	
	-- Renvoie la transposer de la matrice Mat
	function Transposer_f(Mat : in T_Matrice) return T_Matrice;
	
	-- Fait le produit matriciel de deux matrices et le stocke dans une troisième matrice
	procedure Produit(A : in T_Matrice; B : in T_Matrice; Mat_Res : out T_Matrice);
	
	-- Fait le produit matriciel et renvoie la matrice
	function Produit_f(A : in T_Matrice; B : in T_Matrice) return T_Matrice;
	
	-- Copie une matrice dans une autre
	procedure Copier(Mat : in T_Matrice; Copie : out T_Matrice);
	
	-- Renvoie une copie de Mat
	function Copier_f(Mat : in T_Matrice) return T_Matrice;
	
	-- Somme deux matrices et la stocke dans une troisième matrice
	procedure Sommer(A : in T_Matrice; B : in T_Matrice; Mat_Res : out T_Matrice);
	
	-- Somme deux matrices et renvoie le résultat
	function Sommer_f(A : in T_Matrice; B : in T_Matrice) return T_Matrice;
	
	-- Enregistre la valeur donnée en paramètre au coefficient de coordonnées données
	procedure Enregistrer(Mat : in out T_Matrice; Ind_Ligne : in Integer;  Ind_Colonne : in Integer; Valeur : in T_Reel);

	-- Fait le produit d'une constante avec une matrice
	procedure Produit_Const (Const : in T_Reel; Mat : in out T_Matrice);
	
	-- Stock dans Valeur le coefficient de la matrice aux coordonnées données
	procedure Obtenir_Val(Mat: in T_Matrice; Ind_Ligne : in Integer; Ind_Colonne :in Integer; Valeur : out T_Reel);
	
	-- Retourne la valeur aux coordonnées données
	function Obtenir_Val_f(Mat: in T_Matrice; Ind_Ligne : in Integer; Ind_Colonne : in Integer) return T_Reel;
	
	-- Fait la somme d'une constante avec une matrice
	procedure Sommer_Const(Const : in T_Reel ; Mat : in out T_Matrice);
	
	-- Afficher une matrice, dont les coefficients sont des T_Reel génériques
	generic
        with procedure Afficher_T_Reel (Val : in T_Reel);
	procedure Afficher (Mat : in T_Matrice);
	
	-- Savoir si la ligne de la matrice ne contient que des 0
	function Ligne_Vide (Num_Ligne : in Integer; Mat : in T_Matrice) return Boolean;
	
	-- Récupère le nombre de ligne d'une matrice
	function Nombre_Lignes(Mat : in T_Matrice) return Integer;
	
	-- Récupère le nombre de ligne d'une matrice
	function Nombre_Colonnes(Mat : in T_Matrice) return Integer;
	
private 

	type T_Tab_Colonne is array (1..100) of T_Reel; -- Premier tableau représentant les colonnes de la matrice
	type T_Tab_Ligne is array (1..100) of T_Tab_Colonne ; -- Deuxième tableau dont les indices correspondent aux lignes de la matrice et qui contient la tableau des colonnes
	type T_Matrice is
		record
			Matrice : T_Tab_Ligne; -- Tableau de tableau représentant la matrice
			Nb_Ligne : Integer; -- Nombre de lignes de la matrice
			Nb_Colonne : Integer; -- Nombre de colonnes de la matrice
		end record;
		
end Matrice;
