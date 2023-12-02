with Ada.IO_Exceptions;
with Ada.Float_Text_IO;		use Ada.Float_Text_IO;
with Ada.Integer_Text_IO;	use Ada.Integer_Text_IO;
with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;
with Ada.Command_Line;     use Ada.Command_Line;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
--with matrice; use matrice;

--R0:Renvoyer le PageRank dans un fichier .pr et le poids de chaque noeud du graphe dans un 
--fichier.prw à partir d’un graphe orienté dans un fichier .net

procedure PageRank is


    No_Argument_Error : Exception;
	sujet : Ada.Text_IO.File_Type;
    K: Integer;
    alpha: Float;
    epsilon: Float;
    prefixe: Unbounded_String;
    choix: Boolean;
    N:Integer;
    --sujet: T_Matrice;
    N2: Integer;
    Entier: Integer;
    i: Integer;
begin
    --Initialiser les variables
    epsilon:=0.0;
    prefixe:= To_Unbounded_String("output");
    alpha:=0.85;
    K:=150;
    choix:=True;

    --Traiter les arguments
    if Argument_Count>1 then
        i:=1;
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
                break;
            end if;
        end loop;
    elsif Argument_Count < 1 then
		raise No_Argument_Error;
	end if;
    Put(alpha);
    Put(K);
    Put(epsilon);
    Put(To_String(prefixe));
exception
	when No_Argument_Error =>
		Put_Line ("Pas de fichier.");
		New_Line;
		Put_Line ("Usage : " & Command_Name & " <fichier>");
end PageRank;