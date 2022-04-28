Option Explicit
'USEUNIT Library_Common
'USEUNIT Library_Colour
'USEUNIT Online_PaySys_Library
'USEUNIT Constants

'----------------------------------------------
'ºïÑ³ßí»ÏßéÇ ÙáïùÇ ûñ¹»ñ ÷³ëï³ÃÕÃÇ Éñ³óáõÙ
'----------------------------------------------
'docNumber - ö³ëï³ÃÕÃÇ Ñ³Ù³ñÁ
'summa - ¶áõÙ³ñ ¹³ßïÇ ³ñÅ»ù
'nbAcc - Ð³ßÇí ¹³ßïÇ ³ñÅ»ù
'aim - Üå³ï³Ï ¹³ßïÇ ³ñÅ»ù
'fISN - ö³ëï³ïÃÕÃÇ ISN-Á
'draft - true ³ñÅ»ùÇ ¹»åùáõÙ ë»ÕÙíáõÙ ¿ êñ³·Çñ Ïá×³ÏÁ, false-Ç ¹»åùáõÙ` Î³ï³ñ»É
Sub BackBallance_Input_Doc_Fill(docNumber, nbAcc, summa, aim, fISN, draft)
  Dim rekvName
    
  BuiltIn.Delay(3000)
  Call wMainForm.MainMenu.Click(c_AllActions)
  Call wMainForm.PopupMenu.Click("Ետհաշվեկշիռ|Մուտքի օրդեր")
  If wMDIClient.WaitVBObject("frmASDocForm", 3000).Exists Then
    'êï»ÕÍíáÕ ISN - Ç ÷³ëï³ïÃÕÃÇ  í»ñ³·ñáõÙ ÷á÷áË³Ï³ÝÇÝ
    fISN = wMDIClient.vbObject("frmASDocForm").DocFormCommon.Doc.isn
    'ö³ëï³ÃÕÃÇ N ¹³ßïÇ ³ñÅ»ùÇ í»ñ³·ñáõÙ ÷á÷áË³Ï³ÝÇÝ
    rekvName = GetVBObject("NOMDOK", wMDIClient.vbObject("frmASDocForm"))
    docNumber = wMDIClient.vbObject("frmASDocForm").vbObject("TabFrame").vbObject(rekvName).Text
    'Ð³ßÇí ¹³ßïÇ Éñ³óáõÙ 
    Call Rekvizit_Fill("Document", 1, "General", "NBACC", nbAcc)
    '¶áõÙ³ñ ¹³ßïÇ Éñ³óáõÙ
    Call Rekvizit_Fill("Document", 1, "General", "SUMMA", summa)
    'Üå³ï³Ï ¹³ßïÇ Éñ³óáõÙ
    Call Rekvizit_Fill("Document", 1, "General", "COM", aim)
    ' Î³ï³ñ»É Ï³Ù ê¨³·Çñ Ïá×³ÏÇ ë»ÕÙáõÙ
    If draft Then
      Call ClickCmdButton(1, "ê¨³·Çñ")
    Else
      Call ClickCmdButton(1, "Î³ï³ñ»É")
    End If
  Else 
    Log.Error "Can't find frmASDocForm window", "", pmNormal, ErrorColor
  End if
End Sub

'-----------------------------------------------------------------------
'ºïÑ³ßí»ÏßéÇ ÙáïùÇ ûñ¹»ñÇ ³éÏ³ÛáõÃÛ³Ý ëïáõ·áõÙ Ð³ßí³éí³Í »ïÑ³ßí»Ïßé³ÛÇÝ
' ÷³ëï³ÃÕÃ»ñ ÃÕÃ³å³Ý³ÏáõÙ : ö³ëï³ÃÕÃÇ ³éÏ³ÛáõÃ³Ý ¹»åùáõÙ ýáõÝÏóÇ³Ý
'í»ñ³¹³ñÓÝáõÙ ¿ true , Ñ³Ï³é³Ï ¹»åùáõÙ ` false : 
'-----------------------------------------------------------------------
Function Check_Doc_In_RegBackBallance_Workpaper (docNumber)
    Dim is_exist : is_exist = False
    Dim colN
    
    BuiltIn.Delay(4000)
    Call wTreeView.DblClickItem("|¶ÉË³íáñ Ñ³ßí³å³ÑÇ ²Þî|ÂÕÃ³å³Ý³ÏÝ»ñ|Ð³ßí³éí³Í »ïÑ³ßí»Ïßé³ÛÇÝ ÷³ëï³ÃÕÃ»ñ")
    
    If p1.WaitVBObject("frmAsUstPar", 6000).Exists Then
      Call ClickCmdButton(2, "Î³ï³ñ»É")
    Else 
      Log.Error "Can't find frmAsUstPar window", "", pmNormal, ErrorColor
    End if
    
    If wMDIClient.WaitVBObject("frmPttel", 6000).Exists Then
      colN = wMDIClient.vbObject("frmPttel").GetColumnIndex("DOCNUM")
      BuiltIn.Delay(3000)
      If SearchInPttel("frmPttel", colN, docNumber) Then
        BuiltIn.Delay(2000)
        is_exist = True
      End If
    Else
        Log.Error "Registered back ballances input folder view doesn't exists", "", pmNormal, ErrorColor
    End If
    
    BuiltIn.Delay(2000)
    Check_Doc_In_RegBackBallance_Workpaper = is_exist
End Function

'-----------------------------------------------------------------------------
'ºïÑ³ßí»ÏßéÇ ÙáïùÇ ûñ¹»ñÇ ÷³ëï³ÃÕÃÇ Ñ³Ù³ñ "ÎñÏ³ÝÏÇ Ùáõïù" ·áñÍáÕáÃÛ³Ý Ï³ï³ñáõÙ:
'ºÃ» Ýáñ Ý»ñÙáõÍí³Í ³ñÅ»ùÝ»ñÁ ëË³É »Ý, ³å³ ýáõÝÏóÇ³Ý í»ñ³¹³ñÓÝáõÙ ¿ fasle,
' »Ã» Ñ³ëï³ïíáõÙ ¿ ` true :üáõÝÏóÇ³Ý »ÝÃ³¹ñáõÙ ¿ ÷³ëï³ÃÕÃÇ ³éÏ³ÛáõÃÛáõÝÁ :
'-----------------------------------------------------------------------------
Function BackBallance_Verify_Doc_In_InspecdetDoc_Folder(accCred, summa)
    Dim isverify : isverify = False
    
    BuiltIn.Delay(3000)
    Call wMainForm.MainMenu.Click(c_AllActions)
    wMainForm.PopupMenu.click(c_DoubleInput)
    BuiltIn.Delay(1000)
    
    If wMDIClient.WaitVBObject("frmASDocForm", delay_middle).Exists Then
        'Ð³ßÇí Ïñ»¹Çï ¹³ßïÇ Éñ³óáõÙ
        Call Rekvizit_Fill("Document", 1, "General", "NBACC", "^A[Del]" & accCred)
        '¶áõÙ³ñ ¹³ßïÇ Éñ³óáõÙ
        Call Rekvizit_Fill("Document", 1, "General", "Summa", summa)
        Call ClickCmdButton(1, "Î³ï³ñ»É")
    Else
        Log.Error "Can't open the document for double input", "", pmNormal, ErrorColor
    End If
    
    If p1.WaitVBObject("frmAsMsgBox", delay_middle).Exists Then
        Call ClickCmdButton(5, "Î³ï³ñ»É")
    Else
        isverify = True
    End If
    
    BackBallance_Verify_Doc_In_InspecdetDoc_Folder = isverify
End Function