with Ada.IO_Exceptions;
with Ada.Text_IO;			use Ada.Text_IO;
with Ada.Float_Text_IO;		use Ada.Float_Text_IO;
with Ada.Integer_Text_IO;	use Ada.Integer_Text_IO;
with Ada.Command_line;		use Ada.Command_line;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;


-- Illustrer l'utilisation :
-- * des paramètres (arguments) de la ligne de commande
--   https://www.adaic.org/resources/add_content/standards/05rm/html/RM-A-15.html
-- * et des fichiers.
--   https://www.adaic.org/resources/add_content/standards/05rm/html/RM-A-10.html
procedure Exemple_Texte_IO is

	No_Argument_Error : Exception;

	File : Ada.Text_IO.File_Type; -- descripteur de fichier texte (Ada.Text_IO)
	Entier : Integer;
	Flottant : Float;
	Nom_Fichier : Unbounded_String;
begin
	-- Afficher les paramètres (ou arguments) de la ligne de commande
	New_Line;
	Put ("-- Arguments de la ligne de commande : ");
	Put (Argument_Count, 1);
	Put_Line (" argument(s).");
	for i in 1 .. Argument_Count loop
		Put ("Argument ");
		Put (i, 1);
		Put (" : ");
		Put_Line (Argument (i));
	end loop;
	New_Line (2);

	-- Vérifier que le nom du fichier est fourni
	if Argument_Count < 1 then
		raise No_Argument_Error;
	end if;

	-- Lire le fichier (il doit respecter le format entier, réel, entier+)
	Put ("-- Lire le fichier ");
	Put_Line (Argument (1));

	--   Ouvrir le fichier en lecture (In_File)
	open (File, In_File, Argument (1));
		-- File est le descripteur de fichier

	--   Lire un entier et un réel dans le fichier
	--   (Get usuel avec le descripteur comme 1er paramètre)
	Put_Line ("--   Lire un enier et un réel");
	Get (File, Entier);
	Get (File, Flottant);

	--   Afficher l'entier lu
	Put ("Entier lu : ");
	Put (Entier,1);--Put(type,padding)
	New_Line;

	--   Afficher le réel lu
	Put ("Réel lu : ");
	Put (Flottant, 2, 3,2); -- 2 positions avant la virgule, 3 après.put(flottant,nbvalavvirgule(padding),nbvalapvirgule,nbvalexpos)
	New_Line;

	--   Lire tous les autres entiers du fichier
	begin
		Put_Line ("--   Lire les autres entiers");
		while not End_Of_file (File) loop
			Get (File, Entier);
			Put (Entier, 1);
			Put (" ");
		end loop;
		Put_Line ("[fini]");
	exception
		when End_Error =>
			-- la fin du fichier a été atteinte.
			-- se produit en particulier si on a des caractères après le
			-- dernier entier (un blanc, une ligne vide)
			null;
			Put_Line ("[fin du fichier détectée sur exception]");
	end;
	New_Line (2);

	-- Fermer le fichier
	Close (File);


	-- Créer un fichier avec l'extension .new 
	Nom_Fichier := To_Unbounded_String (Argument (1));
	Append (Nom_Fichier, ".new");
	Put_Line ("-- Écrire dans un nouveau fichier appelé "
			& To_String (Nom_Fichier));
	Create (File, Out_File, To_String (Nom_Fichier));
	Put (File, "produit par " & Command_Name);
	New_Line (File);
	close (File);

	-- Ajouter à la fin d'un fichier
	Open (File, Append_File, To_String (Nom_Fichier));
	Put (File, 'V');
	Put (File, "alue ");
	Put (File, 12.3);
	Close (File);

exception
	when No_Argument_Error =>
		Put_Line ("Pas de fichier.");
		New_Line;
		Put_Line ("Usage : " & Command_Name & " <fichier>");

	when Ada.IO_Exceptions.Name_Error =>
		Put_Line ("Fichier inexisant : " & Argument (1));

	when Data_Error =>
		Put_Line ("Mauvais format du fichier : devrait être entier, reel, entier*");

end Exemple_Texte_IO;
