-- Définition des matrices
generic		
	 type T_Reel is digits <>; --! type réel de précision quelconque
	 --Num_Ligne : Integer; -- Nombre maximum de ligne possibles pour les matrices
	 Zero :  T_Reel;
	 Taille_Tab : Integer;
	
package Matrice_Creuse is

	type T_Matrice_Creuse is  private;
	
	type T_TableauElements is array (1..Taille_Tab) of T_Reel;

    	type T_Tableau is
		record
		    Elements: T_TableauElements;
		    Taille: Integer;
		    -- Invariant: 0 <= Taille and Taille <= Capacite;
		end record;
	
	-- Initialiser une matrice.avec tous ses coefficients qui valent Val
	procedure Initialiser(Mat : out T_Matrice_Creuse; Taille_Ligne : in Integer; Taille_Colonne : in Integer);
	
	   -- Détruire la matrice.  Elle ne devra plus être utilisée.
    	procedure Detruire (Mat : in out T_Matrice_Creuse);
	
	-- Renvoie la transposer de la matrice Mat
	procedure Transposer(Mat : in T_Matrice_Creuse; Mat_Res : out T_Matrice_Creuse);
	
	-- Fait le produit matriciel de deux matrices et le stocke dans une troisième matrice
	procedure Produit(A : in T_Matrice_Creuse; B : in T_Matrice_Creuse; Mat_Res : out T_Matrice_Creuse);
	
	-- Renvoie une copie de Mat
	procedure Copier(Mat : in T_Matrice_Creuse; Copie : out T_Matrice_Creuse);
	
	-- Somme deux matrices et la stocke dans une troisième matrice
	procedure Sommer(A : in T_Matrice_Creuse; B : in T_Matrice_Creuse; Mat_Res : out T_Matrice_Creuse);
	
	-- Enregistre la valeur donnée en paramètre au coefficient de coordonnées données
	procedure Enregistrer(Mat : in out T_Matrice_Creuse; Ind_Ligne : in Integer;  Ind_Colonne : in Integer; Valeur : in T_Reel);

	-- Fait le produit d'une constante avec une matrice
	procedure Produit_Const (Const : in T_Reel; Mat : in out T_Matrice_Creuse);
	
	-- Fait le produit entre une matrice pleine et une matrice creuse
	function Produit_Tab_Creux (Tab : T_Tableau; Creux : T_Matrice_Creuse) return T_Tableau;
	
	-- Retourne la valeur aux coordonnées données
	function Obtenir_Val(Mat: in T_Matrice_Creuse; Ind_Ligne : in Integer; Ind_Colonne : in Integer) return T_Reel;
	
	-- Fait la somme d'une constante avec une matrice
	procedure Sommer_Const(Const : in T_Reel ; Mat : in out T_Matrice_Creuse);
	
	generic
        with procedure Afficher_Val (Val : in T_Reel);
	procedure Afficher_Colonne(Mat : in T_Matrice_Creuse; Ind_Colonne : in Integer);
	
	-- Afficher une matrice, dont les coefficients sont des T_Reel génériques
	generic
        with procedure Afficher_T_Reel (Val : in T_Reel);
	procedure Afficher (Mat : in T_Matrice_Creuse);
	
	-- Savoir si la ligne de la matrice ne contient que des 0
	function Ligne_Vide (Num_Ligne : in Integer; Mat : in T_Matrice_Creuse) return Boolean;
	
	-- Récupère le nombre de ligne d'une matrice
	function Nombre_Lignes(Mat : in T_Matrice_Creuse) return Integer;
	
	-- Récupère le nombre de ligne d'une matrice
	function Nombre_Colonnes(Mat : in T_Matrice_Creuse) return Integer;
	
private 
	type T_Cellule;
	type T_Colonne;
	type T_Liste_Colonne is access T_Cellule ; -- Premier tableau représentant les colonnes de la matrice
	type T_Ptr_Colonne is access T_Colonne; -- Deuxième tableau dont les indices correspondent aux lignes de la matrice et qui contient la tableau des colonnes
	
	type T_Cellule is
		record
			Ligne : Integer; -- Clé de la valeur dans la liste représentant les éléments d'une ligne, numéro de colonne de l'élément
			Valeur : T_Reel; -- Valeur d'un coefficient
			Suivant : T_Liste_Colonne; -- Pointeur vers l'élément suivant de la même ligne
		end record;
		
	type T_Colonne is 
		record
			Num_Colonne: Integer;
			Colonne_Actuelle : T_Liste_Colonne;
			Colonne_Suivante : T_Ptr_Colonne;
		end record;
	
	type T_Matrice_Creuse is
		record
			Matrice_Creuse : T_Ptr_Colonne; -- Tableau de pointeurs représentant la matrice
			Nb_Ligne : Integer; -- Nombre de lignes de la matrice
			Nb_Colonne : Integer; -- Nombre de colonnes de la matrice
		end record;
		
end Matrice_Creuse;
