-- PlayerSelect Implementation
--------------------------------

-- Begin Items
local Items = { "single","versus" }

-- This is used to track our position
local cursorindex = 1
local function OffsetVerify(offset)
    local changed = true
    cursorindex = cursorindex + offset
    if cursorindex > #Items then cursorindex = #Items changed=false end
    if cursorindex < 1 then cursorindex = 1 changed=false end
    MESSAGEMAN:Broadcast("CursorChanged")
    if changed then SOUND:PlayOnce( THEME:GetPathS("Common","value") ) end
end

-- Begin input tracker
local function Input(event)
    local IN = {
        ["MenuLeft"] = function() OffsetVerify( -1 ) end,
        ["MenuRight"] = function() OffsetVerify( 1 ) end,
        ["Start"] = function(pn)
            SOUND:PlayOnce( THEME:GetPathS("Common","start") )
            MESSAGEMAN:Broadcast("SelectedEntry")
            -- if OptionSelect[cursorindex[2]][cursorindex[1]] then
                -- SCREENMAN:GetTopScreen():SetNextScreenName( OptionSelect[cursorindex[2]][cursorindex[1]] ):StartTransitioningScreen("SM_GoToNextScreen")
            -- end
            GAMESTATE:SetCurrentStyle( Items[cursorindex] )
            if Items[cursorindex] == "single" then GAMESTATE:JoinPlayer(pn) end
            if Items[cursorindex] == "versus" then GAMESTATE:JoinPlayer(PLAYER_1) GAMESTATE:JoinPlayer(PLAYER_2) end
            SCREENMAN:GetTopScreen():SetNextScreenName( "CharacterSelect" ):StartTransitioningScreen("SM_GoToNextScreen")
        end,
        ["Back"] = function()
            GAMESTATE:Env()["BackToMainMenu"] = true
            MESSAGEMAN:Broadcast("SelectedEntry")
            SCREENMAN:GetTopScreen():SetPrevScreenName( "MainMenu" ):StartTransitioningScreen("SM_GoToPrevScreen")
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
        MESSAGEMAN:Broadcast("CursorChanged")
        SCREENMAN:GetTopScreen():AddInputCallback(Input)
    end,
    SelectedEntryMessageCommand=function(s) s:stoptweening():accelerate(0.6):addx( SCREEN_RIGHT/2 ) end,
}

for s,v in ipairs(Items) do
    local offset = s
    RI[#RI+1] = Def.ActorFrame{
        OnCommand=function(s)
            s:xy( SCREEN_RIGHT-350+(130*offset) ,SCREEN_CENTER_Y-120 )
            :addx( SCREEN_RIGHT/2 ):decelerate(0.6):addx( -SCREEN_RIGHT/2 )
        end,
        Def.Sprite{
            Texture=THEME:GetPathG("PlayerSelect/Icon",v),
            OnCommand=function(s) end,
            CursorChangedMessageCommand=function(s)
                s:diffuse( color("#777777") )
                if cursorindex == offset then
                    s:diffuse(Color.White)
                end
            end,
        }
    }
end

t[#t+1] = loadfile( THEME:GetPathG("","Global/SkyBG.lua") )()
t[#t+1] = RI;

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("Global/Header","Under"),
    OnCommand=function(s) s:xy( 0,55 ):halign(0):zoomx(0.9):addy( -SCREEN_RIGHT/2 ):decelerate(0.6):addy( SCREEN_RIGHT/2 ) end,
    SelectedEntryMessageCommand=function(s) s:stoptweening():accelerate(0.6):addy( -SCREEN_RIGHT/2 ) end
}

t[#t+1] = Def.BitmapText{
    Font="_title",
    Text=THEME:GetString("PlayerSelect","HeaderText"),
    OnCommand=function(s) s:xy( 20,50 ):halign(0):zoomx(0.9):addy( -SCREEN_RIGHT/2 ):decelerate(0.6):addy( SCREEN_RIGHT/2 ) end,
    SelectedEntryMessageCommand=function(s) s:stoptweening():accelerate(0.6):addy( -SCREEN_RIGHT/2 ) end
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

t[#t+1] = Def.ActorFrame{
    OnCommand=function(s) s:xy(SCREEN_RIGHT-156,SCREEN_CENTER_Y+40):addx( SCREEN_RIGHT/2 ):decelerate(0.6):addx( -SCREEN_RIGHT/2 ) end,
    SelectedEntryMessageCommand=function(s) s:stoptweening():accelerate(0.6):addx( SCREEN_RIGHT/2 ) end,
    Def.Sprite{
        OnCommand=function(s) s:y(0) end,
        CursorChangedMessageCommand=function(s)
            s:Load( THEME:GetPathG("PlayerSelect/Desc",Items[cursorindex]) )
        end,
    },
}

return t;