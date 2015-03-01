#Region AutoIt3Wrapper 预编译参数(常用参数)
#AutoIt3Wrapper_Icon=res\app.ico							;图标,支持EXE,DLL,ICO
#AutoIt3Wrapper_OutFile=									;输出文件名
#AutoIt3Wrapper_OutFile_Type=exe							;文件类型
#AutoIt3Wrapper_Compression=4								;压缩等级
#AutoIt3Wrapper_UseUPX=y 									;使用压缩
#AutoIt3Wrapper_Res_Comment= 								;注释
#AutoIt3Wrapper_Res_Description=							;详细信息
#AutoIt3Wrapper_Res_FileVersion=							;文件版本
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=p				;自动更新版本
#AutoIt3Wrapper_Res_LegalCopyright= 						;版权
#AutoIt3Wrapper_Change2CUI=N                   				;修改输出的程序为CUI(控制台程序)
;#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%		;自定义资源段
;#AutoIt3Wrapper_Run_Tidy=                   				;脚本整理
;#AutoIt3Wrapper_Run_Obfuscator=      						;代码迷惑
;#AutoIt3Wrapper_Run_AU3Check= 								;语法检查
;#AutoIt3Wrapper_Run_Before= 								;运行前
;#AutoIt3Wrapper_Run_After=									;运行后
#EndRegion AutoIt3Wrapper 预编译参数(常用参数)
#cs ＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿
	
	Au3 版本:
	脚本作者:  计嵌入式09001班 李超
	Email:  lich09@nou.com.cn
	QQ/TM:
	脚本版本:
	脚本功能:
	
#ce ＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿脚本开始＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>

FileInstall(".\res\login.jpg", @TempDir & "\")

Func _loginmain()
	
	Local $loginForm, $backgroundPic, $uidInput, $pwInput, $loginButton, $MARGINS, $uid, $pw
	
	$loginForm = GUICreate("用户登录", 384, 240, -1, -1, $GUI_SS_DEFAULT_GUI, $WS_EX_LAYERED)
	$backgroundPic = GUICtrlCreatePic(@TempDir & "\login.jpg", 0, 0, 141, 240)

	GUICtrlCreateLabel("用户名", 160, 30, 60, 30)
	GUICtrlSetFont(-1, 15, 400, 0, "微软雅黑", 3)
	$uidInput = GUICtrlCreateInput("", 230, 30, 135, 30)
	GUICtrlSetFont(-1, 15, 400, 0, "微软雅黑")
	GUICtrlCreateLabel("密   码", 160, 80, 60, 30)
	GUICtrlSetFont(-1, 15, 400, 0, "微软雅黑", 3)
	$pwInput = GUICtrlCreateInput("", 230, 80, 135, 30, $ES_PASSWORD)
	GUICtrlSetFont(-1, 15, 400, 0, "微软雅黑")

	$loginButton = GUICtrlCreateButton("登  录", 197, 140, 140, 90)
	GUICtrlSetFont(-1, 30, 400, 0, "微软雅黑")

	GUISetBkColor(0xA4D4D3)
	_WinAPI_SetLayeredWindowAttributes($loginForm, 0xA4D4D3, 255)
	$MARGINS = DllStructCreate("int;int;int;int")
	DllStructSetData($MARGINS, 1, -1)
	DllCall("dwmapi.dll", "none", "DwmExtendFrameIntoClientArea", "hwnd", $loginForm, "ptr", DllStructGetPtr($MARGINS))
	GUISetState(@SW_SHOW)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				FileDelete(@TempDir & "\login.jpg")
				Exit
			Case $loginButton
				$uid = GUICtrlRead($uidInput)
				$pw = GUICtrlRead($pwInput)
				If _checkUidPw($uid, $pw) Then
					GUISetState(@SW_HIDE, $loginForm)
					Return True
				Else
					MsgBox(0x40, "错误", "用户名或密码错误!")
				EndIf
		EndSwitch
	WEnd

EndFunc   ;==>_loginmain

Func _checkUidPw($uid, $pw)
	
	If $uid = "admin" And $pw = "admin" Then
		Return True
	Else
		Return False
	EndIf
	
EndFunc   ;==>_checkUidPw
