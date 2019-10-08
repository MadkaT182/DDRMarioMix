local toplay = GAMESTATE:Env()["GLOBALINTERFACEENV"] == "WorkoutMenu" and "TitleMenus" or "ScreenTitleMenu"
return THEME:GetPathS(toplay,"music")