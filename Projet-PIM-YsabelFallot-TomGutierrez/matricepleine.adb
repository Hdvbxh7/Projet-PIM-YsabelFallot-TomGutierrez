with Ada.IO_Exceptions;
with Ada.Float_Text_IO;		use Ada.Float_Text_IO;
with Ada.Integer_Text_IO;	use Ada.Integer_Text_IO;
with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Command_Line;     use Ada.Command_Line;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
--with matrice; use matrice;

package body mp is

procedure matricepleine(K:Integer;epsilon:Float;alpha:Integer;prefixe:Unbounded_String;N:Integer;N2:Integer;sujet:T_Tableau) is
    type T_Tableau is array (1..2,1..7) of Integer;--temporaire le temps que matrice fonctionne
    --instancier matrice
    ecart:Integer;
    distance:integer;
    i:Integer;
    z:Integer;
    j:Integer;
    compt:Integer;
    pi:T_Matrice;
    pik:T_Matrice;
    e:T_Matrice;
    G:T_Matrice;
    S:T_Matrice;
    H:T_Matrice;
    N3:Integer;
    list:T_Matrice;
begin
    --Initialiser le programme
    --Générer e
    Initialiser(e,N,N);
    Sommer_Const(e,1);
    --Générer H
    Initialiser(H,N,N);
    for z in 0..N-1 loop
        compt:=0;
        Initialiser(list,N,1);
        for i in 1..N2 loop
        
    end loop;
end matricepleine;
end mp;