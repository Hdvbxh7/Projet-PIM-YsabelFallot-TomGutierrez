with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;   use Ada.Float_Text_IO;
with Matrice_Exceptions;         use Matrice_Exceptions;
with Matrice;

procedure test_matrice is

-- Instanciation des matrices
package Matrice_Reel is
		new Matrice( T_Reel => Float, Num_Colonne => 10, Num_Ligne => 10, Zero => 0.0);
	use Matrice_Reel;
	
-- Instanciation de la fonction Afficher
procedure Afficher_T_Reel_Float (Val : in Float) is
	begin
		Put(Val,1);
end Afficher_T_Reel_Float;

procedure Afficher_Mat is
            new Matrice_Reel.Afficher(Afficher_T_Reel_Float);

procedure Tester_Initialiser is
	Mat : T_Matrice;
	begin
		begin
			Initialiser(Mat, 4,4,0.0);
			pragma Assert (Nombre_Lignes(Mat) = 4);
			pragma Assert (Nombre_Colonnes(Mat) = 4);
			for i in 1..Nombre_Lignes(Mat) loop
				for j in 1..Nombre_Colonnes(Mat) loop
					pragma Assert (Obtenir_Val(Mat,i,j) = 0.0);
				end loop;
			end loop;
			
			Initialiser(Mat, 1,4,6.0);
			pragma Assert (Nombre_Lignes(Mat) = 1);
			pragma Assert (Nombre_Colonnes(Mat) = 4);
			for i in 1..Nombre_Lignes(Mat) loop
				for j in 1..Nombre_Colonnes(Mat) loop
					pragma Assert (Obtenir_Val(Mat,i,j) = 6.0);
				end loop;
			end loop;
			
			Initialiser(Mat, 1,4,-26.56);
			pragma Assert (Nombre_Lignes(Mat) = 1);
			pragma Assert (Nombre_Colonnes(Mat) = 4);
			for i in 1..Nombre_Lignes(Mat) loop
				for j in 1..Nombre_Colonnes(Mat) loop
					pragma Assert (Obtenir_Val(Mat,i,j) = -26.56);
				end loop;
			end loop;
			
			-- Cas problématiques
			Initialiser(Mat,5,-2,1.0);
			
			exception 
				when INDICE_INVALIDE_EXCEPTION => Put_Line("Dimensions nulles ou négatives -> matrice non initialisée");
			end;
		
		Initialiser(Mat,-1,0,0.0);
		
		exception 
			when INDICE_INVALIDE_EXCEPTION => Put_Line("Dimensions nulles ou négatives -> matrice non initialisée");
		
		Put_Line("Fin Tester_Initialiser");
		
end Tester_Initialiser;

procedure Tester_Enregistrer is
	Mat: T_Matrice;
	begin
		begin
			begin
				Initialiser(Mat, 4,4,0.0);
				
				Enregistrer(Mat,2,2,50.0);
				Enregistrer(Mat,3,1,46.0);
				pragma Assert (Obtenir_Val(Mat,2,2) = 50.0);
				pragma Assert (Obtenir_Val(Mat,3,1) = 46.0);
				
				
				Enregistrer(Mat,1,3,-15.75);
				Enregistrer(Mat,4,2,-5.0);
				pragma Assert (Obtenir_Val(Mat,1,3) = -15.75);
				pragma Assert (Obtenir_Val(Mat,4,2) = -5.0);

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
		
		Put_Line("Fin Tester_Enregistrer");
end Tester_Enregistrer;

procedure Tester_Obtenir_Valeur is
	Mat : T_Matrice;
	Val : float;
	begin
		begin
			begin
		
				Initialiser(Mat,4,4,0.0);
				Enregistrer(Mat,2,2,50.0);
				Enregistrer(Mat,3,1,46.0);
				
				pragma Assert (Obtenir_Val(Mat,2,2) = 50.0);
				pragma Assert (Obtenir_Val(Mat,3,1) = 46.0);
				pragma Assert (Obtenir_Val(Mat,1,3) = 0.0);
				pragma Assert (Obtenir_Val(Mat,1,3) = 0.0);
				
				-- Cas problématiques
				Val := Obtenir_Val(Mat,5,2);
				
				exception 
					when INDICE_INVALIDE_EXCEPTION => Put_Line("Indices nuls ou négatifs -> Valeur non lue");
				end;
		
			Val := Obtenir_Val(Mat,-3,1);
			
			exception 
					when INDICE_INVALIDE_EXCEPTION => Put_Line("Indices nuls ou négatifs -> Valeur non lue");
			end;
		
		Val := Obtenir_Val(Mat,-3,0);
		
		exception 
					when INDICE_INVALIDE_EXCEPTION => Put_Line("Indices nuls ou négatifs -> Valeur non lue");
		
		Put_Line("Fin Tester_Obtenir_Valeur");
		
end Tester_Obtenir_Valeur;

procedure Tester_Transposer is 
	Mat : T_Matrice;
	Trans : T_Matrice;
	begin
		Initialiser(Mat,4,4,0.0);
		Enregistrer(Mat,2,2,50.0);
		Enregistrer(Mat,3,1,46.0);
		
		Trans := Transposer(Mat);
		pragma Assert (Nombre_Lignes(Mat)=Nombre_Colonnes(Trans));
		pragma Assert (Nombre_Lignes(Trans)=Nombre_Colonnes(Mat));
		for i in 1..Nombre_Lignes(Mat) loop
			for j in 1..Nombre_Colonnes(Mat) loop
				pragma Assert (Obtenir_Val(Mat,i,j) = Obtenir_Val(Trans,j,i));
			end loop;
		end loop;
		
		
		Initialiser(Mat,3,2,0.0);
		Enregistrer(Mat,2,2,50.0);
		Enregistrer(Mat,3,1,46.0);
		Enregistrer(Mat,1,2,-15.75);
		
		Trans := Transposer(Mat);
		pragma Assert (Nombre_Lignes(Mat)=Nombre_Colonnes(Trans));
		pragma Assert (Nombre_Lignes(Trans)=Nombre_Colonnes(Mat));
		for i in 1..Nombre_Lignes(Mat) loop
			for j in 1..Nombre_Colonnes(Mat) loop
				pragma Assert (Obtenir_Val(Mat,i,j) = Obtenir_Val(Trans,j,i));
			end loop;
		end loop;
		Put_Line("Fin Tester_Transposer");
		
end Tester_Transposer;

procedure Tester_Copier is
	Mat : T_Matrice;
	Res : T_Matrice;
	begin
		Initialiser(Mat,4,4,0.0);
		Enregistrer(Mat,2,2,50.0);
		Enregistrer(Mat,3,1,46.0);
		
		Copier(Mat,Res);
		pragma Assert (Nombre_Lignes(Mat)=Nombre_Lignes(Res));
		pragma Assert (Nombre_Colonnes(Res)=Nombre_Colonnes(Mat));
		for i in 1..Nombre_Lignes(Mat) loop
			for j in 1..Nombre_Colonnes(Mat) loop
				pragma Assert (Obtenir_Val(Mat,i,j) = Obtenir_Val(Res,i,j));
			end loop;
		end loop;
		
		
		Initialiser(Mat, 3,2,6.0);
		Enregistrer(Mat,2,2,50.0);
		Enregistrer(Mat,3,1,46.0);
		Enregistrer(Mat,1,2,-15.75);
		
		Copier(Mat,Res);
		pragma Assert (Nombre_Lignes(Mat)=Nombre_Lignes(Res));
		pragma Assert (Nombre_Colonnes(Res)=Nombre_Colonnes(Mat));
		for i in 1..Nombre_Lignes(Mat) loop
			for j in 1..Nombre_Colonnes(Mat) loop
				pragma Assert (Obtenir_Val(Mat,i,j) = Obtenir_Val(Res,i,j));
			end loop;
		end loop;
		
		
		Initialiser(Mat, 1,4,-26.56);
		Enregistrer(Mat,1,3,-15.75);
		Enregistrer(Mat,1,4,-465.0);
		
		Copier(Mat,Res);
		pragma Assert (Nombre_Lignes(Mat)=Nombre_Lignes(Res));
		pragma Assert (Nombre_Colonnes(Res)=Nombre_Colonnes(Mat));
		for i in 1..Nombre_Lignes(Mat) loop
			for j in 1..Nombre_Colonnes(Mat) loop
				pragma Assert (Obtenir_Val(Mat,i,j) = Obtenir_Val(Res,i,j));
			end loop;
		end loop;
		
		Put_Line("Fin Tester_Copier");
		
end Tester_Copier;

procedure Tester_Produit is
	A : T_Matrice;
	B : T_Matrice;
	Res : T_Matrice;
	somme_ligneA_colonneB: float;
	begin
		begin
			Initialiser(A,4,4,0.0);
			Initialiser(B,4,4,5.0);
			Enregistrer(A,2,2,50.0);
			Enregistrer(A,3,1,46.0);
			Enregistrer(A,1,3,-15.75);
			
			Produit(A,B,Res);
			somme_ligneA_colonneB := 0.0;
			for i in 1..Nombre_Lignes(A) loop
				for j in 1.. Nombre_Colonnes(B) loop
					for k in 1.. Nombre_Colonnes(A) loop
						somme_ligneA_colonneB := somme_ligneA_colonneB + Obtenir_Val(A,i,k)*Obtenir_Val(B,k,j);
					end loop;
					pragma Assert(somme_ligneA_colonneB = Obtenir_Val(Res,i,j));
				end loop;
			end loop;
			
			Initialiser(A,4,4,0.0);
			Initialiser(B,4,2,-1.5);
			Enregistrer(A,2,2,50.0);
			Enregistrer(A,3,1,4.0);
			Enregistrer(A,1,3,-15.75);
			
			Produit(A,B,Res);
			for i in 1..Nombre_Lignes(A) loop
				for j in 1.. Nombre_Colonnes(B) loop
					for k in 1.. Nombre_Colonnes(A) loop
						somme_ligneA_colonneB := somme_ligneA_colonneB + Obtenir_Val(A,i,k)*Obtenir_Val(B,k,j);
					end loop;
					pragma Assert(somme_ligneA_colonneB = Obtenir_Val(Res,i,j));
				end loop;
			end loop;
			
			-- Cas d'erreurs
			Initialiser(A,4,5,0.0);
			Initialiser(B,4,2,-1.5);
			Enregistrer(A,2,2,50.0);
			Enregistrer(A,3,1,4.0);
			Enregistrer(A,1,3,-15.75);
			
			Produit(A,B,Res);
			exception
				when PRODUIT_INDEFINI_EXCEPTION => Put_Line("Dimensions des matrices incompatibles");
			end;
		
		Put_Line("Fin Tester_Produit");
		
end Tester_Produit;

procedure Tester_Produit_f is
	A : T_Matrice;
	B : T_Matrice;
	Res : T_Matrice;
	somme_ligneA_colonneB: float;
	begin
		begin
			Initialiser(A,4,4,0.0);
			Initialiser(B,4,4,5.0);
			Enregistrer(A,2,2,50.0);
			Enregistrer(A,3,1,46.0);
			Enregistrer(A,1,3,-15.75);
			
			Res := Produit_f(A,B);
			somme_ligneA_colonneB := 0.0;
			for i in 1..Nombre_Lignes(A) loop
				for j in 1.. Nombre_Colonnes(B) loop
					for k in 1.. Nombre_Colonnes(A) loop
						somme_ligneA_colonneB := somme_ligneA_colonneB + Obtenir_Val(A,i,k)*Obtenir_Val(B,k,j);
					end loop;
					pragma Assert(somme_ligneA_colonneB = Obtenir_Val(Res,i,j));
				end loop;
			end loop;
			
			Initialiser(A,4,4,0.0);
			Initialiser(B,4,2,-1.5);
			Enregistrer(A,2,2,50.0);
			Enregistrer(A,3,1,4.0);
			Enregistrer(A,1,3,-15.75);
			
			Res := Produit_f(A,B);
			for i in 1..Nombre_Lignes(A) loop
				for j in 1.. Nombre_Colonnes(B) loop
					for k in 1.. Nombre_Colonnes(A) loop
						somme_ligneA_colonneB := somme_ligneA_colonneB + Obtenir_Val(A,i,k)*Obtenir_Val(B,k,j);
					end loop;
					pragma Assert(somme_ligneA_colonneB = Obtenir_Val(Res,i,j));
				end loop;
			end loop;
			
			-- Cas d'erreurs
			Initialiser(A,4,5,0.0);
			Initialiser(B,4,2,-1.5);
			Enregistrer(A,2,2,50.0);
			Enregistrer(A,3,1,4.0);
			Enregistrer(A,1,3,-15.75);
			
			Res := Produit_f(A,B);
			exception
				when PRODUIT_INDEFINI_EXCEPTION => Put_Line("Dimensions des matrices incompatibles");
			end;
		Put_Line("Fin Tester_Produit_f");
		
end Tester_Produit_f;

procedure Tester_Sommer is
	A : T_Matrice;
	B : T_Matrice;
	Res : T_Matrice;
	begin
		begin
	
			Initialiser(A,4,4,0.0);
			Initialiser(B,4,4,5.0);
			Enregistrer(A,2,2,50.0);
			Enregistrer(A,3,1,46.0);
			Enregistrer(A,1,3,-15.75);
			
			Sommer(A,B,Res);
			pragma Assert (Nombre_Lignes(A)=Nombre_Lignes(Res));
			pragma Assert (Nombre_Colonnes(A)=Nombre_Colonnes(Res));
			for i in 1..Nombre_Lignes(A) loop
				for j in 1..Nombre_Colonnes(A) loop
					pragma Assert (Obtenir_Val(A,i,j) + Obtenir_Val(B,i,j) = Obtenir_Val(Res,i,j));
				end loop;
			end loop;

			
			Initialiser(A,4,2,0.0);
			Initialiser(B,4,2,-1.5);
			Enregistrer(A,2,2,50.0);
			Enregistrer(A,3,1,4.0);
			Enregistrer(A,1,2,-15.75);
			
			Sommer(A,B,Res);
			pragma Assert (Nombre_Lignes(A)=Nombre_Lignes(Res));
			pragma Assert (Nombre_Colonnes(A)=Nombre_Colonnes(Res));
			for i in 1..Nombre_Lignes(A) loop
				for j in 1..Nombre_Colonnes(A) loop
					pragma Assert (Obtenir_Val(A,i,j) + Obtenir_Val(B,i,j) = Obtenir_Val(Res,i,j));
				end loop;
			end loop;
			
			-- Cas d'erreurs
			Initialiser(A,4,5,0.0);
			Initialiser(B,4,2,-1.5);
			Enregistrer(A,2,2,50.0);
			Enregistrer(A,3,1,4.0);
			Enregistrer(A,1,3,-15.75);
			
			Sommer(A,B,Res);
			exception
				when SOMME_INDEFINIE_EXCEPTION => Put_Line("Dimensions des matrices incompatibles");
			end;
			
		Put_Line("Fin Tester_Sommer");
end Tester_Sommer;
	
procedure Tester_Sommer_f is
	A : T_Matrice;
	B : T_Matrice;
	Res : T_Matrice;
	begin
		begin
	
			Initialiser(A,4,4,0.0);
			Initialiser(B,4,4,5.0);
			Enregistrer(A,2,2,50.0);
			Enregistrer(A,3,1,46.0);
			Enregistrer(A,1,3,-15.75);
			
			Res := Sommer_f(A,B);
			pragma Assert (Nombre_Lignes(A)=Nombre_Lignes(Res));
			pragma Assert (Nombre_Colonnes(A)=Nombre_Colonnes(Res));
			for i in 1..Nombre_Lignes(A) loop
				for j in 1..Nombre_Colonnes(A) loop
					pragma Assert (Obtenir_Val(A,i,j) + Obtenir_Val(B,i,j) = Obtenir_Val(Res,i,j));
				end loop;
			end loop;

			
			Initialiser(A,4,2,0.0);
			Initialiser(B,4,2,-1.5);
			Enregistrer(A,2,2,50.0);
			Enregistrer(A,3,1,4.0);
			Enregistrer(A,1,2,-15.75);
			
			Res := Sommer_f(A,B);
			pragma Assert (Nombre_Lignes(A)=Nombre_Lignes(Res));
			pragma Assert (Nombre_Colonnes(A)=Nombre_Colonnes(Res));
			for i in 1..Nombre_Lignes(A) loop
				for j in 1..Nombre_Colonnes(A) loop
					pragma Assert (Obtenir_Val(A,i,j) + Obtenir_Val(B,i,j) = Obtenir_Val(Res,i,j));
				end loop;
			end loop;
			
			-- Cas d'erreurs
			Initialiser(A,4,5,0.0);
			Initialiser(B,4,2,-1.5);
			Enregistrer(A,2,2,50.0);
			Enregistrer(A,3,1,4.0);
			Enregistrer(A,1,3,-15.75);
			
			Res := Sommer_f(A,B);
			exception
				when SOMME_INDEFINIE_EXCEPTION => Put_Line("Dimensions des matrices incompatibles");
			end;
			Put_Line("Fin Tester_Sommer_f");
		
end Tester_Sommer_f;

procedure Tester_Produit_Const is
	Mat :  T_Matrice;
	Copie : T_Matrice;
	begin
		Initialiser(Mat,5,5,1.0);
		Copier(Mat,Copie);
		Produit_Const(5.0,Mat);
		for i in 1..Nombre_Lignes(Mat) loop
			for j in 1..Nombre_Colonnes(Mat) loop
				pragma Assert (5.0*Obtenir_Val(Copie,i,j) = Obtenir_Val(Mat,i,j));
			end loop;
		end loop;
		
		Initialiser(Mat,2,6,1.0);
		Copier(Mat,Copie);
		Produit_Const(-3.84653,Mat);
		for i in 1..Nombre_Lignes(Mat) loop
			for j in 1..Nombre_Colonnes(Mat) loop
				pragma Assert (-3.84653*Obtenir_Val(Copie,i,j) = Obtenir_Val(Mat,i,j));
			end loop;
		end loop;
		
		Initialiser(Mat,7,1,-1.0);
		Copier(Mat,Copie);
		Produit_Const(-3.84653,Mat);
		for i in 1..Nombre_Lignes(Mat) loop
			for j in 1..Nombre_Colonnes(Mat) loop
				pragma Assert (-3.84653*Obtenir_Val(Copie,i,j) = Obtenir_Val(Mat,i,j));
			end loop;
		end loop;
		
		Put_Line("Fin Tester_Produit_Const");
		
end Tester_Produit_Const;
			
procedure Tester_Sommer_Const is
	Mat :  T_Matrice;
	Copie :  T_Matrice;
	begin
		Initialiser(Mat,5,5,1.0);
		Copier(Mat,Copie);
		Sommer_Const(5.0,Mat);
		for i in 1..Nombre_Lignes(Mat) loop
			for j in 1..Nombre_Colonnes(Mat) loop
				pragma Assert (5.0+Obtenir_Val(Copie,i,j) = Obtenir_Val(Mat,i,j));
			end loop;
		end loop;
		
		Initialiser(Mat,2,6,1.45);
		Copier(Mat,Copie);
		Sommer_Const(-3.84653,Mat);
		for i in 1..Nombre_Lignes(Mat) loop
			for j in 1..Nombre_Colonnes(Mat) loop
				pragma Assert (-3.84653+Obtenir_Val(Copie,i,j) = Obtenir_Val(Mat,i,j));
			end loop;
		end loop;
		
		Initialiser(Mat,7,1,-1.0);
		Copier(Mat,Copie);
		Sommer_Const(-3.84653,Mat);
		for i in 1..Nombre_Lignes(Mat) loop
			for j in 1..Nombre_Colonnes(Mat) loop
				pragma Assert (-3.84653+Obtenir_Val(Copie,i,j) = Obtenir_Val(Mat,i,j));
			end loop;
		end loop;
		
		Put_Line("Fin Tester_Sommer_Const");
		
end Tester_Sommer_Const;

procedure Tester_Ligne_Vide is
	Mat : T_Matrice;
	begin
		Initialiser(Mat,4,4,0.0);
		Enregistrer(Mat,1,2,1.897);
		Enregistrer(Mat,3,2,-1.897);
		for i in 1..Nombre_Lignes(Mat) loop
		if i=2 or else i=4 then
			pragma Assert(Ligne_Vide (i,Mat));
		else
			pragma Assert(not Ligne_Vide (i,Mat));
		end if;
	end loop;

	Put_Line("Fin Tester_Ligne_Vide");

end Tester_Ligne_Vide;

procedure Tester_Afficher is
	Mat : T_Matrice;
	begin
	
		Initialiser(Mat,4,5,2.75);
		Put_Line("Matrice 4x5 avec comme coefficients 2.75");
		Afficher_Mat(Mat);
		
		Initialiser(Mat,3,3,0.0);
		Enregistrer(Mat,1,2,-1.0);
		Put_Line("Matrice 3x3 avec comme coefficients 0.0 et -1.0 en 1,2");
		Afficher_Mat(Mat);
		
		Initialiser(Mat,7,1,-5.0);
		Enregistrer(Mat,2,1,88.0);
		Put_Line("Matrice 7x1 avec comme coefficients -5.0 et 88.0 en 2,1");
		Afficher_Mat(Mat);
		
		Put_Line("Fin Tester_Afficher");
		
end Tester_Afficher;

	begin
	
	Tester_Initialiser;
	Tester_Enregistrer;
	Tester_Obtenir_Valeur;
	Tester_Copier;
	Tester_Transposer;
	Tester_Produit;
	Tester_Produit_f;
	Tester_Sommer;
	Tester_Sommer_f;
	Tester_Produit_Const;
	Tester_Sommer_Const;
	Tester_Ligne_Vide;
	Tester_Afficher;

	Put_Line("Fin des tests");
		
end test_matrice;
