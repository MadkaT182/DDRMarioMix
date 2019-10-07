local t = Def.ActorFrame {};

for player in ivalues(GAMESTATE:GetHumanPlayers()) do
	--Vars
	local Score = string.format("% 7d",STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetScore());
	local Combo = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):MaxCombo();
	local Marvelous = string.format("% 5d",STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W1"));
	local Perfect = string.format("% 5d",STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W2"));
	local Great = string.format("% 5d",STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W3"));
	local Good = string.format("% 5d",STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W4"));
	local Ok = string.format("% 5d",STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetHoldNoteScores("HoldNoteScore_Held"));
	local Miss = string.format("% 5d",STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_Miss")+STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W5"));
	local NG = string.format("% 5d",STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetHoldNoteScores("HoldNoteScore_LetGo"));

	local pChar = GAMESTATE:GetCharacter(player):GetCharacterID();

	local NewRec = false;
	local offset = 0;

	--New record definition
	if (STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetPersonalHighScoreIndex() == 0) or (STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetMachineHighScoreIndex() == 0) then
		NewRec = true;
	end

	if pChar ~= "default" then
		t[#t+1] = Def.ActorFrame{
			InitCommand=function(self)
				self:x(player == PLAYER_1 and SCREEN_CENTER_X-207 or SCREEN_CENTER_X+207);
				self:y(SCREEN_CENTER_Y+58);
				self:bob();
				self:effectmagnitude(0,3,0);
				self:effectperiod(3);
			end;
			LoadActor("platform");
			Def.Model {
				Materials="/Characters/"..pChar.."/model.txt";
				Meshes="/Characters/"..pChar.."/model.txt";
				Bones="/Characters/_DDRPC_common_Rest.bones.txt";
				InitCommand=cmd(zoom,9;x,-5;y,-10;rotationy,180;cullmode,'CullMode_None');
			};
		};
	end

	t[#t+1] = Def.ActorFrame{
		InitCommand=function(self)
			self:x(player == PLAYER_1 and SCREEN_CENTER_X-58 or SCREEN_CENTER_X+59);
			self:y(SCREEN_CENTER_Y);
		end;
		LoadFont("Result Stats")..{
			InitCommand=function(self)
				self:y(-48);
				self:horizalign(player == PLAYER_1 and right or left);
				self:settext(Marvelous);
			end;
		};
		LoadFont("Result Stats")..{
			InitCommand=function(self)
				self:y(-18);
				self:horizalign(player == PLAYER_1 and right or left);
				self:settext(Perfect);
			end;
		};
		LoadFont("Result Stats")..{
			InitCommand=function(self)
				self:y(12);
				self:horizalign(player == PLAYER_1 and right or left);
				self:settext(Great);
			end;
		};
		LoadFont("Result Stats")..{
			InitCommand=function(self)
				self:y(42);
				self:horizalign(player == PLAYER_1 and right or left);
				self:settext(Good);
			end;
		};
		LoadFont("Result Stats")..{
			InitCommand=function(self)
				self:y(72);
				self:horizalign(player == PLAYER_1 and right or left);
				self:settext(Miss);
			end;
		};
	};

	t[#t+1] = Def.ActorFrame{
		InitCommand=function(self)
			self:x(player == PLAYER_1 and SCREEN_CENTER_X-58 or SCREEN_CENTER_X+59);
			self:y(SCREEN_CENTER_Y);
		end;
		LoadActor(THEME:GetPathG("high","score"))..{
			InitCommand=function(self)
			self:x(player == PLAYER_1 and -146 or 199);
				self:y(85);
				self:diffuseshift();
				self:effectcolor1(1,1,1,1);
				self:effectcolor2(.77,.9,.35,1);
			end;
			Condition=NewRec
		};
		LoadFont("Result Score")..{
			InitCommand=function(self)
				self:y(109);
				self:horizalign(player == PLAYER_1 and right or left);
				self:settext(Score);
			end;
		};
		LoadFont("Max Combo")..{
			InitCommand=function(self)
				self:y(141);
				self:horizalign(player == PLAYER_1 and right or left);
				self:settext(Combo);
			end;
		};
	};

end

return t;