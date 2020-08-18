return Def.ActorFrame {
	-- LoadActor("../ScreenSelectMusic background");
	-- LoadActor("ship")..{
	-- 	OnCommand=cmd(x,SCREEN_RIGHT-200;y,SCREEN_TOP;cullmode,'CullMode_None';zoom,.25;rotationy,45;rotationz,2;rotationx,35;linear,2.569;x,SCREEN_LEFT+250;y,SCREEN_CENTER_Y;rotationy,35);
	-- };
	loadfile( THEME:GetPathG("","Global/SkyBG.lua") )();
	Def.ActorFrame{
		FOV=50,
		OnCommand=function(self)
			self:xy( 0, -200 ):z(-90):rotationx( 90 )
			:linear(4):rotationx( -80 ):z(180):xy( SCREEN_RIGHT-120 ,SCREEN_CENTER_Y/2 )
		end,
		LoadActor("ship")..{
			OnCommand=function(self)
				self:cullmode('CullMode_None'):zoom(.25):y(300):rotationy(35):linear(4):rotationy(-35)
			end
		};
		-- LoadActor("ship")..{
		-- 	OnCommand=cmd(x,SCREEN_LEFT-SCREEN_WIDTH;y,SCREEN_CENTER_Y;cullmode,'CullMode_None';zoom,.25);
		-- };
	};
	LoadActor("logo")..{
		OnCommand=function(self)
			self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-56):zoomx(1.11):diffusealpha(0):sleep(4.704):linear(.9):diffusealpha(1)
		end
	};
	LoadActor("copy")..{
		OnCommand=function(self)
			self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+151):diffusealpha(0):sleep(4.704):linear(.9):diffusealpha(1)
		end
	};
};