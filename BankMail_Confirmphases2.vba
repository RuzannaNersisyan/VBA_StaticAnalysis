Option Explicit
'USEUNIT Library_Common
'USEUNIT Payment_Order_ConfirmPhases_Library
'USEUNIT Online_PaySys_Library
'USEUNIT Currency_Exchange_Confirmphases_Library
'USEUNIT CashInput_Confirmphases_Library
'USEUNIT BankMail_Library  
'USEUNIT Constants    

'Test case number - 165057

Sub BankMail_Reject_Test()
  Dim fDATE, startDATE , docNumber, stockID, volume, senderAcc,senderName , recstockAcc
  Dim recstockName,confInput, confPath, docExist, isDel, rCount, data,fISN
    
  data = Null
  Utilities.ShortDateFormat = "yyyymmdd"
  startDATE = "20030101"
  fDATE = "20250101"
  confPath = "X:\Testing\Order confirm phases\BankMail_Reject.txt"               
  stockID = "GB20072283"
  volume = "30,000,000.00" 
  senderAcc = "1660041200064"
  senderName = "Petrosyan Petros"
  recstockAcc = "1150040000004" 
  recstockName = "äáÕáëÛ³Ý äáÕáë"
    
  'Test StartUp 
  Call Initialize_AsBank("bank", startDATE, fDATE)
    
  'Î³ñ·³íáñáõÙÝ»ñÇ Ý»ñÙáõÍáõÙ
  confInput = Input_Config(confPath)
  If Not confInput Then
    Log.Error("The configuration doesn't input")
  End If

  'ì×³ñÙ³Ý Ñ³ÝÓÝ³ñ³ñ·ñÇ ëï»ÕÍáõÙ
  Login("BANKMAIL")
  Call ChangeWorkspace(c_SecuritiesBM)
  Call wTreeView.DblClickItem("|²ñÅ»ÃÕÃ»ñ (BankMail) ²Þî|Üáñ Ñ³Õáñ¹³·ñáõÃÛáõÝ|²ñÅ»ÃÕÃ»ñÇ ³½³ï ³é³ùÙ³Ý Ñ³ÝÓÝ³ñ³ñ³Ï³Ý (Ðî 522)")
  Call BankMail_FreeDeliver_Doc_Fill(docNumber, stockID, volume, senderAcc,senderName ,recstockAcc,recstockName ,fISN)
    
  Login("ARMSOFT")
  Call ChangeWorkspace(c_BM)
  docExist = BankMail_Check_Doc_In_Sending_SecrOrd_Folder(fISN)
  If Not docExist Then
    Log.Error("The document with number " & docNumber & " doesn't exist in workpapers folder")
    Exit Sub
  End If
    
  'ö³ëï³ÃÕÃÇ áõÕ³ñÏáõÙ Ñ³ëï³ïÙ³Ý
  Call PaySys_Send_To_Verify()
    
  'ö³ëï³ÃÕÃÇ ³éÏ³ÛáõÃÛ³Ý ëïáõ·áõÙ 1-ÇÝ Ñ³ëï³ïáÕÇ Ùáï
  Login("VERIFIER")
  docExist = Online_PaySys_Check_Doc_In_Verifier(docNumber, data, data)
  If Not docExist Then
    Log.Error("The document with number " & docNumber & " must exist in 1st verify documents")
    Exit Sub
  End If
    
  'ö³ëï³ÃÕÃÇ í³í»ñ³óáõÙ 1-ÇÝ  Ñ³ëï³áïÕÇ ÏáÕÙÇó
  Call PaySys_Verify(True)
    
  'ö³ëï³ÃÕÃÇ ³éÏ³ÛáõÃÛ³Ý ëïáõ·áõÙ 2-ñ¹ Ñ³ëï³ïáÕÇ Ùáï
  Login("VERIFIER2")
  docExist = PaySys_Check_Doc_In_Verifier(docNumber, data, data, "|Ð³ëï³ïáÕ II ²Þî|Ð³ëï³ïíáÕ í×³ñ³ÛÇÝ ÷³ëï³ÃÕÃ»ñ")
  If Not docExist Then
    Log.Error("The document with number " & docNumber & "doesn't exist in 2nd verify documents")
    Exit Sub
  End If
    
  'ö³ëï³ÃÕÃÇ Ù»ñÅáõÙ 2-ñ¹ Ñ³ëï³áïÕÇ ÏáÕÙÇó
  Call PaySys_Verify(False)
    
  Login("ARMSOFT")
  Call ChangeWorkspace(c_BM)
  docExist = BankMail_Check_Doc_In_Sending_SecrOrd_Folder(fISN)
  If Not docExist Then
    Log.Error("The document with number " & docNumber & " doesn't exist in workpapers folder")
    Exit Sub
  End If
    
  'ö³ëï³ÃÕÃÇ áõÕ³ñÏáõÙ Ñ³ëï³ïÙ³Ý
  Call PaySys_Send_To_Verify()
    
  'ö³ëï³ÃÕÃÇ ³éÏ³ÛáõÃÛ³Ý ëïáõ·áõÙ 1-ÇÝ Ñ³ëï³ïáÕÇ Ùáï
  Login("VERIFIER")
  docExist = Online_PaySys_Check_Doc_In_Verifier(docNumber, data, data)
  If Not docExist Then
    Log.Error("The document with number " & docNumber & " must exist in 1st verify documents")
    Exit Sub
  End If
    
  'ö³ëï³ÃÕÃÇ í³í»ñ³óáõÙ 1-ÇÝ  Ñ³ëï³áïÕÇ ÏáÕÙÇó
  Call PaySys_Verify(True)
    
  'ö³ëï³ÃÕÃÇ ³éÏ³ÛáõÃÛ³Ý ëïáõ·áõÙ 2-ñ¹ Ñ³ëï³ïáÕÇ Ùáï
  Login("VERIFIER2")
  docExist = PaySys_Check_Doc_In_Verifier(docNumber, data, data, "|Ð³ëï³ïáÕ II ²Þî|Ð³ëï³ïíáÕ í×³ñ³ÛÇÝ ÷³ëï³ÃÕÃ»ñ")
  If Not docExist Then
    Log.Error("The document with number " & docNumber & "doesn't exist in 2nd verify documents")
    Exit Sub
  End If
    
  'ö³ëï³ÃÕÃÇ Ù»ñÅáõÙ 2-ñ¹ Ñ³ëï³áïÕÇ ÏáÕÙÇó
  Call PaySys_Verify(True)
    
  'ö³ëï³ÃÕÃÇ ³éÏ³ÛáõÃÛ³Ý ëïáõ·áõÙ 3-ñ¹ Ñ³ëï³ïáÕÇ Ùáï
  Login("VERIFIER3")
  docExist = PaySys_Check_Doc_In_Verifier(docNumber, data, data, "|Ð³ëï³ïáÕ III ²Þî|Ð³ëï³ïíáÕ í×³ñ³ÛÇÝ ÷³ëï³ÃÕÃ»ñ")
  If Not docExist Then
    Log.Error("The document with number " & docNumber & "doesn't exist in 2nd verify documents")
    Exit Sub
  End If
    
  'ö³ëï³ÃÕÃÇ Ñ³ëï³ïáõÙ 3-ñ¹ Ñ³ëï³áïÕÇ ÏáÕÙÇó
  Call PaySys_Verify(True)
    
  Login("ARMSOFT")
  Call ChangeWorkspace(c_BM)
  docExist = BankMail_Check_Doc_In_Sending_SecrOrd_Folder(fISN)
  If Not docExist Then
    Log.Error("The document with number " & docNumber & " doesn't exist in workpapers folder")
    Exit Sub
  End If
    
  'ö³ëï³ÃÕÃÇ Ñ»é³óáõÙ
  Call Online_PaySys_Delete_Agr()
    
  'Test CleanUp 
  Call Close_AsBank()
End Sub