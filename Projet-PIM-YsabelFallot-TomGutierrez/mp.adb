with Ada.IO_Exceptions;
with Ada.Float_Text_IO;		use Ada.Float_Text_IO;
with Ada.Integer_Text_IO;	use Ada.Integer_Text_IO;
with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Command_Line;     use Ada.Command_Line;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;


package body mp is

    
procedure matricepleine(K:Integer;epsilon:Float;alpha:Float;prefixe:Unbounded_String;N:Integer;N2:Integer;sujet:T_Matrice) is
    


    File : Ada.Text_IO.File_Type; 
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
    Initialiser(e,N,N);
    Sommer_Const(1.0,e);
    --Générer H
    Initialiser(H,N,N);
    for z in 0..N-1 loop
        --préparation des valeurs de la ligne z de la matrice H
        compt:=0;       
        Initialiser(list,N,1);
        for i in 1..N2 loop
            if Obtenir_Val_f(sujet,i,1)=Float(z) then
                compt:=compt+1;
                Enregistrer(list,compt,1,Obtenir_Val_f(sujet,i,2)+1.0);
            end if;
        end loop;
        --Ajout des valeurs de la ligne z dans la matrice H
        if compt/=0 then 
            N3:=1.0/Float(compt);
            compt:=0;
            while Obtenir_Val_f(list,compt,1)/=0.0 loop
                Enregistrer(H,Integer(Obtenir_Val_f(list,compt,1)),z,N3);
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
                Enregistrer(H,i,j,1.0/Float(N));
            end loop;
        end if;
    end loop;
    --Calculer G
    S1:=S;
    e1:=e;
    Produit_Const(alpha,S1); 
    Produit_Const((1.0-alpha)/Float(N),e1);
    copier(Sommer_f(S,e1),G);
    --Calculer le poids des différentes pages
    Initialiser(mat,N,2);
    --initialiser pi
    Initialiser(pi,N,1);
    for i in 1..N loop
        Enregistrer(pi,i,1,1.0/Float(N));
    end loop;
    --Calculer le poids de chaque page en fonction de k
    i:=0;
    distance:=0.0;
    while i<K and distance<epsilon loop
        copier(pi,pik);
        Produit(pi,G,pi);
        Produit_Const(-1.0,pik);
        Sommer(pi,pik,ecartm);
        distance:=Sqrt(Obtenir_Val_f(Produit_f(ecartm,Transposer_f(ecartm)),1,1));
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
        Enregistrer(mat,class,1,Float(imax));
        Enregistrer(mat,class,2,max);
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

end mp;