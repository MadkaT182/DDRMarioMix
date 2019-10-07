local t = Def.ActorFrame{
	OnCommand=cmd(y,SCREEN_BOTTOM-56);
};

--TODO: Revamp this
if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
	t[#t+1] = Def.ActorFrame{
		LoadActor("normal")..{
			InitCommand=cmd(x,SCREEN_CENTER_X-222);
		};
		Def.RollingNumbers{
			InitCommand=cmd(x,SCREEN_CENTER_X-108);
			File = THEME:GetPathF("Gameplay","p1_score");
			ScoreChangedMessageCommand=function(self, params)
				self:Load("RollingNumbersScoring");
				self:targetnumber(STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetScore());
			end;
		};
	};
end
if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
	t[#t+1] = Def.ActorFrame{
		LoadActor("normal")..{
			InitCommand=cmd(x,SCREEN_CENTER_X+222;zoomx,-1);
		};
		Def.RollingNumbers{
			InitCommand=cmd(x,SCREEN_CENTER_X+107);
			File = THEME:GetPathF("Gameplay","p2_score");
			ScoreChangedMessageCommand=function(self, params)
				self:Load("RollingNumbersScoring");
				self:targetnumber(STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):GetScore());
			end;
		};
	};
end

return t