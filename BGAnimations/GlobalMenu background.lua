local t = Def.ActorFrame{}

local function VerifyBGEntity()
    local FileLoad = {"Pink","Pink"}
    local RequiredLabels = {
        ["WorkoutMenu"] = {"Purple","Purple"},
        ["Options"] = {"Orange","Yellow"}
    }
    if RequiredLabels[GAMESTATE:Env()["GLOBALINTERFACEENV"]] then
        FileLoad = RequiredLabels[GAMESTATE:Env()["GLOBALINTERFACEENV"]]
    end
    return FileLoad
end

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("","Global/Backgrounds/"..VerifyBGEntity()[1]),
    InitCommand=function(s)
        s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):zoomto(SCREEN_WIDTH,SCREEN_HEIGHT):customtexturerect(0,0,2,2)
    end,
    UpdateBackgroundMessageCommand=function(s)
        s:Load( THEME:GetPathG("","Global/Backgrounds/"..VerifyBGEntity()[1]) )
    end
};

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("","Global/Foregrounds/"..VerifyBGEntity()[2]),
    InitCommand=function(s)
        s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):zoomto(SCREEN_WIDTH,SCREEN_HEIGHT):customtexturerect(0,0,2,2)
    end,
    OnCommand=function(s) s:texcoordvelocity(-0.1,0) end,
    UpdateBackgroundMessageCommand=function(s)
        s:Load( THEME:GetPathG("","Global/Foregrounds/"..VerifyBGEntity()[2]) )
    end
};

return t;