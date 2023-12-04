with Ada.IO_Exceptions;
with Ada.Float_Text_IO;		use Ada.Float_Text_IO;
with Ada.Integer_Text_IO;	use Ada.Integer_Text_IO;
with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Command_Line;     use Ada.Command_Line;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Matrice; -- use Matrice;
with mp; use mp;

--R0:Renvoyer le PageRank dans un fichier .pr et le poids de chaque noeud du graphe dans un 
--fichier.prw à partir d’un graphe orienté dans un fichier .net

procedure PageRank is

	package Matrice_Reel is
		new Matrice( Num_Colonne => 100, Num_Ligne => 100);
	use Matrice_Reel;
	
procedure matricepleine(K:Integer;epsilon:Float;alpha:Float;prefixe:Unbounded_String;N:Integer;N2:Integer;sujet:T_Matrice) is
    


    File : Ada.Text_IO.File_Type; 
    ecart:Float;
    distance:Float;
    N3:Float;
    max:Float;
    imax:Integer;
    i:Integer;
    z:Integer;
    j:Integer;
    compt:Integer;
    class:Integer;
    mat:T_Matrice;
    pi:T_Matrice;
    pik:T_Matrice;
    e:T_Matrice;
    G:T_Matrice;
    S:T_Matrice;
    H:T_Matrice;
    list:T_Matrice;
begin
    --Initialiser le programme
    --Générer e
    Initialiser(e,N,N);
    Sommer_Const(e,1.0);
    --Générer H
    Initialiser(H,N,N);
    for z in 0..N-1 loop
        --préparation des valeurs de la ligne z de la matrice H
        compt:=0;       
        Initialiser(list,N,1);
        for i in 1..N2 loop
            if sujet(i,1)=z then
                compt:=compt+1;
                Enregistrer(list,compt,1,Obtenir_Val_f(sujet,i,2)+1.0);
            end if;
        end loop;
        --Ajout des valeurs de la ligne z dans la matrice H
        if compt/=0 then 
            N3:=1/compt;
            compt:=0;
            while Obtenir_Val_f(list,compt,1)/=0 loop
                Enregistrer(H,Obtenir_Val_f(list,compt,1),z,N3);
                compt:=compt+1;
            end loop;
        end if;
    end loop;
    --Trabsformer H en S
    Copier(H,S);
    for i in 1..N loop
        --Transformer la ligne si tout les coeifficients sont vides
        if Ligne_Vide(i,S) then
            --remplacer la valeur de chaque coordonnées de la ligne par 1/N
            for j in 1..N loop
                Enregistrer(H,i,j,1/N);
            end loop;
        end if;
    end loop;
    --Calculer G
    Initialiser(G,N,N);
    Copier(Sommer_f(Produit_Const(alpha,S),Produit_Const(e,(1.0-alpha)/N)),G);
    --Calculer le poids des différentes pages
    Initialiser(mat,N,2);
    --initialiser pi
    Initialiser(pi,N,1);
    for i in 1..N loop
        Enregistrer(pi,i,1,1/N);
    end loop;
    --Calculer le poids de chaque page en fonction de k
    i:=0;
    distance:=0;
    while i<K and distance<epsilon loop
        copier(pi,pik);
        Produit(pi,G,pi);
        Sommer(pi,Produit_Const(-1,pik),ecart);
        distance:=Sqrt(Obtenir_Val_f(Produit(ecart,Transposer_f(ecart)),1,1));
    end loop;
    --Générer les fichiers résultats
    --Trier les pages et leur poids dans une matrice
    class:=0;
    while class<N loop
        class:=class+1;
        max:=0.0;
        imax:=1;
        --Chercher le max
        for i in 1..N loop
            if Obtenir_Val_f(pi,i,1)>max then
                max:=Obtenir_Val_f(pi,i,1);
                imax:=i;
            end if;
        end loop;
        Enregistrer(mat,class,1,imax);
        Enregistrer(mat,class,2,max);
    end loop;
    --Créer le fichier sujet.prw
    --Nommer prefixe.prw
	Append (prefixe, ".prw");
    --initialiser sujet.prw
	Create (File, Out_File, To_String (prefixe));  
	New_Line (File);
    Put (File, N & " " & alpha & " " & K );
    New_Line (File);
    for i in 1..N loop
        Put (File, Obtenir_Val_f(mat,i,2));
        New_Line (File);
    end loop;
	close (File);
    --Créer le fichier sujet.pr
    --Nommer prefixe.pr
	Append (prefixe, ".pr");
    --initialiser sujet.pr
	Create (File, Out_File, To_String (prefixe));
	New_Line (File);
    Put (File, N);
    New_Line (File);
    for i in 1..N loop
        Put (File, Obtenir_Val_f(mat,i,1));
        New_Line (File);
    end loop;
	close (File);
end matricepleine;


    No_Argument_Error : Exception;
	F_sujet : Ada.Text_IO.File_Type;
    K: Integer;
    alpha: Float;
    epsilon: Float;
    prefixe: Unbounded_String;
    choix: Boolean;
    N:Integer;
    sujet: T_Matrice;
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
    Initialiser(sujet,N2,2);
    open (F_sujet, In_File, Argument (i));
    Get (F_sujet, Entier);
    Get(F_sujet,alpha);
    compt:=0;
    while compt<N2 loop
        --ajouter les valeurs du fichier sujet.net dans la matrice sujet
        compt:=compt+1;
        Get (F_sujet, Entier);
        Enregistrer(sujet,compt,1,Float(Entier));
        --sujet(1,compt):=Entier;
        Get (F_sujet, Entier);
        Enregistrer(sujet,compt,2,Float(Entier));
        --sujet(2,compt):=Entier;
    end loop;
    Close(F_sujet);
    --Choisir le programme à éxécuter
    if choix then
        Put("Matrice creuse");
    else
        Put("Matrice pleine");
        --matricepleine(K,epsilon,alpha,prefixe,N,N2,sujet);
    end if;
    Put(alpha);
    Put(K);
    Put(epsilon);
    Put(To_String(prefixe));
    Put(N);
    Put(N2);
    for i in 1..7 loop
        for j in 1..2 loop
            Put(Obtenir_Val_f(sujet,i,j));
        end loop;
    end loop;
end PageRank;
