return Def.ActorFrame {
	LoadActor("../_header")..{};
	LoadFont("_title")..{
		InitCommand=function(self)
			if GAMESTATE:GetCoinMode() == 'CoinMode_Home' then
				self:settext("Free Mode");
			else
				self:settext("Select Music");
			end
			self:horizalign(left);
			self:x(23);
			self:y(43);
		end;
	};
	LoadActor("selector")..{
		InitCommand=cmd(x,SCREEN_CENTER_X+140;y,SCREEN_CENTER_Y;);
	};
	LoadActor("../_footer")..{
		--InitCommand=cmd(x,SCREEN_CENTER_X+140;y,SCREEN_CENTER_Y;);
	};
}