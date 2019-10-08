local t = Def.ActorFrame{}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("","Global/2BG"),
    OnCommand=function(s)
        s:zoom(2):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
    end,
};

return t;