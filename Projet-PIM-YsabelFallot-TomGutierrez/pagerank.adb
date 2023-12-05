with Ada.IO_Exceptions;
with Ada.Float_Text_IO;		use Ada.Float_Text_IO;
with Ada.Integer_Text_IO;	use Ada.Integer_Text_IO;
with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Command_Line;     use Ada.Command_Line;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with Matrice; -- use Matrice;


--R0:Renvoyer le PageRank dans un fichier .pr et le poids de chaque noeud du graphe dans un 
--fichier.prw à partir d’un graphe orienté dans un fichier .net

procedure PageRank is

    package Matrice_Reel is
		new Matrice( T_Reel=>Float,Num_Colonne => 1000, Num_Ligne => 1000);
	use Matrice_Reel;

        
    procedure matricepleine(K:Integer;epsilon:Float;alpha:Float;prefixe:Unbounded_String;N:Integer;N2:Integer;sujet:T_Matrice) is
    


    File : Ada.Text_IO.File_Type; 
    distance:Float;
    N3:Float;
    max:Float;
    imax:Integer;
    i:Integer;
    compt:Integer;
    class:Integer;
    mat:T_Matrice;
    pi:T_Matrice;
    pik:T_Matrice;
    e:T_Matrice;
    G:T_Matrice;
    S:T_Matrice;
    S1:T_Matrice;
    e1:T_Matrice;
    H:T_Matrice;
    list:T_Matrice;
    ecartm:T_Matrice;
    prefixepr:Unbounded_String;
    prefixeprw:Unbounded_String;
begin
    --Initialiser le programme
    --Générer e
    Initialiser(e,N,N,0.0);
    Sommer_Const(1.0,e);
    --Générer H
    Initialiser(H,N,N,0.0);
    for z in 0..N-1 loop
        --préparation des valeurs de la ligne z de la matrice H
        compt:=0;       
        Initialiser(list,N,1,0.0);
        for i in 1..N2 loop
            if Obtenir_Val_f(sujet,i,1)=Float(z) then
                compt:=compt+1;
                Enregistrer(list,compt,1,Obtenir_Val_f(sujet,i,2)+1.0);
            end if;
        end loop;
        --Ajout des valeurs de la ligne z dans la matrice H
        if compt/=0 then 
            N3:=1.0/Float(compt);
            compt:=1;
            while Obtenir_Val_f(list,compt,1)/=0.0 loop
                Enregistrer(H,z+1,Integer(Obtenir_Val_f(list,compt,1)),N3);
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
                Enregistrer(S,i,j,1.0/Float(N));
            end loop;
        end if;
    end loop;

    --Calculer G
    S1:=S;
    e1:=e;
    Produit_Const(alpha,S1); 
    Produit_Const((1.0-alpha)/Float(N),e1);
    copier(Sommer_f(S1,e1),G);
    --Calculer le poids des différentes pages
    Initialiser(mat,N,2,0.0);
    --initialiser pi
    Initialiser(pi,1,N,0.0);
    for i in 1..N loop
        Enregistrer(pi,1,i,1.0/Float(N));
    end loop;
    --Calculer le poids de chaque page en fonction de k
    i:=0;
    distance:=0.0;
    if epsilon/=0.0 then
        while i<K and distance<=epsilon loop
            copier(pi,pik);
            Produit(pi,G,pi);
            Produit_Const(-1.0,pik);
            Sommer(pi,pik,ecartm);
            distance:=Sqrt(Obtenir_Val_f(Produit_f(ecartm,Transposer_f(ecartm)),1,1));
            i:=i+1;
        end loop;
    else
        while i<K loop
            Produit(pi,G,pik);
            pi:=pik;
            i:=i+1;
        end loop;
    end if;
    --Générer les fichiers résultats
    --Trier les pages et leur poids dans une matrice
    class:=0;
    while class<N loop
        class:=class+1;
        max:=0.0;
        imax:=1;
        --Chercher le max
        for i in 1..N loop
            if Obtenir_Val_f(pi,1,i)>max then
                max:=Obtenir_Val_f(pi,1,i);
                imax:=i;
            end if;
        end loop;
        Enregistrer(mat,class,1,Float(imax-1));
        Enregistrer(mat,class,2,max);
        Enregistrer(pi,1,imax,0.0);

    end loop;
    --Créer le fichier sujet.prw
    --Nommer prefixe.prw
    prefixeprw:=prefixe;
	Append (prefixeprw, ".prw");
    --initialiser sujet.prw
	Create (File, Out_File, To_String (prefixeprw));  
	New_Line (File);
    Put (File, N );
    Put (File, " ");
    Put (File, alpha );
    Put (File, " ");
    Put (File, K );
    New_Line (File);
    for i in 1..N loop
        Put (File, Obtenir_Val_f(mat,i,2));
        New_Line (File);
    end loop;
	close (File);
    --Créer le fichier sujet.pr
    --Nommer prefixe.pr
    prefixepr:=prefixe;
	Append (prefixepr, ".pr");
    --initialiser sujet.pr
	Create (File, Out_File, To_String (prefixepr));
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
    --compter le nombre de vecteur dans le fichier
    compt:=0;
    while not End_Of_file (F_sujet) loop
			Get (F_sujet, Entier);
            compt:=compt+1;
    end loop;
    exception
		when End_Error =>null;
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
    Initialiser(sujet,N2,2,0.0);
    open (F_sujet, In_File, Argument (i));
    Get (F_sujet, Entier);
    compt:=0;
    while compt<N2 loop
        --ajouter les valeurs du fichier sujet.net dans la matrice sujet
        compt:=compt+1;
        Get (F_sujet, Entier);
        Enregistrer(sujet,compt,1,Float(Entier));
        Get (F_sujet, Entier);
        Enregistrer(sujet,compt,2,Float(Entier));
    end loop;
    Close(F_sujet);
    --Choisir le programme à éxécuter
    if choix then
        Put("Matrice creuse");
    else
        Put("Matrice pleine");
        matricepleine(K,epsilon,alpha,prefixe,N,N2,sujet);
    end if;
end PageRank;
