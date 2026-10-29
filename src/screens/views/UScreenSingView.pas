{* UltraStar Deluxe - Karaoke Game
 *
 * UltraStar Deluxe is the legal property of its developers, whose names
 * are too numerous to list here. Please refer to the COPYRIGHT
 * file distributed with this source distribution.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; see the file COPYING. If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 *
 * $URL: svn://basisbit@svn.code.sf.net/p/ultrastardx/svn/trunk/src/screens/UScreenSing.pas $
 * $Id: UScreenSing.pas 3150 2015-10-20 00:07:57Z basisbit $
 *}

unit UScreenSingView;

interface

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{$I switches.inc}

uses
  SysUtils,
  sdl2,
  UText,
  UCommon,
  UGraphicClasses,
  UHookableEvent,
  UIni,
  ULog,
  ULyrics,
  UAvatars,
  UMenu,
  UMusic,
  URenderer,
  USingScores,
  USongs,
  UThemes,
  UTime,
  USkins;

type
  TScreenSingView = class
  public

    //StaticDuet: array of cardinal;

    // lyrics bar fields
    StaticLyricsBar: integer;
    StaticLyricsBarDuet: integer;

    // timebar fields
    StaticTimeBar: integer;
    StaticTimeProgress: integer;
    TextTimeLabelText: integer;
    TextTimeText: integer;

    StaticP1: array [0..1] of integer;
    TextP1:   integer;
    StaticP1Avatar: array [0..1] of integer;

    // shown when game is in 2/4 player modus
    StaticP1TwoP: array [0..1] of integer;
    TextP1TwoP:   integer;
    StaticP1TwoPAvatar: array [0..1] of integer;

    // shown when game is in 3/6 player modus
    StaticP1ThreeP: array [0..1] of integer;
    TextP1ThreeP:   integer;
    StaticP1ThreePAvatar: array [0..1] of integer;

    StaticP2R: array [0..1] of integer;
    TextP2R:   integer;
    StaticP2RAvatar: array [0..1] of integer;

    StaticP2M: array [0..1] of integer;
    TextP2M:   integer;
    StaticP2MAvatar: array [0..1] of integer;

    StaticP3R: array [0..1] of integer;
    TextP3R:   integer;
    StaticP3RAvatar: array [0..1] of integer;

    // 4/6 players in one screen
    StaticP1FourP:  integer;
    StaticP2FourP:  integer;
    StaticP3FourP:  integer;
    StaticP4FourP:  integer;

    StaticP1FourPAvatar:  integer;
    StaticP2FourPAvatar:  integer;
    StaticP3FourPAvatar:  integer;
    StaticP4FourPAvatar:  integer;

    TextP1FourP:   integer;
    TextP2FourP:   integer;
    TextP3FourP:   integer;
    TextP4FourP:   integer;

    StaticP1SixP:  integer;
    StaticP2SixP:  integer;
    StaticP3SixP:  integer;
    StaticP4SixP:  integer;
    StaticP5SixP:  integer;
    StaticP6SixP:  integer;

    StaticP1SixPAvatar:  integer;
    StaticP2SixPAvatar:  integer;
    StaticP3SixPAvatar:  integer;
    StaticP4SixPAvatar:  integer;
    StaticP5SixPAvatar:  integer;
    StaticP6SixPAvatar:  integer;

    TextP1SixP:   integer;
    TextP2SixP:   integer;
    TextP3SixP:   integer;
    TextP4SixP:   integer;
    TextP5SixP:   integer;
    TextP6SixP:   integer;

    // 3/6 players duet
    StaticDuetP1ThreeP: array [0..1] of integer;
    TextDuetP1ThreeP:   integer;
    StaticDuetP1ThreePAvatar: array [0..1] of integer;

    StaticDuetP2M: array [0..1] of integer;
    TextDuetP2M:   integer;
    StaticDuetP2MAvatar: array [0..1] of integer;

    StaticDuetP3R: array [0..1] of integer;
    TextDuetP3R:   integer;
    StaticDuetP3RAvatar: array [0..1] of integer;

    // 4/6 players duet one screen
    StaticP1DuetFourP:  integer;
    StaticP2DuetFourP:  integer;
    StaticP3DuetFourP:  integer;
    StaticP4DuetFourP:  integer;

    StaticP1DuetFourPAvatar:  integer;
    StaticP2DuetFourPAvatar:  integer;
    StaticP3DuetFourPAvatar:  integer;
    StaticP4DuetFourPAvatar:  integer;

    TextP1DuetFourP:   integer;
    TextP2DuetFourP:   integer;
    TextP3DuetFourP:   integer;
    TextP4DuetFourP:   integer;

    StaticP1DuetSixP:  integer;
    StaticP2DuetSixP:  integer;
    StaticP3DuetSixP:  integer;
    StaticP4DuetSixP:  integer;
    StaticP5DuetSixP:  integer;
    StaticP6DuetSixP:  integer;

    StaticP1DuetSixPAvatar:  integer;
    StaticP2DuetSixPAvatar:  integer;
    StaticP3DuetSixPAvatar:  integer;
    StaticP4DuetSixPAvatar:  integer;
    StaticP5DuetSixPAvatar:  integer;
    StaticP6DuetSixPAvatar:  integer;

    TextP1DuetSixP:   integer;
    TextP2DuetSixP:   integer;
    TextP3DuetSixP:   integer;
    TextP4DuetSixP:   integer;
    TextP5DuetSixP:   integer;
    TextP6DuetSixP:   integer;


    StaticPausePopup: integer;

    SongNameStatic:   integer;
    SongNameText:     integer;

    ReadyAvatars: array [0..IMaxPlayerCount-1] of TTexture; // copies of the player avatars for the ready check and the part cues

    // part cues (Ini.PartCues) in songs with parts
    CueAlpha:     array [0..MAX_SONG_TRACKS-1] of real; // "your turn" glow of each part
    DimAlpha:     array [0..MAX_SONG_TRACKS-1] of real; // alpha of the lyrics of each part
    CueLastTicks: cardinal;



    constructor Create;
    destructor Destroy; override;

    procedure DrawMedleyCountdown();
    procedure DrawCountIn();
    procedure DrawCountdown(timeDiff: real);
    function Draw: boolean;

    procedure SwapToScreen(Screen: integer);

    procedure WriteMessage(msg: UTF8String);
    procedure FadeMessage();
    procedure CloseMessage();

    procedure MedleyTitleFadeOut();

    function GetLyricColor(Color: integer): TRGB;

    procedure DrawInfoLyricBar();

    procedure SetDuetLyricsLayout;
    procedure SetDuetLyricsColors;

    function GetPlayerRow(PlayerIndex: integer; out X, Y, W, H: real): boolean;
    procedure CopyPlayerAvatars;
    procedure DrawReadyCheck;

    procedure ResetPartCues;
    procedure GetTrackPause(Track: integer; out ToNext, Pause: real);
    procedure DrawPartCues;
  end;
var
  lastVolume: single;

const
  CUE_LEAD       = 2.5; // s before the next line of a part its "your turn" cue shows
  CUE_MIN_PAUSE  = 4;   // s a part must pause to get a "your turn" cue
  CUE_DIM_LEAD   = 3;   // s, parts that sing again later than this are dimmed
  CUE_DIM_ALPHA  = 0.3; // alpha of the lyrics of dimmed parts

  LYRIC_HELPER_SPACE = 60; // space left of side by side lyrics for the lyric helper bar
  LYRIC_MARK_WIDTH   = 8;  // width of the color mark of a player next to the lyrics of their track
  LYRIC_MARK_SPACE   = 4;  // space between the lyrics and the marks and between two marks

implementation

uses
  Classes,
  Math,
  UDatabase,
  UDllManager,
  UDraw,
  UGraphic,
  ULanguage,
  UNote,
  URecord,
  USong,
  UDisplay,
  UParty,
  UPathUtils,
  UUnicodeUtils,
  UScreenSingController,
  UWebcam,
  UWebSDK;

const
  MAX_MESSAGE = 3;

//ToDo basisbit: check this again
// Dirty HacK
procedure TScreenSingView.SwapToScreen(Screen: integer);
  procedure setVisible(elements: array of integer; visible: boolean);
  var
    J: integer;
  begin
    for J := 0 to High(elements) do
      ScreenSing.Statics[elements[J]].Visible := visible;
  end;
  procedure hide(elements: array of integer);
  begin
    setVisible(elements, false);
  end;
  procedure maybeShow(elements: array of integer);
  begin
    setVisible(elements, ScreenSing.Settings.AvatarsVisible);
  end;
begin
  { if screens = 2 and playerplay <= 3 the 2nd screen shows the
    textures of screen 1 }
  if (PlayersPlay <= 3) and (Screen = 2) then
    Screen := 1;

  hide([
    // 1P - screen 1
    StaticP1[0], StaticP1Avatar[0],
    // 2P - screen 1
    StaticP1TwoP[0], StaticP1TwoPAvatar[0],
    StaticP2R[0], StaticP2RAvatar[0],
    // 3P - screen 1
    StaticP1ThreeP[0], StaticP1ThreePAvatar[0],
    StaticP2M[0], StaticP2MAvatar[0],
    StaticP3R[0], StaticP3RAvatar[0],
    // 1P - screen 2 (2 players across 2 screens)
    StaticP1[1], StaticP1Avatar[1],
    // 2P - screen 2 (4 players across 2 screens)
    StaticP1TwoP[1], StaticP1TwoPAvatar[1],
    StaticP2R[1], StaticP2RAvatar[1],
    // 3P - screen 2 (6 players across 2 screens)
    StaticP1ThreeP[1], StaticP1ThreePAvatar[1],
    StaticP2M[1], StaticP2MAvatar[1],
    StaticP3R[1], StaticP3RAvatar[1],
    // 3P duet - screen 1
    StaticDuetP1ThreeP[0], StaticDuetP1ThreePAvatar[0],
    StaticDuetP2M[0], StaticDuetP2MAvatar[0],
    StaticDuetP3R[0], StaticDuetP3RAvatar[0],
    // 3P duet - screen 2 (6 players across 2 screens)
    StaticDuetP1ThreeP[1], StaticDuetP1ThreePAvatar[1],
    StaticDuetP2M[1], StaticDuetP2MAvatar[1],
    StaticDuetP3R[1], StaticDuetP3RAvatar[1],
    // 4P - screen 1
    StaticP1FourP, StaticP1FourPAvatar,
    StaticP2FourP, StaticP2FourPAvatar,
    StaticP3FourP, StaticP3FourPAvatar,
    StaticP4FourP, StaticP4FourPAvatar,
    // 4P duet - screen 1
    StaticP1DuetFourP, StaticP1DuetFourPAvatar,
    StaticP2DuetFourP, StaticP2DuetFourPAvatar,
    StaticP3DuetFourP, StaticP3DuetFourPAvatar,
    StaticP4DuetFourP, StaticP4DuetFourPAvatar,
    // 6P - screen 1
    StaticP1SixP, StaticP1SixPAvatar,
    StaticP2SixP, StaticP2SixPAvatar,
    StaticP3SixP, StaticP3SixPAvatar,
    StaticP4SixP, StaticP4SixPAvatar,
    StaticP5SixP, StaticP5SixPAvatar,
    StaticP6SixP, StaticP6SixPAvatar,
    // 6P duet - screen 1
    StaticP1DuetSixP, StaticP1DuetSixPAvatar,
    StaticP2DuetSixP, StaticP2DuetSixPAvatar,
    StaticP3DuetSixP, StaticP3DuetSixPAvatar,
    StaticP4DuetSixP, StaticP4DuetSixPAvatar,
    StaticP5DuetSixP, StaticP5DuetSixPAvatar,
    StaticP6DuetSixP, StaticP6DuetSixPAvatar
  ]);

  if (PlayersPlay = 1) then
  begin
    // this is actually correct! it just puts the sole player on all screens
    maybeShow([StaticP1[0], StaticP1Avatar[0]]);
  end;

  if (PlayersPlay = 2) or ((PlayersPlay = 4) and (Screens = 2)) then
  begin
    if (Screen = 2) then
    begin
      maybeShow([
        StaticP1TwoP[1], StaticP1TwoPAvatar[1],
        StaticP2R[1], StaticP2RAvatar[1]
      ]);
    end;

    if (Screen = 1) then
    begin
      maybeShow([
        StaticP1TwoP[0], StaticP1TwoPAvatar[0],
        StaticP2R[0], StaticP2RAvatar[0]
      ]);
    end;
  end;

  if (PlayersPlay = 3) or ((PlayersPlay = 6) and (Screens = 2)) then
  begin
    if (CurrentSong.isDuet) then
    begin
      if (Screen = 2) then
      begin
        maybeShow([
          StaticDuetP1ThreeP[1], StaticDuetP1ThreePAvatar[1],
          StaticDuetP2M[1], StaticDuetP2MAvatar[1],
          StaticDuetP3R[1], StaticDuetP3RAvatar[1]
        ]);
      end;

      if (Screen = 1) then
      begin
        maybeShow([
          StaticDuetP1ThreeP[0], StaticDuetP1ThreePAvatar[0],
          StaticDuetP2M[0], StaticDuetP2MAvatar[0],
          StaticDuetP3R[0], StaticDuetP3RAvatar[0]
        ]);
      end;
    end
    else
    begin
      if (Screen = 2) then
      begin
        maybeShow([
          StaticP1ThreeP[1], StaticP1ThreePAvatar[1],
          StaticP2M[1], StaticP2MAvatar[1],
          StaticP3R[1], StaticP3RAvatar[1]
        ]);
      end;

      if (Screen = 1) then
      begin
        maybeShow([
          StaticP1ThreeP[0], StaticP1ThreePAvatar[0],
          StaticP2M[0], StaticP2MAvatar[0],
          StaticP3R[0], StaticP3RAvatar[0]
        ]);
      end;
    end;
  end;

  // 4 Players in 1 Screen
  if (PlayersPlay = 4) and (Screens = 1) then
  begin
    if (CurrentSong.isDuet) then
    begin
      maybeShow([
        StaticP1DuetFourP, StaticP1DuetFourPAvatar,
        StaticP2DuetFourP, StaticP2DuetFourPAvatar,
        StaticP3DuetFourP, StaticP3DuetFourPAvatar,
        StaticP4DuetFourP, StaticP4DuetFourPAvatar
      ]);
    end
    else
    begin
      maybeShow([
        StaticP1FourP, StaticP1FourPAvatar,
        StaticP2FourP, StaticP2FourPAvatar,
        StaticP3FourP, StaticP3FourPAvatar,
        StaticP4FourP, StaticP4FourPAvatar
      ]);
    end;
  end;

  // 6 Players in 1 Screen
  if (PlayersPlay = 6) and (Screens = 1) then
  begin
    if (CurrentSong.isDuet) then
    begin
      maybeShow([
        StaticP1DuetSixP, StaticP1DuetSixPAvatar,
        StaticP2DuetSixP, StaticP2DuetSixPAvatar,
        StaticP3DuetSixP, StaticP3DuetSixPAvatar,
        StaticP4DuetSixP, StaticP4DuetSixPAvatar,
        StaticP5DuetSixP, StaticP5DuetSixPAvatar,
        StaticP6DuetSixP, StaticP6DuetSixPAvatar
      ]);
    end
    else
    begin
      maybeShow([
        StaticP1SixP, StaticP1SixPAvatar,
        StaticP2SixP, StaticP2SixPAvatar,
        StaticP3SixP, StaticP3SixPAvatar,
        StaticP4SixP, StaticP4SixPAvatar,
        StaticP5SixP, StaticP5SixPAvatar,
        StaticP6SixP, StaticP6SixPAvatar
      ]);
    end;
  end;

end;

constructor TScreenSingView.Create;
var
  Col: array [1..UIni.IMaxPlayerCount] of TRGB;
  I: integer;
  procedure setColor(var avatarFrame: TThemeStatic; color: TRGB);
  begin
    avatarFrame.ColR := color.R;
    avatarFrame.ColG := color.G;
    avatarFrame.ColB := color.B;
  end;
  // passing the integer for the static by reference is deliberate
  procedure setColorAndAssignAvatarFrameStatic(var avatarFrame: TThemeStatic; var static: integer; color: TRGB);
  begin
    setColor(avatarFrame, color);
    static := ScreenSing.AddStatic(avatarFrame);
  end;
  // passing the integers for the statics by reference is deliberate
  procedure setColorAndAssignStatics(var singPlayer: TThemeSingPlayer; var avatarFrameStatic: integer; var nameStatic: integer; color: TRGB);
  begin
    setColorAndAssignAvatarFrameStatic(singPlayer.AvatarFrame, avatarFrameStatic, color);
    nameStatic := ScreenSing.AddText(singPlayer.Name);
  end;
  // passing the integer for the static by reference is deliberate
  procedure assignAvatarStatic(var singPlayer: TThemeSingPlayer; var avatarStatic: integer; var texture: TTexture);
  begin
    avatarStatic := ScreenSing.AddStaticAlphaRectangle(singPlayer.Avatar);
    if (texture <> nil) then
      ScreenSing.Statics[avatarStatic].Texture := texture.clone();
    ScreenSing.Statics[avatarStatic].Texture.X := singPlayer.Avatar.X;
    ScreenSing.Statics[avatarStatic].Texture.Y := singPlayer.Avatar.Y;
    ScreenSing.Statics[avatarStatic].Texture.H := singPlayer.Avatar.H;
    ScreenSing.Statics[avatarStatic].Texture.W := singPlayer.Avatar.W;
    ScreenSing.Statics[avatarStatic].Texture.Z := singPlayer.Avatar.Z;
    ScreenSing.Statics[avatarStatic].Texture.Alpha := singPlayer.Avatar.Alpha;
  end;
begin
  lastVolume:= -1;
  //too dangerous, a mouse button is quickly pressed by accident
  ScreenSing.RightMbESC := false;

  ScreenSing.fShowVisualization := false;
  ScreenSing.fShowWebcam := false;
  ScreenSing.fShowBackground := false;

  ScreenSing.fCurrentVideo := nil;

  // create score class
  ScreenSing.Scores := TSingScores.Create;
  ScreenSing.Scores.LoadfromTheme;

  ScreenSing.LoadFromTheme(Theme.Sing);

  // lyrics bar
  StaticLyricsBar := ScreenSing.AddStatic(Theme.Sing.StaticLyricsBar);
  StaticLyricsBarDuet := ScreenSing.AddStatic(Theme.Sing.StaticLyricsBarDuet);

  {SetLength(StaticDuet, Length(Theme.Sing.StaticDuet));
  for i := 0 to High(StaticDuet) do
    StaticDuet[i] := ScreenSing.AddStatic(Theme.Sing.StaticDuet[i]);}

  // timebar
  StaticTimeBar := ScreenSing.AddStatic(Theme.Sing.StaticTimeBar);
  StaticTimeProgress := ScreenSing.AddStaticColorRectangle(Theme.Sing.StaticTimeProgress);
  TextTimeLabelText := ScreenSing.AddText(Theme.Sing.TextTimeLabelText);
  TextTimeText := ScreenSing.AddText(Theme.Sing.TextTimeText);

  for I := 1 to UIni.IMaxPlayerCount do
    Col[I] := GetPlayerColor(Ini.SingColor[I - 1]);

  // SCREEN 1
  // 1 player
  setColorAndAssignAvatarFrameStatic(Theme.Sing.Solo1PP1.AvatarFrame, StaticP1[0], Col[1]);

  // 2 or 4 players
  setColorAndAssignAvatarFrameStatic(Theme.Sing.Solo2PP1.AvatarFrame, StaticP1TwoP[0], Col[1]);
  setColorAndAssignAvatarFrameStatic(Theme.Sing.Solo2PP2.AvatarFrame, StaticP2R[0]   , Col[2]);

  // 3 or 6 players
  setColorAndAssignAvatarFrameStatic(Theme.Sing.Solo3PP1.AvatarFrame, StaticP1ThreeP[0], Col[1]);
  setColorAndAssignAvatarFrameStatic(Theme.Sing.Solo3PP2.AvatarFrame, StaticP2M[0]     , Col[2]);
  setColorAndAssignAvatarFrameStatic(Theme.Sing.Solo3PP3.AvatarFrame, StaticP3R[0]     , Col[3]);

  // 3 or 6 players duet
  setColorAndAssignAvatarFrameStatic(Theme.Sing.Duet3PP1.AvatarFrame, StaticDuetP1ThreeP[0], Col[1]);
  setColorAndAssignAvatarFrameStatic(Theme.Sing.Duet3PP2.AvatarFrame, StaticDuetP2M[0]     , Col[2]);
  setColorAndAssignAvatarFrameStatic(Theme.Sing.Duet3PP3.AvatarFrame, StaticDuetP3R[0]     , Col[3]);

  // SCREEN 2
  // 1 player
  setColorAndAssignStatics(Theme.Sing.Solo1PP1, StaticP1[1], TextP1, Col[1]);

  // 2 or 4 players
  setColorAndAssignStatics(Theme.Sing.Solo2PP1, StaticP1TwoP[1], TextP1TwoP, Col[3]);
  setColorAndAssignStatics(Theme.Sing.Solo2PP2, StaticP2R[1]   , TextP2R   , Col[4]);

  // 3 or 6 players
  setColorAndAssignStatics(Theme.Sing.Solo3PP1, StaticP1ThreeP[1], TextP1ThreeP, Col[4]);
  setColorAndAssignStatics(Theme.Sing.Solo3PP2, StaticP2M[1]     , TextP2M     , Col[5]);
  setColorAndAssignStatics(Theme.Sing.Solo3PP3, StaticP3R[1]     , TextP3R     , Col[6]);

  // 3 or 6 players duet
  setColorAndAssignStatics(Theme.Sing.Duet3PP1, StaticDuetP1ThreeP[1], TextDuetP1ThreeP, Col[4]);
  setColorAndAssignStatics(Theme.Sing.Duet3PP2, StaticDuetP2M[1]     , TextDuetP2M     , Col[5]);
  setColorAndAssignStatics(Theme.Sing.Duet3PP3, StaticDuetP3R[1]     , TextDuetP3R     , Col[6]);

  for I := 1 to PlayersPlay do
  begin
    if (Party.bPartyGame) then
    begin
      ScreenSing.PlayerNames[I] := Ini.NameTeam[I-1];
    end
    else
    begin
      ScreenSing.PlayerNames[I] := Player[I-1].Name;
    end;
    ScreenSing.PlayerDuetNames[I] := ScreenSing.PlayerNames[I];
  end;

  // 4 players in 1 screen
  setColorAndAssignStatics(Theme.Sing.Solo4PP1, StaticP1FourP, TextP1FourP, Col[1]);
  setColorAndAssignStatics(Theme.Sing.Solo4PP2, StaticP2FourP, TextP2FourP, Col[2]);
  setColorAndAssignStatics(Theme.Sing.Solo4PP3, StaticP3FourP, TextP3FourP, Col[3]);
  setColorAndAssignStatics(Theme.Sing.Solo4PP4, StaticP4FourP, TextP4FourP, Col[4]);

  // 6 players in 1 screen
  setColorAndAssignStatics(Theme.Sing.Solo6PP1, StaticP1SixP, TextP1SixP, Col[1]);
  setColorAndAssignStatics(Theme.Sing.Solo6PP2, StaticP2SixP, TextP2SixP, Col[2]);
  setColorAndAssignStatics(Theme.Sing.Solo6PP3, StaticP3SixP, TextP3SixP, Col[3]);
  setColorAndAssignStatics(Theme.Sing.Solo6PP4, StaticP4SixP, TextP4SixP, Col[4]);
  setColorAndAssignStatics(Theme.Sing.Solo6PP5, StaticP5SixP, TextP5SixP, Col[5]);
  setColorAndAssignStatics(Theme.Sing.Solo6PP6, StaticP6SixP, TextP6SixP, Col[6]);


  // 4 players duet in 1 screen
  setColorAndAssignStatics(Theme.Sing.Duet4PP1, StaticP1DuetFourP, TextP1DuetFourP, Col[1]);
  setColorAndAssignStatics(Theme.Sing.Duet4PP2, StaticP2DuetFourP, TextP2DuetFourP, Col[2]);
  setColorAndAssignStatics(Theme.Sing.Duet4PP3, StaticP3DuetFourP, TextP3DuetFourP, Col[3]);
  setColorAndAssignStatics(Theme.Sing.Duet4PP4, StaticP4DuetFourP, TextP4DuetFourP, Col[4]);

  // 6 players duet in 1 screen
  setColorAndAssignStatics(Theme.Sing.Duet6PP1, StaticP1DuetSixP, TextP1DuetSixP, Col[1]);
  setColorAndAssignStatics(Theme.Sing.Duet6PP2, StaticP2DuetSixP, TextP2DuetSixP, Col[2]);
  setColorAndAssignStatics(Theme.Sing.Duet6PP3, StaticP3DuetSixP, TextP3DuetSixP, Col[3]);
  setColorAndAssignStatics(Theme.Sing.Duet6PP4, StaticP4DuetSixP, TextP4DuetSixP, Col[4]);
  setColorAndAssignStatics(Theme.Sing.Duet6PP5, StaticP5DuetSixP, TextP5DuetSixP, Col[5]);
  setColorAndAssignStatics(Theme.Sing.Duet6PP6, StaticP6DuetSixP, TextP6DuetSixP, Col[6]);

  LoadSingScreenTextures(true);

  StaticPausePopup := ScreenSing.AddStatic(Theme.Sing.PausePopUp);

  // <note> pausepopup is not visible at the beginning </note>
  ScreenSing.Statics[StaticPausePopup].Visible := false;

  ScreenSing.Lyrics := TLyricEngine.Create(
      Theme.LyricBar.UpperX, Theme.LyricBar.UpperY, Theme.LyricBar.UpperW, Theme.LyricBar.UpperH,
      Theme.LyricBar.LowerX, Theme.LyricBar.LowerY, Theme.LyricBar.LowerW, Theme.LyricBar.LowerH);

  // one lyric engine per duet track, the positions are set by SetDuetLyricsLayout
  for I := 0 to High(ScreenSing.LyricsDuet) do
    ScreenSing.LyricsDuet[I] := TLyricEngine.Create(0, 0, 0, 0, 0, 0, 0, 0);

  ScreenSing.fLyricsSync := TLyricsSyncSource.Create();
  ScreenSing.fMusicSync := TMusicSyncSource.Create();

  SongNameStatic := ScreenSing.AddStatic(Theme.Sing.StaticSongName);;
  SongNameText := ScreenSing.AddText(Theme.Sing.TextSongName);

  ScreenSing.eSongLoaded := THookableEvent.Create('ScreenSing.SongLoaded');

  // Info Message
  ScreenSing.InfoMessageBG := ScreenSing.AddStatic(Theme.Sing.InfoMessageBG);
  ScreenSing.InfoMessageText := ScreenSing.AddText(Theme.Sing.InfoMessageText);

  // avatars
  // SCREEN 1
  // 1P
  assignAvatarStatic(Theme.Sing.Solo1PP1, StaticP1Avatar[0], AvatarPlayerTextures[1]);
  // 2P
  assignAvatarStatic(Theme.Sing.Solo2PP1, StaticP1TwoPAvatar[0], AvatarPlayerTextures[1]);
  assignAvatarStatic(Theme.Sing.Solo2PP2, StaticP2RAvatar[0]   , AvatarPlayerTextures[2]);
  // 3P
  assignAvatarStatic(Theme.Sing.Solo3PP1, StaticP1ThreePAvatar[0], AvatarPlayerTextures[1]);
  assignAvatarStatic(Theme.Sing.Solo3PP2, StaticP2MAvatar[0]     , AvatarPlayerTextures[2]);
  assignAvatarStatic(Theme.Sing.Solo3PP3, StaticP3RAvatar[0]     , AvatarPlayerTextures[3]);
  // 3P duet
  assignAvatarStatic(Theme.Sing.Duet3PP1, StaticDuetP1ThreePAvatar[0], AvatarPlayerTextures[1]);
  assignAvatarStatic(Theme.Sing.Duet3PP2, StaticDuetP2MAvatar[0]     , AvatarPlayerTextures[2]);
  assignAvatarStatic(Theme.Sing.Duet3PP3, StaticDuetP3RAvatar[0]     , AvatarPlayerTextures[3]);
  // 4P
  assignAvatarStatic(Theme.Sing.Solo4PP1, StaticP1FourPAvatar, AvatarPlayerTextures[1]);
  assignAvatarStatic(Theme.Sing.Solo4PP2, StaticP2FourPAvatar, AvatarPlayerTextures[2]);
  assignAvatarStatic(Theme.Sing.Solo4PP3, StaticP3FourPAvatar, AvatarPlayerTextures[3]);
  assignAvatarStatic(Theme.Sing.Solo4PP4, StaticP4FourPAvatar, AvatarPlayerTextures[4]);
  // 4P duet
  assignAvatarStatic(Theme.Sing.Duet4PP1, StaticP1DuetFourPAvatar, AvatarPlayerTextures[1]);
  assignAvatarStatic(Theme.Sing.Duet4PP2, StaticP2DuetFourPAvatar, AvatarPlayerTextures[2]);
  assignAvatarStatic(Theme.Sing.Duet4PP3, StaticP3DuetFourPAvatar, AvatarPlayerTextures[3]);
  assignAvatarStatic(Theme.Sing.Duet4PP4, StaticP4DuetFourPAvatar, AvatarPlayerTextures[4]);
  // 6P
  assignAvatarStatic(Theme.Sing.Solo6PP1, StaticP1SixPAvatar, AvatarPlayerTextures[1]);
  assignAvatarStatic(Theme.Sing.Solo6PP2, StaticP2SixPAvatar, AvatarPlayerTextures[2]);
  assignAvatarStatic(Theme.Sing.Solo6PP3, StaticP3SixPAvatar, AvatarPlayerTextures[3]);
  assignAvatarStatic(Theme.Sing.Solo6PP4, StaticP4SixPAvatar, AvatarPlayerTextures[4]);
  assignAvatarStatic(Theme.Sing.Solo6PP5, StaticP5SixPAvatar, AvatarPlayerTextures[5]);
  assignAvatarStatic(Theme.Sing.Solo6PP6, StaticP6SixPAvatar, AvatarPlayerTextures[6]);
  // 6P duet
  assignAvatarStatic(Theme.Sing.Duet6PP1, StaticP1DuetSixPAvatar, AvatarPlayerTextures[1]);
  assignAvatarStatic(Theme.Sing.Duet6PP2, StaticP2DuetSixPAvatar, AvatarPlayerTextures[2]);
  assignAvatarStatic(Theme.Sing.Duet6PP3, StaticP3DuetSixPAvatar, AvatarPlayerTextures[3]);
  assignAvatarStatic(Theme.Sing.Duet6PP4, StaticP4DuetSixPAvatar, AvatarPlayerTextures[4]);
  assignAvatarStatic(Theme.Sing.Duet6PP5, StaticP5DuetSixPAvatar, AvatarPlayerTextures[5]);
  assignAvatarStatic(Theme.Sing.Duet6PP6, StaticP6DuetSixPAvatar, AvatarPlayerTextures[6]);

  // SCREEN 2
  // 1P
  assignAvatarStatic(Theme.Sing.Solo1PP1, StaticP1Avatar[1], AvatarPlayerTextures[2]);
  // 2P
  assignAvatarStatic(Theme.Sing.Solo2PP1, StaticP1TwoPAvatar[1], AvatarPlayerTextures[3]);
  assignAvatarStatic(Theme.Sing.Solo2PP2, StaticP2RAvatar[1]   , AvatarPlayerTextures[4]);
  // 3P
  assignAvatarStatic(Theme.Sing.Solo3PP1, StaticP1ThreePAvatar[1], AvatarPlayerTextures[4]);
  assignAvatarStatic(Theme.Sing.Solo3PP2, StaticP2MAvatar[1]     , AvatarPlayerTextures[5]);
  assignAvatarStatic(Theme.Sing.Solo3PP3, StaticP3RAvatar[1]     , AvatarPlayerTextures[6]);
  // 3P duet
  assignAvatarStatic(Theme.Sing.Duet3PP1, StaticDuetP1ThreePAvatar[1], AvatarPlayerTextures[4]);
  assignAvatarStatic(Theme.Sing.Duet3PP2, StaticDuetP2MAvatar[1]     , AvatarPlayerTextures[5]);
  assignAvatarStatic(Theme.Sing.Duet3PP3, StaticDuetP3RAvatar[1]     , AvatarPlayerTextures[6]);
end;

destructor TScreenSingView.Destroy;
var
  PlayerIndex: integer;
begin
  for PlayerIndex := 0 to High(ReadyAvatars) do
    FreeAndNil(ReadyAvatars[PlayerIndex]);
  UnloadSingScreenTextures;
  inherited;
end;

function TScreenSingView.Draw: boolean;
var
  DisplayTime:            real;
  DisplayPrefix:          string;
  DisplayMin:             integer;
  DisplaySec:             integer;
  T:                      integer;
  CurLyricsTime:          real;
  VideoFrameTime:         Extended;
  Line:                   TLyricLine;
  TrackIndex:             integer;
  medley_end:             boolean;
  medley_start_applause:  boolean;
  LastLineSungToEnd:      boolean;
begin
  ScreenSing.Background.Draw;

  // sound enabled/disabled (Party plugins)
  if not(ScreenSing.Settings.SoundEnabled) and not(lastVolume=0) then
  begin
    AudioPlayback.SetVolume(0);
    lastVolume:=0;
  end
  else if not(lastVolume=1) and not(lastVolume=0) then
  begin //changing volume is slow, so do not reset volume every frame
    AudioPlayback.SetVolume(1);
    lastVolume:=1;
  end;

  // swap static textures to current screen ones
  SwapToScreen(ScreenAct);

  // draw background picture (if any, and if no visualizations)
  // when we don't check for visualizations the visualizations would
  // be overdrawn by the picture when {UNDEFINED UseTexture} in UVisualizer
  //if (not fShowVisualization) then
  if (not ScreenSing.fShowVisualization) or (ScreenSing.fShowBackground) then
    SingDrawBackground;

  if (ScreenSing.fShowWebCam) then
    SingDrawWebCamFrame;

  // set player names (for 2 screens and only singstar skin)
  if ScreenAct = 1 then
  begin
    ScreenSing.Text[TextP1].Text           := ScreenSing.PlayerNames[1];
    ScreenSing.Text[TextP1TwoP].Text       := ScreenSing.PlayerNames[1];
    ScreenSing.Text[TextP1ThreeP].Text     := ScreenSing.PlayerNames[1];
    ScreenSing.Text[TextP2R].Text          := ScreenSing.PlayerNames[2];
    ScreenSing.Text[TextP2M].Text          := ScreenSing.PlayerNames[2];
    ScreenSing.Text[TextP3R].Text          := ScreenSing.PlayerNames[3];
    ScreenSing.Text[TextDuetP1ThreeP].Text := ScreenSing.PlayerDuetNames[1];
    ScreenSing.Text[TextDuetP2M].Text      := ScreenSing.PlayerDuetNames[2];
    ScreenSing.Text[TextDuetP3R].Text      := ScreenSing.PlayerDuetNames[3];
    ScreenSing.Text[TextP1FourP].Text      := ScreenSing.PlayerNames[1];
    ScreenSing.Text[TextP2FourP].Text      := ScreenSing.PlayerNames[2];
    ScreenSing.Text[TextP3FourP].Text      := ScreenSing.PlayerNames[3];
    ScreenSing.Text[TextP4FourP].Text      := ScreenSing.PlayerNames[4];
    ScreenSing.Text[TextP1DuetFourP].Text  := ScreenSing.PlayerDuetNames[1];
    ScreenSing.Text[TextP2DuetFourP].Text  := ScreenSing.PlayerDuetNames[2];
    ScreenSing.Text[TextP3DuetFourP].Text  := ScreenSing.PlayerDuetNames[3];
    ScreenSing.Text[TextP4DuetFourP].Text  := ScreenSing.PlayerDuetNames[4];
    ScreenSing.Text[TextP1SixP].Text       := ScreenSing.PlayerNames[1];
    ScreenSing.Text[TextP2SixP].Text       := ScreenSing.PlayerNames[2];
    ScreenSing.Text[TextP3SixP].Text       := ScreenSing.PlayerNames[3];
    ScreenSing.Text[TextP4SixP].Text       := ScreenSing.PlayerNames[4];
    ScreenSing.Text[TextP5SixP].Text       := ScreenSing.PlayerNames[5];
    ScreenSing.Text[TextP6SixP].Text       := ScreenSing.PlayerNames[6];
    ScreenSing.Text[TextP1DuetSixP].Text   := ScreenSing.PlayerDuetNames[1];
    ScreenSing.Text[TextP2DuetSixP].Text   := ScreenSing.PlayerDuetNames[2];
    ScreenSing.Text[TextP3DuetSixP].Text   := ScreenSing.PlayerDuetNames[3];
    ScreenSing.Text[TextP4DuetSixP].Text   := ScreenSing.PlayerDuetNames[4];
    ScreenSing.Text[TextP5DuetSixP].Text   := ScreenSing.PlayerDuetNames[5];
    ScreenSing.Text[TextP6DuetSixP].Text   := ScreenSing.PlayerDuetNames[6];

  end;

  if ScreenAct = 2 then
  begin
    case PlayersPlay of
      4:
      begin
        ScreenSing.Text[TextP1TwoP].Text := ScreenSing.PlayerNames[3];
        ScreenSing.Text[TextP2R].Text    := ScreenSing.PlayerNames[4];


      end;
      6:
      begin
        if (CurrentSong.isDuet) then
        begin
          ScreenSing.Text[TextDuetP1ThreeP].Text := ScreenSing.PlayerDuetNames[4];
          ScreenSing.Text[TextDuetP2M].Text      := ScreenSing.PlayerDuetNames[5];
          ScreenSing.Text[TextDuetP3R].Text      := ScreenSing.PlayerDuetNames[6];
        end
        else
        begin
          ScreenSing.Text[TextP1ThreeP].Text := ScreenSing.PlayerNames[4];
          ScreenSing.Text[TextP2M].Text      := ScreenSing.PlayerNames[5];
          ScreenSing.Text[TextP3R].Text      := ScreenSing.PlayerNames[6];
        end;
      end;
    end; // case
  end; // if

  if (CurrentSong.isDuet) and (PlayersPlay <> 1) then
    SetDuetLyricsColors;

  // retrieve current lyrics time, we have to store the value to avoid
  // that min- and sec-values do not match
  if ScreenSong.Mode = smMedley then
  begin
    CurLyricsTime := LyricsState.GetCurrentTime() - ScreenSing.MedleyStart;
    TotalTime := ScreenSing.MedleyEnd - ScreenSing.MedleyStart;
  end
  else
  begin
    CurLyricsTime := LyricsState.GetCurrentTime();
    TotalTime :=  LyricsState.TotalTime;
  end;

  // retrieve time for timebar text
  case (ScreenSing.fTimebarMode) of
    tbmRemaining: begin
      DisplayTime := TotalTime - Max(CurLyricsTime, CurrentSong.Start);
      DisplayPrefix := '-';
    end;
    tbmTotal: begin
      DisplayTime := TotalTime;
      DisplayPrefix := '#';
    end;
    else begin       // current time
      DisplayTime := Max(CurLyricsTime, CurrentSong.Start);
      DisplayPrefix := '';
    end;
  end;
  DisplayMin := Round(DisplayTime) div 60;
  DisplaySec := Round(DisplayTime) mod 60;

  // update static menu with time ...
  ScreenSing.Text[TextTimeLabelText].Visible := ScreenSing.Settings.TimeBarVisible;
  ScreenSing.Text[TextTimeText].Text := Format('%s%.2d:%.2d', [DisplayPrefix, DisplayMin, DisplaySec]);
  ScreenSing.Text[TextTimeText].Visible := ScreenSing.Settings.TimeBarVisible;

  LastLineSungToEnd := false;
  //the song was sung to the end?
  if not ScreenSing.SungToEnd and ((not CurrentSong.isDuet) or (PlayersPlay = 1)) and
      not ScreenSong.RapToFreestyle then
  begin
    Line := ScreenSing.Lyrics.GetUpperLine();
    if Line.LastLine then
    begin
      LastLineSungToEnd := true;
      for T := 0 to High(Line.Words) do
      begin
        if (CurLyricsTime < GetTimeFromBeat(Line.Words[T].Start + Line.Words[T].Length)) and
           (not Line.Words[T].Freestyle) then
          LastLineSungToEnd := false;
      end;
    end;
    if LastLineSungToEnd then
      ScreenSing.SungToEnd := true;
  end;

  if not ScreenSing.SungToEnd and CurrentSong.isDuet and (PlayersPlay <> 1) and
      not ScreenSong.RapToFreestyle then
  begin
    // the last lines of all sung tracks must be finished
    LastLineSungToEnd := true;
    for TrackIndex := 0 to High(CurrentSong.Tracks) do
    begin
      Line := ScreenSing.LyricsDuet[TrackIndex].GetUpperLine();
      if (ScreenSing.TrackSinger(TrackIndex) >= 0) and
         (not Line.LastLine or (Length(Line.Words) = 0) or
          (CurLyricsTime < GetTimeFromBeat(Line.Words[High(Line.Words)].Start +
            Line.Words[High(Line.Words)].Length))) then
        LastLineSungToEnd := false;
    end;
    if LastLineSungToEnd then
      ScreenSing.SungToEnd := true;
  end;

  // for medley-mode:
  CurLyricsTime := LyricsState.GetCurrentTime();
  if (ScreenSong.Mode = smMedley) and (CurLyricsTime > ScreenSing.MedleyEnd) then
    medley_end := true
  else
    medley_end := false;

  if (ScreenSong.Mode = smMedley) and (CurLyricsTime >
    GetTimeFromBeat(CurrentSong.Medley.EndBeat)) then
    medley_start_applause := true
  else
    medley_start_applause := false;

  // update and draw movie
  // USE FFMPEG
  if Assigned(ScreenSing.fCurrentVideo) and (not ScreenSing.fShowWebcam) then
  begin
    // Just call this once
    // when Screens = 2
    if (ScreenAct = 1) then
    begin
      if (ScreenSing.ShowFinish) then
      begin
        // everything is setup, determine the current position
        VideoFrameTime := CurrentSong.VideoGAP + Max(LyricsState.GetCurrentTime(), CurrentSong.Start);
      end
      else
      begin
        // Important: do not yet start the triggered timer by a call to
        // LyricsState.GetCurrentTime()
        VideoFrameTime := CurrentSong.VideoGAP;
      end;
      try
        ScreenSing.fCurrentVideo.GetFrame(VideoFrameTime);
      except
      end;
    end;

    ScreenSing.fCurrentVideo.SetScreen(ScreenAct);
    ScreenSing.fCurrentVideo.Draw;
  end;

  // draw static menu (FG)
  ScreenSing.DrawFG;

  //Medley Countdown
  if ScreenSong.Mode = smMedley then
    DrawMedleyCountdown;
  if ScreenSing.CountIn and not ScreenSing.ReadyCheck then
    DrawCountIn;

  // check for music finish
  //Log.LogError('Check for music finish: ' + BoolToStr(Music.Finished) + ' ' + FloatToStr(LyricsState.CurrentTime*1000) + ' ' + IntToStr(CurrentSong.Finish));
  if ScreenSing.ShowFinish and not ScreenSing.ReadyCheck then
  begin
    if (not ScreenSing.FinishedMusic) and (not medley_end or (ScreenSong.Mode <> smMedley)) and
       ((CurrentSong.Finish = 0) or
        (LyricsState.GetCurrentTime() * 1000 <= CurrentSong.Finish)) and
       (not ScreenSing.Settings.Finish) then
    begin
      // analyze song if not paused
      if (not ScreenSing.Paused) then
      begin
        Sing(ScreenSing);

        //Update Medley Stats
        if (ScreenSong.Mode = smMedley) and not ScreenSing.FadeOut then
          ScreenSing.UpdateMedleyStats(medley_start_applause);

        Party.CallOnSing;
      end;
    end
    else
    begin
      if (not ScreenSing.FadeOut) and (Screens=1) or (ScreenAct=2) then
      begin
        ScreenSing.Finish;
      end;
    end;
  end;

  // draw info lyric bar if not medley
  if (ScreenSing.Settings.TimeBarVisible) then
    DrawInfoLyricBar;

  // always draw custom items
  ScreenSing.Statics[StaticLyricsBar].Visible := ScreenSing.Settings.LyricsVisible;
  ScreenSing.Statics[StaticLyricsBarDuet].Visible := ScreenSing.Settings.LyricsVisible and (CurrentSong.isDuet) and (PlayersPlay <> 1);
  ScreenSing.Statics[StaticTimeBar].Visible := ScreenSing.Settings.TimeBarVisible;
  // part cues are drawn behind the lyrics and set their alpha
  if (CurrentSong.isDuet) and (PlayersPlay <> 1) and ScreenSing.Settings.LyricsVisible then
    DrawPartCues;
  SingDraw;

  // goldennotestarstwinkle
  GoldenRec.SpawnRec;

  // draw scores
  if (ScreenSing.Settings.ScoresVisible) and ((Ini.SingScores = 1) or (Party.bPartyGame)) then
    ScreenSing.Scores.Draw;

  FadeMessage();

  if ScreenSing.ReadyCheck then
    DrawReadyCheck;

  // draw pausepopup
  // FIXME: this is a workaround that the static is drawn over the lyrics, lines, scores and effects
  // maybe someone could find a better solution
  if ScreenSing.Paused then
  begin
    ScreenSing.Statics[StaticPausePopup].Texture.Z := 1;
    ScreenSing.Statics[StaticPausePopup].Visible := true;
    ScreenSing.Statics[StaticPausePopup].Draw;
    ScreenSing.Statics[StaticPausePopup].Visible := false;
    SDL_Delay(33);//wait a bit to save electricity...
  end;

  Result := true;
end;

procedure TScreenSingView.DrawMedleyCountdown();
begin
  if AudioPlayback.Position < GetTimeFromBeat(CurrentSong.Medley.StartBeat) then
  begin
    ScreenSing.TextMedleyFadeOut := false;

    ScreenSing.Statics[SongNameStatic].Texture.Alpha := 1;
    ScreenSing.Text[SongNameText].Alpha := 1;

    ScreenSing.Statics[SongNameStatic].Visible := true;
    ScreenSing.Text[SongNameText].Visible := true;
    DrawCountdown(GetTimeFromBeat(CurrentSong.Medley.StartBeat) - AudioPlayback.Position);
  end else
  begin
    if (ScreenSing.TextMedleyFadeOut = false) then
    begin
      ScreenSing.TextMedleyFadeOut := true;
      ScreenSing.TextMedleyFadeTime := SDL_GetTicks();
    end;

    MedleyTitleFadeOut;
  end;
end;

procedure TScreenSingView.DrawCountIn;
var
  Pos: real;
begin
  Pos := AudioPlayback.Position;
  if (Pos > ScreenSing.FirstNote) then
    ScreenSing.CountIn := false
  else
    DrawCountdown(ScreenSing.FirstNote - Pos);

end;

procedure TScreenSingView.DrawCountdown(timeDiff: real);
var
  t: real;
  w, h: real;
  CountDownText:  UTF8String;
begin
  t := frac(timeDiff);

  h := 300*t*ScreenH/RenderH;
  SetFontFamily(0);
  SetFontStyle(ftBoldHighRes);
  SetFontItalic(false);
  SetFontSize(h);
  SetFontColor(0.15, 0.30, 0.6, t);
  CountDownText := IntToStr(round(timeDiff - t + 1));
  w := TextWidth(PChar(CountDownText));

  SetFontPos (RenderW/2-w/2, RenderH/2-h/2);
  PrintText(PChar(CountDownText));

end;

procedure TScreenSingView.WriteMessage(msg: UTF8String);
begin
  ScreenSing.MessageTime := SDL_GetTicks();

  ScreenSing.Statics[ScreenSing.InfoMessageBG].Texture.Alpha := 1;
  ScreenSing.Text[ScreenSing.InfoMessageText].Alpha := 1;

  ScreenSing.Statics[ScreenSing.InfoMessageBG].Visible := true;
  ScreenSing.Text[ScreenSing.InfoMessageText].Visible := true;
  ScreenSing.Text[ScreenSing.InfoMessageText].Text := msg;
end;

procedure TScreenSingView.FadeMessage();
var
  factor: real;
begin
  if ((SDL_GetTicks - ScreenSing.MessageTime)/1000 > MAX_MESSAGE) then
  begin
    if (ScreenSing.MessageTimeFade = 0) then
      ScreenSing.MessageTimeFade := SDL_GetTicks();

    factor := (SDL_GetTicks - ScreenSing.MessageTimeFade)/1000/2;

    ScreenSing.Statics[ScreenSing.InfoMessageBG].Texture.Alpha := 1 - factor;
    ScreenSing.Text[ScreenSing.InfoMessageText].Alpha := 1 - factor;
  end
  else
    ScreenSing.MessageTimeFade := 0;

  ScreenSing.Statics[ScreenSing.InfoMessageBG].Draw;
  ScreenSing.Text[ScreenSing.InfoMessageText].Draw;
end;

procedure TScreenSingView.CloseMessage();
begin
  ScreenSing.Statics[ScreenSing.InfoMessageBG].Visible := false;
  ScreenSing.Text[ScreenSing.InfoMessageText].Visible := false;
end;

procedure TScreenSingView.MedleyTitleFadeOut();
var
  Alpha: real;
  CTime: cardinal;
begin

  CTime := SDL_GetTicks() - ScreenSing.TextMedleyFadeTime;
  Alpha := CTime/3000;

  if (Alpha >= 1) then
  begin
    ScreenSing.Statics[SongNameStatic].Visible := false;
    ScreenSing.Text[SongNameText].Visible := false;
  end
  else
  begin
    ScreenSing.Text[SongNameText].Alpha := 1 - Alpha;
    ScreenSing.Statics[SongNameStatic].Texture.Alpha := 1 - Alpha;
  end;
end;

function TScreenSingView.GetLyricColor(Color: integer): TRGB;
begin
  case (Color) of
    1://blue
    begin
      Result.R := 5/255;
      Result.G := 153/255;
      Result.B := 204/255;
    end;
    2: //red
    begin
      Result.R := 230/255;
      Result.G := 0;
      Result.B := 0;
    end;
    3: //green
    begin
      Result.R := 0;
      Result.G := 170/255;
      Result.B := 0;
    end;
    4: //yellow
    begin
      Result.R := 255/255;
      Result.G := 225/255;
      Result.B := 0;
    end;
    5: //orange
    begin
      Result.R := 227/255;
      Result.G := 127/255;
      Result.B := 0;
    end;
    6: //pink
    begin
      Result.R := 255/255;
      Result.G := 0/255;
      Result.B := 130/255;
    end;
    7: //purple
    begin
      Result.R := 180/255;
      Result.G := 0;
      Result.B := 220/255;
    end;
    8: //gold
    begin
      Result.R := 255/255;
      Result.G := 190/255;
      Result.B := 35/255;
    end;
    9: //gray
    begin
      Result.R := 80/255;
      Result.G := 80/255;
      Result.B := 80/255;
    end;
    10: //dark blue
    begin
      Result.R := 90/255;
      Result.G := 90/255;
      Result.B := 240/255;
    end;
    11: //sky
    begin
      Result.R := 0;
      Result.G := 110/255;
      Result.B := 210/255;
    end;
    12: //cyan
    begin
      Result.R := 0/255;
      Result.G := 215/255;
      Result.B := 215/255;
    end;
    13: //flame
    begin
      Result.R := 210/255;
      Result.G := 70/255;
      Result.B := 0/255;
    end;
    14: //orchid
    begin
      Result.R := 210/255;
      Result.G := 0;
      Result.B := 210/255;
    end;
    15: //harlequin
    begin
      Result.R := 110/255;
      Result.G := 210/255;
      Result.B := 0;
    end;
    16: //lime
    begin
      Result.R := 160/255;
      Result.G := 210/255;
      Result.B := 0;
    end;
    else//blue
    begin
      Result.R := 5/255;
      Result.G := 153/255;
      Result.B := 204/255;
    end;
  end;
end;

procedure TScreenSingView.DrawInfoLyricBar();
var
  SongStart:       real;
  SongEnd:         real;
  SongDuration:    real;
  gapInBeats:      real;

  pos:             real;
  br:              real;

  LineIndex:       integer;
  numLines:        integer;

  x, y, w, h:      real;
  Col:            TRGB;
  CurrentTrack:    integer;
  QuadList:        TQuadList;
  NumQuads, I:     integer;
begin
  x := Theme.Sing.StaticTimeProgress.x;
  y := Theme.Sing.StaticTimeProgress.y;

  w := Theme.Sing.StaticTimeProgress.w;
  h := Theme.Sing.StaticTimeProgress.h;

  //calculate total singing beats of song
  if ScreenSong.Mode = smMedley then
  begin
    SongStart := ScreenSing.MedleyStart * CurrentSong.BPM / 60;
    SongEnd := ScreenSing.MedleyEnd * CurrentSong.BPM / 60;
  end
  else
  begin
    SongStart := CurrentSong.BPM*CurrentSong.Start/60;
    SongEnd := CurrentSong.BPM*TotalTime/60;
  end;
  SongDuration := SongEnd - SongStart;
  gapInBeats := CurrentSong.BPM*CurrentSong.GAP/1000/60;

  // Calculate number of quads to draw
  NumQuads := 1; // progress indicator
  for CurrentTrack := 0 to High(CurrentSong.Tracks) do
    NumQuads := NumQuads + Length(CurrentSong.Tracks[CurrentTrack].Lines);
  SetLength(QuadList, NumQuads);
  I := 0;

  // draw sentence boxes
  for CurrentTrack := 0 to High(CurrentSong.Tracks) do //for P1 of duet or solo lyrics, P2 of duet,..
  begin
    numLines := Length(CurrentSong.Tracks[CurrentTrack].Lines); //Lyric lines
    //set color to player.color
    if (CurrentTrack = 0) then
      Col := GetLyricColor(Ini.SingColor[0])
    else
      Col := GetLyricColor(Ini.SingColor[CurrentTrack]);

    for LineIndex := 0 to numLines - 1 do
    begin
      if (CurrentSong.Tracks[CurrentTrack].Lines[LineIndex].Notes = nil) then Continue;
      if (ScreenSong.Mode = smMedley) and (CurrentSong.Tracks[CurrentTrack].Lines[LineIndex].Notes[0].StartBeat < CurrentSong.Medley.StartBeat) then Continue;
      pos := (gapInBeats + CurrentSong.Tracks[CurrentTrack].Lines[LineIndex].Notes[0].StartBeat - SongStart) / SongDuration*w;
      br := (CurrentSong.Tracks[CurrentTrack].Lines[LineIndex].Notes[CurrentSong.Tracks[CurrentTrack].Lines[LineIndex].HighNote].StartBeat +
                CurrentSong.Tracks[CurrentTrack].Lines[LineIndex].Notes[CurrentSong.Tracks[CurrentTrack].Lines[LineIndex].HighNote].Duration -
                CurrentSong.Tracks[CurrentTrack].Lines[LineIndex].Notes[0].StartBeat) / SongDuration*w;  //br = last note of sentence position + its duration - first note of sentence position
      QuadList[I].X := x+pos;
      QuadList[I].Y := y;
      QuadList[I].Z := 0;
      QuadList[I].W := br;
      QuadList[I].H := h;
      QuadList[I].Gradient := gdNone;
      QuadList[I].ColR := Col.R;
      QuadList[I].ColG := Col.G;
      QuadList[I].ColB := Col.B;
      QuadList[I].Alpha := 0.6;
      I := I + 1;
    end;
  end;

  // draw progress indicator
  br := Max((gapInBeats + LyricsState.CurrentBeat - SongStart) / SongDuration*w, 0);
  QuadList[I].X := x;
  QuadList[I].Y := y;
  QuadList[I].Z := 0;
  QuadList[I].W := br;
  QuadList[I].H := h;
  QuadList[I].Gradient := gdNone;
  QuadList[I].ColR := Theme.Sing.StaticTimeProgress.ColR;
  QuadList[I].ColG := Theme.Sing.StaticTimeProgress.ColG;
  QuadList[I].ColB := Theme.Sing.StaticTimeProgress.ColB;
  QuadList[I].Alpha := 1;
  Renderer.DrawQuads(QuadList);
end;

{**
 * Places the lyrics of the duet tracks in the two duet lyric bars of the
 * theme. A track goes to the bar on the side of the screen with the note
 * lines of its players, upper or lower half. The other tracks go to the bar
 * with fewer tracks: tracks with players in both halves first, then the
 * tracks nobody sings. A track alone in its bar uses the whole bar, as in
 * duets. Tracks sharing a bar are shown side by side, in the order of the
 * note line columns of their players, each with its current line and its next
 * line below. Space is left for the player color marks of
 * SingDrawLyricsPlayerMarks.
 *}
procedure TScreenSingView.SetDuetLyricsLayout;
var
  TrackIndex:  integer;
  OtherTrack:  integer;
  PlayerIndex: integer;
  Rows:        integer; // rows of note lines on a screen
  Singers:     array [0..MAX_SONG_TRACKS-1] of integer;
  FirstSinger: array [0..MAX_SONG_TRACKS-1] of integer; // tracks nobody sings come after all players
  RowSum:      array [0..MAX_SONG_TRACKS-1] of real;    // < 0: players in the upper half, > 0: lower half
  ColumnSum:   array [0..MAX_SONG_TRACKS-1] of real;
  Bar:         array [0..MAX_SONG_TRACKS-1] of integer; // 0: upper bar, 1: lower bar, -1: not placed yet
  BarTracks:   array [0..1] of integer;                 // tracks in each bar
  BarIndex:    integer; // position of the track in its bar
  ThemeBar:    TThemeLyricBar;
  Engine:      TLyricEngine;
  ColumnW:     real;    // width of the part of a bar used by one track
  ColumnX:     real;
  MarksW:      real;    // space right of the lyrics for the player color marks

  // the lyrics of track A are left of the ones of track B in their bar
  function IsLeftOf(A, B: integer): boolean;
  var
    ColumnA, ColumnB: real;
  begin
    ColumnA := 2;
    ColumnB := 2;
    if (Singers[A] > 0) then
      ColumnA := ColumnSum[A] / Singers[A];
    if (Singers[B] > 0) then
      ColumnB := ColumnSum[B] / Singers[B];
    Result := (ColumnA < ColumnB) or ((ColumnA = ColumnB) and (FirstSinger[A] < FirstSinger[B]));
  end;

  // the next track to place in the bar with fewer tracks
  function NextOpenTrack(): integer;
  var
    TrackIndex: integer;
  begin
    Result := -1;
    for TrackIndex := 0 to High(CurrentSong.Tracks) do
      if (Bar[TrackIndex] = -1) and
         ((Result = -1) or (FirstSinger[TrackIndex] < FirstSinger[Result])) then
        Result := TrackIndex;
  end;

begin
  // the note lines of 4 and 6 players are in 2 columns or on 2 screens
  if (PlayersPlay = 4) or (PlayersPlay = 6) then
    Rows := PlayersPlay div 2
  else
    Rows := PlayersPlay;

  for TrackIndex := 0 to High(CurrentSong.Tracks) do
  begin
    Singers[TrackIndex] := 0;
    FirstSinger[TrackIndex] := PlayersPlay + TrackIndex;
    RowSum[TrackIndex] := 0;
    ColumnSum[TrackIndex] := 0;
    Bar[TrackIndex] := -1;
  end;

  for PlayerIndex := PlayersPlay - 1 downto 0 do
  begin
    TrackIndex := Player[PlayerIndex].Track;
    Inc(Singers[TrackIndex]);
    FirstSinger[TrackIndex] := PlayerIndex;
    RowSum[TrackIndex] := RowSum[TrackIndex] + (PlayerIndex mod Rows) - (Rows - 1) / 2;
    if (Screens = 1) then
      ColumnSum[TrackIndex] := ColumnSum[TrackIndex] + PlayerIndex div Rows;
  end;

  BarTracks[0] := 0;
  BarTracks[1] := 0;
  for TrackIndex := 0 to High(CurrentSong.Tracks) do
  begin
    if (Singers[TrackIndex] > 0) and (RowSum[TrackIndex] < 0) then
      Bar[TrackIndex] := 0
    else if (Singers[TrackIndex] > 0) and (RowSum[TrackIndex] > 0) then
      Bar[TrackIndex] := 1;
    if (Bar[TrackIndex] >= 0) then
      Inc(BarTracks[Bar[TrackIndex]]);
  end;

  TrackIndex := NextOpenTrack();
  while (TrackIndex >= 0) do
  begin
    if (BarTracks[0] <= BarTracks[1]) then
      Bar[TrackIndex] := 0
    else
      Bar[TrackIndex] := 1;
    Inc(BarTracks[Bar[TrackIndex]]);
    TrackIndex := NextOpenTrack();
  end;

  // players sharing a track get color marks next to its lyrics
  MarksW := 0;
  for TrackIndex := 0 to High(CurrentSong.Tracks) do
    if (Singers[TrackIndex] > 1) then
      MarksW := Max(MarksW, Singers[TrackIndex] * (LYRIC_MARK_WIDTH + LYRIC_MARK_SPACE));

  for TrackIndex := 0 to High(CurrentSong.Tracks) do
  begin
    Engine := ScreenSing.LyricsDuet[TrackIndex];
    if (Bar[TrackIndex] = 0) then
      ThemeBar := Theme.LyricBarDuetP1
    else
      ThemeBar := Theme.LyricBarDuetP2;

    BarIndex := 0;
    for OtherTrack := 0 to High(CurrentSong.Tracks) do
      if (Bar[OtherTrack] = Bar[TrackIndex]) and IsLeftOf(OtherTrack, TrackIndex) then
        Inc(BarIndex);

    ScreenSing.LyricsDuetLowerBar[TrackIndex] := (Bar[TrackIndex] = 1);
    ScreenSing.LyricsDuetShared[TrackIndex] := (BarTracks[Bar[TrackIndex]] > 1);

    Engine.UpperLineX := ThemeBar.UpperX;
    Engine.UpperLineY := ThemeBar.UpperY;
    Engine.UpperLineW := ThemeBar.UpperW;
    Engine.UpperLineH := ThemeBar.UpperH;
    Engine.LowerLineX := ThemeBar.LowerX;
    Engine.LowerLineY := ThemeBar.LowerY;
    Engine.LowerLineW := ThemeBar.LowerW;
    Engine.LowerLineH := ThemeBar.LowerH;

    // tracks sharing a bar split the width of the lyrics bar background,
    // each column keeps space for the lyric helper on its left
    if (BarTracks[Bar[TrackIndex]] > 1) then
    begin
      ColumnW := Theme.Sing.StaticLyricsBar.W / BarTracks[Bar[TrackIndex]];
      ColumnX := Theme.Sing.StaticLyricsBar.X + BarIndex * ColumnW;

      Engine.UpperLineX := ColumnX + LYRIC_HELPER_SPACE;
      Engine.UpperLineW := ColumnW - LYRIC_HELPER_SPACE - Max(MarksW, 5);
      Engine.LowerLineX := Engine.UpperLineX;
      Engine.LowerLineW := Engine.UpperLineW;
    end;
  end;
end;

{**
 * The sung text of a duet track has the color of a player who sings it,
 * preferably one on the current screen. The text of tracks nobody sings is
 * gray.
 *}
procedure TScreenSingView.SetDuetLyricsColors;
var
  TrackIndex: integer;
  Singer:     integer;
  Col:        TRGB;
begin
  for TrackIndex := 0 to High(CurrentSong.Tracks) do
  begin
    Singer := ScreenSing.TrackSinger(TrackIndex);
    if (Singer >= 0) then
    begin
      Col := GetPlayerColor(Ini.SingColor[Singer]);
      // very dark colors (dark blue) merge with the black outline of the lyrics, use their light variant
      if (0.2126 * Col.R + 0.7152 * Col.G + 0.0722 * Col.B < 0.15) then
        Col := GetPlayerLightColor(Ini.SingColor[Singer]);
    end
    else
      Col := GetLyricGrayColor(4);
    ScreenSing.LyricsDuet[TrackIndex].LineColor_act.R := Col.R;
    ScreenSing.LyricsDuet[TrackIndex].LineColor_act.G := Col.G;
    ScreenSing.LyricsDuet[TrackIndex].LineColor_act.B := Col.B;
  end;
end;


{ the area of the note row of a player as SingDraw places it,
  false if the player is on the other screen }
function TScreenSingView.GetPlayerRow(PlayerIndex: integer; out X, Y, W, H: real): boolean;
var
  RowsPerScreen: integer;
  Row:           integer;
  Column:        integer; // -1: full width, 0: left half, 1: right half
begin
  Result := false;
  X := 0;
  Y := 0;
  W := 0;
  H := 0;
  Column := -1;
  if (PlayersPlay = 4) or (PlayersPlay = 6) then
  begin
    RowsPerScreen := PlayersPlay div 2;
    Row := PlayerIndex mod RowsPerScreen;
    if (Screens = 2) then
    begin
      if (PlayerIndex div RowsPerScreen <> ScreenAct - 1) then
        Exit;
    end
    else
      Column := PlayerIndex div RowsPerScreen;
  end
  else
  begin
    RowsPerScreen := PlayersPlay;
    Row := PlayerIndex;
  end;

  if (RowsPerScreen = 3) then
  begin
    Y := 120 + Row * 125;
    H := 9 * 12;
  end
  else if (RowsPerScreen = 2) then
  begin
    Y := Skin_P1_NotesB - 105 + Row * (Skin_P2_NotesB - Skin_P1_NotesB);
    H := 9 * 15;
  end
  else
  begin
    Y := Skin_P2_NotesB - 105;
    H := 9 * 15;
  end;

  case Column of
    0: begin X := 40;  W := 330; end;
    1: begin X := 410; W := 350; end;
    else begin X := 40; W := 720; end;
  end;
  Result := true;
end;

{ copies the avatars of the players for the ready check and the part cues,
  the avatars can change between songs }
procedure TScreenSingView.CopyPlayerAvatars;
var
  PlayerIndex: integer;
begin
  for PlayerIndex := 0 to High(ReadyAvatars) do
  begin
    FreeAndNil(ReadyAvatars[PlayerIndex]);
    if (AvatarPlayerTextures[PlayerIndex + 1] <> nil) and not AvatarPlayerTextures[PlayerIndex + 1].IsEmpty then
    begin
      ReadyAvatars[PlayerIndex] := AvatarPlayerTextures[PlayerIndex + 1].Clone();
      ReadyAvatars[PlayerIndex].Reflection := false;
    end;
  end;
end;

{ draws a panel over the note row of each player with the avatar, name, part, mic meter
  and whether the player is ready, the keys at the bottom and the countdown to the start }
procedure TScreenSingView.DrawReadyCheck;
var
  PlayerIndex: integer;
  X, Y, W, H:  real;
  Col:         TRGB;
  LightCol:    TRGB;
  Ready:       boolean;
  Ticks:       cardinal;
  Pulse:       real;
  Pop:         real;
  Voice:       real;
  Threshold:   real;
  AvatarSize:  real;
  Size:        real;
  AvatarX:     real;
  AvatarY:     real;
  Avatar:      TTexture;
  TextX:       real;
  TextW:       real;
  FontH:       real;
  MeterY:      real;
  MeterW:      real;
  Remaining:   real;
  Fade:        real;
  Line:        UTF8String;

  // prints Line at (PosX, PosY) with the font size Size, smaller if it is wider than MaxW
  procedure PrintFitted(const Line: UTF8String; PosX, PosY, MaxW, Size: real);
  begin
    SetFontSize(Size);
    if (TextWidth(Line) > MaxW) then
      SetFontSize(Size * MaxW / TextWidth(Line));
    SetFontPos(PosX, PosY);
    PrintText(Line);
  end;

begin
  Ticks := SDL_GetTicks();
  Pulse := 0.5 + 0.5 * Sin(Ticks / 200);
  Threshold := IThresholdVals[Ini.ThresholdIndex];

  SetFontFamily(0);
  SetFontItalic(false);
  SetFontReflection(false, 0);
  SetFontZ(0);

  for PlayerIndex := 0 to PlayersPlay - 1 do
  begin
    if not GetPlayerRow(PlayerIndex, X, Y, W, H) then
      Continue;

    Ready := ScreenSing.ReadyPlayer[PlayerIndex];
    Col := GetPlayerColor(Ini.SingColor[PlayerIndex]);
    LightCol := GetPlayerLightColor(Ini.SingColor[PlayerIndex]);

    // panel over the note row, lit in the player color when the player is ready
    Renderer.DrawQuad(X, Y, 0, W, H, 0, 0, 0, 0.75);
    if Ready then
    begin
      Renderer.DrawQuad(X, Y, 0, W, H, Col.R, Col.G, Col.B, 0.35);
      Renderer.DrawBoundedBox(X, Y, X + W, Y + H, 0, 4, LightCol.R, LightCol.G, LightCol.B, 1);
    end
    else
      Renderer.DrawBoundedBox(X, Y, X + W, Y + H, 0, 2 + 2 * Pulse, Col.R, Col.G, Col.B, 0.4 + 0.6 * Pulse);

    // avatar: grows with the voice, pops when the player gets ready
    Voice := Min(1.0, ScreenSing.ReadyLevel[PlayerIndex] / Max(2 * Threshold, 0.01));
    Pop := 0;
    if Ready then
      Pop := Max(0.0, 1 - (Ticks - ScreenSing.ReadyTime[PlayerIndex]) / 400);
    AvatarSize := H - 24;
    Size := AvatarSize * (1 + 0.15 * Voice + 0.3 * Pop);
    AvatarX := X + 12 + (AvatarSize - Size) / 2;
    AvatarY := Y + (H - Size) / 2;
    Avatar := ReadyAvatars[PlayerIndex];
    if Assigned(Avatar) then
    begin
      Avatar.X := AvatarX;
      Avatar.Y := AvatarY;
      Avatar.Z := 0;
      Avatar.W := Size;
      Avatar.H := Size;
      Avatar.Alpha := 1;
      Renderer.DrawTexture(Avatar);
    end
    else
      Renderer.DrawQuad(AvatarX, AvatarY, 0, Size, Size, Col.R, Col.G, Col.B, 0.8);
    Renderer.DrawBoundedBox(AvatarX, AvatarY, AvatarX + Size, AvatarY + Size, 0, 3, Col.R, Col.G, Col.B, 1);

    // name and part
    TextX := X + AvatarSize + 28;
    TextW := X + W - 12 - TextX;
    FontH := H / 5;
    SetFontStyle(ftBold);
    SetFontColor(LightCol.R, LightCol.G, LightCol.B, 1);
    PrintFitted(ScreenSing.PlayerNames[PlayerIndex + 1], TextX, Y + 6, TextW, FontH);
    if CurrentSong.isDuet then
    begin
      SetFontColor(1, 1, 1, 0.85);
      PrintFitted(Format(Language.Translate('SING_READY_PART'), [CurrentSong.DuetNames[Player[PlayerIndex].Track]]),
        TextX, Y + 8 + FontH, TextW, FontH * 0.75);
    end;

    // ready, or how to get ready
    if Ready then
    begin
      SetFontColor(LightCol.R, LightCol.G, LightCol.B, 1);
      PrintFitted(Language.Translate('SING_READY'), TextX, Y + H - FontH * 1.5 - 8, TextW, FontH * 1.4 * (1 + 0.3 * Pop));
    end
    else if ScreenSing.ReadyHasMic[PlayerIndex] then
    begin
      SetFontColor(1, 1, 1, 0.7 + 0.3 * Pulse);
      PrintFitted(Language.Translate('SING_READY_SING'), TextX, Y + H - FontH * 2 - 10, TextW, FontH * 0.9);

      // mic meter, the mark is the volume the game needs to hear a tone
      MeterY := Y + H - 18;
      MeterW := TextW * 0.6;
      Renderer.DrawQuad(TextX, MeterY, 0, MeterW, 8, 1, 1, 1, 0.15);
      Renderer.DrawQuad(TextX, MeterY, 0, MeterW * Min(1.0, ScreenSing.ReadyLevel[PlayerIndex] / Max(4 * Threshold, 0.01)), 8, Col.R, Col.G, Col.B, 1);
      Renderer.DrawQuad(TextX + MeterW / 4 - 1, MeterY - 3, 0, 2, 14, 1, 1, 1, 0.8);
      SetFontColor(1, 1, 1, 0.6);
      PrintFitted(Format(Language.Translate('SING_READY_OR_PRESS'), [PlayerIndex + 1]),
        TextX + MeterW + 10, MeterY - FontH * 0.25, TextW - MeterW - 10, FontH * 0.6);
    end
    else
    begin
      SetFontColor(1, 1, 1, 0.7 + 0.3 * Pulse);
      PrintFitted(Format(Language.Translate('SING_READY_NO_MIC'), [PlayerIndex + 1]), TextX, Y + H - FontH * 1.5 - 8, TextW, FontH * 0.9);
    end;
  end;

  // keys, over the time bar
  Renderer.DrawQuad(0, 576, 0, 800, 24, 0, 0, 0, 0.8);
  SetFontStyle(ftBold);
  SetFontColor(1, 1, 1, 0.9);
  SetFontSize(16);
  Line := Language.Translate('SING_READY_HINT');
  SetFontPos(400 - TextWidth(Line) / 2, 579);
  PrintText(Line);

  // countdown when all players are ready
  if (ScreenSing.ReadyAllTime > 0) then
  begin
    Remaining := (READY_COUNTDOWN - (Ticks - ScreenSing.ReadyAllTime)) / 1000;
    if (Remaining > 0) then
    begin
      Fade := Frac(Remaining);
      Line := IntToStr(Trunc(Remaining) + 1);
      SetFontStyle(ftBoldHighRes);
      SetFontSize(100 + 120 * Fade);
      // dark shadow, so the number can be read over the lit panels
      SetFontColor(0, 0, 0, 0.8 * Fade);
      SetFontPos(400 - TextWidth(Line) / 2 + 4, 300 - (100 + 120 * Fade) / 2 + 4);
      PrintText(Line);
      SetFontColor(1, 1, 1, Fade);
      SetFontPos(400 - TextWidth(Line) / 2, 300 - (100 + 120 * Fade) / 2);
      PrintText(Line);
    end;
  end;
end;


{ called when a song is loaded: all lyrics visible, no cues }
procedure TScreenSingView.ResetPartCues;
var
  Track: integer;
begin
  for Track := 0 to High(CueAlpha) do
  begin
    CueAlpha[Track] := 0;
    DimAlpha[Track] := 1;
    ScreenSing.LyricsDuet[Track].LineAlpha := 1;
  end;
  CueLastTicks := SDL_GetTicks();
  CopyPlayerAvatars;
end;

{ ToNext: seconds until the next note of a track, 0 while one of its lines is sung,
  a large value after its last note.
  Pause: seconds between the previous note of the track and its next note, 0 while a line is sung }
procedure TScreenSingView.GetTrackPause(Track: integer; out ToNext, Pause: real);
const
  NO_NOTE = 1000; // s, for no next or previous note
var
  Lines:       ^TLines;
  LineIndex:   integer;
  Beat:        real;
  Now:         real;
  NextBeat:    integer;
  PrevEndBeat: integer;
  HasNext:     boolean;
  HasPrev:     boolean;

  function LineEnd(Index: integer): integer;
  begin
    with Lines.Lines[Index] do
      Result := Notes[High(Notes)].StartBeat + Notes[High(Notes)].Duration;
  end;

begin
  ToNext := NO_NOTE;
  Pause := NO_NOTE;
  Lines := @CurrentSong.Tracks[Track];
  if (Length(Lines.Lines) = 0) then
    Exit;
  LineIndex := EnsureRange(Lines.CurrentLine, 0, High(Lines.Lines));
  Beat := LyricsState.MidBeat;
  Now := LyricsState.GetCurrentTime();

  HasNext := false;
  HasPrev := false;
  NextBeat := 0;
  PrevEndBeat := 0;
  if (Length(Lines.Lines[LineIndex].Notes) > 0) then
  begin
    if (Beat < Lines.Lines[LineIndex].Notes[0].StartBeat) then
    begin
      // waiting for the current line
      HasNext := true;
      NextBeat := Lines.Lines[LineIndex].Notes[0].StartBeat;
    end
    else if (Beat <= LineEnd(LineIndex)) then
    begin
      // singing the current line
      ToNext := 0;
      Pause := 0;
      Exit;
    end
    else
    begin
      // the current line is sung, the next note is in a later line
      HasPrev := true;
      PrevEndBeat := LineEnd(LineIndex);
    end;
  end;

  // the next note in a later line
  if not HasNext then
    while (LineIndex < High(Lines.Lines)) and not HasNext do
    begin
      Inc(LineIndex);
      if (Length(Lines.Lines[LineIndex].Notes) > 0) then
      begin
        HasNext := true;
        NextBeat := Lines.Lines[LineIndex].Notes[0].StartBeat;
      end;
    end;
  if not HasNext then
    Exit;

  // the previous note in an earlier line
  if not HasPrev then
  begin
    LineIndex := EnsureRange(Lines.CurrentLine, 0, High(Lines.Lines)) - 1;
    while (LineIndex >= 0) and not HasPrev do
    begin
      if (Length(Lines.Lines[LineIndex].Notes) > 0) then
      begin
        HasPrev := true;
        PrevEndBeat := LineEnd(LineIndex);
      end;
      Dec(LineIndex);
    end;
  end;

  ToNext := Max(0.0, GetTimeFromBeat(NextBeat) - Now);
  if HasPrev then
    Pause := GetTimeFromBeat(NextBeat) - GetTimeFromBeat(PrevEndBeat);
end;

{ part cues, set by Ini.PartCues (key C in the song):
  "your turn": after a pause, the lyrics of a part light up in the color of its singers,
  with their avatars, shortly before its next line;
  "dim idle parts": the lyrics of parts that do not sing for a while fade out }
procedure TScreenSingView.DrawPartCues;
var
  Track:       integer;
  PlayerIndex: integer;
  AvatarIndex: integer;
  Singer:      integer;
  Engine:      TLyricEngine;
  ToNext:      real;
  Pause:       real;
  Target:      real;
  Delta:       real;
  Ticks:       cardinal;
  Pulse:       real;
  X, Y, W, H:  real;
  Size:        real;
  Col:         TRGB;
  Avatar:      TTexture;

  function Approach(Value, Goal, Step: real): real;
  begin
    if (Value < Goal) then
      Result := Min(Goal, Value + Step)
    else
      Result := Max(Goal, Value - Step);
  end;

begin
  Ticks := SDL_GetTicks();
  Delta := Min(0.1, (Ticks - CueLastTicks) / 1000);
  CueLastTicks := Ticks;
  Pulse := 0.5 + 0.5 * Sin(Ticks / 150);

  for Track := 0 to High(CurrentSong.Tracks) do
  begin
    Engine := ScreenSing.LyricsDuet[Track];
    Singer := ScreenSing.TrackSinger(Track);
    if (Singer < 0) or ScreenSing.ReadyCheck then
    begin
      // parts nobody sings are already gray, and the song has not started
      CueAlpha[Track] := 0;
      DimAlpha[Track] := 1;
      Engine.LineAlpha := 1;
      Continue;
    end;
    GetTrackPause(Track, ToNext, Pause);

    // dim idle parts
    if (Ini.PartCues in [2, 3]) and (ToNext > CUE_DIM_LEAD) then
      Target := CUE_DIM_ALPHA
    else
      Target := 1;
    DimAlpha[Track] := Approach(DimAlpha[Track], Target, Delta * 2);
    Engine.LineAlpha := DimAlpha[Track];

    // your turn
    if (Ini.PartCues in [1, 3]) and (Pause >= CUE_MIN_PAUSE) and (ToNext > 0) and (ToNext <= CUE_LEAD) then
      Target := 1
    else
      Target := 0;
    CueAlpha[Track] := Approach(CueAlpha[Track], Target, Delta * 4);
    if (CueAlpha[Track] <= 0) then
      Continue;

    // glow behind the lyrics of the part, in the color of its first singer
    X := Engine.UpperLineX;
    Y := Engine.UpperLineY;
    W := Engine.UpperLineW;
    H := Engine.LowerLineY + Engine.LowerLineH - Engine.UpperLineY;
    Col := GetPlayerColor(Ini.SingColor[Singer]);
    Renderer.DrawQuad(X, Y, 0, W, H, Col.R, Col.G, Col.B, CueAlpha[Track] * (0.25 + 0.2 * Pulse));
    Renderer.DrawBoundedBox(X, Y, X + W, Y + H, 0, 3, Col.R, Col.G, Col.B, CueAlpha[Track]);

    // avatars of the singers of the part at its right end, bouncing
    Size := H * (0.8 + 0.1 * Pulse);
    AvatarIndex := 0;
    for PlayerIndex := 0 to PlayersPlay - 1 do
    begin
      if (Player[PlayerIndex].Track <> Track) then
        Continue;
      Col := GetPlayerColor(Ini.SingColor[PlayerIndex]);
      Avatar := ReadyAvatars[PlayerIndex];
      X := Engine.UpperLineX + Engine.UpperLineW - 6 - (AvatarIndex + 1) * (H * 0.9 + 4) + (H * 0.9 - Size) / 2;
      Y := Engine.UpperLineY + (H - Size) / 2;
      if Assigned(Avatar) then
      begin
        Avatar.X := X;
        Avatar.Y := Y;
        Avatar.Z := 0;
        Avatar.W := Size;
        Avatar.H := Size;
        Avatar.Alpha := CueAlpha[Track];
        Renderer.DrawTexture(Avatar);
      end;
      Renderer.DrawBoundedBox(X, Y, X + Size, Y + Size, 0, 3, Col.R, Col.G, Col.B, CueAlpha[Track]);
      Inc(AvatarIndex);
    end;
  end;
end;

end.
