with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Float_Text_IO;   use Ada.Float_Text_IO;
with Matrice_Exceptions;         use Matrice_Exceptions;
with Matrice_Creuse;

procedure test_matrice_creuse is

-- Instanciation des matrices
package Matrice_Creuse_Reel is
		new Matrice_Creuse( T_Reel => Float, Zero => 0.0);
	use Matrice_Creuse_Reel;
	
-- Instanciation de la fonction Afficher
procedure Afficher_T_Reel_Float (Val : in Float) is
	begin
		Put(Val,1);
end Afficher_T_Reel_Float;

procedure Afficher_Mat is
            new Matrice_Creuse_Reel.Afficher(Afficher_T_Reel_Float);
            
procedure Afficher_Ligne_Ex is
            new Matrice_Creuse_Reel.Afficher_Ligne(Afficher_T_Reel_Float);

procedure Tester_Initialiser is
	Mat : T_Matrice_Creuse;
	begin
		begin
			Initialiser(Mat, 4,4);
			pragma Assert (Nombre_Lignes(Mat) = 4);
			pragma Assert (Nombre_Colonnes(Mat) = 4);
			for i in 1..Nombre_Lignes(Mat) loop
				pragma Assert (Ligne_Vide (i,Mat));
			end loop;
			Detruire(Mat);
			
			Initialiser(Mat, 1,4);
			pragma Assert (Nombre_Lignes(Mat) = 1);
			pragma Assert (Nombre_Colonnes(Mat) = 4);
			for i in 1..Nombre_Lignes(Mat) loop
				pragma Assert (Ligne_Vide (i,Mat));
			end loop;
			Detruire(Mat);
			
			Initialiser(Mat, 7,1);
			pragma Assert (Nombre_Lignes(Mat) = 7);
			pragma Assert (Nombre_Colonnes(Mat) = 1);
			for i in 1..Nombre_Lignes(Mat) loop
				pragma Assert (Ligne_Vide (i,Mat));
			end loop;
			Detruire(Mat);
			
			-- Cas problématiques
			Initialiser(Mat,5,-2);
			Detruire(Mat);
			
			exception 
				when INDICE_INVALIDE_EXCEPTION => Put_Line("Dimensions nulles ou négatives -> matrice non initialisée");
			end;
		
		Initialiser(Mat,-1,0);
		Detruire(Mat);
		
		exception 
			when INDICE_INVALIDE_EXCEPTION => Put_Line("Dimensions nulles ou négatives -> matrice non initialisée");
		
		Put_Line("Fin Tester_Initialiser");
		
end Tester_Initialiser;

procedure Tester_Enregistrer is
	Mat: T_Matrice_Creuse;
	--Curseur :T_Liste_Ligne;
	begin
		begin
			begin
				Initialiser(Mat, 4,4);
				
				Enregistrer(Mat,1,1,50.0);
				Enregistrer(Mat,2,1,46.0);
				Enregistrer(Mat,2,4,4.0);
				Enregistrer(Mat,2,3,14.0);
				Enregistrer(Mat,2,2,14.0);
				pragma Assert (Obtenir_Val(Mat,2,2) = 14.0);
				pragma Assert (Obtenir_Val(Mat,2,1) = 46.0);
				Detruire(Mat);
				
				
				Initialiser(Mat,1,3);
				Enregistrer(Mat,1,2,-5.0);
				pragma Assert (Obtenir_Val(Mat,1,2) = -5.0);
				Enregistrer(Mat,1,1,0.0);
				pragma Assert (Obtenir_Val(Mat,1,1) = 0.0);
				Enregistrer(Mat,1,2,0.0);
				pragma Assert (Obtenir_Val(Mat,1,3) = 0.0);
				--Put(Obtenir_Val(Mat,1,2),1);
				pragma Assert (Obtenir_Val(Mat,1,2) = 0.0);
				Detruire(Mat);

				-- Cas problématiques
				Enregistrer(Mat,5,3,-15.75);
				
				exception 
					when INDICE_INVALIDE_EXCEPTION => Put_Line("Indices nuls ou négatifs -> Valeur non enregistrée");
				end;
				
			Enregistrer(Mat,4,-2,-5.0);
			
			exception 
					when INDICE_INVALIDE_EXCEPTION => Put_Line("Indices nuls ou négatifs -> Valeur non enregistrée");
			end;
		Enregistrer(Mat,1,0,-5.0);
		exception 
				when INDICE_INVALIDE_EXCEPTION => Put_Line("Indices nuls ou négatifs -> Valeur non enregistrée");
		Detruire(Mat);
		Put_Line("Fin Tester_Enregistrer");
end Tester_Enregistrer;

procedure Tester_Obtenir_Valeur is
	Mat : T_Matrice_Creuse;
	begin
		begin
			begin
		
				Initialiser(Mat,4,4);
				Enregistrer(Mat,2,2,50.0);
				Enregistrer(Mat,3,1,46.0);
				
				pragma Assert (Obtenir_Val(Mat,2,2) = 50.0);
				pragma Assert (Obtenir_Val(Mat,3,1) = 46.0);
				pragma Assert (Obtenir_Val(Mat,1,3) = 0.0);
				pragma Assert (Obtenir_Val(Mat,1,3) = 0.0);
				
				-- Cas problématiques
				Put(Obtenir_Val(Mat,5,2));
				
				exception 
					when INDICE_INVALIDE_EXCEPTION => Put_Line("Indices nuls ou négatifs -> Valeur non lue");
				end;
		
			Put(Obtenir_Val(Mat,-3,1));
			
			exception 
					when INDICE_INVALIDE_EXCEPTION => Put_Line("Indices nuls ou négatifs -> Valeur non lue");
			end;
		
		Put(Obtenir_Val(Mat,-3,0));
		
		exception 
					when INDICE_INVALIDE_EXCEPTION => Put_Line("Indices nuls ou négatifs -> Valeur non lue");
		Detruire(Mat);
		Put_Line("Fin Tester_Obtenir_Valeur");
		
end Tester_Obtenir_Valeur;

procedure Tester_Transposer is 
	Mat : T_Matrice_Creuse;
	Trans : T_Matrice_Creuse;
	begin
		Initialiser(Mat,4,4);
		Enregistrer(Mat,2,2,50.0);
		Enregistrer(Mat,3,1,46.0);
		
		Initialiser(Trans,4,4);
		Transposer(Mat,Trans);
		pragma Assert (Nombre_Lignes(Mat)=Nombre_Colonnes(Trans));
		pragma Assert (Nombre_Lignes(Trans)=Nombre_Colonnes(Mat));
		for i in 1..Nombre_Lignes(Mat) loop
			for j in 1..Nombre_Colonnes(Mat) loop
				pragma Assert (Obtenir_Val(Mat,i,j) = Obtenir_Val(Trans,j,i));
			end loop;
		end loop;
		Detruire(Mat);
		Detruire(Trans);
		
		Initialiser(Mat,3,2);
		Enregistrer(Mat,2,2,50.0);
		Enregistrer(Mat,3,1,46.0);
		Enregistrer(Mat,1,2,-15.75);
		
		Initialiser(Trans,2,3);
		Transposer(Mat,Trans);
		pragma Assert (Nombre_Lignes(Mat)=Nombre_Colonnes(Trans));
		pragma Assert (Nombre_Lignes(Trans)=Nombre_Colonnes(Mat));
		for i in 1..Nombre_Lignes(Mat) loop
			for j in 1..Nombre_Colonnes(Mat) loop
				pragma Assert (Obtenir_Val(Mat,i,j) = Obtenir_Val(Trans,j,i));
			end loop;
		end loop;
		Detruire(Mat);
		Detruire(Trans);
		
		
		
		Put_Line("Fin Tester_Transposer");
		
end Tester_Transposer;

procedure Tester_Copier is
	Mat : T_Matrice_Creuse;
	Res : T_Matrice_Creuse;
	begin
		Initialiser(Mat,4,4);
		Enregistrer(Mat,2,2,50.0);
		Enregistrer(Mat,3,1,46.0);
		
		Initialiser(Res,4,4);
		Copier(Mat,Res);
		pragma Assert (Nombre_Lignes(Mat)=Nombre_Lignes(Res));
		pragma Assert (Nombre_Colonnes(Res)=Nombre_Colonnes(Mat));
		for i in 1..Nombre_Lignes(Mat) loop
			for j in 1..Nombre_Colonnes(Mat) loop
				pragma Assert (Obtenir_Val(Mat,i,j) = Obtenir_Val(Res,i,j));
			end loop;
		end loop;
		Detruire(Mat);
		Detruire(Res);
		
		
		Initialiser(Mat,3,2);
		Enregistrer(Mat,2,2,50.0);
		Enregistrer(Mat,3,1,46.0);
		Enregistrer(Mat,1,2,-15.75);
		
		Initialiser(Res,3,2);
		Copier(Mat,Res);
		pragma Assert (Nombre_Lignes(Mat)=Nombre_Lignes(Res));
		pragma Assert (Nombre_Colonnes(Res)=Nombre_Colonnes(Mat));
		for i in 1..Nombre_Lignes(Mat) loop
			for j in 1..Nombre_Colonnes(Mat) loop
				pragma Assert (Obtenir_Val(Mat,i,j) = Obtenir_Val(Res,i,j));
			end loop;
		end loop;
		Detruire(Mat);
		Detruire(Res);
		
		
		Initialiser(Mat, 1,4);
		Enregistrer(Mat,1,3,-15.75);
		Enregistrer(Mat,1,4,-465.0);
		
		Initialiser(Res,1,4);
		Copier(Mat,Res);
		pragma Assert (Nombre_Lignes(Mat)=Nombre_Lignes(Res));
		pragma Assert (Nombre_Colonnes(Res)=Nombre_Colonnes(Mat));
		for i in 1..Nombre_Lignes(Mat) loop
			for j in 1..Nombre_Colonnes(Mat) loop
				pragma Assert (Obtenir_Val(Mat,i,j) = Obtenir_Val(Res,i,j));
			end loop;
		end loop;
		Detruire(Mat);
		Detruire(Res);
		
		Put_Line("Fin Tester_Copier");
		
end Tester_Copier;

-- TODO à changer
procedure Tester_Produit is
	A : T_Matrice_Creuse;
	B : T_Matrice_Creuse;
	Res : T_Matrice_Creuse;
	somme_ligneA_colonneB: float;
	begin
		begin
			Initialiser(A,4,4);
			Initialiser(B,4,4);
			Enregistrer(A,2,2,50.0);
			Enregistrer(A,3,1,46.0);
			Enregistrer(A,1,3,-15.75);
			
			Initialiser(Res,4,4);
			Produit(A,B,Res);
			for i in 1..Nombre_Lignes(A) loop
				for j in 1.. Nombre_Colonnes(B) loop
					somme_ligneA_colonneB := 0.0;
					for k in 1.. Nombre_Colonnes(A) loop
						somme_ligneA_colonneB := somme_ligneA_colonneB + Obtenir_Val(A,i,k)*Obtenir_Val(B,k,j);
					end loop;
				end loop;
			end loop;
			Detruire(A);
			Detruire(B);
			Detruire(Res);
			
			Initialiser(A,4,4);
			Initialiser(B,4,2);
			Enregistrer(A,2,2,50.0);
			Enregistrer(A,3,1,4.0);
			Enregistrer(A,1,3,-15.75);
			
			Initialiser(Res,4,2);
			Produit(A,B,Res);
			for i in 1..Nombre_Lignes(A) loop
				for j in 1.. Nombre_Colonnes(B) loop
					somme_ligneA_colonneB := 0.0;
					for k in 1.. Nombre_Colonnes(A) loop
						somme_ligneA_colonneB := somme_ligneA_colonneB + Obtenir_Val(A,i,k)*Obtenir_Val(B,k,j);
					end loop;
					pragma Assert(somme_ligneA_colonneB = Obtenir_Val(Res,i,j));
				end loop;
			end loop;
			Detruire(A);
			Detruire(B);
			Detruire(Res);
			
			-- Cas d'erreurs
			Initialiser(A,4,5);
			Initialiser(B,4,2);
			Enregistrer(A,2,2,50.0);
			Enregistrer(A,3,1,4.0);
			Enregistrer(A,1,3,-15.75);
			
			Initialiser(Res,4,2);
			Produit(A,B,Res);
			exception
				when PRODUIT_INDEFINI_EXCEPTION => Put_Line("Dimensions des matrices incompatibles");
			end;
		Detruire(A);
		Detruire(B);
		Detruire(Res);
		Put_Line("Fin Tester_Produit");
		
end Tester_Produit;

procedure Tester_Produit_f is
	A : T_Matrice_Creuse;
	B : T_Matrice_Creuse;
	Res : T_Matrice_Creuse;
	somme_ligneA_colonneB: float;
	begin
		begin
			Initialiser(A,4,4);
			Initialiser(B,4,4);
			Enregistrer(A,2,2,50.0);
			Enregistrer(A,3,1,46.0);
			Enregistrer(A,1,3,-15.75);
			
			Initialiser(Res,4,4);
			Res := Produit_f(A,B);
			for i in 1..Nombre_Lignes(A) loop
				for j in 1.. Nombre_Colonnes(B) loop
					somme_ligneA_colonneB := 0.0;
					for k in 1.. Nombre_Colonnes(A) loop
						somme_ligneA_colonneB := somme_ligneA_colonneB + Obtenir_Val(A,i,k)*Obtenir_Val(B,k,j);
					end loop;
					pragma Assert(somme_ligneA_colonneB = Obtenir_Val(Res,i,j));
				end loop;
			end loop;
			Detruire(A);
			Detruire(B);
			Detruire(Res);
			
			Initialiser(A,4,4);
			Initialiser(B,4,2);
			Enregistrer(A,2,2,50.0);
			Enregistrer(A,3,1,4.0);
			Enregistrer(A,1,3,-15.75);
			
			Initialiser(Res,4,2);
			Res := Produit_f(A,B);
			for i in 1..Nombre_Lignes(A) loop
				for j in 1.. Nombre_Colonnes(B) loop
					somme_ligneA_colonneB := 0.0;
					for k in 1.. Nombre_Colonnes(A) loop
						somme_ligneA_colonneB := somme_ligneA_colonneB + Obtenir_Val(A,i,k)*Obtenir_Val(B,k,j);
					end loop;
					pragma Assert(somme_ligneA_colonneB = Obtenir_Val(Res,i,j));
				end loop;
			end loop;
			Detruire(A);
			Detruire(B);
			Detruire(Res);
			
			-- Cas d'erreurs
			Initialiser(A,4,5);
			Initialiser(B,4,2);
			Enregistrer(A,2,2,50.0);
			Enregistrer(A,3,1,4.0);
			Enregistrer(A,1,3,-15.75);
			
			Initialiser(Res,4,2);
			Res := Produit_f(A,B);
			exception
				when PRODUIT_INDEFINI_EXCEPTION => Put_Line("Dimensions des matrices incompatibles");
			end;
		Detruire(A);
		Detruire(B);
		Detruire(Res);
		Put_Line("Fin Tester_Produit_f");
		
end Tester_Produit_f;

-- TODO à changre
procedure Tester_Sommer is
	A : T_Matrice_Creuse;
	B : T_Matrice_Creuse;
	Res : T_Matrice_Creuse;
	begin
		begin
	
			Initialiser(A,4,4);
			Initialiser(B,4,4);
			Enregistrer(A,2,2,50.0);
			Enregistrer(A,3,1,46.0);
			Enregistrer(A,1,3,-15.75);
			
			Initialiser(Res,4,4);
			Sommer(A,B,Res);
			pragma Assert (Nombre_Lignes(A)=Nombre_Lignes(Res));
			pragma Assert (Nombre_Colonnes(A)=Nombre_Colonnes(Res));
			for i in 1..Nombre_Lignes(A) loop
				for j in 1..Nombre_Colonnes(A) loop
					pragma Assert (Obtenir_Val(A,i,j) + Obtenir_Val(B,i,j) = Obtenir_Val(Res,i,j));
				end loop;
			end loop;
			Detruire(A);
			Detruire(B);
			Detruire(Res);

			
			Initialiser(A,4,2);
			Initialiser(B,4,2);
			Enregistrer(A,2,2,50.0);
			Enregistrer(A,3,1,4.0);
			Enregistrer(A,1,2,-15.75);
			
			Initialiser(Res,4,2);
			Sommer(A,B,Res);
			pragma Assert (Nombre_Lignes(A)=Nombre_Lignes(Res));
			pragma Assert (Nombre_Colonnes(A)=Nombre_Colonnes(Res));
			for i in 1..Nombre_Lignes(A) loop
				for j in 1..Nombre_Colonnes(A) loop
					pragma Assert (Obtenir_Val(A,i,j) + Obtenir_Val(B,i,j) = Obtenir_Val(Res,i,j));
				end loop;
			end loop;
			Detruire(A);
			Detruire(B);
			Detruire(Res);
			
			-- Cas d'erreurs
			Initialiser(A,4,5);
			Initialiser(B,4,2);
			Enregistrer(A,2,2,50.0);
			Enregistrer(A,3,1,4.0);
			Enregistrer(A,1,3,-15.75);
			
			Initialiser(Res,4,2);
			Sommer(A,B,Res);
			exception
				when SOMME_INDEFINIE_EXCEPTION => Put_Line("Dimensions des matrices incompatibles");
			end;
		Detruire(A);
		Detruire(B);
		Detruire(Res);
			
		Put_Line("Fin Tester_Sommer");
end Tester_Sommer;
	
procedure Tester_Sommer_f is
	A : T_Matrice_Creuse;
	B : T_Matrice_Creuse;
	Res : T_Matrice_Creuse;
	begin
		begin
	
			Initialiser(A,4,4);
			Initialiser(B,4,4);
			Enregistrer(A,2,2,50.0);
			Enregistrer(A,3,1,46.0);
			Enregistrer(A,1,3,-15.75);
			
			Initialiser(Res,4,4);
			Res := Sommer_f(A,B);
			pragma Assert (Nombre_Lignes(A)=Nombre_Lignes(Res));
			pragma Assert (Nombre_Colonnes(A)=Nombre_Colonnes(Res));
			for i in 1..Nombre_Lignes(A) loop
				for j in 1..Nombre_Colonnes(A) loop
					pragma Assert (Obtenir_Val(A,i,j) + Obtenir_Val(B,i,j) = Obtenir_Val(Res,i,j));
				end loop;
			end loop;
			Detruire(A);
			Detruire(B);
			Detruire(Res);

			
			Initialiser(A,4,2);
			Initialiser(B,4,2);
			Enregistrer(A,2,2,50.0);
			Enregistrer(A,3,1,4.0);
			Enregistrer(A,1,2,-15.75);
			
			Initialiser(Res,4,2);
			Res := Sommer_f(A,B);
			pragma Assert (Nombre_Lignes(A)=Nombre_Lignes(Res));
			pragma Assert (Nombre_Colonnes(A)=Nombre_Colonnes(Res));
			for i in 1..Nombre_Lignes(A) loop
				for j in 1..Nombre_Colonnes(A) loop
					pragma Assert (Obtenir_Val(A,i,j) + Obtenir_Val(B,i,j) = Obtenir_Val(Res,i,j));
				end loop;
			end loop;
			Detruire(A);
			Detruire(B);
			Detruire(Res);
			
			-- Cas d'erreurs
			Initialiser(A,4,5);
			Initialiser(B,4,2);
			Enregistrer(A,2,2,50.0);
			Enregistrer(A,3,1,4.0);
			Enregistrer(A,1,3,-15.75);
			
			Initialiser(Res,4,2);
			Res := Sommer_f(A,B);
			exception
				when SOMME_INDEFINIE_EXCEPTION => Put_Line("Dimensions des matrices incompatibles");
			end;
			Detruire(A);
			Detruire(B);
			Detruire(Res);
			Put_Line("Fin Tester_Sommer_f");
		
end Tester_Sommer_f;

procedure Tester_Produit_Const is
	Mat :  T_Matrice_Creuse;
	Copie : T_Matrice_Creuse;
	begin
		Initialiser(Mat,5,5);
		for i in 1..Nombre_Lignes(Mat) loop
			for j in 1..Nombre_Colonnes(Mat) loop
				Enregistrer(Mat,i,j,1.0);
			end loop;
		end loop;
		Initialiser(Copie,5,5);
		Copier(Mat,Copie);
		Produit_Const(5.0,Mat);
		for i in 1..Nombre_Lignes(Mat) loop
			for j in 1..Nombre_Colonnes(Mat) loop
				pragma Assert (5.0*Obtenir_Val(Copie,i,j) = Obtenir_Val(Mat,i,j));
			end loop;
		end loop;
		Detruire(Mat);
		Detruire(Copie);
		
		Initialiser(Mat,2,6);
		Initialiser(Copie,2,6);
		Copier(Mat,Copie);
		Produit_Const(-3.84653,Mat);
		for i in 1..Nombre_Lignes(Mat) loop
			for j in 1..Nombre_Colonnes(Mat) loop
				pragma Assert (-3.84653*Obtenir_Val(Copie,i,j) = Obtenir_Val(Mat,i,j));
			end loop;
		end loop;
		Detruire(Mat);
		Detruire(Copie);
		
		Initialiser(Mat,7,1);
		Initialiser(Copie,7,1);
		Copier(Mat,Copie);
		Produit_Const(-3.84653,Mat);
		for i in 1..Nombre_Lignes(Mat) loop
			for j in 1..Nombre_Colonnes(Mat) loop
				pragma Assert (-3.84653*Obtenir_Val(Copie,i,j) = Obtenir_Val(Mat,i,j));
			end loop;
		end loop;
		Detruire(Mat);
		Detruire(Copie);
		
		Put_Line("Fin Tester_Produit_Const");
		
end Tester_Produit_Const;
			
procedure Tester_Sommer_Const is
	Mat :  T_Matrice_Creuse;
	Copie :  T_Matrice_Creuse;
	begin
		Initialiser(Mat,5,5);
		for i in 1..Nombre_Lignes(Mat) loop
			for j in 1..Nombre_Colonnes(Mat) loop
				Enregistrer(Mat,i,j,1.0);
			end loop;
		end loop;
		Initialiser(Copie,5,5);
		Copier(Mat,Copie);
		Sommer_Const(5.0,Mat);
		for i in 1..Nombre_Lignes(Mat) loop
			for j in 1..Nombre_Colonnes(Mat) loop		
				pragma Assert (5.0 + Obtenir_Val(Copie,i,j) = Obtenir_Val(Mat,i,j));
			end loop;
		end loop;
		Detruire(Mat);
		Detruire(Copie);
		
		Initialiser(Mat,2,6);
		Initialiser(Copie,2,6);
		Copier(Mat,Copie);
		Sommer_Const(-3.84653,Mat);
		for i in 1..Nombre_Lignes(Mat) loop
			for j in 1..Nombre_Colonnes(Mat) loop
				pragma Assert (Obtenir_Val(Copie,i,j)-3.84653 - Obtenir_Val(Mat,i,j)< 0.000000000000000000001);
			end loop;
		end loop;
		Detruire(Mat);
		Detruire(Copie);
		
		Initialiser(Mat,7,1);
		Initialiser(Copie,7,1);
		Copier(Mat,Copie);
		Sommer_Const(-3.84653,Mat);
		for i in 1..Nombre_Lignes(Mat) loop
			for j in 1..Nombre_Colonnes(Mat) loop
				pragma Assert (Obtenir_Val(Copie,i,j)-3.84653 - Obtenir_Val(Mat,i,j)< 0.00000001);
			end loop;
		end loop;
		Detruire(Mat);
		Detruire(Copie);
		
		
		
		Put_Line("Fin Tester_Sommer_Const");
		
end Tester_Sommer_Const;

procedure Tester_Afficher is
	Mat : T_Matrice_Creuse;
	begin
	
		Initialiser(Mat, 4,4);
				
		Enregistrer(Mat,2,2,50.0);
		Enregistrer(Mat,3,1,46.0);
		Put_Line("Matrice 4x4 avec comme coefficients 0.0 et 50.0 en 2,2 et 46.0 en 3,1");
		Afficher_Mat(Mat);
		Detruire(Mat);
	
		Initialiser(Mat,4,5);
		Enregistrer(Mat,2,1,88.0);
		Put_Line("Matrice 4x5 avec comme coefficients 0.0 et 88.0 en 2,1");
		Afficher_Mat(Mat);
		Detruire(Mat);
		
		Initialiser(Mat,3,3);
		Enregistrer(Mat,1,2,-1.0);
		Put_Line("Matrice 3x3 avec comme coefficients 0.0 et -1.0 en 1,2");
		Afficher_Mat(Mat);
		Detruire(Mat);
		
		
		Put_Line("Fin Tester_Afficher");
		
end Tester_Afficher;

procedure Tester_Afficher_Ligne is
	Mat : T_Matrice_Creuse;
	begin
		Initialiser(Mat, 4,4);		
		Enregistrer(Mat,2,2,50.0);
		Enregistrer(Mat,2,1,-46.0);
		Afficher_Mat(Mat);
		Put_Line("Affichage Ligne 2 et 3 sans tenir compte des 0 (les éléments de la ligne sont classés par ordre d'enregistrement et non par ordre de numéro de colonne)");
		Afficher_Ligne_Ex(Mat,2);
		Afficher_Ligne_Ex(Mat,3);
		
		Detruire(Mat);
		Put_Line("Fin Tester_Afficher_Ligne");
	
end Tester_Afficher_Ligne;

	begin
	
	Tester_Initialiser;
	Tester_Enregistrer;
	Tester_Obtenir_Valeur;
	Tester_Copier;
	Tester_Transposer;
	Tester_Produit;
	--Tester_Produit_f;
	Tester_Sommer;
	--Tester_Sommer_f;
	Tester_Produit_Const;
	Tester_Sommer_Const;
	Tester_Afficher;
	Tester_Afficher_Ligne;

	Put_Line("Fin des tests");
		
end test_matrice_creuse;
