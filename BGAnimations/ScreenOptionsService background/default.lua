local t = Def.ActorFrame {};

t[#t+1] = LoadActor("bg")..{
	--InitCommand=cmd(rotationy,0;rotationz,0;rotationx,-90/4*3.5;zoomto,SCREEN_WIDTH*2,SCREEN_HEIGHT*2;customtexturerect,0,0,SCREEN_WIDTH*4/256,SCREEN_HEIGHT*4/256);
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;customtexturerect,0,0,2,2);
};

t[#t+1] = LoadActor("tile")..{
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;customtexturerect,0,0,2,2);
	OnCommand=cmd(texcoordvelocity,-0.1,0);
};

return t;