#Region AutoIt3Wrapper Ԥ�������(���ò���)
#AutoIt3Wrapper_Icon=app.ico							;ͼ��,֧��EXE,DLL,ICO
#AutoIt3Wrapper_OutFile=									;����ļ���
#AutoIt3Wrapper_OutFile_Type=exe							;�ļ�����
#AutoIt3Wrapper_Compression=4								;ѹ���ȼ�
#AutoIt3Wrapper_UseUPX=y 									;ʹ��ѹ��
#AutoIt3Wrapper_Res_Comment= 								;ע��
#AutoIt3Wrapper_Res_Description=							;��ϸ��Ϣ
#AutoIt3Wrapper_Res_FileVersion=							;�ļ��汾
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=p				;�Զ����°汾
#AutoIt3Wrapper_Res_LegalCopyright= 						;��Ȩ
#AutoIt3Wrapper_Change2CUI=N                   				;�޸�����ĳ���ΪCUI(����̨����)
;#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%		;�Զ�����Դ��
;#AutoIt3Wrapper_Run_Tidy=                   				;�ű�����
;#AutoIt3Wrapper_Run_Obfuscator=      						;�����Ի�
;#AutoIt3Wrapper_Run_AU3Check= 								;�﷨���
;#AutoIt3Wrapper_Run_Before= 								;����ǰ
;#AutoIt3Wrapper_Run_After=									;���к�
#EndRegion AutoIt3Wrapper Ԥ�������(���ò���)
#cs �ߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣ�
	
	Au3 �汾:
	�ű�����:  BY:SOVOɭ��
	Email:  lich09@nou.com.cn
	QQ/TM:  1603213522
	�ű��汾:
	�ű�����:
	
#ce �ߣߣߣߣߣߣߣߣߣߣߣߣߣߣ߽ű���ʼ�ߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣ�
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GUIConstants.au3>
#include <ButtonConstants.au3>
#include <WinAPI.au3>
#include <Process.au3>

Opt("GUIOnEventMode", 1)

FileInstall(".\background.jpg", @TempDir & "\")
FileInstall(".\close.jpg", @TempDir & "\")
FileInstall(".\to.jpg", @TempDir & "\")
FileInstall(".\stop.jpg", @TempDir & "\")
FileInstall(".\start.jpg", @TempDir & "\")

Dim $MainForm, $BackgroundPic, $MinNumInput, $MaxNumInput, $StartBut, $StopBut, $ToBut, $ExitBut, $User32Dll
Dim $Number[1], $MinNumRead, $MaxNumRead, $LuckyNumShow, $i, $j, $total, $iStart

$User32Dll = DllOpen("user32.dll")

$MainForm = GUICreate("LuckyNum", 424, 600, -1, -1, BitOR($WS_POPUP, $WS_CLIPSIBLINGS))
GUISetOnEvent(-3, "_Exit")
$BackgroundPic = GUICtrlCreatePic(@TempDir & "\background.jpg", 0, 0, 424, 600, $WS_CLIPSIBLINGS)

$ExitBut = GUICtrlCreatePic(@TempDir & "\close.jpg", 374, 0, 50, 50)
GUICtrlSetOnEvent(-1, "_Exit")
$ToBut = GUICtrlCreatePic(@TempDir & "\to.jpg", 196, 289, 32, 33)
$StartBut = GUICtrlCreatePic(@TempDir & "\start.jpg", 140, 361, 149, 44)
GUICtrlSetOnEvent(-1, "_Start")

$MinNumInput = GUICtrlCreateInput("1", 120, 289, 56, 33, $ES_CENTER)
GUICtrlSetFont(-1, 15, 400, 0, "΢���ź�")
$MaxNumInput = GUICtrlCreateInput("255", 246, 289, 56, 33, $ES_CENTER)
GUICtrlSetFont(-1, 15, 400, 0, "΢���ź�")

DllCall($User32Dll, "int", "AnimateWindow", "hwnd", $MainForm, "int", 1500, "long", 0x00080000)

GUISetState(@SW_SHOW)

While 1
	Sleep(20)
	If $iStart Then
		GUICtrlSetData($LuckyNumShow, Random($MinNumRead, $MaxNumRead, 1))
	EndIf
WEnd

Func _Start()
	
	$StopBut = GUICtrlCreatePic(@TempDir & "\stop.jpg", 140, 361, 149, 44, -1, $GUI_ONTOP)
	GUICtrlSetOnEvent(-1, "_Stop")
	
	$MinNumRead = GUICtrlRead($MinNumInput)
	$MaxNumRead = GUICtrlRead($MaxNumInput)
	
	GUICtrlDelete($StartBut)
	GUICtrlDelete($ToBut)
	GUICtrlDelete($MinNumInput)
	GUICtrlDelete($MaxNumInput)
	
	$total = $MaxNumRead - $MinNumRead + 1
	
	ReDim $Number[$total]
	$j = 0
	For $i = $MinNumRead To $MaxNumRead Step 1
		$Number[$j] = $i
		$j += 1
	Next
	
	$LuckyNumShow = GUICtrlCreateLabel("", 150, 259, 120, 80, $ES_CENTER)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont(-1, 50, 400, 0, "΢���ź�", 3)
	
	$iStart = 1
	
EndFunc   ;==>_Start

Func _Restart()
	
	$iStart = 1
	
	$StopBut = GUICtrlCreatePic(@TempDir & "\stop.jpg", 140, 361, 149, 44, -1, $GUI_ONTOP)
	GUICtrlSetOnEvent(-1, "_Stop")
	
	GUICtrlDelete($StartBut)
	
EndFunc   ;==>_Restart

Func _Stop()
	
	$iStart = 0
	
	$StartBut = GUICtrlCreatePic(@TempDir & "\start.jpg", 140, 361, 149, 44, -1, $GUI_ONTOP)
	GUICtrlSetOnEvent(-1, "_Restart")
	
	GUICtrlDelete($StopBut)
	
EndFunc   ;==>_Stop

Func _Exit()
	
	FileDelete(@TempDir & "\background.jpg")
	FileDelete(@TempDir & "\close.jpg")
	FileDelete(@TempDir & "\to.jpg")
	FileDelete(@TempDir & "\start.jpg")
	FileDelete(@TempDir & "\stop.jpg")
	
	DllCall($User32Dll, "int", "AnimateWindow", "hwnd", $MainForm, "int", 1000, "long", 0x00050010)
	
	DllClose($User32Dll)
	
	Exit
EndFunc   ;==>_Exit

