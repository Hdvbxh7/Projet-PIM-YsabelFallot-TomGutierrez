with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;   use Ada.Float_Text_IO;
with Matrice_Exceptions;         use Matrice_Exceptions;
with Matrice;

package body Matrice is
	
	procedure Initialiser(Mat : out T_Matrice; Taille_Ligne : in Integer; Taille_Colonne : in Integer; Val : in T_Reel) is
	begin
		if Taille_Colonne <=0 or else Taille_Ligne <=0 then
			raise INDICE_INVALIDE_EXCEPTION;
		else
			-- Définition de la taille de la matrice
			Mat.Nb_Ligne := Taille_Ligne;
			Mat.Nb_Colonne := Taille_Colonne;
			
			-- Met tous les coefficients de la matrice à la valeur donnée
			for i in 1..Taille_Ligne loop
				for j in 1..Taille_Colonne loop
					Enregistrer(Mat, i, j, Val);
				end loop;
			end loop;
		end if;
end Initialiser;

function Transposer_f(Mat : in T_Matrice) return T_Matrice is
		Mat_Res : T_Matrice;
	begin
		-- Définition de la taille de la matrice transposée
		Mat_Res.Nb_Ligne := Mat.Nb_Colonne;
		Mat_Res.Nb_Colonne := Mat.Nb_Ligne;
		
		-- Définition des coefficients de la matrice transposée
		for i in 1..Mat.Nb_Ligne loop
			for j in 1..i loop
				if i/=j then
					Mat_Res.Matrice(i)(j) := Mat.Matrice(j)(i);
					Mat_Res.Matrice(j)(i) := Mat.Matrice(i)(j);
				else 
					Mat_Res.Matrice(i)(j) := Mat.Matrice(i)(j);
				end if;
			end loop;
		end loop;
		return Mat_res;
end Transposer_f;

procedure Produit(A : in T_Matrice; B : in T_Matrice; Mat_Res : out T_Matrice) is
	begin
		-- Vérification de la compatibilité des matrices pour le produit matriciel
		if A.Nb_Colonne /= B.Nb_Ligne then
			raise PRODUIT_INDEFINI_EXCEPTION;
		end if;
		
		-- Définition des dimensions de la matrice résultat
		Mat_Res.Nb_Ligne := A.Nb_Ligne;
		Mat_Res.Nb_Colonne := B.Nb_Colonne;
		
		-- Calcul des coefficients de la matrice résultat
		for i in 1..A.Nb_Ligne loop
			for j in 1.. B.Nb_Colonne loop
				for k in 1.. A.Nb_Colonne loop
					if k/=1 then
						Mat_Res.Matrice(i)(j) := Mat_Res.Matrice(i)(j) + A.Matrice(i)(k)*B.Matrice(k)(j);
					else
						-- Initialisation du coefficient (i,j) de la matrice pour la somme du calcul du produit matriciel
						Mat_Res.Matrice(i)(j) := A.Matrice(i)(1)*B.Matrice(1)(j);
					end if;
				end loop;
			end loop;
		end loop;
end Produit;

function Produit_f(A : in T_Matrice; B : in T_Matrice) return T_Matrice is
	Mat_Res : T_Matrice;
	begin
		-- Vérification de la compatibilité des matrices pour le produit matriciel
		if A.Nb_Colonne /= B.Nb_Ligne then
			raise PRODUIT_INDEFINI_EXCEPTION;
		end if;
		
		-- Définition des dimensions de la matrice résultat
		Mat_Res.Nb_Ligne := A.Nb_Ligne;
		Mat_Res.Nb_Colonne := B.Nb_Colonne;
		
		-- Calcul des coefficients de la matrice résultat
		for i in 1..A.Nb_Ligne loop
			for j in 1.. B.Nb_Colonne loop
				for k in 1.. A.Nb_Colonne loop
					if k/=1 then
						Mat_Res.Matrice(i)(j) := Mat_Res.Matrice(i)(j) + A.Matrice(i)(k)*B.Matrice(k)(j);
					else
						-- Initialisation du coefficient (i,j) de la matrice pour la somme du calcul du produit matriciel
						Mat_Res.Matrice(i)(j) := A.Matrice(i)(1)*B.Matrice(1)(j);
					end if;
				end loop;
			end loop;
		end loop;
		return Mat_Res;
end Produit_f;
		
procedure Copier(Mat : in T_Matrice;  Copie : out T_Matrice) is
	begin
		-- Attribue les dimensions de la matrice de départ
		Copie.Nb_Ligne := Mat.Nb_Ligne;
		Copie.Nb_Colonne := Mat.Nb_Colonne;
		
		-- Copie des coefficients de Mat dans Copie
		for i in 1..Mat.Nb_Ligne loop
			for j in 1..Mat.Nb_Colonne loop
				Copie.Matrice(i)(j) := Mat.Matrice(i)(j);
			end loop;
		end loop;
end Copier;

procedure Sommer(A : in T_Matrice; B : in T_Matrice; Mat_Res : out T_Matrice) is
	begin
		-- Vérification de la compatibilité des matrices pour la somme matriciel
		if A.Nb_Colonne /= B.Nb_Colonne or else A.Nb_Ligne /= B.Nb_Ligne  then
			raise SOMME_INDEFINIE_EXCEPTION;
		end if;
		
		-- Attribution des dimensions de la matrice résultat
		Mat_Res.Nb_Ligne := A.Nb_Ligne;
		Mat_Res.Nb_Colonne := B.Nb_Colonne;
		
		-- Calcul des coefficients de la matrice résultat
		for i in 1..A.Nb_Ligne loop
			for j in 1..A.Nb_Colonne loop
				Mat_Res.Matrice(i)(j) := A.Matrice(i)(j)+B.Matrice(i)(j);
			end loop;
		end loop;	
end Sommer;

function Sommer_f(A : in T_Matrice; B : in T_Matrice) return T_Matrice is
		Mat_Res : T_Matrice;
	begin
		-- Vérification de la compatibilité des matrices pour la somme matriciel
		if  A.Nb_Colonne /= B.Nb_Colonne or else A.Nb_Ligne /= B.Nb_Ligne  then
			raise SOMME_INDEFINIE_EXCEPTION;
		end if;
		
		-- Attribution des dimensions de la matrice résultat
		Mat_Res.Nb_Ligne := A.Nb_Ligne;
		Mat_Res.Nb_Colonne := B.Nb_Colonne;
		
		-- Calcul des coefficients de la matrice résultat
		for i in 1..A.Nb_Ligne loop
			for j in 1..A.Nb_Colonne loop
				Mat_Res.Matrice(i)(j) := A.Matrice(i)(j)+B.Matrice(i)(j);
			end loop;
		end loop;
		return Mat_Res;
end Sommer_f;

procedure Enregistrer(Mat : in out T_Matrice; Ind_Ligne : in Integer; Ind_Colonne : in Integer; Valeur : in T_Reel) is
	begin
		if Ind_Colonne <=0 or else Ind_Ligne <=0 or else Ind_Ligne > Mat.Nb_Ligne or else Ind_Colonne > Mat.Nb_Colonne then
			raise INDICE_INVALIDE_EXCEPTION;
		else
			Mat.Matrice(Ind_ligne)(Ind_Colonne) := Valeur;
		end if;
end Enregistrer;

procedure Produit_Const (Const : in T_Reel; Mat : in out T_Matrice) is
	begin
		-- Calcul les nouveaux coefficients de la matrice 
		for i in 1..Mat.Nb_Ligne loop
			for j in 1..Mat.Nb_Colonne loop
				Mat.Matrice(i)(j) := Const * Mat.Matrice(i)(j);
			end loop;
		end loop;
end Produit_Const;

function Obtenir_Val_f(Mat: in T_Matrice; Ind_Ligne : in Integer; Ind_Colonne :in Integer) return T_Reel is
	begin	
		if Ind_Colonne <=0 or else Ind_Ligne <=0 or else Ind_Ligne > Mat.Nb_Ligne or else Ind_Colonne > Mat.Nb_Colonne then
			raise INDICE_INVALIDE_EXCEPTION;
		else
		 	return Mat.Matrice(Ind_Ligne)(Ind_Colonne);
		end if;
end Obtenir_Val_f;
	
procedure Sommer_Const(Const : in T_Reel ; Mat : in out T_Matrice) is
	begin
		-- Calcul les nouveaux coefficients de la matrice 
		for i in 1..Mat.Nb_Ligne loop
			for j in 1..Mat.Nb_Colonne loop
				Mat.Matrice(i)(j) := Const + Mat.Matrice(i)(j);
			end loop;
		end loop;
end Sommer_Const;

procedure Afficher(Mat : in T_Matrice) is
begin
	-- Affiche chaque coefficient de la matrice, avec chaque ligne entre deux |
	for i in 1..Mat.Nb_Ligne loop
		Put("| ");
		for j in 1..Mat.Nb_Colonne loop
			Afficher_T_Reel(Mat.Matrice(i)(j));
			Put(" ");
		end loop;
		Put("|");
		New_Line;
	end loop;
end Afficher;

function Ligne_Vide (Num_Ligne : in Integer; Mat : in T_Matrice) return Boolean is
		Num_Colonne : Integer;
		A_Que_Zero : Boolean;
	begin
		Num_Colonne := 1;
		A_Que_Zero := true;
		-- Parcours les colonnes de la ligne pour détecter la présence d'un 0
		while Num_Colonne <=Mat.Nb_Ligne and then A_Que_Zero loop
			if Mat.Matrice(Num_Ligne)(Num_Colonne) /= Zero then
				A_Que_Zero := false;
			end if;
			Num_Colonne := Num_Colonne +1;
		end loop;
		return A_Que_Zero;
end Ligne_Vide;

function Nombre_Lignes(Mat : in T_Matrice) return Integer is
	begin
		return Mat.Nb_Ligne;
end Nombre_Lignes;

function Nombre_Colonnes(Mat : in T_Matrice) return Integer is
	begin
		return Mat.Nb_Colonne;
end Nombre_Colonnes;


end Matrice;		
