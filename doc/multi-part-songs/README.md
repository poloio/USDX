# Songs with 3 to 6 parts

A song can have up to six parts, `P1` to `P6`. Each player sings one part. Each part has its own notes,
its own lyrics, and its own score. Duet songs (`P1` and `P2`) and solo songs work as before.

The official UltraStar Deluxe supports only `P1` and `P2`. This fork adds `P3` to `P6`. The source code
calls a part a "track".

![3 players sing a song with 3 parts](sing-3-players.jpg)

## Song file format

A song with parts uses the same format as a duet song. Two changes apply:

- The header can name the parts `#P3` to `#P6`, in addition to `#P1` and `#P2`.
- The note section can contain the part markers `P3` to `P6`, in addition to `P1` and `P2`.

Example: the start of the [demo song](demo-song/song.txt), a round for three voices.

```
#VERSION:1.1.0
#TITLE:Row, Row, Row Your Boat (round for 3 voices)
#ARTIST:Traditional
#AUDIO:audio.ogg
#BPM:300
#GAP:2000
#P1:Voice 1
#P2:Voice 2
#P3:Voice 3
P1
: 0 11 0 Row,
: 12 11 0  row,
...
P2
: 48 11 0 Row,
...
P3
: 96 11 0 Row,
...
E
```

### Header

| Header | Function |
|---|---|
| `#P1` to `#P6` | The name of the part, for example the name of the singer. The default name is `P1` to `P6`. |
| `#DUETSINGERP1` to `#DUETSINGERP6` | The old name of the same header. The game reads it only for format versions before 1.0.0. If a file has both headers, the game uses `#Pn`. |

### Note section

- The first line of the note section must be a part marker. Otherwise the song is a solo song.
- A part marker is a line with `P1` to `P6`. The game also accepts a space after the `P` (`P 3`).
- The notes after a part marker belong to that part, until the next part marker.
- The parts can be in any sequence. Every part from `P1` to the highest part must have notes.

The song does not load in these conditions:

- A part marker is higher than `P6`. The log shows `Wrong P-Number`.
- A part has no notes, for example a song with `P1` and `P3` but no `P2`.

### Compatibility

- The official UltraStar Deluxe (version 2026.10 and older) does not load a song with `P3` or higher.
  The song shows in the song list, but it does not start.
- Songs with 1 or 2 parts are not changed. The fork reads and plays them the same as the official game.
- Some older duet files use `P3` for the lines that both singers sing. The official game does not load these
  files. The fork loads them as songs with 3 parts. With 2 players, no player sings the `P3` lines.

The format project discussed songs with more parts in
[UltraStar-Deluxe/format#17](https://github.com/UltraStar-Deluxe/format/issues/17). This fork uses the
`P1` to `Pn` approach from that discussion. Each part contains all of its lines, also the lines that all
singers sing. No part has a special meaning, for example "all singers".

## Players and parts

Player 1 sings `P1`, player 2 sings `P2`, and so on. If there are more players than parts, the parts start
again from `P1`.

| Players | Song with 2 parts | Song with 3 parts |
|---|---|---|
| 1 | `P1` (solo screen) | `P1` (solo screen) |
| 2 | `P1`, `P2` | `P1`, `P2` (`P3` is not sung) |
| 3 | `P1`, `P2`, `P1` | `P1`, `P2`, `P3` |
| 4 | `P1`, `P2`, `P1`, `P2` | `P1`, `P2`, `P3`, `P1` |
| 6 | `P1`, `P2`, `P1`, `P2`, `P1`, `P2` | `P1`, `P2`, `P3`, `P1`, `P2`, `P3` |

A part that no player sings does not show on the sing screen and does not get a score.

To change who sings which part, push <kbd>Space</kbd> in the song list. Each player then sings the next
part: player 1 sings `P2`, player 2 sings `P3`, and the player of the last part sings `P1`. With two parts,
this is the same as the duet swap of the official game.

## Sing screen

The layout of the note rows is the same as for duets. It depends on the number of players.

The layout of the lyrics depends on the number of sung parts:

| Sung parts | Lyrics |
|---|---|
| 1 | The solo lyrics bar. |
| 2 | The two duet lyrics bars of the theme, as for duets. |
| 3 to 6 | The first half of the parts uses the upper duet bar. The other parts use the lower duet bar. Parts in the same bar show side by side. |

Each part shows its current line, with its next line below. The text of the current line uses the color
of the player. If a line is too long for its part of the bar, the game makes the font smaller.

The fork uses the duet lyrics bars of the theme. Themes do not need new sections.

### Color marks

If there are more players than parts, some players share a part. Then each part shows a color mark for
each player who sings it, to the right of its lyrics. Each player can find the lyrics of their part from
the color. The marks also show for duets with 3 or more players. With one player for each part, the game
shows no marks.

![4 players sing a song with 3 parts](sing-4-players.jpg)

## Song list

The song list shows the name of the part that each player sings. With 4 players and a song with 3 or more
parts, the list shows three parts. A color mark shows that player 4 also sings `P1`.

![The song list shows the part of each player](song-list.jpg)

To find the number of parts, the song list reads the part markers of each duet file. It does not read
the notes.

## Scores

- Each player gets a score for their own part.
- Each part has the full maximum score, also when one part has fewer notes than another part.
- The game calculates the line bonus for each part.
- The highscore list keeps the part of each score. It shows the part after the name, for example
  `Ana (P3)`.

## Song editor

The song editor does not open a song with more than two parts. It shows a message. This prevents a save
that removes parts `P3` to `P6`. When the song editor saves a duet, it writes a `#Pn` header for each part.

## Other game modes

Medley mode, the party modes, and the jukebox use songs with 3 or more parts the same as duets.

## Try the demo song

The folder [demo-song](demo-song) has a song for three voices: "Row, Row, Row Your Boat" as a round. The
melody and the lyrics are in the public domain. The audio uses synthesized tones.

1. Copy the folder `demo-song` into your song folder.
2. Start the game.
3. In the player setup, set the number of players to 3.
4. In the song list, select "Row, Row, Row Your Boat (round for 3 voices)".
5. Start the song.

Each voice starts two bars after the previous voice.

## For developers

The changes are in these units:

| Unit | Change |
|---|---|
| `src/base/UMusic.pas` | The constant `MAX_SONG_TRACKS` (6). |
| `src/base/USong.pas` | The parser adds a track when it finds `P3` to `P6`. It reads `#P3` to `#P6` and `#DUETSINGERP3` to `#DUETSINGERP6`. The field `TrackCount` gives the number of parts. The header scan of the song list also sets it. With `DuetChange`, the parser rotates the tracks. |
| `src/base/UNote.pas` | The part of a player is `PlayerIndex mod TrackCount`. `Sing` updates the current line of each sung part. |
| `src/base/UGraphicClasses.pas` | The golden note effects use the part of each player. |
| `src/screens/controllers/UScreenSingController.pas` | One lyric engine for each part (`LyricsDuet`), not two. `SungTrackCount` gives the number of parts that players sing. `OnSentenceEnd` calculates the line bonus for each part. |
| `src/screens/views/UScreenSingView.pas` | `SetDuetLyricsLayout` sets the position of the lyrics for 2 and for 3 or more parts. |
| `src/base/UDraw.pas` | Draws the lyrics of each sung part, the note rows of each player's part, and the color marks. |
| `src/screens/UScreenSong.pas` | The part name of each player. The layout for 4 players and 3 or more parts. The song editor check. |
| `src/base/UFiles.pas` | Writes a `#Pn` header for each part. |
| `src/base/UDataBase.pas` | The number of parts for highscores comes from `TrackCount`. |
| `game/languages` | The message `ERROR_MULTI_TRACK_NOT_EDITABLE`. |

The score database did not change. It already keeps the number of parts (`TrackCount`) and the part of
each score (`TrackMask`).

### Tests

The tests used automatic runs of the game without a visible window (Xvfb), with screenshots:

- A song with 3 parts, with 1, 2, 3, 4, and 6 players.
- The rotation of parts with <kbd>Space</kbd>.
- The Modern theme and the Deluxe theme.
- A duet song with 2, 3, and 4 players, and with the duet swap.
- A solo song with 1 and 3 players.
- The song editor message for a song with 3 parts.

The tests compared the duet and solo screens with the screens of the unmodified game. They were the same,
except for the new color marks.

These items were not tested: scores with real microphones (the automatic runs have no microphone input),
two screens, and macOS.
