#Region ;**** 参数创建于 ACNWrapper_GUI ****
#AutoIt3Wrapper_icon=000.ico
#AutoIt3Wrapper_outfile=C:\Users\hp\Desktop\AU3\新建文件夹\w7theme@think.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Fileversion=3.3.6.10
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
#EndRegion ;**** 参数创建于 ACNWrapper_GUI ****
#Region AutoIt3Wrapper 预编译参数(常用参数)
;#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%		;自定义资源段
;#AutoIt3Wrapper_Run_Tidy=                   				;脚本整理
;#AutoIt3Wrapper_Run_Obfuscator=      						;代码迷惑
;#AutoIt3Wrapper_Run_AU3Check= 								;语法检查
;#AutoIt3Wrapper_Run_Before= 								;运行前
;#AutoIt3Wrapper_Run_After=									;运行后
#EndRegion AutoIt3Wrapper 预编译参数(常用参数)
#cs ＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿
	
	Au3 版本:
	脚本作者:
	Email:
	QQ/TM:
	脚本版本:
	脚本功能:
	
#ce ＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿脚本开始＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿

#include <Process.au3>
#include <GUIConstants.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEX.au3>
#include <WindowsConstants.au3>

Dim $MainForm, $Button[10] ;窗体,按钮
Dim $w7theme ;背景
Dim $dll ;dll挂载
Dim $money ;捐助
Dim $edcmp[4] ;比较exe,dll

;调用所需
FileInstall(".\beijing.jpg", @TempDir & "\beijing.jpg", 1)
FileInstall(".\0explorer.bat", @TempDir & "\0explorer.bat", 1)
FileInstall(".\0explorer.vbs", @TempDir & "\0explorer.vbs", 1)
FileInstall(".\0ExplorerFrame.bat", @TempDir & "\0ExplorerFrame.bat", 1)
FileInstall(".\0ExplorerFrame.vbs", @TempDir & "\0ExplorerFrame.vbs", 1)
FileInstall(".\0LogonUI.bat", @TempDir & "\0LogonUI.bat", 1)
FileInstall(".\0LogonUI.vbs", @TempDir & "\0LogonUI.vbs", 1)
FileInstall(".\explorer.bat", @TempDir & "\explorer.bat", 1)
FileInstall(".\explorer.vbs", @TempDir & "\explorer.vbs", 1)
FileInstall(".\ExplorerFrame.bat", @TempDir & "\ExplorerFrame.bat", 1)
FileInstall(".\ExplorerFrame.vbs", @TempDir & "\ExplorerFrame.vbs", 1)
FileInstall(".\LogonUI.bat", @TempDir & "\LogonUI.bat", 1)
FileInstall(".\LogonUI.vbs", @TempDir & "\LogonUI.vbs", 1)
FileInstall(".\Win7Logon.exe", @TempDir & "\Win7Logon.exe", 1)

$dll = DllOpen("user32.dll")

;主窗口
$MainForm = GUICreate("w7theme@think", 642, 402, -1, -1, BitOR($WS_POPUP, $WS_CLIPSIBLINGS))
$w7theme = GUICtrlCreatePic(@TempDir & "\beijing.jpg", 0, 0, 642, 402, 0x04000000)

;淡入代码
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $MainForm, "int", 1500, "long", 0x00080000)

;按钮代码
$Button[0] = GUICtrlCreateButton("美化", 145, 115, 90, 50)
GUICtrlSetFont(-1, 20, 400, 0, "微软雅黑")
$Button[1] = GUICtrlCreateButton("美化", 145, 190, 90, 50)
GUICtrlSetFont(-1, 20, 400, 0, "微软雅黑")
$Button[2] = GUICtrlCreateButton("美化", 145, 265, 90, 50)
GUICtrlSetFont(-1, 20, 400, 0, "微软雅黑")
$Button[3] = GUICtrlCreateButton("还原", 255, 115, 90, 50)
GUICtrlSetFont(-1, 20, 400, 0, "微软雅黑")
$Button[4] = GUICtrlCreateButton("还原", 255, 190, 90, 50)
GUICtrlSetFont(-1, 20, 400, 0, "微软雅黑")
$Button[5] = GUICtrlCreateButton("还原", 255, 265, 90, 50)
GUICtrlSetFont(-1, 20, 400, 0, "微软雅黑")
$Button[6] = GUICtrlCreateButton("更改登录界面", 400, 360, 90, 25)
GUICtrlSetFont(-1, 10, 400, 0, "微软雅黑")
$Button[7] = GUICtrlCreateButton("抖抖", 510, 360, 40, 25)
GUICtrlSetFont(-1, 10, 400, 0, "微软雅黑")
$Button[8] = GUICtrlCreateButton("囧", 600, 15, 25, 25)
GUICtrlSetFont(-1, 10, 400, 0, "微软雅黑")
$Button[9] = GUICtrlCreateButton("退出", 570, 360, 40, 25)
GUICtrlSetFont(-1, 10, 400, 0, "微软雅黑")

GUISetState(@SW_SHOW)

While 1
	
	;比较explorer.exe是否替换
	$edcmp[0] = FileGetSize(@ProgramFilesDir & "\w7theme@think\xiu\explorer.exe")
	$edcmp[1] = FileGetSize(@WindowsDir & "\explorer.exe")
	If $edcmp[0] <> $edcmp[1] Then
		ControlEnable("w7theme@think", "", $Button[0]) ;不同美化为开启
		ControlDisable("w7theme@think", "", $Button[3]) ;不同恢复为灰色
	Else
		ControlDisable("w7theme@think", "", $Button[0]) ;相同美化为灰色
		ControlEnable("w7theme@think", "", $Button[3]) ;相同恢复为开启
	EndIf
	
	;比较ExplorerFrame.dll是否替换
	$edcmp[2] = FileGetSize(@ProgramFilesDir & "\w7theme@think\xiu\ExplorerFrame.dll")
	$edcmp[3] = FileGetSize(@WindowsDir & "\system32\ExplorerFrame.dll")
	If $edcmp[2] <> $edcmp[3] Then
		ControlEnable("w7theme@think", "", $Button[2]) ;不同美化为开启
		ControlDisable("w7theme@think", "", $Button[5]) ;不同恢复为灰色
	Else
		ControlDisable("w7theme@think", "", $Button[2]) ;相同美化为灰色
		ControlEnable("w7theme@think", "", $Button[5]) ;相同恢复为开启
	EndIf
	
	;按钮消息
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $Button[0]
			ShellExecute(@TempDir & "\explorer.vbs", "", @TempDir)
		Case $Button[1]
			ShellExecute(@TempDir & "\LogonUI.vbs", "", @TempDir)
		Case $Button[2]
			ShellExecute(@TempDir & "\ExplorerFrame.vbs", "", @TempDir)
		Case $Button[3]
			ShellExecute(@TempDir & "\0explorer.vbs", "", @TempDir)
		Case $Button[4]
			ShellExecute(@TempDir & "\0LogonUI.vbs", "", @TempDir)
		Case $Button[5]
			ShellExecute(@TempDir & "\0ExplorerFrame.vbs", "", @TempDir)
		Case $Button[6]
			ShellExecute(@TempDir & "\Win7Logon.exe", "", @TempDir)
		Case $Button[7]
			Jitter()
		Case $Button[8]
			$money = MsgBox(1,"我点到什么东西了?","如果您愿意赞助SOVO森科继续开发,请点确定."&@CRLF&@CRLF&"当然,我们是免费的.我知道您没看到这个对话框里面的内容.嘿嘿.", 0x0)
			Select
				Case $money = 1
					ShellExecute("C:\Program Files\Internet Explorer\IEXPLORE.EXE","http://llwslc.taobao.com/")
			EndSelect
		Case $Button[9]
			DllCall($dll, "int", "AnimateWindow", "hwnd", $MainForm, "int", 1000, "long", 0x00050010)
			DllClose($dll)
			
			FileDelete(@TempDir & "\beijing.jpg")
			FileDelete(@TempDir & "\0explorer.bat")
			FileDelete(@TempDir & "\0explorer.vbs")
			FileDelete(@TempDir & "\0ExplorerFrame.bat")
			FileDelete(@TempDir & "\0ExplorerFrame.vbs")
			FileDelete(@TempDir & "\0LogonUI.bat")
			FileDelete(@TempDir & "\0LogonUI.vbs")
			FileDelete(@TempDir & "\explorer.bat")
			FileDelete(@TempDir & "\explorer.vbs")
			FileDelete(@TempDir & "\ExplorerFrame.bat")
			FileDelete(@TempDir & "\ExplorerFrame.vbs")
			FileDelete(@TempDir & "\LogonUI.bat")
			FileDelete(@TempDir & "\LogonUI.vbs")
			FileDelete(@TempDir & "\Win7Logon.exe")

			Exit
	EndSwitch
WEnd

;窗口抖动代码
Func Jitter()
	Dim $i
	$sCoor = WinGetPos($MainForm)
	For $i = 1 To 4
		WinMove($MainForm, "", $sCoor[0] + 3, $sCoor[1] - 3, Default, Default, 1)
		WinMove($MainForm, "", $sCoor[0], $sCoor[1] - 6, Default, Default, 1)
		WinMove($MainForm, "", $sCoor[0] - 3, $sCoor[1] - 3, Default, Default, 1)
		WinMove($MainForm, "", $sCoor[0], $sCoor[1], Default, Default, 1)
	Next
EndFunc   ;==>Jitter
