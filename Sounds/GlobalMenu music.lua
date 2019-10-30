local toplay = {
    ["WorkoutMenu"] = "TitleMenus",
    ["Options"] = "TitleMenus",
}
return toplay[GAMESTATE:Env()["GLOBALINTERFACEENV"]] and THEME:GetPathS(toplay[GAMESTATE:Env()["GLOBALINTERFACEENV"]],"music") or THEME:GetPathS("ScreenTitleMenu","music")