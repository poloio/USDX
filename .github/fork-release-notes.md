UltraStar Deluxe with songs for 3 to 6 singers. This build comes from a fork of the official game. It is not an
official release.

![3 players sing a song with 3 parts](https://github.com/poloio/USDX/raw/@TAG@/doc/multi-part-songs/sing-3-players.jpg)

## What is new

- A song can have up to 6 parts (`P1` to `P6`). Each player sings one part, with their own notes, lyrics, and score.
- With 3 or more parts, the lyrics of the parts show side by side. Each part shows its next line below its current line.
- If players share a part, color marks next to the lyrics show who sings each part. This also helps in duets with 3 or more players.
- The song list shows the part of each player. <kbd>Space</kbd> in the song list rotates the parts of all players. The keys <kbd>1</kbd> to <kbd>6</kbd> give that player the next part, so players can choose their part.
- The lyrics of each part show near the notes of its singers, also with 4 and 6 players.
- Parts that nobody sings show in gray, without a score.
- Ready check: with 2 or more players, each player sings a note into their microphone (or presses their number) before the song starts. A panel over each note row shows the avatar, color, and part of the player.
- Part cues: before a part sings again after a pause, its lyrics light up in the color of its player. Parts that do not sing for a while fade out. <kbd>C</kbd> during the song changes the cues.
- Lyrics in the Dark Blue player color use a lighter blue, so they are easy to read.
- The song editor opens, edits, and saves songs with 3 to 6 parts.
- Fixed: the song editor crashed on undo after switching duet parts. Songs with an empty line after the header showed as solo songs in the song list.
- Solo songs and duet songs work as before.

Details: [Songs with 3 to 6 parts](https://github.com/poloio/USDX/blob/@TAG@/doc/multi-part-songs/README.md)

## Install

### Windows, portable version

1. Download `UltraStarDeluxe-fork-windows-portable-@TAG@.zip`.
2. Extract the zip file into a new, empty folder.
3. Start `ultrastardx.exe` in that folder.

The portable version keeps its settings and scores in its own folder. It does not change an installed UltraStar Deluxe.

### Windows, installer

1. Download `UltraStarDeluxe-fork-windows-installer-@TAG@.exe`.
2. Start the installer.

The installer can replace an installed official version. To keep both versions, use the portable version.

### Linux

1. Download `UltraStarDeluxe-fork-linux-@TAG@.AppImage`.
2. Make the file executable: `chmod +x UltraStarDeluxe-fork-linux-@TAG@.AppImage`
3. Start the file.

The AppImage uses the same settings folder as the official game (`~/.ultrastardx`).

## Try it

Copy the [demo song](https://github.com/poloio/USDX/tree/@TAG@/doc/multi-part-songs/demo-song) into your song
folder. It is a round for three voices, with public domain melody and lyrics.

## Known limits

- There is no macOS build.
- The official UltraStar Deluxe cannot load songs with more than 2 parts.
- These items have no tests yet: scores with real microphones, and two screens.

Source: branch [`trio`](https://github.com/poloio/USDX/tree/trio), commit @SHA@.
