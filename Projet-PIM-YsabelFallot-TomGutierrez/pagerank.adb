with Ada.IO_Exceptions;
with Ada.Float_Text_IO;		use Ada.Float_Text_IO;
with Ada.Integer_Text_IO;	use Ada.Integer_Text_IO;
with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Command_Line;     use Ada.Command_Line;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
--with matrice; use matrice;

--R0:Renvoyer le PageRank dans un fichier .pr et le poids de chaque noeud du graphe dans un 
--fichier.prw à partir d’un graphe orienté dans un fichier .net

procedure PageRank is
    type T_Tableau is array (1..2,1..7) of Integer;--temporaire le temps que matrice fonctionne
    No_Argument_Error : Exception;
	F_sujet : Ada.Text_IO.File_Type;
    K: Integer;
    alpha: Float;
    epsilon: Float;
    prefixe: Unbounded_String;
    choix: Boolean;
    N:Integer;
    sujet: T_Tableau;
    N2: Integer;
    Entier: Integer;
    i: Integer;
    compt: Integer;
begin
    --Initialiser les variables
    epsilon:=0.0;
    prefixe:= To_Unbounded_String("output");
    alpha:=0.85;
    K:=150;
    choix:=True;

    --Traiter les arguments
    begin
    i:=1;
    if Argument_Count>1 then
        while Argument_Count/=i loop
            --Etudier la valeur de l'argument
            if Argument (i)="-K" then
                K:=Integer'Value(Argument(i+1));
                i:=i+2;
            elsif Argument (i)="-P" then
                Choix:=False; 
                i:=i+1;
            elsif Argument (i)="-A" then
                alpha:=Float'Value(Argument(i+1)); 
                i:=i+2;
            elsif Argument (i)="-C" then
                Choix:=True; 
                i:=i+1;
            elsif Argument (i)="-R" then
                prefixe:=To_Unbounded_String(Argument(i+1));
                i:=i+2;
            elsif Argument (i)="-E" then
                epsilon:=Float'Value(Argument(i+1));
                i:=i+2;
            else
                Put("Erreur dans l’entrée des arguments!");
            end if;
        end loop;
    elsif Argument_Count < 1 then
		raise No_Argument_Error;    
	end if;
    exception
        When Constraint_Error => Put("Erreur dans l’entrée des arguments!");
        when No_Argument_Error =>Put_Line ("Pas de fichier.");
		                        New_Line;
		                        Put_Line ("Usage : " & Command_Name & " <fichier>");
    end;
    --lire sujet.net
    begin
    open (F_sujet, In_File, Argument (i));--ouvrir le fichier sujet.net
    Get (F_sujet, N);--récuperer le nombre de sommet
    Get(F_sujet,alpha);--utiliser pour les test
    --compter le nombre de vecteur dans le fichier
    compt:=0;
    while not End_Of_file (F_sujet) loop
			Get (F_sujet, Entier);
            compt:=compt+1;
    end loop;
    exception
		when End_Error =>
			-- la fin du fichier a été atteinte.
			-- se produit en particulier si on a des caractères après le
			-- dernier entier (un blanc, une ligne vide)
			null;
    end;
    Close(F_sujet);
    begin
    N2:=compt/2;
    if (2*N2)/=compt then
        raise Data_Error;
    end if;
    exception
    when Data_Error =>
		Put_Line ("Mauvais format du fichier : devrait être entier, reel, entier*");
    end;
    --Créer la matrice sujet
    --préparation pour matrice sujet
    --Initialiser(sujet,N2,2)
    open (F_sujet, In_File, Argument (i));
    Get (F_sujet, Entier);
    Get(F_sujet,alpha);
    compt:=0;
    while compt<N2 loop
        --ajouter les valeurs du fichier sujet.net dans la matrice sujet
        compt:=compt+1;
        Get (F_sujet, Entier);
        --Enregistrer(sujet,compt,1,Entier)
        sujet(1,compt):=Entier;
        Get (F_sujet, Entier);
        --Enregistrer(sujet,compt,1,Entier)
        sujet(2,compt):=Entier;
    end loop;
    Close(F_sujet);
    --Choisir le programme à éxécuter
    if choix then
        Put("Matrice creuse");
    else
        Put("Matrice pleine");
    end if;
    Put(alpha);
    Put(K);
    Put(epsilon);
    Put(To_String(prefixe));
    Put(N);
    Put(N2);
    for i in 1..7 loop
        for j in 1..2 loop
            Put(sujet(j,i));
        end loop;
    end loop;
end PageRank;