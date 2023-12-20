with Ada.IO_Exceptions;
with Ada.Float_Text_IO;                 use Ada.Float_Text_IO;
with Ada.Integer_Text_IO;               use Ada.Integer_Text_IO;
with Ada.Text_IO;                       use Ada.Text_IO;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with Matrice;

package body matricepleines is

    procedure matricepleine
       (K         : Integer; epsilon : Float; alpha : Float;
        prefixe   : Unbounded_String; N : Integer; N2 : Integer;
        nom_sujet : String)
    is
        package Matrice_Reel is new Matrice
           (T_Reel => Float, Num_Colonne => 100, Num_Ligne => 100,
            Zero   => 0.0);
        use Matrice_Reel;

        F_sujet    : Ada.Text_IO.File_Type; --Format du fichiern d'entrée
        File       : Ada.Text_IO.File_Type; --Format du fichier de sortie
        distance   : Float; --distance entre les vecteurs k et k-1
        N3         : Float; --valeur des lignes dans l'
        max        : Float; --valeur du poids maximum a chaque boucle
        Entier     : Integer; --dernier entier lu par le fichier
        imax       : Integer; --indice du poids maximum a chaque boucle
        i          : Integer; --variable de boucle while
        compt      : Integer; --variable compteur
        class      : Integer; --variable de classement
        sujet      : T_Matrice; --matrice qui contient les vecteurs du graphe
        mat        : T_Matrice; --matrice contenant les resultats du programme
        pi         : T_Matrice; --pi a la recurrence k
        pik        : T_Matrice; --pi à la recurrence k-1
        e          : T_Matrice; --matrice de 1 de taille N*1 
        G          : T_Matrice; --matrice de google
        S          : T_Matrice; --matrice S
        S1         : T_Matrice; --copie de la matrice S
        e1         : T_Matrice; --copie de la matrice e
        H          : T_Matrice; --matrice H
        list       : T_Matrice; --liste des vecteurs partant d'un sommet pour un sommet différent a chaque boucle
        ecartm     : T_Matrice; --matrice 1*1 de l'ecart entre pik et pi
        prefixepr  : Unbounded_String; --prefixe du fichier .pr
        prefixeprw : Unbounded_String; --prefixe du fichier .prw
    begin
        --Créer la matrice sujet
        --préparation pour matrice sujet
        Initialiser (sujet, N2, 2, 0.0);
        Open (F_sujet, In_File, nom_sujet);
        Get (F_sujet, Entier);
        compt := 0;
        while compt < N2 loop
            --ajouter les valeurs du fichier sujet.net dans la matrice sujet
            compt := compt + 1;
            Get (F_sujet, Entier);
            Enregistrer (sujet, compt, 1, Float (Entier));
            Get (F_sujet, Entier);
            Enregistrer (sujet, compt, 2, Float (Entier));
        end loop;
        Close (F_sujet);
        --Initialiser le programme
        --Générer e
        Initialiser (e, N, N, 0.0);
        Sommer_Const (1.0, e);
        --Générer H
        Initialiser (H, N, N, 0.0);
        for z in 0 .. N - 1 loop
            --préparation des valeurs de la ligne z de la matrice H
            compt := 0;
            Initialiser (list, N, 1, 0.0);
            for i in 1 .. N2 loop
                if Obtenir_Val_f (sujet, i, 1) = Float (z) then
                    compt := compt + 1;
                    Enregistrer
                       (list, compt, 1, Obtenir_Val_f (sujet, i, 2) + 1.0);
                end if;
            end loop;
            --Ajout des valeurs de la ligne z dans la matrice H
            if compt /= 0 then
                N3    := 1.0 / Float (compt);
                compt := 1;
                while Obtenir_Val_f (list, compt, 1) /= 0.0 loop
                    Enregistrer
                       (H, z + 1, Integer (Obtenir_Val_f (list, compt, 1)),
                        N3);
                    compt := compt + 1;
                end loop;
            end if;
        end loop;
        --Trabsformer H en S
        Copier (H, S);
        for i in 1 .. N loop
            --Transformer la ligne si tout les coeifficients sont vides
            if Ligne_Vide (i, S) then
                --remplacer la valeur de chaque coordonnées de la ligne par 1/N
                for j in 1 .. N loop
                    Enregistrer (S, i, j, 1.0 / Float (N));
                end loop;
            end if;
        end loop;

        --Calculer G
        S1 := S;
        e1 := e;
        Produit_Const (alpha, S1);
        Produit_Const ((1.0 - alpha) / Float (N), e1);
        Copier (Sommer_f (S1, e1), G);
        --Calculer le poids des différentes pages
        Initialiser (mat, N, 2, 0.0);
        --initialiser pi
        Initialiser (pi, 1, N, 0.0);
        for i in 1 .. N loop
            Enregistrer (pi, 1, i, 1.0 / Float (N));
        end loop;
        --Calculer le poids de chaque page en fonction de k
        i        := 0;
        distance := 0.0;
        if epsilon /= 0.0 then
            while i < K and distance <= epsilon loop
                Copier (pi, pik);
                Produit (pi, G, pi);
                Produit_Const (-1.0, pik);
                Sommer (pi, pik, ecartm);
                distance :=
                   Sqrt
                      (Obtenir_Val_f
                          (Produit_f (ecartm, Transposer_f (ecartm)), 1, 1));
                i        := i + 1;
            end loop;
        else
            while i < K loop
                Produit (pi, G, pik);
                pi := pik;
                i  := i + 1;
            end loop;
        end if;
        --Générer les fichiers résultats
        --Trier les pages et leur poids dans une matrice
        class := 0;
        while class < N loop
            class := class + 1;
            max   := 0.0;
            imax  := 1;
            --Chercher le max
            for i in 1 .. N loop
                if Obtenir_Val_f (pi, 1, i) > max then
                    max  := Obtenir_Val_f (pi, 1, i);
                    imax := i;
                end if;
            end loop;
            Enregistrer (mat, class, 1, Float (imax - 1));
            Enregistrer (mat, class, 2, max);
            Enregistrer (pi, 1, imax, 0.0);

        end loop;
        --Créer le fichier sujet.prw
        --Nommer prefixe.prw
        prefixeprw := prefixe;
        Append (prefixeprw, ".prw");
        --initialiser sujet.prw
        Create (File, Out_File, To_String (prefixeprw));
        New_Line (File);
        Put (File, N);
        Put (File, " ");
        Put (File, alpha);
        Put (File, " ");
        Put (File, K);
        New_Line (File);
        for i in 1 .. N loop
            Put (File, Obtenir_Val_f (mat, i, 2));
            New_Line (File);
        end loop;
        Close (File);
        --Créer le fichier sujet.pr
        --Nommer prefixe.pr
        prefixepr := prefixe;
        Append (prefixepr, ".pr");
        --initialiser sujet.pr
        Create (File, Out_File, To_String (prefixepr));
        New_Line (File);
        Put (File, N);
        New_Line (File);
        for i in 1 .. N loop
            Put (File, Obtenir_Val_f (mat, i, 1));
            New_Line (File);
        end loop;
        Close (File);
    end matricepleine;

end matricepleines;
