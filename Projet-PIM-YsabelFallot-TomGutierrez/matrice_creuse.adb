with Ada.Text_IO;            use Ada.Text_IO;
with Matrice_Exceptions;         use Matrice_Exceptions; -- à voir
with Ada.Unchecked_Deallocation;


package body Matrice_creuse is

    procedure Free_Ligne is
            new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_Liste_Ligne);
            
    procedure Free_Ptr_Ligne is
            new Ada.Unchecked_Deallocation (Object => T_Ligne, Name => T_Ptr_Ligne);
	
procedure Initialiser(Mat : out T_Matrice_Creuse; Taille_Ligne : in Integer; Taille_Colonne : in Integer) is
	begin
		if Taille_Colonne <=0 or else Taille_Ligne <=0 then
			raise INDICE_INVALIDE_EXCEPTION;
		else
		
			-- Définition de la taille de la matrice
			Mat.Nb_Ligne := Taille_Ligne;
			Mat.Nb_Colonne := Taille_Colonne;

			Mat.Matrice_Creuse := null;
		end if;
end Initialiser;
			

procedure Detruire (Mat : in out T_Matrice_Creuse) is

	procedure Detruire_Ligne (Liste_Ligne : in out T_Liste_Ligne) is
	    begin
		if  Liste_Ligne /= null then
		    Detruire_Ligne(Liste_Ligne.all.Suivant);
		    Free_Ligne(Liste_Ligne);
		end if;
	   end Detruire_Ligne;
	   
	procedure Detruire_Ptr_Ligne (Liste_Ptr_Ligne : in out T_Ptr_Ligne) is
	    begin
		if  Liste_Ptr_Ligne /= null then
		    Detruire_Ptr_Ligne(Liste_Ptr_Ligne.all.Ligne_Suivante);
		    Detruire_Ligne(Liste_Ptr_Ligne.all.Ligne_Actuelle);
		    Free_Ptr_Ligne(Liste_Ptr_Ligne);
		end if;
	   end Detruire_Ptr_Ligne;
    
    begin
    	
    	Detruire_Ptr_Ligne(Mat.Matrice_Creuse);
    	
    end Detruire;

procedure Transposer(Mat : in T_Matrice_Creuse; Mat_Res: out T_Matrice_Creuse) is
		Curseur_Ligne : T_Ptr_Ligne;
		Curseur_Liste_Ligne : T_Liste_Ligne;
	begin
		-- Initialisation de la matrice transposée
		--Initialiser(Mat_Res, Mat.Nb_Colonne, Mat.Nb_Ligne);
		
		-- Définition des coefficients de la matrice transposée
		Curseur_Ligne := Mat.Matrice_Creuse;
		while Curseur_Ligne /= null loop
			Curseur_Liste_Ligne := Curseur_Ligne.all.Ligne_Actuelle;
			while Curseur_Liste_Ligne /= null loop
			Enregistrer(Mat_Res,Curseur_Liste_Ligne.all.Colonne,Curseur_Ligne.all.Num_Ligne,Curseur_Liste_Ligne.Valeur);
				Curseur_Liste_Ligne := Curseur_Liste_Ligne.Suivant;
			end loop;
			Curseur_Ligne := Curseur_Ligne.all.Ligne_Suivante;
		end loop;
end Transposer;

-- TODO non modifée
procedure Produit(A : in T_Matrice_Creuse; B : in T_Matrice_Creuse; Mat_Res : out T_Matrice_Creuse) is
	Valeur : T_Reel;
	begin
		-- Vérification de la compatibilité des matrices pour le produit matriciel
		if A.Nb_Colonne /= B.Nb_Ligne then
			raise PRODUIT_INDEFINI_EXCEPTION;
		end if;
		
		-- Initialisation de la matrice résultat TODO check avec TOM
		--Initialiser(Mat_Res, A.Nb_Ligne, B.Nb_Colonne);
		
		-- Calcul des coefficients de la matrice résultat
		for i in 1..A.Nb_Ligne loop
			-- On regarde si une ligne de A est vide
			if not Ligne_Vide(i,A) then
				for j in 1.. B.Nb_Colonne loop
					Valeur := Zero;
					for k in 1.. A.Nb_Colonne loop
						Valeur := Valeur + Obtenir_Val(A,i,k) * Obtenir_Val(B,k,j);
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
		--Initialiser(Mat_Res, A.Nb_Ligne, B.Nb_Colonne);
		
		-- Calcul des coefficients de la matrice résultat
		for i in 1..A.Nb_Ligne loop
			-- On regarde si une ligne de A est vide
			if not Ligne_Vide(i,A) then
				for j in 1.. B.Nb_Colonne loop
					Valeur := Zero;
					for k in 1.. A.Nb_Colonne loop
						Valeur := Valeur + Obtenir_Val(A,i,k) * Obtenir_Val(B,k,j);
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
	Curseur_Ligne : T_Ptr_Ligne;
	Curseur_Liste_Ligne : T_Liste_Ligne;
	begin
		-- Initialisation de la matrice copie
		--Initialiser(Copie, Mat.Nb_Ligne, Mat.Nb_Colonne);
		
		-- Copie des coefficients de Mat dans Copie
		Curseur_Ligne := Mat.Matrice_Creuse;
		while Curseur_Ligne /= null loop
			Curseur_Liste_Ligne := Curseur_Ligne.all.Ligne_Actuelle;
			while Curseur_Liste_Ligne /= null loop
					Enregistrer(Copie,Curseur_Ligne.all.Num_Ligne,Curseur_Liste_Ligne.all.Colonne,Curseur_Liste_Ligne.all.Valeur);
				Curseur_Liste_Ligne := Curseur_Liste_Ligne.all.Suivant;
			end loop;
			Curseur_Ligne := Curseur_Ligne.all.Ligne_Suivante;
		end loop;
end Copier;

procedure Sommer(A : in T_Matrice_Creuse; B : in T_Matrice_Creuse; Mat_Res : out T_Matrice_Creuse)is
		Valeur : T_Reel;
		Curseur_Ligne : T_Ptr_Ligne;
		Curseur_Liste_Ligne : T_Liste_Ligne;
	begin
		-- Vérification de la compatibilité des matrices pour la somme matriciel
		if A.Nb_Colonne /= B.Nb_Colonne or else A.Nb_Ligne /= B.Nb_Ligne  then
			raise SOMME_INDEFINIE_EXCEPTION;
		end if;
		
		-- Initialisation de la matrice résultat
		--Initialiser(Mat_Res, A.Nb_Ligne, B.Nb_Colonne);
		
		-- Calcul des coefficients de la matrice résultat
		-- On regarde tous les coefficients non  nuls de A
		Curseur_Ligne := A.Matrice_Creuse;
		while Curseur_Ligne /= null loop
			Valeur := Zero;
			Curseur_Liste_Ligne := Curseur_Ligne.all.Ligne_Actuelle;
			while Curseur_Liste_Ligne /= null loop
				Valeur := Obtenir_Val(A,Curseur_Ligne.all.Num_Ligne,Curseur_Liste_Ligne.all.Colonne) + Obtenir_Val(B,Curseur_Ligne.all.Num_Ligne,Curseur_Liste_Ligne.all.Colonne);
				Enregistrer(Mat_Res,Curseur_Ligne.all.Num_Ligne,Curseur_Liste_Ligne.all.Colonne, Valeur);
				Curseur_Liste_Ligne := Curseur_Liste_Ligne.all.Suivant;
			end loop;
			Curseur_Ligne := Curseur_Ligne.all.Ligne_Suivante;
		end loop;
		
		-- On regarde tous les coefficients non nuls de B et on fait le calcul de A+B qui s'il a pas déjà était fait lors du parcours de A
		Curseur_Ligne := B.Matrice_Creuse;
		while Curseur_Ligne /= null loop
			Curseur_Liste_Ligne := Curseur_Ligne.all.Ligne_Actuelle;
			while Curseur_Liste_Ligne /= null loop
				if Obtenir_Val(Mat_res,Curseur_Ligne.all.Num_Ligne,Curseur_Liste_Ligne.all.Colonne) = Zero then
					Valeur := Obtenir_Val(A,Curseur_Ligne.all.Num_Ligne,Curseur_Liste_Ligne.all.Colonne) + Obtenir_Val(B,Curseur_Ligne.all.Num_Ligne,Curseur_Liste_Ligne.all.Colonne);
					Enregistrer(Mat_Res,Curseur_Ligne.all.Num_Ligne,Curseur_Liste_Ligne.Colonne, Valeur);
				end if;
				Curseur_Liste_Ligne := Curseur_Liste_Ligne.all.Suivant;
			end loop;
			Curseur_Ligne := Curseur_Ligne.all.Ligne_Suivante;
		end loop;
end Sommer;

function Sommer_f(A : in T_Matrice_Creuse; B : in T_Matrice_Creuse) return T_Matrice_Creuse is
		Mat_Res : T_Matrice_Creuse;
		Valeur : T_Reel;
		Curseur_Ligne : T_Ptr_Ligne;
		Curseur_Liste_Ligne : T_Liste_Ligne;
	begin
		-- Vérification de la compatibilité des matrices pour la somme matriciel
		if A.Nb_Colonne /= B.Nb_Colonne or else A.Nb_Ligne /= B.Nb_Ligne  then
			raise SOMME_INDEFINIE_EXCEPTION;
		end if;
		
		-- Initialisation de la matrice résultat
		-- Initialiser(Mat_Res, A.Nb_Ligne, B.Nb_Colonne);
		
		-- Calcul des coefficients de la matrice résultat
		-- On regarde tous les coefficients non  nuls de A
		Curseur_Ligne := A.Matrice_Creuse;
		while Curseur_Ligne /= null loop
			Valeur := Zero;
			Curseur_Liste_Ligne := Curseur_Ligne.all.Ligne_Actuelle;
			while Curseur_Liste_Ligne /= null loop
				Valeur := Obtenir_Val(A,Curseur_Ligne.all.Num_Ligne,Curseur_Liste_Ligne.all.Colonne) + Obtenir_Val(B,Curseur_Ligne.all.Num_Ligne,Curseur_Liste_Ligne.all.Colonne);
				Enregistrer(Mat_Res,Curseur_Ligne.all.Num_Ligne,Curseur_Liste_Ligne.all.Colonne, Valeur);
				Curseur_Liste_Ligne := Curseur_Liste_Ligne.all.Suivant;
			end loop;
			Curseur_Ligne := Curseur_Ligne.all.Ligne_Suivante;
		end loop;
		
		-- On regarde tous les coefficients non nuls de B et on fait le calcul de A+B qui s'il a pas déjà était fait lors du parcours de A
		Curseur_Ligne := B.Matrice_Creuse;
		while Curseur_Ligne /= null loop
			Curseur_Liste_Ligne := Curseur_Ligne.all.Ligne_Actuelle;
			while Curseur_Liste_Ligne /= null loop
				if Obtenir_Val(Mat_res,Curseur_Ligne.all.Num_Ligne,Curseur_Liste_Ligne.all.Colonne) = Zero then
					Valeur := Obtenir_Val(A,Curseur_Ligne.all.Num_Ligne,Curseur_Liste_Ligne.all.Colonne) + Obtenir_Val(B,Curseur_Ligne.all.Num_Ligne,Curseur_Liste_Ligne.all.Colonne);
					Enregistrer(Mat_Res,Curseur_Ligne.all.Num_Ligne,Curseur_Liste_Ligne.Colonne, Valeur);
				end if;
				Curseur_Liste_Ligne := Curseur_Liste_Ligne.all.Suivant;
			end loop;
			Curseur_Ligne := Curseur_Ligne.all.Ligne_Suivante;
		end loop;
				
		return Mat_Res;
end Sommer_f;

procedure Enregistrer(Mat : in out T_Matrice_Creuse; Ind_Ligne : in Integer; Ind_Colonne : in Integer; Valeur : in T_Reel) is

	procedure Enregistrer_Ligne (Liste_Ligne : in out T_Liste_Ligne; Ind_Colonne : in Integer; Valeur : in T_Reel) is
				begin
					if Liste_Ligne=null then
					    Liste_Ligne := new T_Cellule;
					    Liste_Ligne.all.Valeur := Valeur;
					    Liste_Ligne.all.Colonne := Ind_Colonne;
					    Liste_Ligne.all.Suivant := null;
					elsif Liste_Ligne.all.Colonne = Ind_Colonne then
					    Liste_Ligne.all.Valeur := Valeur;
					else
					    Enregistrer_Ligne(Liste_Ligne.all.Suivant, Ind_Colonne, Valeur);
					end if;
	end Enregistrer_Ligne;
	
	procedure Detruire_Cellule(Liste_Ligne: in out T_Liste_Ligne; Ind_Colonne : in Integer) is
	Cuseur_Liste_Ligne : T_Liste_Ligne;
	precedent : T_Liste_Ligne;
	begin
		Cuseur_Liste_Ligne := Liste_Ligne;
		precedent := null;
		while Cuseur_Liste_Ligne.Colonne /= Ind_Colonne loop
			precedent := Cuseur_Liste_Ligne;
			Cuseur_Liste_Ligne := Cuseur_Liste_Ligne.all.Suivant;
		end loop;
		if precedent = null then 
			-- On supprime l'élément de tête
			precedent := Liste_Ligne;
			Liste_Ligne:=Liste_Ligne.all.Suivant;
			Free_Ligne(precedent);
		else
			Precedent.all.Suivant :=Cuseur_Liste_Ligne.all.Suivant;
			Free_Ligne(Cuseur_Liste_Ligne);
		end if;
	end Detruire_Cellule;
	
		procedure Enregistrer_Ptr_Ligne (Liste_Ptr_Ligne : in out T_Ptr_Ligne ; Ind_Ligne: in Integer) is
				begin
					if Liste_Ptr_Ligne =null then
					    Liste_Ptr_Ligne  := new T_Ligne;
					    Liste_Ptr_Ligne.all.Num_Ligne := Ind_Ligne;
					    Liste_Ptr_Ligne.all.Ligne_Actuelle := null;
					    Liste_Ptr_Ligne.all.Ligne_Suivante := null;
					elsif Liste_Ptr_Ligne.all.Num_Ligne /= Ind_Ligne then
					    Enregistrer_Ptr_Ligne(Liste_Ptr_Ligne.all.Ligne_Suivante, Ind_Ligne);
					end if;
	end Enregistrer_Ptr_Ligne;
	
	procedure Detruire_Ptr_Liste(Liste_Ptr_Ligne : in out T_Ptr_Ligne ; Ind_Ligne: in Integer) is
	Cuseur_Ptr_Ligne : T_Ptr_Ligne;
	precedent : T_Ptr_Ligne;
	begin
		Cuseur_Ptr_Ligne := Liste_Ptr_Ligne;
		precedent := null;
		while Cuseur_Ptr_Ligne.all.Num_Ligne /= Ind_Ligne loop
			precedent := Cuseur_Ptr_Ligne;
			Cuseur_Ptr_Ligne := Cuseur_Ptr_Ligne.all.Ligne_Suivante;
		end loop;
		if Cuseur_Ptr_Ligne.all.Ligne_Actuelle=null then
			if precedent = null then 
				-- On supprime l'élément de tête
				precedent := Liste_Ptr_Ligne;
				Liste_Ptr_Ligne:=Liste_Ptr_Ligne.all.Ligne_Suivante;
				Free_Ptr_Ligne(precedent);
			else
				Precedent.all.Ligne_Suivante :=Cuseur_Ptr_Ligne.all.Ligne_Suivante;
				Free_Ptr_Ligne(Cuseur_Ptr_Ligne);
			end if;
		end if;
	end Detruire_Ptr_Liste;
	
	
	Ligne_Enregistrement : T_Ptr_Ligne;
	
	begin	
	
		if Ind_Colonne <=0 or else Ind_Ligne <=0 or else Ind_Ligne > Mat.Nb_Ligne or else Ind_Colonne > Mat.Nb_Colonne then
			raise INDICE_INVALIDE_EXCEPTION;
		else
			Enregistrer_Ptr_Ligne(Mat.Matrice_Creuse,Ind_Ligne);
			Ligne_Enregistrement := Mat.Matrice_Creuse;
			while Ligne_Enregistrement.all.Num_Ligne /= Ind_Ligne loop
					Ligne_Enregistrement := Ligne_Enregistrement.all.Ligne_Suivante;
			end loop;
			
				if Valeur = Zero and then Obtenir_Val(Mat,Ind_Ligne, Ind_Colonne) /= Zero then
					Detruire_Cellule(Ligne_Enregistrement.all.Ligne_Actuelle,Ind_Colonne);
					Detruire_Ptr_Liste(Ligne_Enregistrement, Ind_Ligne);
				elsif Valeur /= Zero then
					Enregistrer_Ligne(Ligne_Enregistrement.all.Ligne_Actuelle,Ind_Colonne,Valeur);
				end if;
		end if;
end Enregistrer;

procedure Produit_Const (Const : in T_Reel; Mat : in out T_Matrice_Creuse) is
	Curseur_Ligne : T_Ptr_Ligne;
	Curseur_Liste_Ligne : T_Liste_Ligne;
	begin
		-- Calcul les nouveaux coefficients de la matrice
		Curseur_Ligne := Mat.Matrice_Creuse;
		while Curseur_Ligne /= null loop
			Curseur_Liste_Ligne := Curseur_Ligne.all.Ligne_Actuelle;
			while Curseur_Liste_Ligne /= null loop
				Enregistrer(Mat,Curseur_Ligne.all.Num_Ligne,Curseur_Liste_Ligne.all.Colonne, Const * Curseur_Liste_Ligne.all.Valeur);
				Curseur_Liste_Ligne := Curseur_Liste_Ligne.Suivant;
			end loop;
			Curseur_Ligne := Curseur_Ligne.all.Ligne_Suivante;
		end loop;
end Produit_Const;


function Obtenir_Val(Mat: in T_Matrice_Creuse; Ind_Ligne : in Integer; Ind_Colonne :in Integer) return T_Reel is
	Curseur_Ligne : T_Ptr_Ligne;
	Curseur_Liste_Ligne : T_Liste_Ligne;
	begin	
		if Ind_Colonne <=0 or else Ind_Ligne <=0 or else Ind_Ligne > Mat.Nb_Ligne or else Ind_Colonne > Mat.Nb_Colonne then
			raise INDICE_INVALIDE_EXCEPTION;
		else
			Curseur_Ligne := Mat.Matrice_Creuse;
			while Curseur_Ligne /= null and then Curseur_Ligne.all.Num_Ligne /= Ind_Ligne loop
				Curseur_Ligne := Curseur_Ligne.all.Ligne_Suivante;
			end loop;
			
			if  Curseur_Ligne = null then 
				return Zero;
				
			else -- Curseur_Ligne.all.Num_Ligne = Ind_Ligne
			
				Curseur_Liste_Ligne :=Curseur_Ligne.all.Ligne_Actuelle;
				while Curseur_Liste_Ligne /= null loop
					if Curseur_Liste_Ligne.all.Colonne = Ind_Colonne then
						return Curseur_Liste_Ligne.all.Valeur;
					end if;
					Curseur_Liste_Ligne := Curseur_Liste_Ligne.all.Suivant;
				end loop;
				return Zero;
			end if;
		end if;
end Obtenir_Val;
	
procedure Sommer_Const(Const : in T_Reel ; Mat : in out T_Matrice_Creuse) is
	Curseur_Ligne : T_Ptr_Ligne;
	Curseur_Liste_Ligne : T_Liste_Ligne;
	Val : T_Reel;
	begin
		-- Calcul les nouveaux coefficients de la matrice
		Curseur_Ligne := Mat.Matrice_Creuse;
		while Curseur_Ligne /= null loop
			Curseur_Liste_Ligne := Curseur_Ligne.all.Ligne_actuelle;
			while Curseur_Liste_Ligne /= null loop
				Val := Const + Curseur_Liste_Ligne.all.Valeur;
				Enregistrer(Mat,Curseur_Ligne.all.Num_Ligne,Curseur_Liste_Ligne.all.Colonne, Val);
				Curseur_Liste_Ligne := Curseur_Liste_Ligne.Suivant;
			end loop;
			Curseur_Ligne := Curseur_Ligne.all.Ligne_Suivante;
		end loop;
end Sommer_Const;

procedure Afficher_Ligne(Mat : in T_Matrice_Creuse; Ind_Ligne : in Integer) is
	Curseir_Ligne : T_Ptr_Ligne;
	Curseur_Liste_Ligne : T_Liste_Ligne;
	begin
			Curseir_Ligne:= Mat.Matrice_Creuse;
			while Curseir_Ligne /= null and then Curseir_Ligne.all.Num_Ligne /= Ind_Ligne loop
				Curseir_Ligne := Curseir_Ligne.all.Ligne_Suivante;
			end loop;
			
			if Curseir_Ligne =null then
			
				for j in 1..Mat.Nb_Colonne loop
					Afficher_Val(Zero);
					Put(" ");
				end loop;
				Put("|");
				New_Line;
				
			else -- Curseir_Ligne.all.Num_Ligne = Ind_Ligne 
				
				Curseur_Liste_Ligne := Curseir_Ligne.all.Ligne_Actuelle;
				Put("| ");		
				while Curseur_Liste_Ligne /= null loop
					Afficher_Val(Obtenir_Val(Mat,Ind_Ligne,Curseur_Liste_Ligne.all.Colonne));
					Put(" ");
					Curseur_Liste_Ligne := Curseur_Liste_Ligne.all.Suivant;
				end loop;
				Put("|");
				New_Line;
				
				
			end if;
end Afficher_Ligne;

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
	Curseur_Ligne : T_Ptr_Ligne;
	begin
		Curseur_Ligne := Mat.Matrice_Creuse;
		
		while Curseur_Ligne /= null and then Curseur_Ligne.all.Num_Ligne /= Num_Ligne loop
					Curseur_Ligne := Curseur_Ligne.all.Ligne_Suivante;
			end loop;
			
			if Curseur_Ligne =null  then
				return true;
			
			else -- cad Curseur_Ligne.all.Num_Ligne = Num_Ligne 
				return false;
			end if;
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
