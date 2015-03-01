#Region AutoIt3Wrapper 预编译参数(常用参数)
#AutoIt3Wrapper_Icon=res\app.ico							;图标,支持EXE,DLL,ICO
#AutoIt3Wrapper_OutFile=数据库管理软件.exe					;输出文件名
#AutoIt3Wrapper_OutFile_Type=exe							;文件类型
#AutoIt3Wrapper_Compression=4								;压缩等级
#AutoIt3Wrapper_UseUPX=y 									;使用压缩
#AutoIt3Wrapper_Res_Comment= 								;注释
#AutoIt3Wrapper_Res_Description=							;详细信息
#AutoIt3Wrapper_Res_FileVersion=1.0.0.0
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=p				;自动更新版本
#AutoIt3Wrapper_Res_LegalCopyright=计嵌入式09001班 李超		;版权
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
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <WinAPI.au3>

#include <.\sqloperate.au3>
#include <.\login.au3>

FileInstall(".\res\bkhead.jpg", @TempDir & "\")

_checkLoginmain()


Func _checkLoginmain()
	If _loginmain() Then
		_mainMenu()
	EndIf
EndFunc   ;==>_checkLoginmain

Func _mainMenu()
	
	Local $mainMenu, $bkHead, $reReadBut, $readBut, $insertBut, $deleteBut, $updateBut, $selectBut
	Local $SQLdsn, $SQLdsnInput, $SQLdsnCheck, $SQLdsnConnect, $SQLtab
	
	$mainMenu = GUICreate("数据库操作", 300, 480, -1, -1, $GUI_SS_DEFAULT_GUI, $WS_EX_LAYERED)
	$bkHead = GUICtrlCreatePic(@TempDir & "\bkhead.jpg", 0, 0, 300, 70)
	
	$readBut = GUICtrlCreateButton("读取", 0, 75, 40, 25)
	$reReadBut = GUICtrlCreateButton("刷新", 52, 75, 40, 25) ;先添加后删除,$nMsg会得到此控件消息
	GUICtrlDelete($reReadBut)
	$insertBut = GUICtrlCreateButton("增", 104, 75, 40, 25)
	GUICtrlDelete($insertBut)
	$deleteBut = GUICtrlCreateButton("删", 156, 75, 40, 25)
	GUICtrlDelete($deleteBut)
	$updateBut = GUICtrlCreateButton("改", 208, 75, 40, 25)
	GUICtrlDelete($updateBut)
	$selectBut = GUICtrlCreateButton("查", 260, 75, 40, 25)
	GUICtrlDelete($selectBut)
	$SQLdsnConnect = GUICtrlCreateButton("连   接", 110, 250, 80, 40)
	GUICtrlDelete($SQLdsnConnect)

	GUISetBkColor(0xA4D4D3)
	_WinAPI_SetLayeredWindowAttributes($mainMenu, 0xA4D4D3, 255)
	$MARGINS = DllStructCreate("int;int;int;int")
	DllStructSetData($MARGINS, 1, -1)
	DllCall("dwmapi.dll", "none", "DwmExtendFrameIntoClientArea", "hwnd", $mainMenu, "ptr", DllStructGetPtr($MARGINS))
	GUISetState(@SW_SHOW)

	While 1
		
		$nMsg = GUIGetMsg()
		Switch $nMsg
			
			Case $GUI_EVENT_CLOSE
				
				FileDelete(@TempDir & "\bkhead.jpg")
				FileDelete(@TempDir & "\login.jpg")
				
				_SQLExit()
				Exit
				
			Case $readBut
				
				GUICtrlDelete($SQLtab)
				GUICtrlDelete($reReadBut)
				GUICtrlDelete($insertBut)
				GUICtrlDelete($deleteBut)
				GUICtrlDelete($updateBut)
				GUICtrlDelete($selectBut)
				
				ControlDisable("", "", $readBut)
				
				$SQLdsn = GUICtrlCreateLabel("输入数据源", 100, 120, 100, 30)
				GUICtrlSetFont(-1, 15, 400, 0, "微软雅黑", 3)
				$SQLdsnInput = GUICtrlCreateInput("lcsql", 50, 160, 200, 40)
				GUICtrlSetFont(-1, 15, 400, 0, "微软雅黑")
				$SQLdsnCheck = GUICtrlCreateLabel("请确保DSN名称正确,连接不成功将直接退出!", 70, 210, 160, 30)
				$SQLdsnConnect = GUICtrlCreateButton("连   接", 110, 250, 80, 40)
				GUICtrlSetFont(-1, 15, 400, 0, "微软雅黑")
				
			Case $SQLdsnConnect
				
				ControlEnable("", "", $readBut)

				_SQLConnect(GUICtrlRead($SQLdsnInput))
				_SQLreadDbfName()
				_SQLreadFieldName()
				
				$reReadBut = GUICtrlCreateButton("刷新", 52, 75, 40, 25)
				$insertBut = GUICtrlCreateButton("增", 104, 75, 40, 25)
				$deleteBut = GUICtrlCreateButton("删", 156, 75, 40, 25)
				$updateBut = GUICtrlCreateButton("改", 208, 75, 40, 25)
				$selectBut = GUICtrlCreateButton("查", 260, 75, 40, 25)
				GUICtrlDelete($SQLdsn)
				GUICtrlDelete($SQLdsnInput)
				GUICtrlDelete($SQLdsnCheck)
				GUICtrlDelete($SQLdsnConnect)
				
				_SQLdisplayDbfTab($SQLtab)
				
			Case $reReadBut

				GUICtrlDelete($SQLtab)
				_SQLreadDbfName()
				_SQLreadFieldName()
				_SQLdisplayDbfTab($SQLtab)

			Case $insertBut
				
				ControlDisable("", "", $readBut)
				ControlDisable("", "", $reReadBut)
				ControlDisable("", "", $deleteBut)
				ControlDisable("", "", $updateBut)
				ControlDisable("", "", $selectBut)
				
				GUICtrlDelete($SQLtab)
				_SQLinsertDate($reReadBut)
				
				ControlEnable("", "", $readBut)
				ControlEnable("", "", $reReadBut)
				ControlEnable("", "", $deleteBut)
				ControlEnable("", "", $updateBut)
				ControlEnable("", "", $selectBut)
				
			Case $deleteBut
				
				ControlDisable("", "", $readBut)
				ControlDisable("", "", $reReadBut)
				ControlDisable("", "", $insertBut)
				ControlDisable("", "", $updateBut)
				ControlDisable("", "", $selectBut)
				
				GUICtrlDelete($SQLtab)
				_SQLdeleteDate($reReadBut)
				
				ControlEnable("", "", $readBut)
				ControlEnable("", "", $reReadBut)
				ControlEnable("", "", $insertBut)
				ControlEnable("", "", $updateBut)
				ControlEnable("", "", $selectBut)
				
			Case $updateBut
				
				ControlDisable("", "", $readBut)
				ControlDisable("", "", $reReadBut)
				ControlDisable("", "", $insertBut)
				ControlDisable("", "", $deleteBut)
				ControlDisable("", "", $selectBut)
				
				GUICtrlDelete($SQLtab)
				_SQLupdateDate($reReadBut)
				
				ControlEnable("", "", $readBut)
				ControlEnable("", "", $reReadBut)
				ControlEnable("", "", $insertBut)
				ControlEnable("", "", $deleteBut)
				ControlEnable("", "", $selectBut)
				
			Case $selectBut
				
				ControlDisable("", "", $readBut)
				ControlDisable("", "", $reReadBut)
				ControlDisable("", "", $insertBut)
				ControlDisable("", "", $deleteBut)
				ControlDisable("", "", $updateBut)
				
				GUICtrlDelete($SQLtab)
				_SQLselectDate($reReadBut)
				
				ControlEnable("", "", $readBut)
				ControlEnable("", "", $reReadBut)
				ControlEnable("", "", $insertBut)
				ControlEnable("", "", $deleteBut)
				ControlEnable("", "", $updateBut)
				
		EndSwitch
	WEnd
	
EndFunc   ;==>_mainMenu
