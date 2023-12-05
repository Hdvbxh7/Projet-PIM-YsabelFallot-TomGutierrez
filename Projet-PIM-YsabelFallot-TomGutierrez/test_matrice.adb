with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;   use Ada.Float_Text_IO;
with Matrice_Exceptions;         use Matrice_Exceptions;
with Matrice;

procedure test_matrice is


package Matrice_Reel is
		new Matrice( T_Reel => Float, Num_Colonne => 10, Num_Ligne => 10);
	use Matrice_Reel;
	
	
procedure Afficher_T_Reel_Float (Val : in Float) is
	begin
		Put(Val,1);
end Afficher_T_Reel_Float;

procedure Afficher_Mat is
            new Matrice_Reel.Afficher(Afficher_T_Reel_Float);

	
	Mat : T_Matrice;
	Res : T_Matrice;
	Res_P_ou_S : T_Matrice;
	Val : Float;
	
	begin
	
	-- Test initialiser
	Initialiser(Mat,4,4,0.0);
	Put("Mat initialisé :");
	New_Line;
	Afficher_Mat(Mat);
	
	-- Test enregistrer
	Enregistrer(Mat,2,2,50.0);
	Enregistrer(Mat,3,1,46.0);
	Put("Ajoute sur Mat de deux valeurs");
	New_Line;
	Afficher_Mat(Mat);
	
	-- Test Obtenir_Valeur (procédure et fonction)
	Obtenir_Val(Mat,2,2,Val);
	Put("Val : ");
	Afficher_T_Reel_Float(Val);
	New_Line;
	Obtenir_Val(Mat,3,1,Val);
	Put("Val : ");
	Afficher_T_Reel_Float(Val);
	New_Line;
	
	Val:= Obtenir_Val_f(Mat,2,2);
	Put("Val_f : ");
	Afficher_T_Reel_Float(Val);
	New_Line;
	Val := Obtenir_Val_f(Mat,3,1);
	Put("Val_f : ");
	Afficher_T_Reel_Float(Val);
	New_Line;
	
	-- Test Transposer (Procédure et fonction)
	Transposer(Mat);
	Put("Mat transposer :");
	New_Line;
	Afficher_Mat(Mat);
	
	Res :=Transposer_f(Mat);
	Put("Res transposer_f :");
	New_Line;
	Afficher_Mat(Res);
	
	-- Test Copier (Procédure et fonction)
	Copier(Mat,Res);
	Put("Res Copier :");
	New_Line;
	Afficher_Mat(Res);
	
	--Initialiser(Mat,4,4,0.0);
	Res := Copier_f(Mat);
	Put("Res Copier_f :");
	New_Line;
	Afficher_Mat(Res);
	
	-- Test Produit (procédure et fonction)
	Produit(Mat,Res,Res_P_ou_S);
	Put("Res_P_ou_S Produit :");
	New_Line;
	Afficher_Mat(Res_P_ou_S);
	
	
	New_Line;
	Put("Mat");
	New_Line;
	Afficher_Mat(Mat);
	New_Line;
	
	New_Line;
	Put("Res");
	New_Line;
	Afficher_Mat(Res);
	New_Line;
	
	Initialiser(Res_P_ou_S,4,4,0.0);
	Res_P_ou_S := Produit_f(Mat,Res);
	Put("Res_P_ou_S Produit_f :");
	New_Line;
	Afficher_Mat(Res_P_ou_S);
	
	New_Line;
	Put("Res");
	New_Line;
	Afficher_Mat(Res);
	New_Line;
	
	New_Line;
	New_Line;
	
	-- Test Sommer (procédure et fonction)
	Sommer(Mat,Res,Res_P_ou_S);
	Put("Res_P_ou_S Sommer :");
	New_Line;
	Afficher_Mat(Res_P_ou_S);
	New_Line;
	
	Res := Sommer_f(Mat,Res);
	Put("Res_P_ou_S Sommer_f :");
	New_Line;
	Afficher_Mat(Res_P_ou_S);
	New_Line;
	
	Produit_Const(5.0,Mat);
	Put("Mat Prod_Const :");
	New_Line;
	Afficher_Mat(Mat);
	
	
	
	for i in 1..Nombre_Lignes(Mat) loop
		if Ligne_Vide (i,Mat) then
			Put("Ligne ");
			Put(i,1);
			Put(" vide");
			New_Line;
		else 
			Put("Ligne ");
			Put(i,1);
			Put(" non vide");
			New_Line;
		end if;
	end loop;
	New_Line;
	
	Sommer_Const(100.0,Mat);
	Put("Mat Somme_const :");
	New_Line;
	Afficher_Mat(Mat);
	
	Put("Nb_ligne :");
	Put(Nombre_Lignes(Mat),1);
	New_Line;
	
	Put("Nb_Colonne :");
	Put(Nombre_Colonnes(Mat),1);
	New_Line;
	
	Initialiser(Mat,10,10,0.0);
	--Exception
	Res := Sommer_f(Mat,Res);

end test_matrice;
