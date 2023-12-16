with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;   use Ada.Float_Text_IO;
with Matrice_Exceptions;         use Matrice_Exceptions; -- à voir
with Matrice_creuse;

package body Matrice_creuse is
	
procedure Initialiser(Mat : out T_Matrice_Creuse; Taille_Ligne : in Integer; Taille_Colonne : in Integer) is
	begin
		-- Définition de la taille de la matrice
		Mat.Nb_Ligne := Taille_Ligne;
		Mat.Nb_Colonne := Taille_Colonne;
		
		-- Met tous les listes des lignes à null
		for i in 1..Taille_Ligne loop
			Mat.Matrice_Creuse(i) := null;
		end loop;
end Initialiser;



procedure Detruire (Mat : in out T_Matrice_Creuse) is

	procedure Detruire_Ligne (Liste_Ligne : in out T_Liste_Ligne) is
	    begin
		if not Est_Vide(Liste_Ligne) then
		    Detruire_Ligne(Liste_Ligne.all.Suivant);
		    free(Liste_Ligne);
		end if;
	   end Detruire_Ligne;
    
    begin
        for i in 1..Taille_Tab loop
		Detruire_Ligne(Mat.Matrice_Creuse(i));
        end loop;
    end Detruire;

function Transposer_f(Mat : in T_Matrice_Creuse) return T_Matrice_Creuse is
		Mat_Res : T_Matrice_Creuse;
		Curseur_Ligne : T_Liste_Ligne;
	begin
		-- Initialisation de la matrice transposée
		Initialiser(Mat_Res, Mat.Nb_Colonne, Mat.Nb_Ligne);
		
		-- Définition des coefficients de la matrice transposée
		for i in 1..Mat.Nb_Ligne loop
			Curseur_Ligne := Mat.Matrice_Creuse(i);
			while Curseur_Ligne /= null loop
				Enregistrer(Mat_Res,Curseur_Ligne.Colonne,i,Curseur_Ligne.Valeur);
				Curseur_Ligne := Curseur_Ligne.Suivant;
			end loop;
		end loop;
		return Mat_res;
end Transposer_f;

-- TODO à changer
function Produit_f(A : in T_Matrice_Creuse; B : in T_Matrice_Creuse) return T_Matrice_Creuse is
	Mat_Res : T_Matrice_Creuse;
	begin
		-- Vérification de la compatibilité des matrices pour le produit matriciel
		if A.Nb_Colonne /= B.Nb_Ligne then
			raise PRODUIT_INDEFINI_EXCEPTION;
		end if;
		
		-- Initialisation de la matrice résultat
		Initialiser(Mat_Res, A.Nb_Ligne, B.Nb_Colonne);
		
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

function Copier_f(Mat : in T_Matrice_Creuse) return T_Matrice_Creuse is
	Copie : T_Matrice_Creuse ;
	begin
		-- Initialisation de la matrice copie
		Initialiser(Mat_Res, Mat.Nb_Colonne, Mat.Nb_Ligne);
		
		-- Copie des coefficients de Mat dans Copie
		for i in 1..Mat.Nb_Ligne loop
			Curseur_Ligne := Mat.Matrice_Creuse(i);
			while Curseur_Ligne /= null loop
				Enregistrer(Mat_Res,i,Curseur_Ligne.Colonne,Curseur_Ligne.Valeur);
				Curseur_Ligne := Curseur_Ligne.Suivant;
			end loop;
		end loop;
		return Copie;
end Copier_f;

-- TODO à changer
function Sommer_f(A : in T_Matrice_Creuse; B : in T_Matrice_Creuse) return T_Matrice_Creuse is
		Mat_Res : T_Matrice_Creuse;
	begin
		-- Vérification de la compatibilité des matrices pour la somme matriciel
		if A.Nb_Colonne /= B.Nb_Colonne and then A.Nb_Ligne /= B.Nb_Ligne  then
			raise SOMME_INDEFINIE_EXCEPTION;
		end if;
		
		-- Initilisation de la matrice résultat
		Initialiser(Mat_Res, A.Nb_Ligne, B.Nb_Colonne);
		
		-- Calcul des coefficients de la matrice résultat
		for i in 1..A.Nb_Ligne loop
			while Curseur_Ligne /= null loop
				Enregistrer(Mat_Res,i,Curseur_Ligne.Colonne, A.Matrice(i).Colonne + B.Matrice(i).Colonne);
				Curseur_Ligne := Curseur_Ligne.Suivant;
			end loop;
		end loop;
		return Mat_Res;
end Sommer_f;

-- TODO à changer plus tard, tt
procedure Enregistrer(Mat : in out T_Matrice_Creuse; Ind_Ligne : in Integer; Ind_Colonne : in Integer; Valeur : in T_Reel) is
	Curseur_Ligne : T_Liste_Ligne;
	Est_Enregistre : Boolean;
	begin
		Curseur_Ligne := Mat.Matrice_Creuse(Ind_ligne);
		Est_Enregistre := false;
		while Curseur_Ligne /= null and then not Est_Enregistre loop
			if Curseur_Ligne.Colonne < Ind_Colonne then
				Nouv := new T_Cellule;
           			Nouv.all.Valeur := Valeur;
            			Nouv.all.Colonne:= Ind_Colonne;
            			Nouv.all.Suivant := Curseur_Ligne.Suivant;
            			Curseur_Ligne.Suivant : = Nouv;
            			Est_Enregistre := true;
            		elsif Curseur_Ligne.Colonne = Ind_Colonne then
            			Curseur_Ligne.Valeur := Valeur;
            		end if;
            	end loop;
            	if Curseur_Ligne = null then
            		Nouv := new T_Cellule;
           			Nouv.all.Valeur := Valeur;
            			Nouv.all.Colonne:= Ind_Colonne;
            			Nouv.all.Suivant := Curseur_Ligne.Suivant;
            			Curseur_Ligne.Suivant : = Nouv;
end Enregistrer;

procedure Produit_Const (Const : in T_Reel; Mat : in out T_Matrice_Creuse) is
	begin
		-- Calcul les nouveaux coefficients de la matrice 
		for i in 1..Mat.Nb_Ligne loop
			for j in 1..Mat.Nb_Colonne loop
				Mat.Matrice(i)(j) := Const * Mat.Matrice(i)(j);
			end loop;
		end loop;
end Produit_Const;

procedure Obtenir_Val(Mat: in T_Matrice_Creuse; Ind_Ligne : in Integer; Ind_Colonne :in Integer; Valeur : out T_Reel) is
	begin
		Valeur := Mat.Matrice(Ind_Ligne)(Ind_Colonne);
end Obtenir_Val;

function Obtenir_Val_f(Mat: in T_Matrice_Creuse; Ind_Ligne : in Integer; Ind_Colonne :in Integer) return T_Reel is
	begin	
		 return Mat.Matrice(Ind_Ligne)(Ind_Colonne);
end Obtenir_Val_f;
	
procedure Sommer_Const(Const : in T_Reel ; Mat : in out T_Matrice_Creuse) is
	begin
		-- Calcul les nouveaux coefficients de la matrice 
		for i in 1..Mat.Nb_Ligne loop
			for j in 1..Mat.Nb_Colonne loop
				Mat.Matrice(i)(j) := Const + Mat.Matrice(i)(j);
			end loop;
		end loop;
end Sommer_Const;

procedure Afficher(Mat : in T_Matrice_Creuse) is
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

function Ligne_Vide (Num_Ligne : in Integer; Mat : in T_Matrice_Creuse) return Boolean is
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

function Nombre_Lignes(Mat : in T_Matrice_Creuse) return Integer is
	begin
		return Mat.Nb_Ligne;
end Nombre_Lignes;

function Nombre_Colonnes(Mat : in T_Matrice_Creuse) return Integer is
	begin
		return Mat.Nb_Colonne;
end Nombre_Colonnes;


end Matrice_creuse;		
