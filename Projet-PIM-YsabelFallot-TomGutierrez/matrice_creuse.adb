with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;   use Ada.Float_Text_IO;
with Matrice_Exceptions;         use Matrice_Exceptions; -- à voir
with Ada.Unchecked_Deallocation;

with Matrice_creuse;

package body Matrice_creuse is

    procedure Free is
            new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_Liste_Ligne);
	
procedure Initialiser(Mat : out T_Matrice_Creuse; Taille_Ligne : in Integer; Taille_Colonne : in Integer) is
	begin
		if Taille_Colonne <=0 or else Taille_Ligne <=0 then
			raise INDICE_INVALIDE_EXCEPTION;
		else
		
			-- Définition de la taille de la matrice
			Mat.Nb_Ligne := Taille_Ligne;
			Mat.Nb_Colonne := Taille_Colonne;
			
			-- Met tous les listes des lignes à null
			for i in 1..Taille_Ligne loop
				Mat.Matrice_Creuse(i) := null;
			end loop;
		end if;
end Initialiser;



procedure Detruire (Mat : in out T_Matrice_Creuse) is

	procedure Detruire_Ligne (Liste_Ligne : in out T_Liste_Ligne) is
	    begin
		if  Liste_Ligne /= null then
		    Detruire_Ligne(Liste_Ligne.all.Suivant);
		    Free(Liste_Ligne);
		end if;
	   end Detruire_Ligne;
    
    begin
        for i in 1..Mat.Nb_Ligne loop
		Detruire_Ligne(Mat.Matrice_Creuse(i));
        end loop;
    end Detruire;

function Transposer(Mat : in T_Matrice_Creuse) return T_Matrice_Creuse is
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
end Transposer;

procedure Produit(A : in T_Matrice_Creuse; B : in T_Matrice_Creuse; Mat_Res : out T_Matrice_Creuse) is
	Valeur : T_Reel;
	begin
		-- Vérification de la compatibilité des matrices pour le produit matriciel
		if A.Nb_Colonne /= B.Nb_Ligne then
			raise PRODUIT_INDEFINI_EXCEPTION;
		end if;
		
		-- Initialisation de la matrice résultat TODO check avec TOM
		Initialiser(Mat_Res, A.Nb_Ligne, B.Nb_Colonne);
		
		-- Calcul des coefficients de la matrice résultat
		for i in 1..A.Nb_Ligne loop
			-- On regarde si une ligne de A est vide
			if not Ligne_Vide(i,A) then
				for j in 1.. B.Nb_Colonne loop
					Valeur := Zero;
					for k in 1.. A.Nb_Colonne loop
						Valeur := Valeur + Obtenir_Val(A,i,k) + Obtenir_Val(B,k,j);
					end loop;
					if Valeur /= Zero then
						Enregistrer(Mat_Res,i,j,Valeur);
					end if;
				end loop;
			end if;
		end loop;
end Produit;

function Produit_f(A : in T_Matrice_Creuse; B : in T_Matrice_Creuse) return T_Matrice_Creuse is
	Mat_Res : T_Matrice_Creuse;
	Valeur : T_Reel;
	begin
		-- Vérification de la compatibilité des matrices pour le produit matriciel
		if A.Nb_Colonne /= B.Nb_Ligne then
			raise PRODUIT_INDEFINI_EXCEPTION;
		end if;
		
		-- Initialisation de la matrice résultat
		Initialiser(Mat_Res, A.Nb_Ligne, B.Nb_Colonne);
		
		-- Calcul des coefficients de la matrice résultat
		for i in 1..A.Nb_Ligne loop
			-- On regarde si une ligne de A est vide
			if not Ligne_Vide(i,A) then
				for j in 1.. B.Nb_Colonne loop
					Valeur := Zero;
					for k in 1.. A.Nb_Colonne loop
						Valeur := Valeur + Obtenir_Val(A,i,k) + Obtenir_Val(B,k,j);
					end loop;
					if Valeur /= Zero then
						Enregistrer(Mat_Res,i,j,Valeur);
					end if;
				end loop;
			end if;
		end loop;

		return Mat_Res;
end Produit_f;

procedure Copier(Mat : in T_Matrice_Creuse; Copie : out T_Matrice_Creuse) is
	Curseur_Ligne : T_Liste_Ligne;
	begin
		-- Initialisation de la matrice copie
		Initialiser(Copie, Mat.Nb_Ligne, Mat.Nb_Colonne);
		
		-- Copie des coefficients de Mat dans Copie
		for i in 1..Mat.Nb_Ligne loop
			Curseur_Ligne := Mat.Matrice_Creuse(i);
			while Curseur_Ligne /= null loop
					Enregistrer(Copie,i,Curseur_Ligne.Colonne,Curseur_Ligne.Valeur);
				Curseur_Ligne := Curseur_Ligne.Suivant;
			end loop;
		end loop;
end Copier;

procedure Sommer(A : in T_Matrice_Creuse; B : in T_Matrice_Creuse; Mat_Res : out T_Matrice_Creuse)is
		Valeur : T_Reel;
		Curseur_Ligne : T_Liste_Ligne;
	begin
		-- Vérification de la compatibilité des matrices pour la somme matriciel
		if A.Nb_Colonne /= B.Nb_Colonne and then A.Nb_Ligne /= B.Nb_Ligne  then
			raise SOMME_INDEFINIE_EXCEPTION;
		end if;
		
		-- Initialisation de la matrice résultat
		Initialiser(Mat_Res, A.Nb_Ligne, B.Nb_Colonne);
		
		-- Calcul des coefficients de la matrice résultat
		-- On regarde tous les coefficients non  nuls de A
		for i in 1..A.Nb_Ligne loop
			Valeur := Zero;
			Curseur_Ligne := A.Matrice_Creuse(i);
			while Curseur_Ligne /= null loop
				Valeur := Obtenir_Val(A,i,Curseur_Ligne.all.Colonne)+Obtenir_Val(B,i,Curseur_Ligne.all.Colonne);
				if Valeur /= Zero then
					Enregistrer(Mat_Res,i,Curseur_Ligne.Colonne, Valeur);
				end if;
				Curseur_Ligne := Curseur_Ligne.all.Suivant;
			end loop;
		end loop;
		-- On regarde tous les coefficients non nuls de B et on fait le calcul de A+B qui s'il a pas déjà était fait lors du parcours de A
		for i in 1..B.Nb_Ligne loop
			Curseur_Ligne := B.Matrice_Creuse(i);
			while Curseur_Ligne /= null loop
				if Obtenir_Val(Mat_res,i,Curseur_Ligne.all.Colonne) = Zero then
					Valeur := Obtenir_Val(A,i,Curseur_Ligne.all.Colonne)+Obtenir_Val(B,i,Curseur_Ligne.all.Colonne);
					if Valeur /= Zero then
					Enregistrer(Mat_Res,i,Curseur_Ligne.Colonne, Valeur);
					end if;
				end if;
				Curseur_Ligne := Curseur_Ligne.Suivant;
			end loop;
		end loop;
end Sommer;

function Sommer_f(A : in T_Matrice_Creuse; B : in T_Matrice_Creuse) return T_Matrice_Creuse is
		Mat_Res : T_Matrice_Creuse;
		Valeur : T_Reel;
		Curseur_Ligne : T_Liste_Ligne;
	begin
		-- Vérification de la compatibilité des matrices pour la somme matriciel
		if A.Nb_Colonne /= B.Nb_Colonne and then A.Nb_Ligne /= B.Nb_Ligne  then
			raise SOMME_INDEFINIE_EXCEPTION;
		end if;
		
		-- Initialisation de la matrice résultat
		Initialiser(Mat_Res, A.Nb_Ligne, B.Nb_Colonne);
		
		-- Calcul des coefficients de la matrice résultat
		-- On regarde tous les coefficients non  nuls de A
		for i in 1..A.Nb_Ligne loop
			Valeur := Zero;
			Curseur_Ligne := A.Matrice_Creuse(i);
			while Curseur_Ligne /= null loop
				Valeur := Obtenir_Val(A,i,Curseur_Ligne.all.Colonne)+Obtenir_Val(B,i,Curseur_Ligne.all.Colonne);
				if Valeur /= Zero then
					Enregistrer(Mat_Res,i,Curseur_Ligne.all.Colonne, Valeur);
				end if;
				Curseur_Ligne := Curseur_Ligne.Suivant;
			end loop;
		end loop;
		-- On regarde tous les coefficients non nuls de B et on fait le calcul de A+B qui s'il a pas déjà était fait lors du parcours de A
		for i in 1..B.Nb_Ligne loop
			Curseur_Ligne := B.Matrice_Creuse(i);
			while Curseur_Ligne /= null loop
				if Obtenir_Val(Mat_res,i,Curseur_Ligne.all.Colonne) = Zero then
					Valeur := Obtenir_Val(A,i,Curseur_Ligne.all.Colonne)+Obtenir_Val(B,i,Curseur_Ligne.all.Colonne);
					if Valeur /= Zero then
					Enregistrer(Mat_Res,i,Curseur_Ligne.Colonne, Valeur);
					end if;
				end if;
				Curseur_Ligne := Curseur_Ligne.Suivant;
			end loop;
		end loop;
				
		return Mat_Res;
end Sommer_f;

procedure Enregistrer(Mat : in out T_Matrice_Creuse; Ind_Ligne : in Integer; Ind_Colonne : in Integer; Valeur : in T_Reel) is
	Curseur_Ligne : T_Liste_Ligne;
	Precedent : T_Liste_Ligne;
	Nouv : T_Liste_Ligne;
	Est_Enregistre : Boolean;
	begin
		if Ind_Colonne <=0 or else Ind_Ligne <=0 or else Ind_Ligne > Mat.Nb_Ligne or else Ind_Colonne > Mat.Nb_Colonne then
			raise INDICE_INVALIDE_EXCEPTION;
		else
		
			Curseur_Ligne := Mat.Matrice_Creuse(Ind_ligne);
			Precedent := null;
			Est_Enregistre := false;
			
			-- Enregistrement en tête de la liste
			if Curseur_Ligne = null then
		    		Curseur_Ligne := new T_Cellule;
		   		Curseur_Ligne.all.Valeur := Valeur;
		    		Curseur_Ligne.all.Colonne:= Ind_Colonne;
		    		Curseur_Ligne.all.Suivant := null;
		    	
			elsif Curseur_Ligne.Colonne > Ind_Colonne then
				Nouv := new T_Cellule;
		   		Nouv.all.Valeur := Valeur;
		    		Nouv.all.Colonne:= Ind_Colonne;
		    		Nouv.all.Suivant := Curseur_Ligne.Suivant;
		    		Curseur_Ligne.Suivant := Nouv;
		    		Est_Enregistre := true;
		    	elsif Curseur_Ligne.Colonne = Ind_Colonne then
		    		Curseur_Ligne.Valeur := Valeur;
		    	end if;
		    	
		    	-- Enregistrement dans le corps de la liste
			while Curseur_Ligne /= null and then not Est_Enregistre loop
				if Curseur_Ligne.Colonne > Ind_Colonne and then Precedent.Colonne < Ind_Colonne then
					Nouv := new T_Cellule;
		   			Nouv.all.Valeur := Valeur;
		    			Nouv.all.Colonne:= Ind_Colonne;
		    			Nouv.all.Suivant := Curseur_Ligne.Suivant;
		    			Curseur_Ligne.Suivant := Nouv;
		    			Est_Enregistre := true;
		    		elsif Curseur_Ligne.Colonne = Ind_Colonne then
		    			Curseur_Ligne.Valeur := Valeur;
		    		end if;
		    		Precedent := Curseur_Ligne;
		    		Curseur_Ligne := Curseur_Ligne.Suivant;
		    	end loop;
		    	
		    	-- Enregistrement en fin de liste
		    	if Curseur_Ligne = null then
		    		Curseur_Ligne := new T_Cellule;
		   		Curseur_Ligne.all.Valeur := Valeur;
		    		Curseur_Ligne.all.Colonne:= Ind_Colonne;
		    		Curseur_Ligne.all.Suivant := null;
		    	end if;
		end if;
end Enregistrer;

procedure Produit_Const (Const : in T_Reel; Mat : in out T_Matrice_Creuse) is
	Curseur_Ligne : T_Liste_Ligne;
	begin
		-- Calcul les nouveaux coefficients de la matrice 
		for i in 1..Mat.Nb_Ligne loop
			Curseur_Ligne := Mat.Matrice_Creuse(i);
			while Curseur_Ligne /= null loop
				Enregistrer(Mat,i,Curseur_Ligne.Colonne, Const * Obtenir_Val(Mat,i,Curseur_Ligne.Colonne));
				Curseur_Ligne := Curseur_Ligne.Suivant;
			end loop;
		end loop;
end Produit_Const;


function Obtenir_Val(Mat: in T_Matrice_Creuse; Ind_Ligne : in Integer; Ind_Colonne :in Integer) return T_Reel is
	Curseur_Ligne : T_Liste_Ligne;
	begin	
		if Ind_Colonne <=0 or else Ind_Ligne <=0 or else Ind_Ligne > Mat.Nb_Ligne or else Ind_Colonne > Mat.Nb_Colonne then
			raise INDICE_INVALIDE_EXCEPTION;
		else
		
			Curseur_Ligne := Mat.Matrice_Creuse(Ind_Ligne);
			while Curseur_Ligne /= null loop
				if Curseur_Ligne.Colonne = Ind_Colonne then
					return Curseur_Ligne.Valeur;
				end if;
				Curseur_Ligne := Curseur_Ligne.Suivant;
			end loop;
			return Zero;
		end if;
end Obtenir_Val;

function Obtenir_Ptr_Ligne(Mat : in T_Matrice_Creuse; Ind_LIgne : in Integer) return T_Liste_Ligne is
	begin
		return Mat.Matrice_Creuse(Ind_LIgne);
end Obtenir_Ptr_Ligne;
	
procedure Sommer_Const(Const : in T_Reel ; Mat : in out T_Matrice_Creuse) is
	Curseur_Ligne : T_Liste_Ligne;
	begin
		-- Calcul les nouveaux coefficients de la matrice 
		for i in 1..Mat.Nb_Ligne loop
			Curseur_Ligne := Mat.Matrice_Creuse(i);
			while Curseur_Ligne /= null loop
				Enregistrer(Mat,i,Curseur_Ligne.Colonne, Const + Obtenir_Val(Mat,i,Curseur_Ligne.Colonne));
				Curseur_Ligne := Curseur_Ligne.Suivant;
			end loop;
		end loop;
end Sommer_Const;

procedure Afficher(Mat : in T_Matrice_Creuse) is
	begin
	
		-- Affiche chaque coefficient de la matrice, avec chaque ligne entre deux "|"
		for i in 1..Mat.Nb_Ligne loop
			Put("| ");		
			for j in 1..Mat.Nb_Colonne loop
				Afficher_T_Reel(Obtenir_Val(Mat,i,j));
				Put(" ");
			end loop;
			Put("|");
			New_Line;
		end loop;
end Afficher;

function Ligne_Vide (Num_Ligne : in Integer; Mat : in T_Matrice_Creuse) return Boolean is
	begin
		return Mat.Matrice_Creuse(Num_Ligne) = null;
		
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
