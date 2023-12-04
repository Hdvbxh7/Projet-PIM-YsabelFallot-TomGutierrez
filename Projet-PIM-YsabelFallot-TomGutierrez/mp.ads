--
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

generic
   type T_Matrice;
package mp is

    package Matrice_Reel is
		new Matrice( Num_Colonne => 100, Num_Ligne => 100);
	use Matrice_Reel;

	procedure matricepleine(K:Integer;epsilon:Float;alpha:Float;prefixe:Unbounded_String;N:Integer;N2:Integer;sujet:T_Matrice);
end mp;
