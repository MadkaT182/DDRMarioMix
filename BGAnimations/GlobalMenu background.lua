local t = Def.ActorFrame{}

local function VerifyBGEntity()
    local FileLoad = {"Pink","Pink"}
    if GAMESTATE:Env()["GLOBALINTERFACEENV"] == "WorkoutMenu" then
        FileLoad = {"Purple","Purple"}
    end
    return FileLoad
end

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("","Global/Backgrounds/"..VerifyBGEntity()[1]),
    --InitCommand=cmd(rotationy,0;rotationz,0;rotationx,-90/4*3.5;zoomto,SCREEN_WIDTH*2,SCREEN_HEIGHT*2;customtexturerect,0,0,SCREEN_WIDTH*4/256,SCREEN_HEIGHT*4/256);
    InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;customtexturerect,0,0,2,2);
    UpdateBackgroundMessageCommand=function(s)
        s:Load( THEME:GetPathG("","Global/Backgrounds/"..VerifyBGEntity()[1]) )
    end,
};

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("","Global/Foregrounds/"..VerifyBGEntity()[2]),
    InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;customtexturerect,0,0,2,2);
    OnCommand=cmd(texcoordvelocity,-0.1,0);
    UpdateBackgroundMessageCommand=function(s)
        s:Load( THEME:GetPathG("","Global/Foregrounds/"..VerifyBGEntity()[2]) )
    end,
};

return t;