--

package mp is
    type T_Tableau is array (1..2,1..7) of Integer;--temporaire le temps que matrice fonctionne
    -- matricepleine
	procedure matricepleine(K:Integer;epsilon:Float;alpha:Integer;prefixe:Unbounded_String;N:Integer;N2:Integer;sujet:T_Tableau);
end mp;
