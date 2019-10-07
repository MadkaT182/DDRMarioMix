local t = Def.ActorFrame {};

t[#t+1] = LoadActor("bg")..{
	InitCommand=cmd(Center;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;customtexturerect,0,0,2,2);
};

t[#t+1] = LoadActor("tile")..{
	InitCommand=cmd(Center;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;customtexturerect,0,0,2,2);
	OnCommand=cmd(texcoordvelocity,-0.1,0);
};

t[#t+1] = LoadActor("filter")..{
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-16);
};

return t;