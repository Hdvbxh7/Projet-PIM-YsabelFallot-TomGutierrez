with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Unchecked_Deallocation;
with Matrice;

procedure test_matrice is


package Matrice_Reel is
		new Matrice(T_Reel => Integer, T_CASSE_COUILLE => Boolean);
		-- , Num_Colonne => 10, Num_Ligne => 10);
	use Matrice_Reel;
	
	Mat : T_Matrice;
	Res : T_Matrice;
	Res_P_ou_S : T_Matrice;
	--Val : T_Reel;
	
	begin
	
	-- Test initialiser
	Initialiser(Mat,4,4);
	Put("Mat initialisé :");
	New_Line;
	Afficher(Mat);
	
	-- Test enregistrer
	Enregistrer(Mat,2,2,50.5);
	Enregistrer(Mat,3,1,46);
	Put("Ajoute sur Mat de deux valeurs");
	New_Line;
	Afficher(Mat);
	
	-- Test Obtenir_Valeur (procédure et fonction)
--	Obtenir_Val(Mat,2,2,Val);
--	Put("Val : ");
--	Put(Val,1);
--	New_Line;
--	Obtanir_Val(Mat,3,1,Val);
--	Put("Val : ");
--	Put(Val,1);
--	New_Line;
	
--	Val:= Obtenir_Val_f(Mat,2,2);
	Put("Val_f : ");
	Put(Obtenir_Val_f(Mat,2,2),1);
	New_Line;
--	Val := Obtanir_Val_f(Mat,3,1);
--	Put("Val_f : ");
--	Put(Val,1);
--	New_Line;
	
	-- Test Transposer (Procédure et fonction)
	Transposer(Mat);
	Put("Mat transposer :");
	New_Line;
	Afficher(Mat);
	
	Res :=Transposer_f(Mat);
	Put("Res transposer_f :");
	New_Line;
	Afficher(Res);
	
	-- Test Copier (Procédure et fonction)
	Copier(Mat,Res);
	Put("Res Copier :");
	New_Line;
	Afficher(Res);
	
	Res := Copier_f(Mat);
	Put("Res Copier_f :");
	New_Line;
	Afficher(Res);
	
	-- Test Produit (procédure et fonction)
	Produit(Mat,Res,Res_P_ou_S);
	Put("Res_P_ou_S Produit :");
	New_Line;
	Afficher(Res_P_ou_S);
	
	Res := Produit_f(Mat,Res,Res_P_ou_S);
	Put("Res_P_ou_S Produit_f :");
	New_Line;
	Afficher(Res_P_ou_S);
	
	-- Test Sommer (procédure et fonction)
	Sommer(Mat,Res,Res_P_ou_S);
	Put("Res_P_ou_S Sommer :");
	New_Line;
	Afficher(Res_P_ou_S);
	
	Res := Sommer_f(Mat,Res,Res_P_ou_S);
	Put("Res_P_ou_S Sommer_f :");
	New_Line;
	Afficher(Res_P_ou_S);
	
	Produit_Const(5,Mat);
	Put("Mat Prod_Const :");
	New_Line;
	Afficher(Mat);
	
	Sommer_Const(100,Mat);
	Put("Mat Somme_const :");
	New_Line;
	Afficher(Mat);
	
	if Ligne_Vide (3,Mat) then
		Put("Ligne 3 vide");
	else 
		Put("LIgne non vide");
	end if;
		
	Put("Nb_ligne :");
	Put(Nombre_Lignes(Mat),1);
	New_Line;
	
	Put("Nb_Colonne :");
	Put(Nombre_Colonnes(Mat),1);
	New_Line;
	
end test_matrice;

