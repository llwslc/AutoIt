#Region AutoIt3Wrapper 预编译参数(常用参数)
#AutoIt3Wrapper_Icon=res\app.ico							;图标,支持EXE,DLL,ICO
#AutoIt3Wrapper_OutFile=									;输出文件名
#AutoIt3Wrapper_OutFile_Type=exe							;文件类型
#AutoIt3Wrapper_Compression=4								;压缩等级
#AutoIt3Wrapper_UseUPX=y 									;使用压缩
#AutoIt3Wrapper_Res_Comment= 								;注释
#AutoIt3Wrapper_Res_Description=							;详细信息
#AutoIt3Wrapper_Res_FileVersion=3.3.6.2
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
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <GuiListView.au3>
#include <array.au3>

Global $conn, $RS
Global $SQLdbfNum, $SQLdbfName[1], $SQLdbfNameCat, $SQLFieldNum[1], $SQLFieldNumMax, $SQLFieldName[1][1]

Func _SQLConnect($DSN) ;连接数据库

	$conn = ObjCreate("ADODB.Connection") ;首先要建立ADODB.Connection类
	$RS = ObjCreate("ADODB.Recordset") ;创建记录集对象
	
	;$conn.Open ("driver={SQL Server};server=lacalhost;uid=hp;pwd=;database=DB_Class")

	$conn.Open("DSN=" & $DSN) ;使用open方法连接数据库
	$RS.ActiveConnection = $conn ;设置记录集的激活链接属性来自$Conn

EndFunc   ;==>_SQLConnect

Func _SQLreadDbfName();查询表个数以及表名
	
	Local $i = 0
	$SQLdbfNum = 0
	
	$RS.open("select name from sysobjects where xtype='u'")
	While Not $RS.bof And Not $RS.eof ;当记录指针处于第一条记录和最后一条记录之间时，执行while循环
		$SQLdbfNum += 1 ;表个数
		$RS.movenext ;将记录指针从当前的位置向下移一行
	WEnd
	ReDim $SQLdbfName[$SQLdbfNum] ;重定义$SQLdbfNum个$SQLdbfName
	ReDim $SQLFieldNum[$SQLdbfNum];重定义$SQLdbfNum个$SQLFieldNum
	$RS.Close ;关闭记录集对象
	
	$RS.open("select name from sysobjects where xtype='u'")
	While Not $RS.bof And Not $RS.eof
		$SQLdbfName[$i] = $RS.Fields(0).value ;表名
		$i += 1
		$RS.movenext
	WEnd
	$RS.Close
	
	$SQLdbfNameCat = "" ;表名连接
	For $i = 0 To $SQLdbfNum - 1 Step 1
		$SQLdbfNameCat = $SQLdbfNameCat & $SQLdbfName[$i] & "|"
	Next
	
EndFunc   ;==>_SQLreadDbfName

Func _SQLreadFieldName() ;查询各个表的列名
	
	Local $i = 0, $j = 0
	
	For $i = 0 To $SQLdbfNum - 1 Step 1
		$SQLFieldNum[$i] = 0
	Next
	
	For $i = 0 To $SQLdbfNum - 1 Step 1
		$RS.open("select name from syscolumns where id=object_id('" & $SQLdbfName[$i] & "')")
		
		While Not $RS.bof And Not $RS.eof
			$SQLFieldNum[$i] += 1
			$RS.movenext
		WEnd
		$RS.Close
	Next
	
	$SQLFieldNumMax = _numMax($SQLFieldNum)
	ReDim $SQLFieldName[$SQLdbfNum][$SQLFieldNumMax]
	
	For $i = 0 To $SQLdbfNum - 1 Step 1
		$j = 0
		$RS.open("select name from syscolumns where id=object_id('" & $SQLdbfName[$i] & "')")
		
		While Not $RS.bof And Not $RS.eof
			$SQLFieldName[$i][$j] = $RS.Fields(0).value
			$j += 1
			$RS.movenext
		WEnd
		$RS.Close
	Next
	
EndFunc   ;==>_SQLreadFieldName

Func _SQLdisplayDbfTab(ByRef $SQLtab) ;显示各个表
	
	Local $SQLdbfTab[$SQLdbfNum], $SQLFieldNameList[$SQLdbfNum], $SQLFieldNameCat = "", $SQLFieldContentCat = "", $i, $j
	
	$SQLtab = GUICtrlCreateTab(0, 105, 302, 375)
	
	For $i = 0 To $SQLdbfNum - 1 Step 1
		$SQLdbfTab[$i] = GUICtrlCreateTabItem($SQLdbfName[$i])
		$SQLFieldNameCat = ""
		For $j = 0 To $SQLFieldNum[$i] - 1 Step 1
			$SQLFieldNameCat = $SQLFieldNameCat & $SQLFieldName[$i][$j] & "|"
		Next
		$SQLFieldNameList[$i] = GUICtrlCreateListView($SQLFieldNameCat, 0, 127, 300, 352, -1, BitOR($WS_EX_CLIENTEDGE, $LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES))
	Next
	
	For $i = 0 To $SQLdbfNum - 1 Step 1
		$RS.open("select * from " & $SQLdbfName[$i])
		While Not $RS.bof And Not $RS.eof
			$SQLFieldContentCat = ""
			For $j = 0 To $SQLFieldNum[$i] - 1 Step 1
				$SQLFieldContentCat = $SQLFieldContentCat & $RS.Fields($j).value & "|"
			Next
			GUICtrlCreateListViewItem($SQLFieldContentCat, $SQLFieldNameList[$i])
			$RS.movenext
		WEnd
		$RS.Close
	Next
	
	GUICtrlSetState($SQLdbfTab[0], $GUI_SHOW) ;显示第一个标签
	
EndFunc   ;==>_SQLdisplayDbfTab

Func _SQLinsertDate(ByRef $reReadBut)
	
	Local $SQLdbfNameLabel, $SQLdbfNameCombo, $SQLdbfNameChoiceBut, $SQLdbfNameCancelBut, $SQLdbfNameChoice, $dbfChoice, $i, $SQLdbfChoiceY
	Local $SQLdbfChoiceLabel[1], $SQLdbfChoiceInput[1], $SQLdbfInsertBut, $SQLdbfCancelBut, $SQLdbfInsertValues
	
	$SQLdbfNameLabel = GUICtrlCreateLabel("请选择表:", 0, 120, 90, 25)
	GUICtrlSetFont(-1, 15, 400, 0, "微软雅黑", 3)
	$SQLdbfNameCombo = GUICtrlCreateCombo("", 100, 120, 120, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "微软雅黑")
	GUICtrlSetData($SQLdbfNameCombo, $SQLdbfNameCat)
	$SQLdbfNameChoiceBut = GUICtrlCreateButton("增", 230, 119, 30, 27)
	GUICtrlSetFont(-1, 15, 400, 0, "微软雅黑")
	$SQLdbfNameCancelBut = GUICtrlCreateButton("撤", 270, 119, 30, 27)
	GUICtrlSetFont(-1, 15, 400, 0, "微软雅黑")

	While 1
		Switch GUIGetMsg()
			
			Case $GUI_EVENT_CLOSE
				FileDelete(@TempDir & "\bkhead.jpg")
				FileDelete(@TempDir & "\login.jpg")
				
				Exit
				
			Case $SQLdbfNameChoiceBut
				
				$SQLdbfNameChoice = GUICtrlRead($SQLdbfNameCombo)
				For $i = 0 To $SQLdbfNum - 1 Step 1
					If $SQLdbfNameChoice = $SQLdbfName[$i] Then
						$dbfChoice = $i
						ExitLoop
					EndIf
				Next
				ReDim $SQLdbfChoiceLabel[$SQLFieldNum[$dbfChoice]], $SQLdbfChoiceInput[$SQLFieldNum[$dbfChoice]]
				$SQLdbfChoiceY = 180
				
				For $i = 0 To $SQLFieldNum[$dbfChoice] - 1 Step 1
					$SQLdbfChoiceLabel[$i] = GUICtrlCreateLabel($SQLFieldName[$dbfChoice][$i], 40, $SQLdbfChoiceY, 50, 20)
					$SQLdbfChoiceInput[$i] = GUICtrlCreateInput("", 100, $SQLdbfChoiceY, 100, 20)
					$SQLdbfChoiceY += 30
				Next
				$SQLdbfInsertBut = GUICtrlCreateButton("确认添加", 140, $SQLdbfChoiceY, 60, 25)
				$SQLdbfCancelBut = GUICtrlCreateButton("取消", 220, $SQLdbfChoiceY, 30, 25)
				ExitLoop
				
			Case $SQLdbfNameCancelBut
				
				GUICtrlDelete($SQLdbfNameLabel)
				GUICtrlDelete($SQLdbfNameCombo)
				GUICtrlDelete($SQLdbfNameChoiceBut)
				GUICtrlDelete($SQLdbfNameCancelBut)
				
				ControlClick("", "", $reReadBut)
				Return 0
		EndSwitch
	WEnd
	
	ControlDisable("", "", $SQLdbfNameChoiceBut)
	ControlDisable("", "", $SQLdbfNameCancelBut)
	
	While 1
		Switch GUIGetMsg()
			
			Case $GUI_EVENT_CLOSE
				FileDelete(@TempDir & "\bkhead.jpg")
				FileDelete(@TempDir & "\login.jpg")
				
				Exit
				
			Case $SQLdbfInsertBut
				
				$SQLdbfInsertValues = ""
				For $i = 0 To $SQLFieldNum[$dbfChoice] - 1 Step 1
					If $i < $SQLFieldNum[$dbfChoice] - 1 Then
						$SQLdbfInsertValues = $SQLdbfInsertValues & "'" & GUICtrlRead($SQLdbfChoiceInput[$i]) & "',"
					Else
						$SQLdbfInsertValues = $SQLdbfInsertValues & "'" & GUICtrlRead($SQLdbfChoiceInput[$i]) & "'"
					EndIf
				Next
				
				$RS.open("insert into " & $SQLdbfNameChoice & " values(" & $SQLdbfInsertValues & ")")
				
				MsgBox(0, "添加", "添加成功!")
				ExitLoop
			Case $SQLdbfCancelBut
				ExitLoop
		EndSwitch
	WEnd
	
	GUICtrlDelete($SQLdbfNameLabel)
	GUICtrlDelete($SQLdbfNameCombo)
	GUICtrlDelete($SQLdbfNameChoiceBut)
	GUICtrlDelete($SQLdbfNameCancelBut)
	For $i = 0 To $SQLFieldNum[$dbfChoice] - 1 Step 1
		GUICtrlDelete($SQLdbfChoiceLabel[$i])
		GUICtrlDelete($SQLdbfChoiceInput[$i])
	Next
	GUICtrlDelete($SQLdbfInsertBut)
	GUICtrlDelete($SQLdbfCancelBut)
	
	ControlClick("", "", $reReadBut)
	
EndFunc   ;==>_SQLinsertDate

Func _SQLdeleteDate(ByRef $reReadBut)
	
	Local $SQLdbfNameLabel, $SQLdbfNameCombo, $SQLdbfNameChoiceBut, $SQLdbfNameCancelBut, $SQLdbfNameChoice, $dbfChoice, $i, $SQLdbfChoiceY, $flag = 0
	Local $SQLdbfChoiceLabel[1], $SQLdbfChoiceInput[1], $SQLdbfDeleteBut, $SQLdbfCancelBut, $SQLdbfDeleteValues
	
	$SQLdbfNameLabel = GUICtrlCreateLabel("请选择表:", 0, 120, 90, 25)
	GUICtrlSetFont(-1, 15, 400, 0, "微软雅黑", 3)
	$SQLdbfNameCombo = GUICtrlCreateCombo("", 100, 120, 120, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "微软雅黑")
	GUICtrlSetData($SQLdbfNameCombo, $SQLdbfNameCat)
	$SQLdbfNameChoiceBut = GUICtrlCreateButton("删", 230, 119, 30, 27)
	GUICtrlSetFont(-1, 15, 400, 0, "微软雅黑")
	$SQLdbfNameCancelBut = GUICtrlCreateButton("撤", 270, 119, 30, 27)
	GUICtrlSetFont(-1, 15, 400, 0, "微软雅黑")

	While 1
		Switch GUIGetMsg()
			
			Case $GUI_EVENT_CLOSE
				FileDelete(@TempDir & "\bkhead.jpg")
				FileDelete(@TempDir & "\login.jpg")
				
				Exit
				
			Case $SQLdbfNameChoiceBut
				
				$SQLdbfNameChoice = GUICtrlRead($SQLdbfNameCombo)
				For $i = 0 To $SQLdbfNum - 1 Step 1
					If $SQLdbfNameChoice = $SQLdbfName[$i] Then
						$dbfChoice = $i
						ExitLoop
					EndIf
				Next
				ReDim $SQLdbfChoiceLabel[$SQLFieldNum[$dbfChoice]], $SQLdbfChoiceInput[$SQLFieldNum[$dbfChoice]]
				$SQLdbfChoiceY = 180
				
				For $i = 0 To $SQLFieldNum[$dbfChoice] - 1 Step 1
					$SQLdbfChoiceLabel[$i] = GUICtrlCreateLabel($SQLFieldName[$dbfChoice][$i], 40, $SQLdbfChoiceY, 50, 20)
					$SQLdbfChoiceInput[$i] = GUICtrlCreateInput("", 100, $SQLdbfChoiceY, 100, 20)
					$SQLdbfChoiceY += 30
				Next
				$SQLdbfDeleteBut = GUICtrlCreateButton("确认删除", 140, $SQLdbfChoiceY, 60, 25)
				$SQLdbfCancelBut = GUICtrlCreateButton("取消", 220, $SQLdbfChoiceY, 30, 25)
				ExitLoop
				
			Case $SQLdbfNameCancelBut
				
				GUICtrlDelete($SQLdbfNameLabel)
				GUICtrlDelete($SQLdbfNameCombo)
				GUICtrlDelete($SQLdbfNameChoiceBut)
				GUICtrlDelete($SQLdbfNameCancelBut)
				
				ControlClick("", "", $reReadBut)
				
				Return 0
		EndSwitch
	WEnd
	
	ControlDisable("", "", $SQLdbfNameChoiceBut)
	ControlDisable("", "", $SQLdbfNameCancelBut)

	While 1
		Switch GUIGetMsg()
			
			Case $GUI_EVENT_CLOSE
				FileDelete(@TempDir & "\bkhead.jpg")
				FileDelete(@TempDir & "\login.jpg")
				
				Exit
				
			Case $SQLdbfDeleteBut
				
				$flag = 0
				$SQLdbfDeleteValues = ""
				For $i = 0 To $SQLFieldNum[$dbfChoice] - 1 Step 1
					If GUICtrlRead($SQLdbfChoiceInput[$i]) <> "" Then
						If $flag = 0 Then
							$SQLdbfDeleteValues = $SQLdbfDeleteValues & $SQLFieldName[$dbfChoice][$i] & "='" & GUICtrlRead($SQLdbfChoiceInput[$i]) & "'"
							$flag = 1
						Else
							$SQLdbfDeleteValues = $SQLdbfDeleteValues & " and " & $SQLFieldName[$dbfChoice][$i] & "='" & GUICtrlRead($SQLdbfChoiceInput[$i]) & "'"
						EndIf
					EndIf
				Next

				$RS.open("delete from " & $SQLdbfNameChoice & " where " & $SQLdbfDeleteValues)
				
				MsgBox(0, "删除", "删除成功!")
				ExitLoop
			Case $SQLdbfCancelBut
				ExitLoop
		EndSwitch
	WEnd
	
	GUICtrlDelete($SQLdbfNameLabel)
	GUICtrlDelete($SQLdbfNameCombo)
	GUICtrlDelete($SQLdbfNameChoiceBut)
	GUICtrlDelete($SQLdbfNameCancelBut)
	For $i = 0 To $SQLFieldNum[$dbfChoice] - 1 Step 1
		GUICtrlDelete($SQLdbfChoiceLabel[$i])
		GUICtrlDelete($SQLdbfChoiceInput[$i])
	Next
	GUICtrlDelete($SQLdbfDeleteBut)
	GUICtrlDelete($SQLdbfCancelBut)
	
	ControlClick("", "", $reReadBut)
EndFunc   ;==>_SQLdeleteDate

Func _SQLupdateDate(ByRef $reReadBut)
	
	Local $SQLdbfNameLabel, $SQLdbfNameCombo, $SQLdbfNameChoiceBut, $SQLdbfNameCancelBut, $SQLdbfNameChoice, $dbfChoice, $i, $SQLdbfChoiceY, $flag = 0
	Local $SQLdbfChoiceLabel[1], $SQLdbfChoiceInputBefore[1], $SQLdbfChoiceInputAfter[1], $SQLdbfUpdateBut, $SQLdbfCancelBut
	Local $updateLabelBefore, $updateLabelAfter, $SQLdbfUpdateValuesBefore, $SQLdbfUpdateValuesAfter

	$SQLdbfNameLabel = GUICtrlCreateLabel("请选择表:", 0, 120, 90, 25)
	GUICtrlSetFont(-1, 15, 400, 0, "微软雅黑", 3)
	$SQLdbfNameCombo = GUICtrlCreateCombo("", 100, 120, 120, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "微软雅黑")
	GUICtrlSetData($SQLdbfNameCombo, $SQLdbfNameCat)
	$SQLdbfNameChoiceBut = GUICtrlCreateButton("改", 230, 119, 30, 27)
	GUICtrlSetFont(-1, 15, 400, 0, "微软雅黑")
	$SQLdbfNameCancelBut = GUICtrlCreateButton("撤", 270, 119, 30, 27)
	GUICtrlSetFont(-1, 15, 400, 0, "微软雅黑")

	While 1
		Switch GUIGetMsg()
			
			Case $GUI_EVENT_CLOSE
				FileDelete(@TempDir & "\bkhead.jpg")
				FileDelete(@TempDir & "\login.jpg")
				
				Exit
				
			Case $SQLdbfNameChoiceBut
				
				$SQLdbfNameChoice = GUICtrlRead($SQLdbfNameCombo)
				For $i = 0 To $SQLdbfNum - 1 Step 1
					If $SQLdbfNameChoice = $SQLdbfName[$i] Then
						$dbfChoice = $i
						ExitLoop
					EndIf
				Next
				ReDim $SQLdbfChoiceLabel[$SQLFieldNum[$dbfChoice]], $SQLdbfChoiceInputBefore[$SQLFieldNum[$dbfChoice]], $SQLdbfChoiceInputAfter[$SQLFieldNum[$dbfChoice]]
				$SQLdbfChoiceY = 160
				
				$updateLabelBefore = GUICtrlCreateLabel("修改前", 110, $SQLdbfChoiceY, 40, 20)
				$updateLabelAfter = GUICtrlCreateLabel("修改为", 210, $SQLdbfChoiceY, 40, 20)
				$SQLdbfChoiceY += 30
				For $i = 0 To $SQLFieldNum[$dbfChoice] - 1 Step 1
					$SQLdbfChoiceLabel[$i] = GUICtrlCreateLabel($SQLFieldName[$dbfChoice][$i], 20, $SQLdbfChoiceY, 50, 20)
					$SQLdbfChoiceInputBefore[$i] = GUICtrlCreateInput("", 90, $SQLdbfChoiceY, 90, 20)
					$SQLdbfChoiceInputAfter[$i] = GUICtrlCreateInput("", 190, $SQLdbfChoiceY, 90, 20)
					$SQLdbfChoiceY += 30
				Next
				$SQLdbfUpdateBut = GUICtrlCreateButton("确认更新", 140, $SQLdbfChoiceY, 60, 25)
				$SQLdbfCancelBut = GUICtrlCreateButton("取消", 220, $SQLdbfChoiceY, 30, 25)
				ExitLoop
				
			Case $SQLdbfNameCancelBut
				
				GUICtrlDelete($SQLdbfNameLabel)
				GUICtrlDelete($SQLdbfNameCombo)
				GUICtrlDelete($SQLdbfNameChoiceBut)
				GUICtrlDelete($SQLdbfNameCancelBut)
				
				ControlClick("", "", $reReadBut)
				
				Return 0
		EndSwitch
	WEnd
	
	ControlDisable("", "", $SQLdbfNameChoiceBut)
	ControlDisable("", "", $SQLdbfNameCancelBut)
	
	While 1
		Switch GUIGetMsg()
			
			Case $GUI_EVENT_CLOSE
				FileDelete(@TempDir & "\bkhead.jpg")
				FileDelete(@TempDir & "\login.jpg")
				
				Exit
				
			Case $SQLdbfUpdateBut
				
				$flag = 0
				$SQLdbfUpdateValuesBefore = ""
				For $i = 0 To $SQLFieldNum[$dbfChoice] - 1 Step 1
					If GUICtrlRead($SQLdbfChoiceInputBefore[$i]) <> "" Then
						If $flag = 0 Then
							$SQLdbfUpdateValuesBefore = $SQLdbfUpdateValuesBefore & $SQLFieldName[$dbfChoice][$i] & "='" & GUICtrlRead($SQLdbfChoiceInputBefore[$i]) & "'"
							$flag = 1
						Else
							$SQLdbfUpdateValuesBefore = $SQLdbfUpdateValuesBefore & " and " & $SQLFieldName[$dbfChoice][$i] & "='" & GUICtrlRead($SQLdbfChoiceInputBefore[$i]) & "'"
						EndIf
					EndIf
				Next
				
				$flag = 0
				$SQLdbfUpdateValuesAfter = ""
				For $i = 0 To $SQLFieldNum[$dbfChoice] - 1 Step 1
					If GUICtrlRead($SQLdbfChoiceInputAfter[$i]) <> "" Then
						If $flag = 0 Then
							$SQLdbfUpdateValuesAfter = $SQLdbfUpdateValuesAfter & $SQLFieldName[$dbfChoice][$i] & "='" & GUICtrlRead($SQLdbfChoiceInputAfter[$i]) & "'"
							$flag = 1
						Else
							$SQLdbfUpdateValuesAfter = $SQLdbfUpdateValuesAfter & " , " & $SQLFieldName[$dbfChoice][$i] & "='" & GUICtrlRead($SQLdbfChoiceInputAfter[$i]) & "'"
						EndIf
					EndIf
				Next

				$RS.open("update " & $SQLdbfNameChoice & " set " & $SQLdbfUpdateValuesAfter & " where " & $SQLdbfUpdateValuesBefore)
				
				MsgBox(0, "修改", "修改成功!")
				ExitLoop
			Case $SQLdbfCancelBut
				ExitLoop
		EndSwitch
	WEnd
	
	GUICtrlDelete($SQLdbfNameLabel)
	GUICtrlDelete($SQLdbfNameCombo)
	GUICtrlDelete($SQLdbfNameChoiceBut)
	GUICtrlDelete($SQLdbfNameCancelBut)
	GUICtrlDelete($updateLabelBefore)
	GUICtrlDelete($updateLabelAfter)
	For $i = 0 To $SQLFieldNum[$dbfChoice] - 1 Step 1
		GUICtrlDelete($SQLdbfChoiceLabel[$i])
		GUICtrlDelete($SQLdbfChoiceInputBefore[$i])
		GUICtrlDelete($SQLdbfChoiceInputAfter[$i])
	Next
	GUICtrlDelete($SQLdbfUpdateBut)
	GUICtrlDelete($SQLdbfCancelBut)
	
	ControlClick("", "", $reReadBut)
EndFunc   ;==>_SQLupdateDate

Func _SQLselectDate(ByRef $reReadBut)
	
	Local $SQLdbfNameLabel, $SQLdbfNameCombo, $SQLdbfNameChoiceBut, $SQLdbfNameCancelBut, $SQLdbfNameChoice, $dbfChoice, $i, $flag = 0
	Local $SQLdbfChoiceLabel[1], $SQLdbfChoiceInput[1], $SQLdbfSelectBut, $SQLdbfCancelBut, $SQLdbfSelectValues
	Local $SQLFieldNameList, $SQLFieldNameCat, $SQLFieldContentCat, $SQLFieldNameListReturn
	
	$SQLdbfNameLabel = GUICtrlCreateLabel("请选择表:", 0, 120, 90, 25)
	GUICtrlSetFont(-1, 15, 400, 0, "微软雅黑", 3)
	$SQLdbfNameCombo = GUICtrlCreateCombo("", 100, 120, 120, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "微软雅黑")
	GUICtrlSetData($SQLdbfNameCombo, $SQLdbfNameCat)
	$SQLdbfNameChoiceBut = GUICtrlCreateButton("查", 230, 119, 30, 27)
	GUICtrlSetFont(-1, 15, 400, 0, "微软雅黑")
	$SQLdbfNameCancelBut = GUICtrlCreateButton("撤", 270, 119, 30, 27)
	GUICtrlSetFont(-1, 15, 400, 0, "微软雅黑")
	
	$SQLFieldNameListReturn = GUICtrlCreateButton("返回", 110, 420, 80, 40)
	GUICtrlDelete($SQLFieldNameListReturn)

	While 1
		Switch GUIGetMsg()
			
			Case $GUI_EVENT_CLOSE
				FileDelete(@TempDir & "\bkhead.jpg")
				FileDelete(@TempDir & "\login.jpg")
				
				Exit
				
			Case $SQLdbfNameChoiceBut
				
				$SQLdbfNameChoice = GUICtrlRead($SQLdbfNameCombo)
				For $i = 0 To $SQLdbfNum - 1 Step 1
					If $SQLdbfNameChoice = $SQLdbfName[$i] Then
						$dbfChoice = $i
						ExitLoop
					EndIf
				Next
				ReDim $SQLdbfChoiceLabel[$SQLFieldNum[$dbfChoice]], $SQLdbfChoiceInput[$SQLFieldNum[$dbfChoice]]
				$SQLdbfChoiceY = 180
				
				For $i = 0 To $SQLFieldNum[$dbfChoice] - 1 Step 1
					$SQLdbfChoiceLabel[$i] = GUICtrlCreateLabel($SQLFieldName[$dbfChoice][$i], 40, $SQLdbfChoiceY, 50, 20)
					$SQLdbfChoiceInput[$i] = GUICtrlCreateInput("", 100, $SQLdbfChoiceY, 100, 20)
					$SQLdbfChoiceY += 30
				Next
				$SQLdbfSelectBut = GUICtrlCreateButton("确认查询", 140, $SQLdbfChoiceY, 60, 25)
				$SQLdbfCancelBut = GUICtrlCreateButton("取消", 220, $SQLdbfChoiceY, 30, 25)
				ExitLoop
				
			Case $SQLdbfNameCancelBut
				
				GUICtrlDelete($SQLdbfNameLabel)
				GUICtrlDelete($SQLdbfNameCombo)
				GUICtrlDelete($SQLdbfNameChoiceBut)
				GUICtrlDelete($SQLdbfNameCancelBut)
				
				ControlClick("", "", $reReadBut)
				Return 0
		EndSwitch
	WEnd
	
	ControlDisable("", "", $SQLdbfNameChoiceBut)
	ControlDisable("", "", $SQLdbfNameCancelBut)
	
	While 1
		Switch GUIGetMsg()
			
			Case $GUI_EVENT_CLOSE
				FileDelete(@TempDir & "\bkhead.jpg")
				FileDelete(@TempDir & "\login.jpg")
				
				Exit
				
			Case $SQLdbfSelectBut
				
				$flag = 0
				$SQLdbfSelectValues = ""
				For $i = 0 To $SQLFieldNum[$dbfChoice] - 1 Step 1
					If GUICtrlRead($SQLdbfChoiceInput[$i]) <> "" Then
						If $flag = 0 Then
							$SQLdbfSelectValues = $SQLdbfSelectValues & $SQLFieldName[$dbfChoice][$i] & "='" & GUICtrlRead($SQLdbfChoiceInput[$i]) & "'"
							$flag = 1
						Else
							$SQLdbfSelectValues = $SQLdbfSelectValues & " and " & $SQLFieldName[$dbfChoice][$i] & "='" & GUICtrlRead($SQLdbfChoiceInput[$i]) & "'"
						EndIf
					EndIf
				Next

				$RS.open("select * from " & $SQLdbfNameChoice & " where " & $SQLdbfSelectValues)
				
				$SQLFieldNameCat = ""
				For $i = 0 To $SQLFieldNum[$dbfChoice] - 1 Step 1
					$SQLFieldNameCat = $SQLFieldNameCat & $SQLFieldName[$dbfChoice][$i] & "|"
				Next
				$SQLFieldNameList = GUICtrlCreateListView($SQLFieldNameCat, 0, 105, 300, 295, -1, BitOR($WS_EX_CLIENTEDGE, $LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES))
				
				While Not $RS.bof And Not $RS.eof
					$SQLFieldContentCat = ""
					For $i = 0 To $SQLFieldNum[$dbfChoice] - 1 Step 1
						$SQLFieldContentCat = $SQLFieldContentCat & $RS.Fields($i).value & "|"
					Next
					GUICtrlCreateListViewItem($SQLFieldContentCat, $SQLFieldNameList)
					$RS.movenext
				WEnd
				$RS.Close
				
				$SQLFieldNameListReturn = GUICtrlCreateButton("返回", 110, 420, 80, 40)
				GUICtrlSetFont(-1, 15, 400, 0, "微软雅黑")
				
				GUICtrlDelete($SQLdbfNameLabel)
				GUICtrlDelete($SQLdbfNameCombo)
				GUICtrlDelete($SQLdbfNameChoiceBut)
				GUICtrlDelete($SQLdbfNameCancelBut)
				For $i = 0 To $SQLFieldNum[$dbfChoice] - 1 Step 1
					GUICtrlDelete($SQLdbfChoiceLabel[$i])
					GUICtrlDelete($SQLdbfChoiceInput[$i])
				Next
				GUICtrlDelete($SQLdbfSelectBut)
				GUICtrlDelete($SQLdbfCancelBut)
				
				MsgBox(0, "查询", "查询成功!")
				
			Case $SQLFieldNameListReturn
				
				GUICtrlDelete($SQLFieldNameList)
				GUICtrlDelete($SQLFieldNameListReturn)
				
				ControlClick("", "", $reReadBut)
				Return 0
			Case $SQLdbfCancelBut
				ExitLoop
		EndSwitch
	WEnd
	
	GUICtrlDelete($SQLdbfNameLabel)
	GUICtrlDelete($SQLdbfNameCombo)
	GUICtrlDelete($SQLdbfNameChoiceBut)
	GUICtrlDelete($SQLdbfNameCancelBut)
	For $i = 0 To $SQLFieldNum[$dbfChoice] - 1 Step 1
		GUICtrlDelete($SQLdbfChoiceLabel[$i])
		GUICtrlDelete($SQLdbfChoiceInput[$i])
	Next
	GUICtrlDelete($SQLdbfSelectBut)
	GUICtrlDelete($SQLdbfCancelBut)
	
	ControlClick("", "", $reReadBut)
EndFunc   ;==>_SQLselectDate

Func _SQLExit()
	$conn.Close
EndFunc   ;==>_SQLExit

Func _numMax($inputNum) ;求最大值
	
	Local $maxNum = 0, $i
	
	For $i = 0 To $SQLdbfNum - 1 Step 1
		If $maxNum < $inputNum[$i] Then
			$maxNum = $inputNum[$i]
		Else
			$i += 1
		EndIf
	Next
	
	Return $maxNum
	
EndFunc   ;==>_numMax
