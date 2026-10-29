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
 *}



unit UScreenSingController;

interface

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{$I switches.inc}

uses
  UAvatars,
  UCommon,
  UFiles,
  UGraphicClasses,
  UHookableEvent,
  UIni,
  ULyrics,
  UMenu,
  UMusic,
  UPath,
  URenderer,
  UScreenSingView,
  USingScores,
  USkins,
  USongs,
  UThemes,
  UTime,
  sdl2,
  SysUtils,
  UText;

type
  TLyricsSyncSource = class(TSyncSource)
    function GetClock(): real; override;
  end;

  TMusicSyncSource = class(TSyncSource)
    function GetClock(): real; override;
  end;

  TTimebarMode = (
    tbmCurrent,   // current song position
    tbmRemaining, // remaining time
    tbmTotal      // total time
  );

type
  TScreenSingController = class(TMenu)
  private
    StartNote, EndNote:     TPos;
    fCountIn: boolean;
    fStartTime, fFirstNote: real;

    procedure LoadNextSong();
    procedure SongError();
    procedure ResetLinesAndLyrics();
    procedure ClearLyricEngines();
    procedure CalculateStartTime;
    procedure SaveLocalScores;
    procedure StartReadyCheck;
    procedure StartMusic;
  public
    CheckPlayerConfigOnNextSong: boolean;
    eSongLoaded: THookableEvent; //< event is called after lyrics of a song are loaded on OnShow
    Paused:     boolean; //pause Mod

    // ready check before the song starts: each player sings into their mic or presses their number
    ReadyCheck:     boolean;
    ReadyHasMic:    array [0..IMaxPlayerCount-1] of boolean;
    ReadyPlayer:    array [0..IMaxPlayerCount-1] of boolean;
    ReadyVoiceTime: array [0..IMaxPlayerCount-1] of cardinal; // ms the player sang a tone
    ReadyLevel:     array [0..IMaxPlayerCount-1] of real;     // mic level for the meter
    ReadyTime:      array [0..IMaxPlayerCount-1] of cardinal; // SDL ticks when the player got ready
    ReadyAllTime:   cardinal; // SDL ticks when all players were ready, 0 before
    ReadyLastTicks: cardinal;

    NumEmptySentences: array [0..MAX_SONG_TRACKS-1] of integer;
    // views
    fShowVisualization: boolean;
    fShowBackground: boolean;

    fCurrentVideo: IVideo;
    fVideoClip:    IVideo;
    fLyricsSync: TLyricsSyncSource;
    fMusicSync: TMusicSyncSource;
    fTimebarMode: TTimebarMode;

    PlayMidi: boolean;

    removeVoice: boolean;
    fShowWebcam: boolean;

    // TODO: delete this?
    Act_MD5Song: string;

    MedleyStart, MedleyEnd: real;

    Lyrics: TLyricEngine;
    LyricsDuet: array [0..MAX_SONG_TRACKS-1] of TLyricEngine; // one per track of duets (P1, P2, P3, ...)
    LyricsDuetLowerBar: array [0..MAX_SONG_TRACKS-1] of boolean; // the lyrics of the track are in the lower duet bar
    LyricsDuetShared: array [0..MAX_SONG_TRACKS-1] of boolean;   // the track shares its duet bar with other tracks

    // score manager:
    Scores: TSingScores;

    //the song was sung to the end
    SungToEnd: boolean;

    // some settings to be set by plugins
    Settings: record
      Finish: Boolean; //< if true, screen will finish on next draw

      OscilloscopeVisible: Boolean; //< shows or hides oscilloscope
      LyricsVisible:       Boolean; //< shows or hides lyrics
      NotesVisible:        array [0..IMaxPlayerCount-1] of Boolean; //< if NotesVisible[playerIndex] is set the notes for the specified player are visible. By default all players notes are visible
      ScoresVisible:       Boolean; //< shows or hides scores
      AvatarsVisible:      Boolean; //< shows or hides avatars
      TimeBarVisible:      Boolean; //< shows or hides timebar
      InputVisible:        Boolean; //< shows or hides input (sung notes)

      PlayerEnabled:  Integer; //< defines whether a player can score atm

      SoundEnabled:   Boolean; //< mute or unmute sound
    end;

    // MIDI
    ChannelOff  : integer;

    MidiFadeIn: boolean;
    MidiFadeOut: boolean;
    FadeTime: cardinal;

    InfoMessageBG: cardinal;
    InfoMessageText: cardinal;

    MessageTime: cardinal;
    MessageTimeFade: cardinal;

    TextMedleyFadeOut: boolean;
    TextMedleyFadeTime: cardinal;

    // names
    PlayerNames: array [1..IMaxPlayerCount] of UTF8String;
    PlayerDuetNames:array [1..IMaxPlayerCount] of UTF8String;

    Tex_Background: TTexture;
    Tex_BackgroundAspectRatio: single;
    // controls both background image and video
    BackgroundAspectCorrection: TAspectCorrection;
    FadeOut: boolean;

    procedure ClearSettings;
    procedure AllNotesVisible(visible: boolean);
    procedure ApplySettings; //< applies changes of settings record
    procedure EndSong;

    constructor Create; override;
    destructor Destroy; override;
    procedure OnShow; override;
    procedure OnShowFinish; override;
    procedure OnHide; override;
    function Draw: boolean; override;

    function ParseInput(PressedKey: cardinal; CharCode: UCS4Char;
      PressedDown: boolean): boolean; override;

    function FinishedMusic: boolean;

    procedure AutoSendScore;
    procedure AutoSaveScore;

    procedure Finish; virtual;
    procedure Pause; // toggle pause
    procedure UpdateMedleyStats(medley_end: boolean);
    procedure OnSentenceEnd(Track: integer; SentenceIndex: cardinal);     // for linebonus + singbar
    procedure OnSentenceChange(Track: integer; SentenceIndex: cardinal);  // for golden notes
    procedure GetShownTracks(out FirstTrack, LastTrack: integer);
    function TrackSinger(Track: integer): integer;
    procedure UpdateReadyCheck;
    procedure SetPlayerReady(PlayerIndex: integer);
    property CountIn: boolean read fCountIn write fCountIn;
    property FirstNote: real read fFirstNote;
  end;

var screenSingViewRef: TScreenSingView;
    TotalTime:              real;

const
  ID='ID_022';   //for help system

  READY_VOICE_TIME = 400;  // ms a player sings a tone to be ready
  READY_COUNTDOWN  = 3000; // ms from all players ready to the start of the song

implementation

uses
  UDatabase,
  UDisplay,
  UDLLManager,
  UDraw,
  UGraphic,
  UHelp,
  ULanguage,
  ULog,
  UNote,
  URecord,
  UParty,
  UPathUtils,
  USong,
  UUnicodeUtils,
  UWebcam,
  UWebSDK,
  Classes,
  Math;

const
  MAX_MESSAGE = 3;
  MINIMUM_START_TIME = 3;

// method for input parsing. if false is returned, getnextwindow
// should be checked to know the next window to load;

function TScreenSingController.ParseInput(PressedKey: Cardinal; CharCode: UCS4Char;
  PressedDown: boolean): boolean;
var
  SDL_ModState: word;
  i1:           integer;
  Color:        TRGB;
  ResumeAfterHelp: boolean;
  NewPosition:  real;
  NextLineBeat: integer;
begin
  Result := true;
  if (PressedDown) then
  begin // key down

    SDL_ModState := SDL_GetModState and (KMOD_LSHIFT + KMOD_RSHIFT
    + KMOD_LCTRL + KMOD_RCTRL + KMOD_LALT  + KMOD_RALT);

    // ready check: number keys get a player ready, Enter starts now, Esc goes back to the song list
    if ReadyCheck then
    begin
      case PressedKey of
        SDLK_ESCAPE,
        SDLK_BACKSPACE:
        begin
          ReadyCheck := false;
          // FadeOut stops the view from finishing the song (score screen) while the screen fades
          FadeOut := true;
          AudioInput.CaptureStop;
          AudioPlayback.Stop;
          FadeTo(@ScreenSong, SoundLib.Back);
        end;
        SDLK_RETURN,
        SDLK_SPACE:
          StartMusic;
        SDLK_1..SDLK_6:
          SetPlayerReady(PressedKey - SDLK_1);
        SDLK_KP_1..SDLK_KP_6:
          SetPlayerReady(PressedKey - SDLK_KP_1);
      end;
      Exit;
    end;

    // check normal keys
    case PressedKey of
      SDLK_Q:
      begin
        // when not ask before exit then finish now
        if (Ini.AskbeforeDel <> 1) then
          Finish
        // else just pause and let the popup make the work
        else if not Paused then
          Pause;

        Result := false;
        Exit;
      end;

      // restart song
      SDLK_R:
      begin
        if ScreenSong.Mode = smMedley then Exit;
        for i1 := 0 to High(Player) do
        with Player[i1] do
        begin
          ResetScores;

          ScoreLast      := 0;

          LastSentencePerfect := false;
        end;
        AudioPlayback.SetPosition(fStartTime);
        if (fStartTime < CurrentSong.Start) then
          fCountIn := true;
        if (Assigned(fCurrentVideo)) then
           fCurrentVideo.Position := CurrentSong.VideoGAP + CurrentSong.Start;// + (CurrentSong.gap / 1000.0 - 5.0);
        Scores.KillAllPopUps;
        // setup score manager
        Scores.ClearPlayers; // clear old player values
        Color.R := 0;
        Color.G := 0;
        Color.B := 0;

        // add new players
        for i1 := 0 to PlayersPlay - 1 do
        begin
          Scores.AddPlayer(Tex_ScoreBG[i1], Color);
        end;

        LyricsState.SetCurrentTime(fStartTime);
        LyricsState.UpdateBeats();
        ClearLyricEngines;
        ResetLinesAndLyrics;

        Scores.Init;
        Exit;
      end;

      // show visualization
      SDLK_V:
      begin
        if fShowWebcam then
        begin
          Webcam.Release;
          fShowWebCam:=false;
        end;
        if ((fShowBackground = true) and (Ini.VideoEnabled = 1) and CurrentSong.Video.IsSet())
                             or (fShowVisualization and not CurrentSong.Background.IsSet()) then //switch to video
        begin
          Log.LogStatus('decided to switch to video', 'UScreenSing.ParseInput');
          fShowBackground := false;
          fCurrentVideo := nil;
          fShowVisualization := false;
          fCurrentVideo := fVideoClip;
          if (Assigned(fCurrentVideo)) then
          begin
            fCurrentVideo.SetAspectCorrection(BackgroundAspectCorrection);
            fCurrentVideo.Position := CurrentSong.VideoGAP + AudioPlayback.Position;
          end;
          Log.LogStatus('finished switching to video', 'UScreenSing.ParseInput');
        end
        else
        begin
          if fShowVisualization and CurrentSong.Background.IsSet() then
          begin //switch to Background only
            Log.LogStatus('decided to switch to background', 'UScreenSing.ParseInput');
            fShowBackground := true;
            fCurrentVideo := nil;
            fShowVisualization := false;
            Log.LogStatus('finished switching to background', 'UScreenSing.ParseInput');
          end
          else
          begin //Video is currently visible, change to visualization
            Log.LogStatus('decided to switch to visualization', 'UScreenSing.ParseInput');
            fShowVisualization := true;
            fCurrentVideo := Visualization.Open(PATH_NONE);
            fCurrentVideo.play;
            Log.LogStatus('finished switching to visualization', 'UScreenSing.ParseInput');
          end;
        end;
        Exit;
      end;

      // show Webcam
      SDLK_W:
      begin
        if (fShowWebCam = false) then
        begin
          fCurrentVideo := nil;
          fShowVisualization := false;
          fShowBackground := false;
          Webcam.Restart;
          if (Webcam.Capture = nil) then
          begin
            fShowWebCam := false;
            fShowBackground := true;
            ScreenPopupError.ShowPopup(Language.Translate('SING_OPTIONS_WEBCAM_NO_WEBCAM'))
          end
          else
            fShowWebCam := true;
        //  ChangeEffectLastTick := SDL_GetTicks;
        //  SelectsS[WebcamParamsSlide].Visible := true;
        //  LastTickFrame := SDL_GetTicks;
        end
        else
        begin
          Webcam.Release;
          fShowWebCam:=false;
        end;

        Exit;
      end;

      // pause
      SDLK_P:
      begin
        Pause;
        Exit;
      end;

      // toggle time display: running time/remaining time/total time / SHIFT: show/hide time bar
      SDLK_T:
      begin
        if (SDL_ModState = KMOD_LSHIFT) then
        begin
          if (ScreenSong.Mode <> smNormal) and (ScreenSong.Mode <> smMedley) then
            Exit;

          ScreenSing.Settings.TimeBarVisible := not ScreenSing.Settings.TimeBarVisible;
          Exit;
        end
        else
        begin
          if (fTimebarMode = High(TTimebarMode)) then
            fTimebarMode := Low(TTimebarMode)
          else
            Inc(fTimebarMode);

          Ini.SingTimebarMode := Ord(fTimebarMode);
          Ini.SaveSingTimebarMode;
          Exit;
        end;
      end;

      // skip intro / SHIFT: show/hide score display
      SDLK_S:
      begin
        if (SDL_ModState = KMOD_LSHIFT) then
        begin
          if (ScreenSong.Mode <> smNormal) and (ScreenSong.Mode <> smMedley) then
            Exit;

          ScreenSing.Settings.ScoresVisible := not ScreenSing.Settings.ScoresVisible;
          Exit;
        end
        else
        begin
          // skip to 5 seconds before the next line of any track
          if (CurrentSong.isDuet) and (PlayersPlay <> 1) then
          begin
            NextLineBeat := LyricsDuet[0].GetUpperLine().StartNote;
            for i1 := 1 to High(CurrentSong.Tracks) do
              NextLineBeat := min(NextLineBeat, LyricsDuet[i1].GetUpperLine().StartNote);
          end
          else
            NextLineBeat := Lyrics.GetUpperLine().StartNote;

          if (GetTimeFromBeat(NextLineBeat) - AudioPlayback.Position > 6) then
            AudioPlayback.SetPosition(GetTimeFromBeat(NextLineBeat) - 5);
          Exit;
        end;
      end;

      // SHIFT: show/hide oscilloscope
      SDLK_O:
      begin
        if (SDL_ModState = KMOD_LSHIFT) then
        begin
          if (ScreenSong.Mode <> smNormal) and (ScreenSong.Mode <> smMedley) then
            Exit;

          ScreenSing.Settings.OscilloscopeVisible := not ScreenSing.Settings.OscilloscopeVisible;
          Exit;
        end;
      end;

      // SHIFT: show/hide notes
      SDLK_N:
      begin
        if (SDL_ModState = KMOD_LSHIFT) then
        begin
          if (ScreenSong.Mode <> smNormal) and (ScreenSong.Mode <> smMedley) then
            Exit;

          if (ScreenSing.Settings.NotesVisible[0]) then begin
            // if first player is currently visible, set all players to not visible
            AllNotesVisible(false);
          end else begin
            // else set all players to visible
            AllNotesVisible(true);
          end;
          Exit;
        end;
      end;

      // SHIFT: show/hide notes
      SDLK_L:
      begin
        if (SDL_ModState = KMOD_LSHIFT) then
        begin
          if (ScreenSong.Mode <> smNormal) and (ScreenSong.Mode <> smMedley) then
            Exit;

          ScreenSing.Settings.LyricsVisible := not ScreenSing.Settings.LyricsVisible;
          Exit;
        end;
      end;

      // SHIFT: show/hide avatars and player names
      SDLK_A:
      begin
        if (SDL_ModState = KMOD_LSHIFT) then
        begin
          if (ScreenSong.Mode <> smNormal) and (ScreenSong.Mode <> smMedley) then
            Exit;

          ScreenSing.Settings.AvatarsVisible := not ScreenSing.Settings.AvatarsVisible;
          Exit;
        end
        else
        begin
          BackgroundAspectCorrection := TAspectCorrection((Ord(BackgroundAspectCorrection)+1) mod (Ord(High(TAspectCorrection))+1));
          if (Assigned(fCurrentVideo)) then
          begin
            fCurrentVideo.SetAspectCorrection(BackgroundAspectCorrection);
          end;
        end;
      end;

      // SHIFT: show/hide microphone input/sung notes
      SDLK_I:
      begin
        if (SDL_ModState = KMOD_LSHIFT) then
        begin
          if (ScreenSong.Mode <> smNormal) and (ScreenSong.Mode <> smMedley) then
            Exit;

          ScreenSing.Settings.InputVisible := not ScreenSing.Settings.InputVisible;
          Exit;
        end;
      end;

      // SHIFT: show/hide (toggle) all display elements
      SDLK_H:
      begin
        if (SDL_ModState = KMOD_LSHIFT) then
        begin
          if (ScreenSong.Mode <> smNormal) and (ScreenSong.Mode <> smMedley) then
            Exit;

          if (ScreenSing.Settings.NotesVisible[0]) then begin
            // if first player is currently visible, set all players to not visible
            AllNotesVisible(false);
          end else begin
            // else set all players to visible
            AllNotesVisible(true);
          end;
          // synchronize show/hide of all other elements with NotesVisible
          ScreenSing.Settings.LyricsVisible       := (ScreenSing.Settings.NotesVisible[0]);
          ScreenSing.Settings.ScoresVisible       := (ScreenSing.Settings.NotesVisible[0]);
          ScreenSing.Settings.AvatarsVisible      := (ScreenSing.Settings.NotesVisible[0]);
          ScreenSing.Settings.TimeBarVisible      := (ScreenSing.Settings.NotesVisible[0]);
          ScreenSing.Settings.InputVisible        := (ScreenSing.Settings.NotesVisible[0]);
          ScreenSing.Settings.OscilloscopeVisible := (ScreenSing.Settings.NotesVisible[0]);
          Exit;
        end;
      end;
    end;

    // check special keys
    case PressedKey of
      SDLK_ESCAPE,
      SDLK_BACKSPACE:
      begin
        // record sound hack:
        //Sound[0].BufferLong
        if ScreenSong.Mode = smMedley then
          PlaylistMedley.NumMedleySongs := PlaylistMedley.CurrentMedleySong;

        Finish;
        FadeOut := true;
        AudioPlayback.PlaySound(SoundLib.Back);
      end;

      SDLK_SPACE:
      begin
        Pause;
      end;

      // part cues: off, your turn, dim idle parts, both
      SDLK_C:
      begin
        Ini.PartCues := (Ini.PartCues + 1) mod Length(IPartCues);
        Ini.SavePartCues;
        screenSingViewRef.WriteMessage(Format(Language.Translate('SING_PARTCUES_CHANGED'), [IPartCuesTranslated[Ini.PartCues]]));
      end;

      SDLK_K:
      begin
        AudioPlayback.ToggleKaraoke;
      end;

      SDLK_RIGHT:
      begin
        if ((SDL_ModState and KMOD_LCTRL) <> 0) then
        begin
          NewPosition := AudioPlayback.Position + 5.0;
          AudioPlayback.SetPosition(NewPosition);
          if (Assigned(fCurrentVideo)) then
            fCurrentVideo.Position := CurrentSong.VideoGAP + NewPosition;
        end;
      end;

      SDLK_LEFT:
      begin
        if (SDL_ModState = KMOD_LCTRL) then // seek 5 seconds backward and reset scores to avoid cheating
        begin
          if (AudioPlayback.Position < 20.0) then
          exit;
        for i1 := 0 to High(Player) do
        with Player[i1] do
        begin
          ResetScores;

          ScoreLast      := 0;

          LastSentencePerfect := false;
        end;
        Scores.KillAllPopUps;
        // setup score manager
        Scores.ClearPlayers; // clear old player values
        // add new players
        for i1 := 0 to PlayersPlay - 1 do
        begin
          Scores.AddPlayer(Tex_ScoreBG[i1], Color);
        end;
        Scores.Init;

        NewPosition := AudioPlayback.Position - 5.0;
        AudioPlayback.SetPosition(NewPosition);
        LyricsState.SetCurrentTime(NewPosition);
        ClearLyricEngines;
        LyricsState.UpdateBeats();
        if (Assigned(fCurrentVideo)) then
          fCurrentVideo.Position := CurrentSong.VideoGAP + NewPosition;
        end;
      end;

      SDLK_TAB:
      begin
        if (SDL_ModState = KMOD_LCTRL) then // change visualization preset
        begin
          if fShowVisualization then
            fCurrentVideo.Position := now; // move to a random position

          if (fShowWebcam) then
          begin
            if (Ini.WebCamEffect < 10) then
              Ini.WebCamEffect := Ini.WebCamEffect + 1
            else
              Ini.WebCamEffect := 0;
          end;
        end
        else // show help popup
        begin
          ResumeAfterHelp := not Paused;
          if ResumeAfterHelp then
            Pause;
          ScreenPopupHelp.ShowPopup(ResumeAfterHelp);
        end;
      end;
    end;
  end;
end;

procedure TScreenSingController.Pause;
begin
  if (not Paused) then  // enable pause
  begin
    // pause time
    Paused := true;

    LyricsState.Pause();

    // pause music
      AudioPlayback.Pause;

    // pause video
    if (fCurrentVideo <> nil) then
      fCurrentVideo.Pause;

  end
  else              // disable pause
  begin
    LyricsState.Start();

    // play music
      AudioPlayback.Play;

    // video
    if (fCurrentVideo <> nil) then
      fCurrentVideo.Pause;

    Paused := false;
  end;
end;

constructor TScreenSingController.Create;
begin
  inherited Create;
  ScreenSing := self;
  screenSingViewRef := TScreenSingView.Create();
  CheckPlayerConfigOnNextSong := true;
  // for now: default to letterbox but preserve aspect between songs
  BackgroundAspectCorrection := acoLetterBox;

  ClearSettings;
end;

destructor TScreenSingController.Destroy;
var
  TrackIndex: integer;
begin
  FreeAndNil(screenSingViewRef);
  Lyrics.Free;
  for TrackIndex := 0 to High(LyricsDuet) do
    LyricsDuet[TrackIndex].Free;
  fLyricsSync.Free;
  fMusicSync.Free;
  eSongLoaded.Free;
  Scores.Free;
  Tex_Background.Free;
  inherited;
end;

procedure TScreenSingController.OnShow;
var
  BadPlayer: integer;
  TrackIndex: integer;
  Col: TRGB;
begin
  inherited;

  Log.LogStatus('Begin', 'OnShow');

  if not Help.SetHelpID(ID) then
    Log.LogWarn('No Entry for Help-ID ' + ID, 'ScreenSingController');

  FadeOut := false;

  screenSingViewRef.CloseMessage();

  //the song was sung to the end
  SungToEnd := false;

  ClearSettings;
  Party.CallBeforeSing;

  // prepare players
  SetLength(Player, PlayersPlay);

  //Reset Player Medley stats
  if (ScreenSong.Mode = smMedley) then
  begin
    PlaylistMedley.CurrentMedleySong:=1;

    PlaylistMedley.NumPlayer := PlayersPlay;
    SetLength(PlaylistMedley.Stats, 0);
  end;

  fTimebarMode := TTimebarMode(Ini.SingTimebarMode);

  if (ScreenSong.Mode = smMedley) then
    CatSongs.Selected := PlaylistMedley.Song[PlaylistMedley.CurrentMedleySong-1];

  CurrentSong := CatSongs.Song[CatSongs.Selected];

  {for I := 0 to High(screenSingViewRef.StaticDuet) do
    Statics[screenSingViewRef.StaticDuet[I]].Visible := CurrentSong.isDuet and (PlayersPlay > 1);}
  Statics[screenSingViewRef.StaticLyricsBarDuet].Visible := CurrentSong.isDuet and (PlayersPlay > 1);

  Statics[screenSingViewRef.SongNameStatic].Visible := false;
  Text[screenSingViewRef.SongNameText].Visible := false;

  BadPlayer := AudioInputProcessor.CheckPlayersConfig(PlayersPlay);
  if (BadPlayer <> 0) and CheckPlayerConfigOnNextSong then
  begin
    ScreenPopupError.ShowPopup(
        Format(Language.Translate('ERROR_PLAYER_NO_DEVICE_ASSIGNMENT'),
        [BadPlayer]));
    // do not show the warning again, unless something sets this to true again
    CheckPlayerConfigOnNextSong := false;
  end;

  // set custom options
  if (CurrentSong.isDuet) and (PlayersPlay <> 1) then
  begin
    for TrackIndex := 0 to High(LyricsDuet) do
    begin
      LyricsDuet[TrackIndex].FontFamily := Ini.LyricsFont;
      LyricsDuet[TrackIndex].FontStyle := Ini.LyricsStyle;

      // set custom options, the color of the sung text is set by
      // TScreenSingView.SetDuetLyricsColors for each screen
      LyricsDuet[TrackIndex].LineColor_act.A := 1;

      if (Ini.JukeboxActualLineColor = High(UIni.IActualLineColor)) then
        Col := GetJukeboxLyricOtherColor(1)
      else
        Col := GetLyricGrayColor(Ini.JukeboxActualLineColor);
      LyricsDuet[TrackIndex].LineColor_en.R := Col.R;
      LyricsDuet[TrackIndex].LineColor_en.G := Col.G;
      LyricsDuet[TrackIndex].LineColor_en.B := Col.B;
      LyricsDuet[TrackIndex].LineColor_en.A := 1;

      if (Ini.JukeboxNextLineColor = High(UIni.INextLineColor)) then
        Col := GetJukeboxLyricOtherColor(2)
      else
        Col := GetLyricGrayColor(Ini.JukeboxNextLineColor);
      LyricsDuet[TrackIndex].LineColor_dis.R := Col.R;
      LyricsDuet[TrackIndex].LineColor_dis.G := Col.G;
      LyricsDuet[TrackIndex].LineColor_dis.B := Col.B;
      LyricsDuet[TrackIndex].LineColor_dis.A := 1;
    end;
  end
  else
  begin

    Lyrics.FontFamily := Ini.LyricsFont;
    Lyrics.FontStyle := Ini.LyricsStyle;

    if (Ini.JukeboxSingLineColor = High(UIni.ISingLineColor)) then
      Col := GetJukeboxLyricOtherColor(0)
    else
      Col := GetLyricColor(Ini.JukeboxSingLineColor);
    Lyrics.LineColor_act.R := Col.R;
    Lyrics.LineColor_act.G := Col.G;
    Lyrics.LineColor_act.B := Col.B;
    Lyrics.LineColor_act.A := 1;

    if (Ini.JukeboxActualLineColor = High(UIni.IActualLineColor)) then
      Col := GetJukeboxLyricOtherColor(1)
    else
      Col := GetLyricGrayColor(Ini.JukeboxActualLineColor);
    Lyrics.LineColor_en.R := Col.R;
    Lyrics.LineColor_en.G := Col.G;
    Lyrics.LineColor_en.B := Col.B;
    Lyrics.LineColor_en.A := 1;

    if (Ini.JukeboxNextLineColor = High(UIni.INextLineColor)) then
      Col := GetJukeboxLyricOtherColor(2)
    else
      Col := GetLyricGrayColor(Ini.JukeboxNextLineColor);
    Lyrics.LineColor_dis.R := Col.R;
    Lyrics.LineColor_dis.G := Col.G;
    Lyrics.LineColor_dis.B := Col.B;
    Lyrics.LineColor_dis.A := 1;
  end;

  // deactivate pause
  Paused := false;
  ReadyCheck := false;

  LoadNextSong();

  Log.LogStatus('End', 'OnShow');
end;

procedure TScreenSingController.onShowFinish;
var
  PlayerIndex: integer;
begin
  // hide cursor on singscreen show
  Display.SetCursor;

  // clear the scores of all players
  for PlayerIndex := 0 to High(Player) do
    with Player[PlayerIndex] do
    begin
      ResetScores;

      ScoreLast      := 0;

      LastSentencePerfect := false;
    end;

  // prepare music
  // Important: AudioPlayback must not be initialized in onShow() as TScreenSong
  // uses stops AudioPlayback in onHide() which interferes with TScreenSings onShow.
  PlayMidi := false;
  MidiFadeIn := false;

  if (not Assigned(CurrentSong.Karaoke)) or (CurrentSong.Karaoke = PATH_NONE) then
    AudioPlayback.Open(CurrentSong.Path.Append(CurrentSong.Audio), nil)
  else
    AudioPlayback.Open(CurrentSong.Path.Append(CurrentSong.Audio), CurrentSong.Path.Append(CurrentSong.Karaoke));

  if ScreenSong.Mode = smMedley then
    AudioPlayback.SetVolume(0.1)
  else
    AudioPlayback.SetVolume(1.0);
  //AudioPlayback.Position := CurrentSong.Start;
    if ((fStartTime < CurrentSong.Start) and (fStartTime > 0)) then
      AudioPlayback.StartTime := CurrentSong.Start;
  AudioPlayback.Position := LyricsState.GetCurrentTime();


  // set time
  if (CurrentSong.Finish > 0) then
    LyricsState.TotalTime := CurrentSong.Finish / 1000
  else
  begin
    LyricsState.TotalTime := AudioPlayback.Length;
  end;

  LyricsState.UpdateBeats();

  // synchronize music
  if Ini.SyncTo = Ord(stLyrics) then
    AudioPlayback.SetSyncSource(fLyricsSync)
  else
    AudioPlayback.SetSyncSource(nil);

  // synchronize lyrics (do not set this before AudioPlayback is initialized)
  if Ini.SyncTo = Ord(stMusic) then
    LyricsState.SetSyncSource(fMusicSync)
  else
    LyricsState.SetSyncSource(nil);

  // Send Score
  Act_MD5Song := CurrentSong.MD5;

  // with 2 or more players the song starts when all players are ready
  if (Ini.ReadyCheck = 1) and (PlayersPlay > 1) and (ScreenSong.Mode = smNormal) then
    StartReadyCheck
  else
    StartMusic;
end;

procedure TScreenSingController.StartMusic;
begin
  ReadyCheck := false;

  // start lyrics
  LyricsState.Start(true);

  // start music
  if ScreenSong.Mode = smMedley then
    AudioPlayback.FadeIn(CurrentSong.Medley.FadeIn_time, 1.0)
  else
    AudioPlayback.Play();

  // start timer
  CountSkipTimeSet;
end;

procedure TScreenSingController.StartReadyCheck;
var
  PlayerState: TBooleanDynArray;
  PlayerIndex: integer;
begin
  AudioInputProcessor.CheckPlayersConfig(PlayersPlay, PlayerState);
  for PlayerIndex := 0 to PlayersPlay - 1 do
  begin
    ReadyHasMic[PlayerIndex] := PlayerState[PlayerIndex] and (PlayerIndex <= High(AudioInputProcessor.Sound));
    ReadyPlayer[PlayerIndex] := false;
    ReadyVoiceTime[PlayerIndex] := 0;
    ReadyLevel[PlayerIndex] := 0;
    ReadyTime[PlayerIndex] := 0;
  end;
  ReadyAllTime := 0;
  ReadyLastTicks := SDL_GetTicks();
  ReadyCheck := true;
end;

{ called every frame during the ready check: a player is ready after singing a tone
  for READY_VOICE_TIME, the song starts READY_COUNTDOWN after all players are ready }
procedure TScreenSingController.UpdateReadyCheck;
var
  PlayerIndex: integer;
  Ticks:       cardinal;
  Delta:       cardinal;
  AllReady:    boolean;
  Sound:       TCaptureBuffer;
begin
  Ticks := SDL_GetTicks();
  Delta := Ticks - ReadyLastTicks;
  ReadyLastTicks := Ticks;

  AllReady := true;
  for PlayerIndex := 0 to PlayersPlay - 1 do
  begin
    if ReadyHasMic[PlayerIndex] then
    begin
      Sound := AudioInputProcessor.Sound[PlayerIndex];
      Sound.AnalyzeBuffer;
      // the meter follows the voice up at once and falls slowly
      ReadyLevel[PlayerIndex] := Max(Sound.MaxSampleVolume, ReadyLevel[PlayerIndex] - Delta / 1000);
      if Sound.ToneValid and not ReadyPlayer[PlayerIndex] then
      begin
        Inc(ReadyVoiceTime[PlayerIndex], Delta);
        if (ReadyVoiceTime[PlayerIndex] >= READY_VOICE_TIME) then
          SetPlayerReady(PlayerIndex);
      end;
    end;
    AllReady := AllReady and ReadyPlayer[PlayerIndex];
  end;

  if AllReady and (ReadyAllTime = 0) then
    ReadyAllTime := Ticks;

  if (ReadyAllTime > 0) and (Ticks - ReadyAllTime >= READY_COUNTDOWN) then
    StartMusic;
end;

procedure TScreenSingController.SetPlayerReady(PlayerIndex: integer);
begin
  if (PlayerIndex < 0) or (PlayerIndex >= PlayersPlay) or ReadyPlayer[PlayerIndex] then
    Exit;

  ReadyPlayer[PlayerIndex] := true;
  ReadyTime[PlayerIndex] := SDL_GetTicks();
  AudioPlayback.PlaySound(SoundLib.Option);
end;

procedure TScreenSingController.SongError();
var
  I, len:  integer;

begin
  if ScreenSong.Mode <> smMedley then
  begin
    // error loading song -> go back to previous screen and show some error message
    Display.AbortScreenChange;

    // select new song in party mode
    if ScreenSong.Mode = smPartyClassic then
      ScreenSong.SelectRandomSong();

    if (Length(CurrentSong.LastError) > 0) then
      ScreenPopupError.ShowPopup(Format(Language.Translate(CurrentSong.LastError), [CurrentSong.ErrorLineNo]))
    else
      ScreenPopupError.ShowPopup(Language.Translate('ERROR_CORRUPT_SONG'));
    // FIXME: do we need this?
    CurrentSong.Path := CatSongs.Song[CatSongs.Selected].Path;
    Exit;
  end
  else
  begin
    if (PlaylistMedley.CurrentMedleySong<PlaylistMedley.NumMedleySongs) then
    begin
      //Error Loading Song in Medley Mode -> skip actual Medley Song an go on if possible
      len := Length(PlaylistMedley.Song);
      for I := PlaylistMedley.CurrentMedleySong - 1 to len - 2 do
        PlaylistMedley.Song[I] := PlaylistMedley.Song[I+1];

      SetLength(PlaylistMedley.Song, Len-1);
      Dec(PlaylistMedley.NumMedleySongs);
      LoadNextSong;
      Exit;
    end
    else
    begin
      if (PlaylistMedley.NumMedleySongs=1) then
      begin
        //Error Loading Song in Medley Mode -> Go back to Song Screen and Show some Error Message
        Display.AbortScreenChange;

        // select new song in party mode
        if ScreenSong.Mode = smPartyClassic then
          ScreenSong.SelectRandomSong();

        if (Length(CurrentSong.LastError) > 0) then
          ScreenPopupError.ShowPopup(Format(Language.Translate(CurrentSong.LastError), [CurrentSong.ErrorLineNo]))
        else
          ScreenPopupError.ShowPopup(Language.Translate('ERROR_CORRUPT_SONG'));

        // FIXME: do we need this?
        CurrentSong.Path := CatSongs.Song[CatSongs.Selected].Path;
        Exit;
      end
      else
      begin
        //Error Loading Song in Medley Mode -> Finish actual round
        len := Length(PlaylistMedley.Song);
        SetLength(PlaylistMedley.Song, len-1);
        Dec(PlaylistMedley.NumMedleySongs);
        Finish;
        Exit;
      end;
    end;
  end;
end;

procedure TScreenSingController.LoadNextSong();
var
  Color:      TRGB;
  Index:      integer;
  TrackIndex: integer;
  FirstTrack: integer;
  LastTrack:  integer;
  VideoFile:  IPath;
  BgFile:     IPath;
  success:    boolean;
  AudioEnd:   real;

begin
  // background texture (garbage disposal)
  FreeAndNil(Tex_Background);

  // reset video playback engine
  fCurrentVideo := nil;

  // setup score manager
  Scores.ClearPlayers; // clear old player values
  Color.R := 0;
  Color.G := 0;
  Color.B := 0;

  // add new players
  for Index := 0 to PlayersPlay - 1 do
  begin
    Scores.AddPlayer(Tex_ScoreBG[Index], Color);
  end;

  Scores.Init; // get positions for players

  // FIXME: sets path and filename to ''
  ResetSingTemp;

  PlaylistMedley.ApplausePlayed := false;

  if ScreenSong.Mode = smMedley then
  begin
    if length(PlaylistMedley.Song) >= PlaylistMedley.CurrentMedleySong then
    begin
      CatSongs.Selected := PlaylistMedley.Song[PlaylistMedley.CurrentMedleySong-1];
    end
    else
    begin
      SongError;
      Exit;
    end;
  end;

  CurrentSong := CatSongs.Song[CatSongs.Selected];
  if (not Assigned(AudioPlayback)) or (AudioPlayback.Length = 0) or (CurrentSong.Path.Append(CurrentSong.Audio).ToNative <> AudioPlayback.GetFileName) then
  begin
    if (not Assigned(CurrentSong.Karaoke)) or (CurrentSong.Karaoke = PATH_NONE) then
      AudioPlayback.Open(CurrentSong.Path.Append(CurrentSong.Audio), nil)
    else
      AudioPlayback.Open(CurrentSong.Path.Append(CurrentSong.Audio), CurrentSong.Path.Append(CurrentSong.Karaoke));
  end;

  AudioEnd := 0;
  if Assigned(AudioPlayback) then
    AudioEnd := AudioPlayback.Length; // unfortunately only works when the song is already playing

  if (CurrentSong.Finish > 0) and (CurrentSong.Finish / 1000 < AudioEnd) then
    AudioEnd := CurrentSong.Finish / 1000;

  success := false;
  // FIXME: bad style, put the try-except into loadsong() and not here
  try
    success := CurrentSong.Analyse(false, ScreenSong.RapToFreestyle, true, AudioEnd, true); // and CurrentSong.LoadSong();
  except
    on E: EInOutError do Log.LogWarn(E.Message, 'TScreenSing.LoadNextSong');
  end;

  if (not success) then
  begin
    SongError();
    Exit;
  end;

  // the track (part) of a duet each player sings, chosen in the song selection
  for Index := 0 to High(Player) do
  begin
    if (CurrentSong.isDuet) then
      Player[Index].Track := ScreenSong.GetPlayerTrack(Index, CurrentSong.TrackCount)
    else
      Player[Index].Track := 0;
  end;

  if ScreenSong.Mode = smMedley then
  begin
    if (CurrentSong.Medley.Source < msCalculated) or (Length(CurrentSong.Tracks) = 0) then
    begin
      SongError();
      Exit;
    end;

    if Length(CurrentSong.Tracks[0].Lines) = 0 then
    begin
      SongError();
      Exit;
    end;
  end;

  CalculateStartTime;
  if (fStartTime < CurrentSong.Start) then
  begin
    fCountIn := true;
    AudioPlayback.Position := fStartTime;
    if (fStartTime > 0) then
      AudioPlayback.StartTime := CurrentSong.Start;
  end
  else
    fCountIn := false;

  // Set up Medley timings
  if ScreenSong.Mode = smMedley then
  begin
    CurrentSong.SetMedleyMode();

    if (PlaylistMedley.NumMedleySongs > 1) then
      Text[screenSingViewRef.SongNameText].Text := IntToStr(PlaylistMedley.CurrentMedleySong) +
        '/' + IntToStr(PlaylistMedley.NumMedleySongs) + ': ' +
        CurrentSong.Artist + ' - ' + CurrentSong.Title
    else
      Text[screenSingViewRef.SongNameText].Text := CurrentSong.Artist + ' - ' + CurrentSong.Title;

    //medley start and end timestamps
    StartNote := FindNote(CurrentSong.Medley.StartBeat - round(CurrentSong.BPM*CurrentSong.Medley.FadeIn_time/60));
    MedleyStart := GetTimeFromBeat(CurrentSong.Tracks[0].Lines[StartNote.line].Notes[0].StartBeat);

    //check Medley-Start
    if (MedleyStart+CurrentSong.Medley.FadeIn_time*0.5>GetTimeFromBeat(CurrentSong.Medley.StartBeat)) then
      MedleyStart := GetTimeFromBeat(CurrentSong.Medley.StartBeat) - CurrentSong.Medley.FadeIn_time;
    if MedleyStart<0 then
      MedleyStart := 0;

    MedleyEnd := GetTimeFromBeat(CurrentSong.Medley.EndBeat) + CurrentSong.Medley.FadeOut_time;
  end;

  {*
   * == Background ==
   * We have five types of backgrounds:
   *   + Blank        : Nothing has been set, this is our fallback
   *   + Picture      : Picture has been set, and exists - otherwise we fallback
   *   + Video        : Video has been set, and exists - otherwise we fallback
   *   + Visualization: + Off                 : No visualization
   *                    + WhenNoVideo         : Overwrites blank and picture
   *                    + WhenNoVideoAndImage : Overwrites blank
   *                    + On                  : Overwrites blank, picture and video
   *}

  {*
   * set background to: video
   * Note: ffmpeg / this is also used for many background formats"
   *}
  fShowVisualization := false;
  VideoFile := CurrentSong.Path.Append(CurrentSong.Video);
  if (Ini.VideoEnabled = 1) and CurrentSong.Video.IsSet() and VideoFile.IsFile then
  begin
    fVideoClip := VideoPlayback.Open(VideoFile);
    if (fVideoClip <> nil) then
    begin
      fCurrentVideo := fVideoClip;
      fCurrentVideo.SetAspectCorrection(BackgroundAspectCorrection);
      fShowVisualization := false;
      if ScreenSong.Mode = smMedley then
        fCurrentVideo.Position := CurrentSong.VideoGAP + MedleyStart
      else
        fCurrentVideo.Position := CurrentSong.VideoGAP + CurrentSong.Start;
      fCurrentVideo.Play;
    end;
  end;

  {*
   * set background to: picture
   *}
  if (CurrentSong.Background.IsSet) then
  begin
    BgFile := CurrentSong.Path.Append(CurrentSong.Background);
    try
      Tex_Background := Renderer.LoadTexture(BgFile);
      Tex_BackgroundAspectRatio := Tex_Background.W / Tex_Background.H;
      fShowBackground := fCurrentVideo = nil;
    except
      Log.LogError('Background could not be loaded: ' + BgFile.ToNative);
      FreeAndNil(Tex_Background);
    end;
  end
  else
  begin
    FreeAndNil(Tex_Background);
  end;

  {*
   * set background to: visualization (Overwrites all)
   *}
  if (TVisualizerOption(Ini.VisualizerOption) in [voOn]) then
  begin
    fShowVisualization := true;
    fCurrentVideo := Visualization.Open(PATH_NONE);
    if (fCurrentVideo <> nil) then
      fCurrentVideo.Play;
  end

  {*
   * set background to: visualization (if video and image is not set)
   *}
  else if (TVisualizerOption(Ini.VisualizerOption) in [voWhenNoVideoAndImage]) and
     (not CurrentSong.Background.IsSet) and (fVideoClip = nil) then
  begin
    fShowVisualization := true;
    fCurrentVideo := Visualization.Open(PATH_NONE);
    if fCurrentVideo <> nil then
      fCurrentVideo.Play;
  end

  {*
   * set background to: visualization (Videos are still shown)
   *}
  else if ((TVisualizerOption(Ini.VisualizerOption) in [voWhenNoVideo]) and
     (fVideoClip = nil)) then
  begin
    fShowVisualization := true;
    fCurrentVideo := Visualization.Open(PATH_NONE);
    if fCurrentVideo <> nil then
      fCurrentVideo.Play;
  end;

  // prepare lyrics timer
  LyricsState.Reset();

  if ScreenSong.Mode = smMedley then
  begin
    LyricsState.SetCurrentTime(MedleyStart);
    LyricsState.StartTime := CurrentSong.Gap;
    LyricsState.TotalTime := MedleyEnd;
  end
  else
  begin
    LyricsState.SetCurrentTime(fStartTime);
    LyricsState.StartTime := CurrentSong.Gap;
    if CurrentSong.Finish > 0 then
      LyricsState.TotalTime := CurrentSong.Finish / 1000
    else
      LyricsState.TotalTime := AudioPlayback.Length;
  end;

  LyricsState.UpdateBeats();

  // prepare and start voice-capture
  AudioInput.CaptureStart;

  // main text
  ClearLyricEngines;

  if (CurrentSong.isDuet) and (PlayersPlay <> 1) then
  begin
    screenSingViewRef.SetDuetLyricsLayout;

    for TrackIndex := 0 to High(CurrentSong.Tracks) do
    begin
      // initialize lyrics by filling its queue
      while (not LyricsDuet[TrackIndex].IsQueueFull) and
            (LyricsDuet[TrackIndex].LineCounter <= High(CurrentSong.Tracks[TrackIndex].Lines)) do
      begin
        LyricsDuet[TrackIndex].AddLine(@CurrentSong.Tracks[TrackIndex].Lines[LyricsDuet[TrackIndex].LineCounter]);
      end;
    end;
  end
  else
  begin
    // initialize lyrics by filling its queue, one player of a duet sees
    // only the track they sing
    TrackIndex := Player[0].Track;
    while (not Lyrics.IsQueueFull) and
          (Lyrics.LineCounter <= High(CurrentSong.Tracks[TrackIndex].Lines)) do
    begin
      Lyrics.AddLine(@CurrentSong.Tracks[TrackIndex].Lines[Lyrics.LineCounter]);
    end;
  end;

  GetShownTracks(FirstTrack, LastTrack);

  // kill all stars not killed yet (goldenstarstwinkle mod)
  for TrackIndex := FirstTrack to LastTrack do
    GoldenRec.SentenceChange(TrackIndex);

  // set position of line bonus - line bonus end
  // set number of empty sentences for line bonus
  for TrackIndex := 0 to High(NumEmptySentences) do
    NumEmptySentences[TrackIndex] := 0;

  for TrackIndex := FirstTrack to LastTrack do
  begin
    for Index := Low(CurrentSong.Tracks[TrackIndex].Lines) to High(CurrentSong.Tracks[TrackIndex].Lines) do
      if CurrentSong.Tracks[TrackIndex].Lines[Index].ScoreValue = 0 then
        Inc(NumEmptySentences[TrackIndex]);
  end;

  eSongLoaded.CallHookChain(False);

  screenSingViewRef.ResetPartCues;

  if (ScreenSong.Mode = smMedley) and (PlaylistMedley.CurrentMedleySong>1) then
    onShowFinish;
end;

// Forces the notes (lines) and lyrics to reset to the start of the song
procedure TScreenSingController.ResetLinesAndLyrics();
var
  i1: integer;

begin
  for i1 := 0 to High(CurrentSong.Tracks) do
  begin
    CurrentSong.Tracks[i1].CurrentLine := 0;
    OnSentenceChange(i1, 0);
  end;
end;

procedure TScreenSingController.ClearLyricEngines();
var
  TrackIndex: integer;
begin
  Lyrics.Clear(CurrentSong.BPM);
  for TrackIndex := 0 to High(LyricsDuet) do
    LyricsDuet[TrackIndex].Clear(CurrentSong.BPM);
end;

procedure TScreenSingController.CalculateStartTime;
var
  I, StartBeat: integer;
begin
  StartBeat := MaxInt;
  for I := Low(CurrentSong.Tracks) to High(CurrentSong.Tracks) do
    StartBeat := Min(StartBeat, CurrentSong.Tracks[I].Lines[0].Notes[0].StartBeat);
  fFirstNote := (CurrentSong.GAP / 1000) + ((StartBeat * 60) / CurrentSong.BPM);
  if ((fFirstNote - CurrentSong.Start) < MINIMUM_START_TIME) then
    fStartTime := fFirstNote - MINIMUM_START_TIME
  else
    fStartTime := CurrentSong.Start;
end;

procedure TScreenSingController.ClearSettings;
begin
  Settings.Finish := False;
  Settings.OscilloscopeVisible := Boolean(Ini.Oscilloscope);
  Settings.LyricsVisible := True;
  AllNotesVisible(true);
  Settings.ScoresVisible := True;
  Settings.AvatarsVisible := True;
  Settings.TimeBarVisible := True;
  Settings.InputVisible := True;
  Settings.PlayerEnabled := high(Integer);
  Settings.SoundEnabled := True;
end;

procedure TScreenSingController.AllNotesVisible(visible: boolean);
var
  I: integer;
begin
  for I := 0 to High(ScreenSing.Settings.NotesVisible) do begin
    ScreenSing.Settings.NotesVisible[I] := visible;
  end;
end;

{ applies changes of settings record }
procedure TScreenSingController.ApplySettings;
begin
  //
end;

procedure TScreenSingController.EndSong;
begin
  Settings.Finish := True;
end;

procedure TScreenSingController.OnHide;
begin
  // close video files
  fVideoClip := nil;
  fCurrentVideo := nil;

  // background texture
  FreeAndNil(Tex_Background);
  if fShowWebcam then
        begin
          Webcam.Release;
          fShowWebCam:=false;
        end;
  Background.OnFinish;
  Display.SetCursor(cshIgnoreSingScreen);
end;

function TScreenSingController.Draw: boolean;
var
  V1:     boolean;
  V1TwoP: boolean;   // position of score box in two player mode
  V1ThreeP: boolean; // position of score box in three player mode
  V2R:    boolean;
  V2M:    boolean;
  V3R:    boolean;
  VDuet1ThreeP: boolean;
  VDuet2M:    boolean;
  VDuet3R:    boolean;
  V1FourP: boolean;
  V2FourP: boolean;
  V3FourP: boolean;
  V4FourP: boolean;
  V1SixP: boolean;
  V2SixP: boolean;
  V3SixP: boolean;
  V4SixP: boolean;
  V5SixP: boolean;
  V6SixP: boolean;
  V1DuetFourP: boolean;
  V2DuetFourP: boolean;
  V3DuetFourP: boolean;
  V4DuetFourP: boolean;
  V1DuetSixP: boolean;
  V2DuetSixP: boolean;
  V3DuetSixP: boolean;
  V4DuetSixP: boolean;
  V5DuetSixP: boolean;
  V6DuetSixP: boolean;
begin
  V1     := false;
  V1TwoP := false;
  V1ThreeP := false;
  V2R    := false;
  V2M    := false;
  V3R    := false;

  VDuet1ThreeP := false;
  VDuet2M := false;
  VDuet3R := false;

  V1FourP := false;
  V2FourP := false;
  V3FourP := false;
  V4FourP := false;

  V1SixP := false;
  V2SixP := false;
  V3SixP := false;
  V4SixP := false;
  V5SixP := false;
  V6SixP := false;

  V1DuetFourP := false;
  V2DuetFourP := false;
  V3DuetFourP := false;
  V4DuetFourP := false;

  V1DuetSixP := false;
  V2DuetSixP := false;
  V3DuetSixP := false;
  V4DuetSixP := false;
  V5DuetSixP := false;
  V6DuetSixP := false;

  case PlayersPlay of
    1:
    begin
      V1     := true;
    end;
    2:
    begin
      V1TwoP := true;
      V2R    := true;
    end;
    3:
    begin
      if (CurrentSong.isDuet) then
      begin
        VDuet1ThreeP := true;
        VDuet2M := true;
        VDuet3R := true;
      end
      else
      begin
        V1ThreeP := true;
        V2M    := true;
        V3R    := true;
      end;
    end;
    4:
    begin // double screen
      if (Screens = 2) then
      begin
        V1TwoP := true;
        V2R    := true;
      end
      else
      begin
        if (CurrentSong.isDuet) then
        begin
          V1DuetFourP := true;
          V2DuetFourP := true;
          V3DuetFourP := true;
          V4DuetFourP := true;
        end
        else
        begin
          V1FourP := true;
          V2FourP := true;
          V3FourP := true;
          V4FourP := true;
        end;
      end;
    end;
    6:
    begin // double screen
      if (Screens = 2) then
      begin
        if (CurrentSong.isDuet) then
        begin
          VDuet1ThreeP := true;
          VDuet2M := true;
          VDuet3R := true;
        end
        else
        begin
          V1ThreeP := true;
          V2M    := true;
          V3R    := true;
        end;
      end
      else
      begin
       if (CurrentSong.isDuet) then
        begin
          V1DuetSixP := true;
          V2DuetSixP := true;
          V3DuetSixP := true;
          V4DuetSixP := true;
          V5DuetSixP := true;
          V6DuetSixP := true;
        end
        else
        begin
          V1SixP := true;
          V2SixP := true;
          V3SixP := true;
          V4SixP := true;
          V5SixP := true;
          V6SixP := true;
        end;
      end;
    end;
  end;

  Text[screenSingViewRef.TextP1].Visible           := V1 and ScreenSing.Settings.AvatarsVisible;
  Text[screenSingViewRef.TextP1TwoP].Visible       := V1TwoP and ScreenSing.Settings.AvatarsVisible;
  Text[screenSingViewRef.TextP2R].Visible          := V2R and ScreenSing.Settings.AvatarsVisible;
  Text[screenSingViewRef.TextP1ThreeP].Visible     := V1ThreeP and ScreenSing.Settings.AvatarsVisible;
  Text[screenSingViewRef.TextP2M].Visible          := V2M and ScreenSing.Settings.AvatarsVisible;
  Text[screenSingViewRef.TextP3R].Visible          := V3R and ScreenSing.Settings.AvatarsVisible;
  Text[screenSingViewRef.TextDuetP1ThreeP].Visible := VDuet1ThreeP and ScreenSing.Settings.AvatarsVisible;
  Text[screenSingViewRef.TextDuetP2M].Visible      := VDuet2M and ScreenSing.Settings.AvatarsVisible;
  Text[screenSingViewRef.TextDuetP3R].Visible      := VDuet3R and ScreenSing.Settings.AvatarsVisible;
  Text[screenSingViewRef.TextP1FourP].Visible      := V1FourP and ScreenSing.Settings.AvatarsVisible;
  Text[screenSingViewRef.TextP2FourP].Visible      := V2FourP and ScreenSing.Settings.AvatarsVisible;
  Text[screenSingViewRef.TextP3FourP].Visible      := V3FourP and ScreenSing.Settings.AvatarsVisible;
  Text[screenSingViewRef.TextP4FourP].Visible      := V4FourP and ScreenSing.Settings.AvatarsVisible;
  Text[screenSingViewRef.TextP1SixP].Visible       := V1SixP and ScreenSing.Settings.AvatarsVisible;
  Text[screenSingViewRef.TextP2SixP].Visible       := V2SixP and ScreenSing.Settings.AvatarsVisible;
  Text[screenSingViewRef.TextP3SixP].Visible       := V3SixP and ScreenSing.Settings.AvatarsVisible;
  Text[screenSingViewRef.TextP4SixP].Visible       := V4SixP and ScreenSing.Settings.AvatarsVisible;
  Text[screenSingViewRef.TextP5SixP].Visible       := V5SixP and ScreenSing.Settings.AvatarsVisible;
  Text[screenSingViewRef.TextP6SixP].Visible       := V6SixP and ScreenSing.Settings.AvatarsVisible;
  Text[screenSingViewRef.TextP1DuetFourP].Visible  := V1DuetFourP and ScreenSing.Settings.AvatarsVisible;
  Text[screenSingViewRef.TextP2DuetFourP].Visible  := V2DuetFourP and ScreenSing.Settings.AvatarsVisible;
  Text[screenSingViewRef.TextP3DuetFourP].Visible  := V3DuetFourP and ScreenSing.Settings.AvatarsVisible;
  Text[screenSingViewRef.TextP4DuetFourP].Visible  := V4DuetFourP and ScreenSing.Settings.AvatarsVisible;
  Text[screenSingViewRef.TextP1DuetSixP].Visible   := V1DuetSixP and ScreenSing.Settings.AvatarsVisible;
  Text[screenSingViewRef.TextP2DuetSixP].Visible   := V2DuetSixP and ScreenSing.Settings.AvatarsVisible;
  Text[screenSingViewRef.TextP3DuetSixP].Visible   := V3DuetSixP and ScreenSing.Settings.AvatarsVisible;
  Text[screenSingViewRef.TextP4DuetSixP].Visible   := V4DuetSixP and ScreenSing.Settings.AvatarsVisible;
  Text[screenSingViewRef.TextP5DuetSixP].Visible   := V5DuetSixP and ScreenSing.Settings.AvatarsVisible;
  Text[screenSingViewRef.TextP6DuetSixP].Visible   := V6DuetSixP and ScreenSing.Settings.AvatarsVisible;

  if ReadyCheck then
    UpdateReadyCheck;

  Result := screenSingViewRef.Draw();
end;

function TScreenSingController.FinishedMusic: boolean;
begin
  Result := AudioPlayback.Finished;
end;

procedure TScreenSingController.Finish;
var
  I, J:     integer;
  len, num: integer;

begin
  Log.LogStatus('TScreenSingController.Finish', 'TScreenSingController.Finish');
  AudioInput.CaptureStop;
  AudioPlayback.Stop;
  AudioPlayback.SetSyncSource(nil);

  if (ScreenSong.Mode = smNormal) and SungToEnd then
  begin
    SaveLocalScores;

    if (Length(DllMan.Websites) > 0) then
    begin
      AutoSendScore;
      AutoSaveScore;
    end;
  end;

  LyricsState.Stop();
  LyricsState.SetSyncSource(nil);

  // kill all stars and effects
  GoldenRec.KillAll;

  if (Ini.SavePlayback = 1) then
  begin
    Log.BenchmarkStart(0);
    Log.LogVoice(0);
    if (PlayersPlay > 1) then
      Log.LogVoice(1);
    if (PlayersPlay > 2) then
      Log.LogVoice(2);
    Log.BenchmarkEnd(0);
    Log.LogBenchmark('Creating files', 0);
  end;

  SetFontItalic(false);

  if ScreenSong.Mode = smMedley then
  begin
    if not FadeOut then
    begin
      if Length(PlaylistMedley.Stats) = 0 then
        UpdateMedleyStats(false);

      for I := 0 to PlayersPlay - 1 do
        PlaylistMedley.Stats[Length(PlaylistMedley.Stats) - 1].Player[I] := Player[I];

      Inc(PlaylistMedley.CurrentMedleySong);
      if PlaylistMedley.CurrentMedleySong <= PlaylistMedley.NumMedleySongs then
      begin
        LoadNextSong;
      end
      else
      begin
        //build sums
        len := Length(PlaylistMedley.Stats);
        num := PlaylistMedley.NumPlayer;

        SetLength(PlaylistMedley.Stats, len + 1);
        SetLength(PlaylistMedley.Stats[len].Player, num);
        for I := 0 to num - 1 do
        begin
          PlaylistMedley.Stats[len].Player[I].Name := PlaylistMedley.Stats[0].Player[I].Name;
          PlaylistMedley.Stats[len].Player[I].Level := PlaylistMedley.Stats[0].Player[I].Level;
          PlaylistMedley.Stats[len].Player[I].TeamID := PlaylistMedley.Stats[0].Player[I].TeamID;
          PlaylistMedley.Stats[len].Player[I].PlayerID := PlaylistMedley.Stats[0].Player[I].PlayerID;
          PlaylistMedley.Stats[len].Player[I].HighNote := -1;
          PlaylistMedley.Stats[len].Player[I].LengthNote := 0;
          SetLength(PlaylistMedley.Stats[len].Player[I].Note, 0);
          PlaylistMedley.Stats[len].Player[I].ResetScores;
        end;

        for J := 0 to len - 1 do
        begin
          for I := 0 to num - 1 do
          begin
            PlaylistMedley.Stats[len].Player[I].Score :=
              PlaylistMedley.Stats[len].Player[I].Score +
              PlaylistMedley.Stats[J].Player[I].Score;

            PlaylistMedley.Stats[len].Player[I].ScoreLine :=
              PlaylistMedley.Stats[len].Player[I].ScoreLine +
              PlaylistMedley.Stats[J].Player[I].ScoreLine;

            PlaylistMedley.Stats[len].Player[I].ScoreGolden :=
              PlaylistMedley.Stats[len].Player[I].ScoreGolden +
              PlaylistMedley.Stats[J].Player[I].ScoreGolden;
          end; //of for I
        end; //of for J

        //build mean on sum
        for I := 0 to num - 1 do
        begin
          PlaylistMedley.Stats[len].Player[I].Score := round(
            PlaylistMedley.Stats[len].Player[I].Score / len);

          PlaylistMedley.Stats[len].Player[I].ScoreLine := round(
            PlaylistMedley.Stats[len].Player[I].ScoreLine / len);

          PlaylistMedley.Stats[len].Player[I].ScoreGolden := round(
            PlaylistMedley.Stats[len].Player[I].ScoreGolden / len);
        end;

        Party.CallAfterSing;
        FadeOut:=true;
      end;
    end;
  end
  else
  begin
    SetLength(PlaylistMedley.Stats, 1);
    SetLength(PlaylistMedley.Stats[0].Player, PlayersPlay);
    for I := 0 to PlayersPlay - 1 do
      PlaylistMedley.Stats[0].Player[I] := Player[I];

    PlaylistMedley.Stats[0].SongArtist := CurrentSong.Artist;
    PlaylistMedley.Stats[0].SongTitle := CurrentSong.Title;

    if not FadeOut then
      Party.CallAfterSing;

    FadeOut := true;
  end;

end;

procedure TScreenSingController.OnSentenceEnd(Track: integer; SentenceIndex: cardinal); //ToDo: split and redo
var
  PlayerIndex: byte;
  CurrentPlayer: PPLayer;
  CurrentScore: real;
  Line:      PLine;
  LinePerfection: real;  // perfection of singing performance on the current line
  Rating:    integer;
  LineScore: real;
  LineBonus: real;
  MaxSongScore: integer; // max. points for the song (without line bonus)
  MaxLineScore: real;    // max. points for the current line
const
  // TODO: move this to a better place
  MAX_LINE_RATING = 8;        // max. rating for singing performance
begin
  Line := @CurrentSong.Tracks[Track].Lines[SentenceIndex];

  // check for empty sentence
  if Line.ScoreValue <= 0 then
    Exit;

  // set max song score
  MaxSongScore := MAX_SONG_SCORE - MAX_SONG_LINE_BONUS;

  // Note: ScoreValue is the sum of all note values of the song
  MaxLineScore := MaxSongScore * (Line.ScoreValue / CurrentSong.Tracks[Track].ScoreValue);

  for PlayerIndex := 0 to High(Player) do
  begin
    if (not CurrentSong.isDuet) or (Player[PlayerIndex].Track = Track) or (PlayersPlay = 1)then
    begin
      CurrentPlayer := @Player[PlayerIndex];
      CurrentScore  := CurrentPlayer.Score + CurrentPlayer.ScoreGolden;

      // line bonus

      // points for this line
      LineScore := CurrentScore - CurrentPlayer.ScoreLast;

      // check for lines with low points
      if MaxLineScore <= 2 then
        LinePerfection := 1
      else
        // determine LinePerfection
        // Note: the "+2" extra points are a little bonus so the player does not
        // have to be that perfect to reach the bonus steps.
        LinePerfection := LineScore / (MaxLineScore - 2);

      // clamp LinePerfection to range [0..1]
      if LinePerfection < 0 then
        LinePerfection := 0
      else if LinePerfection > 1 then
        LinePerfection := 1;

      // line-bonus points (same for each line, no matter how long the line is)
      LineBonus := MAX_SONG_LINE_BONUS / (Length(CurrentSong.Tracks[Track].Lines) -
        NumEmptySentences[Track]);
      // apply line-bonus
      CurrentPlayer.ScoreLine :=
        CurrentPlayer.ScoreLine + LineBonus * LinePerfection;

      // spawn rating pop-up
      Rating := Round(LinePerfection * MAX_LINE_RATING);
      Scores.SpawnPopUp(PlayerIndex, Rating, CurrentPlayer.ScoreTotalInt);

      // PerfectLineTwinkle (effect), part 1
      if Ini.EffectSing = 1 then
        CurrentPlayer.LastSentencePerfect := (LinePerfection >= 1);

      // refresh last score
      CurrentPlayer.ScoreLast := CurrentScore;
    end;
  end;

  // PerfectLineTwinkle (effect), part 2
  if Ini.EffectSing = 1 then
  begin
    GoldenRec.SpawnPerfectLineTwinkle;

    for PlayerIndex := 0 to High(Player) do
    begin
      CurrentPlayer := @Player[PlayerIndex];
      CurrentPlayer.LastSentencePerfect := false;
    end;
  end;

end;

 // Called on sentence change
 // SentenceIndex: index of the new active sentence
procedure TScreenSingController.OnSentenceChange(Track: integer; SentenceIndex: cardinal);  //ToDo: split and redo
var
  tmp_Lyric: TLyricEngine;
begin
  // goldenstarstwinkle
  GoldenRec.SentenceChange(Track);

  if (CurrentSong.isDuet) and (PlayersPlay <> 1) then
    tmp_Lyric := LyricsDuet[Track]
  else
    tmp_Lyric := Lyrics;

  // fill lyrics queue and set upper line to the current sentence
  while (tmp_Lyric.GetUpperLineIndex() < SentenceIndex) or
    (not tmp_Lyric.IsQueueFull) do
  begin
    // add the next line to the queue or a dummy if no more lines are available
    if (tmp_Lyric.LineCounter <= High(CurrentSong.Tracks[Track].Lines)) then
    begin
      tmp_Lyric.AddLine(@CurrentSong.Tracks[Track].Lines[tmp_Lyric.LineCounter]);
    end
    else
      tmp_Lyric.AddLine(nil);
  end;

end;

// tracks whose lines are followed and shown: all tracks of a duet sung by
// two or more players, also the tracks nobody sings, else the track of player 1
procedure TScreenSingController.GetShownTracks(out FirstTrack, LastTrack: integer);
begin
  if (CurrentSong.isDuet) and (PlayersPlay <> 1) then
  begin
    FirstTrack := 0;
    LastTrack := High(CurrentSong.Tracks);
  end
  else
  begin
    FirstTrack := Player[0].Track;
    LastTrack := FirstTrack;
  end;
end;

// player whose color the lyrics of the track get: the first player who sings
// the track, preferably one on the current screen. -1 if nobody sings it.
function TScreenSingController.TrackSinger(Track: integer): integer;
var
  PlayerIndex: integer;

  // with 4 or 6 players on 2 screens, each screen shows half of the players
  function OnScreen(PlayerIndex: integer): boolean;
  begin
    Result := (Screens = 1) or ((PlayersPlay <> 4) and (PlayersPlay <> 6)) or
              ((PlayerIndex < PlayersPlay div 2) = (ScreenAct = 1));
  end;

begin
  Result := -1;
  for PlayerIndex := 0 to PlayersPlay - 1 do
    if (Player[PlayerIndex].Track = Track) and
       ((Result = -1) or (not OnScreen(Result) and OnScreen(PlayerIndex))) then
      Result := PlayerIndex;
end;

function TLyricsSyncSource.GetClock(): real;
begin
  Result := LyricsState.GetCurrentTime();
end;

function TMusicSyncSource.GetClock(): real;
begin
  Result := AudioPlayback.Position;
end;

procedure TScreenSingController.UpdateMedleyStats(medley_end: boolean);   //TODO: view or controller? unsure
var
  len, num, I : integer;

begin
  len := Length(PlaylistMedley.Stats);
  num := PlaylistMedley.NumPlayer;

  if (PlaylistMedley.CurrentMedleySong > len) and
    (PlaylistMedley.CurrentMedleySong <= PlaylistMedley.NumMedleySongs) then
  begin
    inc(len);
    SetLength(PlaylistMedley.Stats, len);
    SetLength(PlaylistMedley.Stats[len - 1].Player, num);
    PlaylistMedley.Stats[len-1].SongArtist := CurrentSong.Artist;
    PlaylistMedley.Stats[len-1].SongTitle := CurrentSong.Title;
  end;

  if PlaylistMedley.CurrentMedleySong <= PlaylistMedley.NumMedleySongs then
    for I := 0 to num - 1 do
      PlaylistMedley.Stats[len - 1].Player[I] := Player[I];

  if medley_end and not PlaylistMedley.ApplausePlayed and
    (PlaylistMedley.CurrentMedleySong<=PlaylistMedley.NumMedleySongs) then
  begin
    PlaylistMedley.ApplausePlayed:=true;

    AudioPlayback.Fade(CurrentSong.Medley.FadeOut_time, 0.1);
    AudioPlayback.PlaySound(SoundLib.Applause);
  end;
end;


procedure TScreenSingController.SaveLocalScores;
var
  I: integer;
  Sung: boolean;
  Score: integer;
begin
  Sung := false;

  if ScreenSing.SungToEnd and (not CurrentSong.isDuet or (Ini.DuetScores = 1)) then
  begin
    for I := 0 to PlayersPlay - 1 do
    begin
      Score := Round(Player[I].ScoreTotalInt);
      if Score > 0 then
      begin
        DataBase.AddScore(CurrentSong, Player[I].Level, Length(CurrentSong.Tracks), 1 shl Player[I].Track, Player[I].Name, Score);
        Sung := true;
      end;
    end;
  end;

  if Sung then
    DataBase.WriteScore(CurrentSong);
end;

procedure TScreenSingController.AutoSendScore;
var
  SendInfo: TSendInfo;
  SendStatus: byte;
  Send: boolean;
  TotalScore: integer;
  PlayerIndex, IndexWeb, IndexUser: integer;
begin
  if CurrentSong.isDuet then
    Exit;

  for PlayerIndex := 1 to PlayersPlay do
  begin
    for IndexWeb := 0 to High(DataBase.NetworkUser) do
    begin
      for IndexUser := 0 to High(DataBase.NetworkUser[IndexWeb].Userlist) do
      begin
        Send := false;
        TotalScore := player[PlayerIndex - 1].ScoreTotalInt;

        case (player[PlayerIndex - 1].Level) of
          0: if (TotalScore >= DataBase.NetworkUser[IndexWeb].UserList[IndexUser].AutoScoreEasy)
              and (DataBase.NetworkUser[IndexWeb].UserList[IndexUser].AutoMode = 1)
              and (DataBase.NetworkUser[IndexWeb].UserList[IndexUser].AutoPlayer = PlayerIndex - 1) then
                Send := true;

          1: if (TotalScore >= DataBase.NetworkUser[IndexWeb].UserList[IndexUser].AutoScoreMedium)
              and (DataBase.NetworkUser[IndexWeb].UserList[IndexUser].AutoMode = 1)
              and (DataBase.NetworkUser[IndexWeb].UserList[IndexUser].AutoPlayer = PlayerIndex - 1) then
                Send := true;

          2: if (TotalScore >= DataBase.NetworkUser[IndexWeb].UserList[IndexUser].AutoScoreHard)
              and (DataBase.NetworkUser[IndexWeb].UserList[IndexUser].AutoMode = 1)
              and (DataBase.NetworkUser[IndexWeb].UserList[IndexUser].AutoPlayer = PlayerIndex - 1) then
                Send := true;
        end;

        if (Send) then
        begin

          DllMan.LoadWebsite(IndexWeb);

          SendInfo.Username := DataBase.NetworkUser[IndexWeb].UserList[IndexUser].Username;
          SendInfo.Password := DataBase.NetworkUser[IndexWeb].UserList[IndexUser].Password;
          SendInfo.ScoreInt := player[PlayerIndex - 1].ScoreInt;
          SendInfo.ScoreLineInt := player[PlayerIndex - 1].ScoreLineInt;
          SendInfo.ScoreGoldenInt := player[PlayerIndex - 1].ScoreGoldenInt;
          SendInfo.MD5Song := Act_MD5Song;
          SendInfo.Level := player[PlayerIndex - 1].Level;

          SendStatus := DllMan.WebsiteSendScore(SendInfo);

          case SendStatus of
            0: ScreenPopupError.ShowPopup(Language.Translate('WEBSITE_NO_CONNECTION'));
            2: ScreenPopupError.ShowPopup(Language.Translate('WEBSITE_LOGIN_ERROR'));
            3: ScreenPopupInfo.ShowPopup(Language.Translate('WEBSITE_OK_SEND'));
            4: ScreenPopupError.ShowPopup(Language.Translate('WEBSITE_ERROR_SCORE'));
            5: ScreenPopupError.ShowPopup(Language.Translate('WEBSITE_ERROR_SCORE_DUPLICATED'));
            7: ScreenPopupError.ShowPopup(Language.Translate('WEBSITE_ERROR_SONG'));
          end;

       end;
      end;
    end;
  end;
end;

procedure TScreenSingController.AutoSaveScore;
var
  SendInfo: TSendInfo;
  ScoreFile: TextFile;
  EncryptText: string;
  WebName: UTF8String;
  Save: boolean;
  TotalScore: integer;
  PlayerIndex, IndexWeb, IndexUser: integer;
begin
  if CurrentSong.isDuet then
    Exit;

  for PlayerIndex := 1 to PlayersPlay do
  begin
    for IndexWeb := 0 to High(DataBase.NetworkUser) do
    begin
      for IndexUser := 0 to High(DataBase.NetworkUser[IndexWeb].Userlist) do
      begin
        Save := false;
        TotalScore := player[PlayerIndex - 1].ScoreTotalInt;

        case (player[PlayerIndex - 1].Level) of
          0: if (TotalScore >= DataBase.NetworkUser[IndexWeb].UserList[IndexUser].AutoScoreEasy)
              and (DataBase.NetworkUser[IndexWeb].UserList[IndexUser].AutoMode = 2)
              and (DataBase.NetworkUser[IndexWeb].UserList[IndexUser].AutoPlayer = PlayerIndex - 1) then
                Save := true;

          1: if (TotalScore >= DataBase.NetworkUser[IndexWeb].UserList[IndexUser].AutoScoreMedium)
              and (DataBase.NetworkUser[IndexWeb].UserList[IndexUser].AutoMode = 2)
              and (DataBase.NetworkUser[IndexWeb].UserList[IndexUser].AutoPlayer = PlayerIndex - 1) then
                Save := true;

          2: if (TotalScore >= DataBase.NetworkUser[IndexWeb].UserList[IndexUser].AutoScoreHard)
              and (DataBase.NetworkUser[IndexWeb].UserList[IndexUser].AutoMode = 2)
              and (DataBase.NetworkUser[IndexWeb].UserList[IndexUser].AutoPlayer = PlayerIndex - 1) then
                Save := true;
        end;

        if (Save) then
        begin

          DllMan.LoadWebsite(IndexWeb);

          SendInfo.Username := DataBase.NetworkUser[IndexWeb].UserList[IndexUser].Username;
          SendInfo.Password := DataBase.NetworkUser[IndexWeb].UserList[IndexUser].Password;
          SendInfo.ScoreInt := player[PlayerIndex - 1].ScoreInt;
          SendInfo.ScoreLineInt := player[PlayerIndex - 1].ScoreLineInt;
          SendInfo.ScoreGoldenInt := player[PlayerIndex - 1].ScoreGoldenInt;
          SendInfo.MD5Song := Act_MD5Song;
          SendInfo.Level := player[PlayerIndex - 1].Level;

          WebName := DataBase.NetworkUser[IndexWeb].Website;
          EncryptText := DllMan.WebsiteEncryptScore(SendInfo);

          AssignFile(ScoreFile, WebScoresPath.Append(WebName + '.usc').ToNative);

          if FileExists(WebScoresPath.Append(WebName + '.usc').ToNative) then
            Append(ScoreFile)
          else
            Rewrite(ScoreFile);

          WriteLn(ScoreFile, DatetoStr(Now) + '|' + TimetoStr(Now) + '|' + EncryptText);

          Flush(ScoreFile);
          Close(ScoreFile);

          ScreenPopupInfo.ShowPopup(Language.Translate('WEBSITE_SAVE_SCORE'));

       end;
      end;
    end;
  end;
end;

end.
