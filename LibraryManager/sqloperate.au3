#Region AutoIt3Wrapper Ԥ�������(���ò���)
#AutoIt3Wrapper_Icon=res\app.ico							;ͼ��,֧��EXE,DLL,ICO
#AutoIt3Wrapper_OutFile=									;����ļ���
#AutoIt3Wrapper_OutFile_Type=exe							;�ļ�����
#AutoIt3Wrapper_Compression=4								;ѹ���ȼ�
#AutoIt3Wrapper_UseUPX=y 									;ʹ��ѹ��
#AutoIt3Wrapper_Res_Comment= 								;ע��
#AutoIt3Wrapper_Res_Description=							;��ϸ��Ϣ
#AutoIt3Wrapper_Res_FileVersion=3.3.6.2
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
	�ű�����:  ��Ƕ��ʽ09001�� �
	Email:  lich09@nou.com.cn
	QQ/TM:
	�ű��汾:
	�ű�����:
	
#ce �ߣߣߣߣߣߣߣߣߣߣߣߣߣߣ߽ű���ʼ�ߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣ�
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <GuiListView.au3>
#include <array.au3>

Global $conn, $RS
Global $SQLdbfNum, $SQLdbfName[1], $SQLdbfNameCat, $SQLFieldNum[1], $SQLFieldNumMax, $SQLFieldName[1][1]

Func _SQLConnect($DSN) ;�������ݿ�

	$conn = ObjCreate("ADODB.Connection") ;����Ҫ����ADODB.Connection��
	$RS = ObjCreate("ADODB.Recordset") ;������¼������
	
	;$conn.Open ("driver={SQL Server};server=lacalhost;uid=hp;pwd=;database=DB_Class")

	$conn.Open("DSN=" & $DSN) ;ʹ��open�����������ݿ�
	$RS.ActiveConnection = $conn ;���ü�¼���ļ���������������$Conn

EndFunc   ;==>_SQLConnect

Func _SQLreadDbfName();��ѯ������Լ�����
	
	Local $i = 0
	$SQLdbfNum = 0
	
	$RS.open("select name from sysobjects where xtype='u'")
	While Not $RS.bof And Not $RS.eof ;����¼ָ�봦�ڵ�һ����¼�����һ����¼֮��ʱ��ִ��whileѭ��
		$SQLdbfNum += 1 ;�����
		$RS.movenext ;����¼ָ��ӵ�ǰ��λ��������һ��
	WEnd
	ReDim $SQLdbfName[$SQLdbfNum] ;�ض���$SQLdbfNum��$SQLdbfName
	ReDim $SQLFieldNum[$SQLdbfNum];�ض���$SQLdbfNum��$SQLFieldNum
	$RS.Close ;�رռ�¼������
	
	$RS.open("select name from sysobjects where xtype='u'")
	While Not $RS.bof And Not $RS.eof
		$SQLdbfName[$i] = $RS.Fields(0).value ;����
		$i += 1
		$RS.movenext
	WEnd
	$RS.Close
	
	$SQLdbfNameCat = "" ;��������
	For $i = 0 To $SQLdbfNum - 1 Step 1
		$SQLdbfNameCat = $SQLdbfNameCat & $SQLdbfName[$i] & "|"
	Next
	
EndFunc   ;==>_SQLreadDbfName

Func _SQLreadFieldName() ;��ѯ�����������
	
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

Func _SQLdisplayDbfTab(ByRef $SQLtab) ;��ʾ������
	
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
	
	GUICtrlSetState($SQLdbfTab[0], $GUI_SHOW) ;��ʾ��һ����ǩ
	
EndFunc   ;==>_SQLdisplayDbfTab

Func _SQLinsertDate(ByRef $reReadBut)
	
	Local $SQLdbfNameLabel, $SQLdbfNameCombo, $SQLdbfNameChoiceBut, $SQLdbfNameCancelBut, $SQLdbfNameChoice, $dbfChoice, $i, $SQLdbfChoiceY
	Local $SQLdbfChoiceLabel[1], $SQLdbfChoiceInput[1], $SQLdbfInsertBut, $SQLdbfCancelBut, $SQLdbfInsertValues
	
	$SQLdbfNameLabel = GUICtrlCreateLabel("��ѡ���:", 0, 120, 90, 25)
	GUICtrlSetFont(-1, 15, 400, 0, "΢���ź�", 3)
	$SQLdbfNameCombo = GUICtrlCreateCombo("", 100, 120, 120, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "΢���ź�")
	GUICtrlSetData($SQLdbfNameCombo, $SQLdbfNameCat)
	$SQLdbfNameChoiceBut = GUICtrlCreateButton("��", 230, 119, 30, 27)
	GUICtrlSetFont(-1, 15, 400, 0, "΢���ź�")
	$SQLdbfNameCancelBut = GUICtrlCreateButton("��", 270, 119, 30, 27)
	GUICtrlSetFont(-1, 15, 400, 0, "΢���ź�")

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
				$SQLdbfInsertBut = GUICtrlCreateButton("ȷ�����", 140, $SQLdbfChoiceY, 60, 25)
				$SQLdbfCancelBut = GUICtrlCreateButton("ȡ��", 220, $SQLdbfChoiceY, 30, 25)
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
				
				MsgBox(0, "���", "��ӳɹ�!")
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
	
	$SQLdbfNameLabel = GUICtrlCreateLabel("��ѡ���:", 0, 120, 90, 25)
	GUICtrlSetFont(-1, 15, 400, 0, "΢���ź�", 3)
	$SQLdbfNameCombo = GUICtrlCreateCombo("", 100, 120, 120, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "΢���ź�")
	GUICtrlSetData($SQLdbfNameCombo, $SQLdbfNameCat)
	$SQLdbfNameChoiceBut = GUICtrlCreateButton("ɾ", 230, 119, 30, 27)
	GUICtrlSetFont(-1, 15, 400, 0, "΢���ź�")
	$SQLdbfNameCancelBut = GUICtrlCreateButton("��", 270, 119, 30, 27)
	GUICtrlSetFont(-1, 15, 400, 0, "΢���ź�")

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
				$SQLdbfDeleteBut = GUICtrlCreateButton("ȷ��ɾ��", 140, $SQLdbfChoiceY, 60, 25)
				$SQLdbfCancelBut = GUICtrlCreateButton("ȡ��", 220, $SQLdbfChoiceY, 30, 25)
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
				
				MsgBox(0, "ɾ��", "ɾ���ɹ�!")
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

	$SQLdbfNameLabel = GUICtrlCreateLabel("��ѡ���:", 0, 120, 90, 25)
	GUICtrlSetFont(-1, 15, 400, 0, "΢���ź�", 3)
	$SQLdbfNameCombo = GUICtrlCreateCombo("", 100, 120, 120, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "΢���ź�")
	GUICtrlSetData($SQLdbfNameCombo, $SQLdbfNameCat)
	$SQLdbfNameChoiceBut = GUICtrlCreateButton("��", 230, 119, 30, 27)
	GUICtrlSetFont(-1, 15, 400, 0, "΢���ź�")
	$SQLdbfNameCancelBut = GUICtrlCreateButton("��", 270, 119, 30, 27)
	GUICtrlSetFont(-1, 15, 400, 0, "΢���ź�")

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
				
				$updateLabelBefore = GUICtrlCreateLabel("�޸�ǰ", 110, $SQLdbfChoiceY, 40, 20)
				$updateLabelAfter = GUICtrlCreateLabel("�޸�Ϊ", 210, $SQLdbfChoiceY, 40, 20)
				$SQLdbfChoiceY += 30
				For $i = 0 To $SQLFieldNum[$dbfChoice] - 1 Step 1
					$SQLdbfChoiceLabel[$i] = GUICtrlCreateLabel($SQLFieldName[$dbfChoice][$i], 20, $SQLdbfChoiceY, 50, 20)
					$SQLdbfChoiceInputBefore[$i] = GUICtrlCreateInput("", 90, $SQLdbfChoiceY, 90, 20)
					$SQLdbfChoiceInputAfter[$i] = GUICtrlCreateInput("", 190, $SQLdbfChoiceY, 90, 20)
					$SQLdbfChoiceY += 30
				Next
				$SQLdbfUpdateBut = GUICtrlCreateButton("ȷ�ϸ���", 140, $SQLdbfChoiceY, 60, 25)
				$SQLdbfCancelBut = GUICtrlCreateButton("ȡ��", 220, $SQLdbfChoiceY, 30, 25)
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
				
				MsgBox(0, "�޸�", "�޸ĳɹ�!")
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
	
	$SQLdbfNameLabel = GUICtrlCreateLabel("��ѡ���:", 0, 120, 90, 25)
	GUICtrlSetFont(-1, 15, 400, 0, "΢���ź�", 3)
	$SQLdbfNameCombo = GUICtrlCreateCombo("", 100, 120, 120, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "΢���ź�")
	GUICtrlSetData($SQLdbfNameCombo, $SQLdbfNameCat)
	$SQLdbfNameChoiceBut = GUICtrlCreateButton("��", 230, 119, 30, 27)
	GUICtrlSetFont(-1, 15, 400, 0, "΢���ź�")
	$SQLdbfNameCancelBut = GUICtrlCreateButton("��", 270, 119, 30, 27)
	GUICtrlSetFont(-1, 15, 400, 0, "΢���ź�")
	
	$SQLFieldNameListReturn = GUICtrlCreateButton("����", 110, 420, 80, 40)
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
				$SQLdbfSelectBut = GUICtrlCreateButton("ȷ�ϲ�ѯ", 140, $SQLdbfChoiceY, 60, 25)
				$SQLdbfCancelBut = GUICtrlCreateButton("ȡ��", 220, $SQLdbfChoiceY, 30, 25)
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
				
				$SQLFieldNameListReturn = GUICtrlCreateButton("����", 110, 420, 80, 40)
				GUICtrlSetFont(-1, 15, 400, 0, "΢���ź�")
				
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
				
				MsgBox(0, "��ѯ", "��ѯ�ɹ�!")
				
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

Func _numMax($inputNum) ;�����ֵ
	
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
