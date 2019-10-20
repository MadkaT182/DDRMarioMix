-- Global Menu
-- Items loaded from here come from the Interfaces folder.
--------------------------------
-- Verify we have a valid enviroment.
if not GAMESTATE:Env()["GLOBALINTERFACEENV"] then GAMESTATE:Env()["GLOBALINTERFACEENV"] = "MainMenu" end

-- Now that we have a interface set on the enviroment, we load it.
return loadfile( THEME:GetPathB("","Interfaces/"..GAMESTATE:Env()["GLOBALINTERFACEENV"]) )();
--------------------------------