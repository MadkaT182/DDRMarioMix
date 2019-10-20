local t = Def.ActorFrame{}

t[#t+1] = Def.Sprite{
	Texture=THEME:GetPathG("","Gameplay/wego" ),
	InitCommand=function(s) s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y) end,
	OnCommand=function(s) s:sleep(3):diffusealpha(0) end
};

return t;