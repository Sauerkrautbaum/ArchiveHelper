-- French localisation
-- luacheck: ignore 631
local L = ZO_CreateStringId
local AH = "ARCHIVEHELPER_"
L(AH .. "ADD_AVOID", "Ajouter à la liste des Indésirables")
L(AH .. "ALL_BOTH", "Tous les versets et visions acquis")
L(AH .. "ALL_VISIONS", "Toutes les visions acquises")
L(AH .. "ALL_VERSES", "Tous les versets acquis")
L(AH .. "ARC_BOSS", "Boss d'arc à venir")
L(AH .. "AVOID", "Indésirables")
L(AH .. "BUFF_SELECTED", "<<1>> a sélectionné <<2>>")
L(AH .. "COUNT", "<<1>> sur <<2>>")
L(AH .. "CROSSING_INVALID", "The Crossing Helper can only be activated within the Treacherous Crossing in the Infinite Archive")
L(AH .. "CROSSING_KEY", "<<1>> Prendre à gauche - <<2>> Prendre à droite")
L(AH .. "CROSSING_NO_SOLUTIONS", "Aucun chemin trouvé")
L(AH .. "CROSSING_PATHS", "Chemins possibles")
L(AH .. "CROSSING_SLASH", "aide")
L(AH .. "CROSSING_START", "Début")
L(AH .. "CROSSING_TITLE", "Aide pour le Gué traître")
L(
    AH .. "CROSSING_INSTRUCTIONS",
    "Trouvez l'interrupteur correspondant au début du chemin et sélectionnez-le dans la liste déroulante ci-dessous (1 est le plus à gauche, 6 le plus à droite)." ..
        " Puis, si nécessaire, trouvez la 2ème étape ou la fin du chemin."
)
L(AH .. "CYCLE_BOSS", "Boss de cycle à venir")
L(AH .. "DEN_TIMER", "<<1[0s restantes/1s restante/$ds restantes]>>")
L(AH .. "FABLED", "fabule")
L(AH .. "FABLED_MARKER", "Mettre un marqueur de cible sur les Fables")
L(
    AH .. "FABLED_TOOLTIP",
    "Cette fonctionnalité ne fonctionnera pas avec l'addon Lykeion's Fabled Marker afin d'éviter que les deux addons n'essaient de marquer les mêmes choses."
)
L(AH .. "FLAMESHAPER", "Façonne-feu")
L(AH .. "GW", "Gw le pillard")
L(AH .. "GW_MARKER", "Ajouter un marqueur de cible sur Gw le pillard")
L(AH .. "GW_PLAY", "Jouer un son quand Gw apparaît")
L(AH .. "HERD", "Rassemblez les lueurs fantômes") -- Rassemblez les lueurs fantômes
L(AH .. "HERD_FAIL", "assez") -- Vous n'avez pas assez rassemblé de lueurs fantômes
L(AH .. "HERD_SUCCESS", "ramené") -- Vous avez ramené les lueurs fantômes
L(AH .. "MARAUDER_MARKER", "Mettre un marqueur de cible sur les Maraudeurs")
L(AH .. "MARAUDER_INCOMING_PLAY", "Jouer un son à l'arrivée d'un Maraudeur")
L(AH .. "PROGRESS", "Avancement du critère <<1>><<2>><<3>>. Encore <<4>>.")
L(AH .. "PROGRESS_ACHIEVEMENT", "Progression des succès")
L(AH .. "PROGRESS_CHAT", "Afficher dans le log")
L(AH .. "PROGRESS_SCREEN", "Annoncer à l'écran")
L(AH .. "REMINDER", "Signaler les prochaines phases de boss")
L(AH .. "REMINDER_QUEST", "Rappel en cas d'objet de quête non ramassé")
L(AH .. "REMINDER_QUEST_TEXT", "Pensez à ramasser l'objet de quête !")
L(AH .. "REMINDER_TOOLTIP", "Lors de la sélection des versets, afficher un rappel si la phase suivante est un boss.")
L(AH .. "REMOVE_AVOID", "Retirer de la liste des Indésirables")
L(AH .. "REQUIRES", "Requiert LibChatMessage")
L(AH .. "SECONDS", "s^f")
L(AH .. "SHARD", "Fragment de Tho'at")
L(AH .. "SHARD_IGNORE", "Ignorer les Fragments en dehors du cycle 5")
L(AH .. "SHARD_MARKER", "Mettre un marqueur sur les Fragments de Tho'at")
L(AH .. "SHOW_COUNT", "Décompter les tomes-carapaces de l'Aile du greffier")
L(AH .. "SHOW_CROSSING_HELPER", "Afficher l'aide dans le Gué traître")
L(
    AH .. "SHOW_COUNT_TOOLTIP",
    "Pour que le mode Duo fonctionne correctement, l'autre joueur doit avoir installé cet addon. Les deux joueurs doivent également avoir installé LibDataShare."
)
L(AH .. "SHOW_ECHO", "Afficher un minuteur dans l'Antre aux échos")
L(AH .. "SHOW_SELECTION", "Afficher vos choix de bienfaits en discussion")
L(AH .. "SLASH_MISSING", "manquant")
L(AH .. "STACKS", "Nombre de bienfaits cumulés")
L(AH .. "TOMESHELL", "Tome-carapace")
L(AH .. "TOMESHELL_COUNT", "<<1[0 restants/1 restant/$d restants]>>")
L(AH .. "USE_AUTO_AVOID", "Marquer automatiquement les Indésirables")
L(
    AH .. "USE_AUTO_AVOID_TOOLTIP",
    "Marquer automatiquement les versets ou les visions qui ne vous sont d'aucune utilité en raison de compétences non équipées."
)
L(AH .. "WARNING", "Avertissement : les listes déroulantes ne seront actualisées qu'après un rechargement de l'IU")
L(AH .. "WEREWOLF_BEHEMOTH", "Béhémoth loup-garou")

-- keybinds
L("SI_BINDING_NAME_" .. AH .. "MARK_CURRENT_TARGET", "Marquer la cible actuelle")
L("SI_BINDING_NAME_" .. AH .. "TOGGLE_CROSSING_HELPER", "Toggle Crossing Helper")
L("SI_BINDING_NAME_" .. AH .. "UNMARK_CURRENT_TARGET", "Retirer la marque sur la cible actuelle")
