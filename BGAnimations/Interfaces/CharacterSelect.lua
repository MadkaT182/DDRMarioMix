-- PlayerSelect Implementation
--------------------------------

-- Begin Items
local Items = CHARMAN:GetAllCharacters()

-- This is used to track our position
local cursorindex = {
    [PLAYER_1] = 1,
    [PLAYER_2] = 1
}
local function OffsetVerify(player, offset)
    local changed = true
    cursorindex[player] = cursorindex[player] + offset
    if cursorindex[player] > #Items then cursorindex[player] = #Items changed=false end
    if cursorindex[player] < 1 then cursorindex[player] = 1 changed=false end
    if changed then
        MESSAGEMAN:Broadcast("CursorChanged",{Player=player})
        SOUND:PlayOnce( THEME:GetPathS("Common","value") )
    end
end

-- Begin input tracker
local function Input(event)
    local IN = {
        ["MenuLeft"] = function(pn) OffsetVerify( pn, -1 ) end,
        ["MenuRight"] = function(pn) OffsetVerify( pn, 1 ) end,
        ["Start"] = function(pn)
            SOUND:PlayOnce( THEME:GetPathS("Common","start") )
            MESSAGEMAN:Broadcast("SelectedEntry")
            -- if OptionSelect[cursorindex[2]][cursorindex[1]] then
                -- SCREENMAN:GetTopScreen():SetNextScreenName( OptionSelect[cursorindex[2]][cursorindex[1]] ):StartTransitioningScreen("SM_GoToNextScreen")
            -- end
            for _,pn in pairs( GAMESTATE:GetEnabledPlayers() ) do
                GAMESTATE:SetCharacter(pn, Items[cursorindex[pn]]:GetCharacterID() )
            end
            SCREENMAN:GetTopScreen():SetNextScreenName( "ScreenSelectMusic" ):StartTransitioningScreen("SM_GoToNextScreen")
        end,
        ["Back"] = function()
            GAMESTATE:Env()["BackToMainMenu"] = true
            GAMESTATE:Env()["GLOBALINTERFACEENV"] = "MainMenu"
            MESSAGEMAN:Broadcast("SelectedEntry")
            SCREENMAN:GetTopScreen():SetPrevScreenName( "GlobalMenu" ):StartTransitioningScreen("SM_GoToPrevScreen")
        end
    }
    if not event.PlayerNumber then return end
    -- Input that occurs at the moment the button is pressed.
    if ToEnumShortString(event.type) == "FirstPress" then
        if IN[event.GameButton] then IN[event.GameButton](event.PlayerNumber) end
    end
end

local t = Def.ActorFrame{}
local RI = Def.ActorFrame{
    OnCommand=function(s)
        for _,pn in pairs( GAMESTATE:GetEnabledPlayers() ) do
            OffsetVerify( pn, 0 )
        end
        SCREENMAN:GetTopScreen():AddInputCallback(Input)
    end,
}

for _,pn in pairs( GAMESTATE:GetEnabledPlayers() ) do
    for s,v in ipairs(Items) do
        local offset = s
        RI[#RI+1] = Def.ActorFrame{
            InitCommand=function(s)
                s:xy( pn == PLAYER_1 and 200 or SCREEN_RIGHT-200, SCREEN_CENTER_Y+90 ):bob():effectmagnitude(0,2,0)
                :x( pn == PLAYER_1 and -200 or SCREEN_RIGHT+200 ):decelerate(0.4):x( pn == PLAYER_1 and 200 or SCREEN_RIGHT-200 )
            end,
            CursorChangedMessageCommand=function(s,param)
                if param.Player and param.Player == pn then
                    s:stoptweening():accelerate(0.4):x( pn == PLAYER_1 and -200 or SCREEN_RIGHT+200 )
                    :queuecommand("UpdateVisibility")
                    :decelerate(0.4):x( pn == PLAYER_1 and 200 or SCREEN_RIGHT-200 )
                end
            end,
            UpdateVisibilityCommand=function(s)
                s:visible( offset == cursorindex[pn] )
            end,
            SelectedEntryMessageCommand=function(s) s:stoptweening():accelerate(0.6):diffusealpha(0) end,

            Def.Sprite{ Texture="ScreenEvaluation decorations/platform" },
            Def.Model {
                Materials=v:GetCharacterDir().."/model.txt";
                Meshes=v:GetCharacterDir().."/model.txt";
                Bones="/Characters/_DDRPC_common_Rest.bones.txt";
                InitCommand=function(s)
                    s:zoom(10):xy(-5,-10):rotationy(180):cullmode('CullMode_None')
                end,
                UpdateVisibilityCommand=function(s)
                    s:zoom( offset == cursorindex[pn] and 10 or 0 )
                end,
            };
            Def.BitmapText{
                Font="Common Normal",
                Text=v:GetDisplayName(),
                OnCommand=function(s) s:zoom(0.6):y(10):wrapwidthpixels(500) end,
            },
        }

        RI[#RI+1] = Def.Sprite{
            Texture=THEME:GetPathG("CharacterIcon","Fallback"),
            InitCommand=function(s)
                s:x( pn == PLAYER_1 and SCREEN_CENTER_X+100 ):y(SCREEN_CENTER_Y)
                s:texcoordvelocity(0,0.6):customtexturerect(0,5,0.76,1):zoomy(-5)
                :x( pn == PLAYER_1 and SCREEN_RIGHT+200 or -200 ):decelerate(0.4):x( pn == PLAYER_1 and SCREEN_CENTER_X+100 or SCREEN_CENTER_X-100 )
            end,
            CursorChangedMessageCommand=function(s,param)
                if param.Player and param.Player == pn then
                    s:stoptweening():accelerate(0.4):x( pn == PLAYER_1 and SCREEN_RIGHT+200 or -200 )
                    :queuecommand("UpdateVisibility")
                    :decelerate(0.4):x( pn == PLAYER_1 and SCREEN_CENTER_X+100 or SCREEN_CENTER_X-100 )
                end
            end,
            SelectedEntryMessageCommand=function(s) s:stoptweening():accelerate(0.6):diffusealpha(0) end,
            UpdateVisibilityCommand=function(s)
                s:visible( offset == cursorindex[pn] )
            end,
        }
    end
end

t[#t+1] = loadfile( THEME:GetPathG("","Global/SkyBG.lua") )()..{
    OffCommand=function(s)
        if not GAMESTATE:Env()["BackToMainMenu"] then
            s:linear(0.6):diffusealpha(0)
        end
    end,
}
t[#t+1] = RI;

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("Global/Header","Under"),
    OnCommand=function(s) s:xy( 0,55 ):halign(0):zoomx(0.9):addy( -SCREEN_RIGHT/2 ):decelerate(0.6):addy( SCREEN_RIGHT/2 ) end,
    SelectedEntryMessageCommand=function(s) s:accelerate(0.6):diffusealpha(0) end
}

t[#t+1] = Def.BitmapText{
    Font="_title",
    Text=THEME:GetString("CharacterSelect","HeaderText"),
    OnCommand=function(s) s:xy( 20,50 ):halign(0):zoomx(0.9):addy( -SCREEN_RIGHT/2 ):decelerate(0.6):addy( SCREEN_RIGHT/2 ) end,
    SelectedEntryMessageCommand=function(s) s:accelerate(0.6):diffusealpha(0) end
}

t[#t+1] = Def.ActorFrame{
    OnCommand=function(s) s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+180):addy( SCREEN_RIGHT/2 ):decelerate(0.6):addy( -SCREEN_RIGHT/2 ) end,
    SelectedEntryMessageCommand=function(s) s:stoptweening():accelerate(0.6):diffusealpha(0) end,
    Def.Quad{
        OnCommand=function(s) s:zoomto(SCREEN_WIDTH,100):y(30):diffuse( color("#44444499") ) end
    },

    Def.Sprite{
        Texture=THEME:GetPathG("Global/Button","Side"),
        OnCommand=function(s) s:zoom(0.9) end,
    },
};

return t;