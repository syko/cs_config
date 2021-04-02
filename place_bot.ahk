; Hotkey for placing bots at player position using bot ids 2-11 in a cycle
; Requires -condebug launch option
; Created by syko

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

LogPath := "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo\console.log"
BotId := 0

TruncateLog()

#If WinActive("ahk_exe csgo.exe")
    ^NumpadClear::
        PlaceBot()
    return
#If

TruncateLog()
{
  global LogPath
  FileToErase := FileOpen(LogPath, "w")
  FileToErase.Write("")
  FileToErase.Close()
}

PlaceBot()
{
  global LogPath, BotId

  LogFile := FileOpen(LogPath, "r")
  LogFile.Seek(0, 2)

  SendInput ``
  Sleep, 250
  SendInput getpos_exact {enter}
  Sleep, 100

  while (LastLine := LogFile.ReadLine()) {
    if (RegExMatch(LastLine,"i)^setpos_exact ([0-9.\s-]+);", Pos)) {
      ActualBotId := BotId + 2 ; Bot Ids are between 2 and 11
      SendInput setpos_player %ActualBotId% %Pos1% {enter}
      BotId := Mod(BotId + 1, 10)
    }
  }

  Sleep, 100
  SendInput ``
  LogFile.Close()

}