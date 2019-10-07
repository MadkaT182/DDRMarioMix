return Def.ActorFrame {
	LoadActor("../ScreenSelectMusic background");
	-- LoadActor("ship")..{
	-- 	OnCommand=cmd(x,SCREEN_RIGHT-200;y,SCREEN_TOP;cullmode,'CullMode_None';zoom,.25;rotationy,45;rotationz,2;rotationx,35;linear,2.569;x,SCREEN_LEFT+250;y,SCREEN_CENTER_Y;rotationy,35);
	-- };
	Def.ActorFrame{
		OnCommand=cmd(x,SCREEN_RIGHT-200;y,100;rotationy,90;rotationz,0;linear,2.636;rotationy,-63;rotationz,30;rotationx,15;x,SCREEN_LEFT+100;sleep,0;linear,2.636;rotationy,-63;rotationz,30;rotationx,15;x,SCREEN_RIGHT;y,SCREEN_BOTTOM-100);
		LoadActor("ship")..{
			OnCommand=cmd(cullmode,'CullMode_None';zoom,.25);
		};
		-- LoadActor("ship")..{
		-- 	OnCommand=cmd(x,SCREEN_LEFT-SCREEN_WIDTH;y,SCREEN_CENTER_Y;cullmode,'CullMode_None';zoom,.25);
		-- };
	};
	LoadActor("logo")..{
		OnCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-56;zoomx,1.11;diffusealpha,0;sleep,4.704;linear,.9;diffusealpha,1);
	};
	LoadActor("copy")..{
		OnCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+151;diffusealpha,0;sleep,4.704;linear,.9;diffusealpha,1);
	};
};