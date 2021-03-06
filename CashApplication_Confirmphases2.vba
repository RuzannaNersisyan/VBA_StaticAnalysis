Option Explicit
'USEUNIT Library_Common
'USEUNIT Payment_Order_ConfirmPhases_Library
'USEUNIT Online_PaySys_Library
'USEUNIT Currency_Exchange_Confirmphases_Library
'USEUNIT CashOutput_Confirmpases_Library
'USEUNIT CashInput_Confirmphases_Library
'USEUNIT CashApplication_Confirmphases_Library
'USEUNIT Constants

'Test case ID 165649

Sub CashApp_Pass_Test()
    
    Dim fDATE, startDATE , docNumber, summa, fISN, dateAcc, accCash, data, rekvName
    Dim docExist, isDel, docNumber1, inspDocVerify, confPath,confInput
    
    data = Null
    Utilities.ShortDateFormat = "yyyymmdd"
    startDATE = "20030101"
    fDATE = "20250101"             
    dateAcc = aqConvert.DateTimeToStr(aqDateTime.Today)
    accCash = "03485190101"
    summa = "250000"
    confPath = "X:\Testing\CashOutput confirm phases\CashOutput_Pass.txt"
   
    'Test StartUp 
    Call Initialize_AsBank("bank", startDATE, fDATE)
    'ä³ñ³Ù»ïñÇ ³ñÅ»ùÇ ÷á÷áËáõÙ   
    Call SetParameter("CASHREQVER", "0")
    Call Close_AsBank()
    Call Initialize_AsBank("bank", startDATE, fDATE)
    
    'Î³ñ·³íáñáõÙÝ»ñÇ Ý»ñÙáõÍáõÙ
    confInput = Input_Config(confPath)
    If Not confInput Then
        Log.Error("The configuration doesn't input")
    End If

    Call Online_PaySys_Go_To_Agr_WorkPapers("|²¹ÙÇÝÇëïñ³ïáñÇ ²Þî|ÂÕÃ³å³Ý³ÏÝ»ñ|²ßË³ï³Ýù³ÛÇÝ ÷³ëï³ÃÕÃ»ñ", data, data)
    
    'Î³ÝËÇÏ³óÙ³Ý Ñ³ÛïÇ ëï»ÕÍáõÙ
    Call CashApplication_Doc_Fill(docNumber, dateAcc, accCash , summa, fISN )
    
    'ö³ëï³ÃÕÃÇ  Ñ³ëï³ïÙáõÙ
    BuiltIn.Delay(3000)
    Call wMainForm.MainMenu.Click(c_AllActions)
    Call wMainForm.PopupMenu.Click(c_ToVerify)
    BuiltIn.Delay(1000)
    Call ClickCmdButton(5, "²Ûá")
    
    BuiltIn.Delay(2000)
    wMDIClient.vbObject("frmPttel").Close
    
    'ö³ëï³ÃÕÃÇ áõÕ³ñÏáõÙ ÏñÏÝ³ÏÇ Ùáõïù³·ñÙ³Ý
    Call ChangeWorkspace(c_CustomerService)
    'ö³ëï³ÃÕÃÇ ³éÏ³ÛáõÃÛ³Ý ëïáõ·áõÙ Üáñ ëï»ÕÍí³Í Ï³ÝËÇÏ³óÙ³Ý Ñ³Ûï»ñ ÃÕÃ³å³Ý³ÏáõÙ
    docExist = Check_Doc_In_NewCashApp_Workpaper (accCash)
    If Not docExist Then
        Log.Error("The document with number " & docNumber & " doesn't exist in workpaper documents")
        Exit Sub
    End If
    
    'Î³ÝËÇÏ Ùáõïù ÷³ëï³ïÃÕÃÇ ëï»ÕÍáõÙ
    BuiltIn.Delay(3000)
    Call wMainForm.MainMenu.Click(c_AllActions)
    Call wMainForm.PopupMenu.Click("Ստեղծել «Կանխիկ Ելք»")
    
    If wMDIClient.WaitvbObject("frmASDocForm", 3000).Exists Then
      fISN = wMDIClient.vbObject("frmASDocForm").DocFormCommon.Doc.isn
      rekvName = GetVBObject("DOCNUM", wMDIClient.vbObject("frmASDocForm"))
      docNumber1 = wMDIClient.vbObject("frmASDocForm").vbObject("TabFrame").vbObject(rekvName).Text
      'êï³óáÕ դաշտի լրացում
      Call Rekvizit_Fill("Document", 1, "General", "CLICODE", "00034851") 
      'Նպատակ դաշտի լրացում
      Call Rekvizit_Fill("Document", 1, "General", "AIM", "²ÝÝå³ï³Ï") 
      Call ClickCmdButton(1, "Î³ï³ñ»É")
    Else
      Log.Error("Can't open frmASDocForm window")
    End If
     
    'îå»Éáõ Ó¨ å³ïáõÑ³ÝÇ ÷³ÏáõÙ
    BuiltIn.Delay(1000)   
    wMDIClient.vbObject("FrmSpr").Close
    
    BuiltIn.Delay(1000)
    wMDIClient.vbObject("frmPttel").Close
    
    'ö³ëï³ÃÕÃÇ áõÕ³ñÏáõÙ ÏñÏÝ³ÏÇ Ùáõïù³·ñÙ³Ý
    Call ChangeWorkspace(c_CustomerService)
    '²ßË³ï³Ýù³ÛÇÝ ÷³ëï³ÃÕÃ»ñ ÃÕÃ³å³Ý³ÏáõÙ ÷³ëï³ÃÕÃÇ ³éÏ³ÛáõÃÛ³Ý ëïáõ·áõÙ
    docExist = Online_PaySys_Check_Doc_In_Workpapers(docNumber1, data, data)
    If Not docExist Then
        Log.Error("The document with number " & docNumber1 & " doesn't exist in workpapers folder")
        Exit Sub
    End If
    
    Call CashInput_Send_To_CheckUp()
    
    'ö³ëï³ÃÕÃÇ í³í»ñ³óáõÙ í»ñëïáõ·áÕÇ ÷³ëï³ÃÕÃ»ñÇó
    Login("DOUBLEINPUTOPERATOR")
    docExist = PaySys_Check_Doc_In_InspecdetDoc_Folder(docNumber1)
    If Not docExist Then
        Log.Error("The document with number " & docNumber1 & "doesn't exist in inspected documents folder")
        Exit Sub
    End If
    
    'ö³ëï³ïÃÕÃÇ ÏñÏÝ³ÏÇ Ùáõïù³·ñáõÙ
    inspDocVerify = CashOutput_Verify_Doc_In_InspecdetDoc_Folder(accCash, summa)
    If Not inspDocVerify Then
        Log.Error("Wrong double input values ")
        Exit Sub
    End If
    
    Login("VERIFIER")
    'ö³ëï³ÃÕÃÇ ³éÏ³ÛáõÃÛ³Ý ëïáõ·áõÙ 1-ÇÝ Ñ³ëï³ïáÕÇ Ùáï
    docExist = Online_PaySys_Check_Doc_In_Verifier(docNumber1, data, data)
    If docExist Then
        Log.Error("The document with number " & docNumber1 & " mustn't exist in 1st verify documents")
        Exit Sub
    End If
    
    'ö³ëï³ÃÕÃÇ ³éÏ³ÛáõÃÛ³Ý ëïáõ·áõÙ 2-ñ¹ Ñ³ëï³ïáÕÇ Ùáï
    Login("VERIFIER2")
    docExist = PaySys_Check_Doc_In_Verifier(docNumber1, data, data, "|Ð³ëï³ïáÕ II ²Þî|Ð³ëï³ïíáÕ í×³ñ³ÛÇÝ ÷³ëï³ÃÕÃ»ñ")
    If Not docExist Then
        Log.Error("The document with number " & docNumber1 & "doesn't exist in 2nd verify documents")
        Exit Sub
    End If
    
    'ö³ëï³ÃÕÃÇ í³í»ñ³óáõÙ 2-ñ¹ Ñ³ëï³ïáÕÇ ÏáÕÙÇó
    Call PaySys_Verify(True)
    
    Login("ARMSOFT")
    '¶ÉË³íáñ Ñ³ßí³å³ÑÇ ÁÝ¹Ñ³Ýáõñ ¹ÇïáõÙ ÃÕÃ³å³Ý³ÏáõÙ ÷³ëï³ÃÕÃÇ ³éÏ³ÛáõÃÛ³Ý ëïáõ·áõÙ
    Call ChangeWorkspace(c_ChiefAcc)
    docExist = Check_Doc_In_GeneralView_Folder(fISN)
    If Not docExist Then
        Log.Error("The document with number " & fISN & " must exist in general view folder")
        Exit Sub
    End If                                 
    
    'ö³ëï³ÃÕÃÇ Ñ»é³óáõÙ
    Call Online_PaySys_Delete_Agr()
    
    BuiltIn.Delay(1000)
    wMDIClient.vbObject("frmPttel").Close
    
    Call ChangeWorkspace(c_CustomerService)
    'ö³ëï³ÃÕÃÇ ³éÏ³ÛáõÃÛ³Ý ëïáõ·áõÙ Üáñ ëï»ÕÍí³Í Ï³ÝËÇÏ³óÙ³Ý Ñ³Ûï»ñ ÃÕÃ³å³Ý³ÏáõÙ
    docExist = Check_Doc_In_NewCashApp_Workpaper (accCash)
    If Not docExist Then
        Log.Error("The document with number " & docNumber & " doesn't exist in workpaper documents")
        Exit Sub
    End If
    
    'ö³ëï³ÃÕÃÇ Ñ»é³óáõÙ
    Call Online_PaySys_Delete_Agr()
    
    'Test CleanUp
    Call Close_AsBank()
End Sub