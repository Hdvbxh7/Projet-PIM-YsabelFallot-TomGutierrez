with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with SDA_Exceptions;         use SDA_Exceptions;
with Ada.Unchecked_Deallocation;
with Matrice;

package body Matrice is
	
	procedure Initialiser(Mat : out T_Matrice, Taille_Ligne : in Integer, Taille_Colonne : in Integer) is
	begin
		Mat.Nb_Ligne := Taille_Ligne;
		Mat.Nb_Colonne := Taille_Colonne;
		for i in 1..Taille_Ligne loop
			for j in 1..Taille_Colonne loop
				Mat.Matrice(i)(j) := 0;
			end loop;
		end loop;
end Initialiser;
	
	procedure Transposer(Mat: in out T_Matrice) is
		aux : T_Reel;
	begin
		for i in 1..Mat.Nb_Ligne loop
			for j in 1..i loop
				aux := Mat.Matrice(i)(j);
				Mat.Matrice(i)(j) := Mat.Matrice(j)(i);
				Mat.Matrice(j)(i) := aux;
			end loop;
		end loop;
end Transposer;

procedure Produit(A : in T_Matrice, B : in T_Matrice, Mat_Res : out T_Matrice) is
	begin
		--Vérification de la compatibilité des matrices pour le produit matriciel
		if A.Nb_Colonne /= B.Nb_Ligne then
			raise PRODUIT_INDEFINI_EXCEPTION;
		end if;
		
		Initialiser(Mat_Res,A.Nb_Ligne,B.Nb_Colonne);
		for i in 1..Mat.Nb_Ligne loop
			for j in 1..Mat.Nb_Colonne loop
				Mat_Res.Matrice(i)(j) := Mat_Res.Matrice(i)(j) + A.Matrice(i)(j)*B.Matrice(j)(i);
			end loop;
		end loop;
end Produit;
		
procedure Copier(Mat : in T_Matrice, Copie : out T_Matrice) is
	begin
		Initisalier(Copie, Mat.Nb_Ligle, Mat.Nb_Colonne);
		for i in 1..Mat.Nb_Ligne loop
			for j in 1..Mat.Nb_Colonne loop
				Copie.Matrice(i)(j) := Mat.Matrice(i)(j);
			end loop;
		end loop:
end Copier;

procedure Produit_Const (Const : in T_Reel, Mat : in out T_Matrice) is
	begin
		for i in 1..Mat.Nb_Ligne loop
			for j in 1..Mat.Nb_Colonne loop
				MatMatrice(i)(j) := Const * Mat.Matrice(i)(j);
			end loop;
		end loop;
end Produit_Const;

function Ligne_Vide (Num_Ligne : in Integer, Mat : in T_Matrice) return Boolean is
		Num_Colonne : Integer:
		A_Que_Zero : Boolean;
	begin
		Num_Colonne := 1;
		A_Que_Zero := true;
		while Num_Colonne <=Mat.Nb_Ligne and then A_Que_Zerao loop
			if Mat.Matrice(Num_Ligne)(Num_Colonne) /= 0 then
				A_Quu_Zero := false;
			end if;
		end loop;
		return A_Que_Zero;
end Ligne_Vide;


end Matrice;
		
