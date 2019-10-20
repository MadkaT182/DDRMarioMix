local t = Def.ActorFrame {};

t[#t+1] = LoadActor("bg")..{
	InitCommand=function(s)
		s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):zoomto(SCREEN_WIDTH,SCREEN_HEIGHT)
		:customtexturerect(0,0,2,2)
	end
};

t[#t+1] = LoadActor("tile")..{
	InitCommand=function(s)
		s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):zoomto(SCREEN_WIDTH,SCREEN_HEIGHT)
		:customtexturerect(0,0,2,2)
	end,
	OnCommand=function(s) s:texcoordvelocity(-0.1,0) end
};

t[#t+1] = LoadActor("filter")..{
	InitCommand=function(s) s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-16) end,
};

return t;