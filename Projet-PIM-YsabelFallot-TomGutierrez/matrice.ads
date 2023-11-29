-- Définition des matrices
generic
	T_Valeur is private;
	
package Matrice is

	type T_Matrice is limited private;
	
	
	-- Initialiser une matrice.
	procedure Initialiser(Mat : out T_Matrice, Taille_Ligne : in Integer, Taille_Colonne : in Integer);
	
	-- Transposer une matrice.
	procedure Transposer(Mat: in out T_Matrice);
	
	-- Fait le produit matriciel de deux matrices et le stocke dans une troisième matrice
	procedure Produit(A : in T_Matrice, B : in T_Matrice, Mat_Res : out T_Matrice);
	
	-- Copie une matrice dans une autre
	procedure Copier(Mat : in T_Matrice, Copie : out T_Matrice);
	
	-- Fait le produit d'une constante avec une matrice
	procedure Produit_Const (Const : in T_Reel, Mat : in out T_Matrice);
	
	-- Savoir si la ligne de la matrice ne contient que des 0
	function Ligne_Vide (Num_Ligne : in Integer, Mat : in T_Matrice) return Boolean;
	
private 
	type T_Valeur is array (1.._Num_Ligne) of array (1..Num_Colonne) of T_Reel;
	type T_Martrice is
		record
			Matrice : T_Valeur;
			Nb_Ligne : Integer;
			Nb_Colonne : Integer;
		end record;
		
end Matrice;
