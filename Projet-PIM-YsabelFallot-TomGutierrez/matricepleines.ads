with Ada.Strings.Unbounded;             use Ada.Strings.Unbounded;

package matricepleines is
	procedure matricepleine(K       : Integer; epsilon : Float; alpha : Float;
        prefixe : Unbounded_String; N : Integer; N2 : Integer;
        nom_sujet   : String);
end matricepleines;
