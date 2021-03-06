Option Explicit
'USEUNIT Library_Common
'USEUNIT Payment_Order_ConfirmPhases_Library
'USEUNIT Subsystems_SQL_Library
'USEUNIT Online_PaySys_Library
'USEUNIT BankMail_Library
'USEUNIT BankMail_Library
'USEUNIT Library_CheckDB
'USEUNIT Constants
' Test Case ID 165075

Sub BankMail_DB_PaymWithoutAcc_New()
    
      Dim paramName, paramValue, confPath, confInput
      Dim payer, docNum, wAim, accCR, param, sMes1, sMes2, aim
      Dim mDIClient, frmASDocForm, wTabStrip, frmPttel, fISN
      Dim vioid, wDate, receiver, accDB
      Dim docTypeName, commentName, status
      Dim queryString, sqlValue, colNum, sql_isEqual, sBody, bodyValue
      Dim colN, action, doNum, doActio, childISN, wDateTime, tdDate, wChildISN
      Dim workEnvName, workEnv, stRekName, endRekName, wStatus, isnRekName, state
      Dim startDate, fDate
     
      startDate = "20030101"
      fDate = "20250101"
      Call Initialize_AsBank("bank", startDate, fDate)
               
      ' Մուտք համակարգ ARMSOFT օգտագործողով
      Call Create_Connection()
      Login("ARMSOFT")
      
      ' Պարամետրերի արժեքների ճշգրտում   
      paramName = "BMUSEDB"
      paramValue = "1"
      Call  SetParameter(paramName, paramValue)
      
      paramName = "BMDBSERVER"
      paramValue = "qasql2017"
      Call  SetParameter(paramName, paramValue)
      
      paramName = "BMDBNAME"
      paramValue = "BankMail_Testing"
      Call  SetParameter(paramName, paramValue)
      
      ' Կարգավորումների ներմուծում
      confPath = "X:\Testing\Order confirm phases\NoVerify.txt"
      confInput = Input_Config(confPath)
      If Not confInput Then
          Log.Error("Կարգավորումները չեն ներմուծվել")
         Exit Sub
      End If
      
      ' Մուտք Հաճախորդների սպասարկում և դրամարկղ(Ընդլայնված)
      Call ChangeWorkspace(c_CustomerService)
      
      ' ՃՈ տուգանքի վճարում
      vioid = "123456789"
      wDate = "300617"
      accDB = "77700/77781553311"
      receiver = "ÎáÙÇë³ñ è»ùë"
      aim = "Öà í³ñáõÛÃÇ í×³ñáõÙ (í³ñáõÛÃÇ áñáßÙ³Ý Ñ³Ù³ñ` " & vioid & ")"
      Call PaymentOfTrafficPenalty(wDate, vioid, fISN, docNum, payer, accCR, wAim, accDB, receiver, sMes1, sMes2, aim)
        
      Log.Message("Փաստաթղթի ISN` " & fISN)
      Log.Message("Փաստաթղթի համար՝ " & docNum)
      
      Log.Message("SQL Check 1") 
     ' SQL ստուգում 
     queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                               " AND fTYPE = '11' AND fCUR = '000'   AND fCURSUM = '10000.00' AND fOP = 'TRF'  " & _ 
                               " AND fDBCR = 'C' AND fSUID = '77' AND fSUM = '10000.00' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 

      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                              " AND fTYPE = '11' AND fCUR = '000'   AND fCURSUM = '10000.00' AND fOP = 'TRF' " & _ 
                              " AND fDBCR = 'D' AND fSUID = '77' AND fSUM = '10000.00' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 
              
      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                               " AND fTYPE = '11' AND fCUR = '000'   AND fCURSUM = '80.00' AND fOP = 'FEE' " & _
                               " AND fDBCR = 'C' AND fSUID = '77' AND fSUM = '80.00'"
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 
              
      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                              " AND fTYPE = '11' AND fCUR = '000'   AND fCURSUM = '80.00' AND fOP = 'FEE' " & _
                              " AND fDBCR = 'D' AND fSUID = '77' AND fSUM = '80.00'"
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 
              
      ' Ստուգել որ Վճարման հանձնարարագիրն առկա է Հաճախորդի թղթապանակում
      docTypeName = "ì×³ñÙ³Ý Ñ³ÝÓÝ³ñ³ñ³·Çñ (áõÕ.)"
      commentName = "²Ùë³ÃÇí- 30/06/17 N- "& docNum &" ¶áõÙ³ñ-            10,000.00 ²ñÅ.- 000 [Üáñ                 ]"
      state = CheckPayOrderAvailableOrNot(docTypeName, commentName)
      If Not state Then
            Log.Error("Վճարման հանձնարարագիրն առկա չէ Հաճախորդի թղթապանակում")
            Exit Sub
      End If
      
      ' Փակել Հաճախորդի թղթապանակը
      BuiltIn.Delay(1000)
      wMDIClient.VBObject("frmPttel_2").Close
      
      ' Փաստաթուղթն ուղարկել արտաքին բաժին
      Call PaySys_Send_To_External()
      
      ' Փակել աշխատանքային փաստաթղթեր թղթապանակը
      BuiltIn.Delay(1000)
      wMDIClient.VBObject("frmPttel").Close
      
      ' Մուտք Գլխավոր հաշվապահի ԱՇՏ   
      Call ChangeWorkspace(c_ChiefAcc)
      
      ' Մուտք Հաշվառված Վճարային փաստաթղթեր թղթապանակ
      workEnvName = "|¶ÉË³íáñ Ñ³ßí³å³ÑÇ ²Þî|ÂÕÃ³å³Ý³ÏÝ»ñ|Ð³ßí³éí³Í í×³ñ³ÛÇÝ ÷³ëï³ÃÕÃ»ñ"
      workEnv = "Հաշվառված վճարային փաստաթղթեր"
      isnRekName = "DOCISN"
      wStatus = True
      stRekName = "PERN"
      endRekName = "PERK"
      state = AccessFolder(workEnvName, workEnv, stRekName, wDate, endRekName, wDate, wStatus, isnRekName, fISN)
      If Not state Then
            Log.Error("Սխալ՝ Հաշվառված Վճարային փաստաթղթեր թղթապանակ մուտք գործելիս")
            Exit Sub
      End If
      
      ' Փակել Վճարային փաստաթղթեր թղթապանակը
      BuiltIn.Delay(1000)
      wMDIClient.VBObject("frmPttel").Close
      
      ' Մուտք Արտաքին փոխանցումների ԱՇՏ 
      Call ChangeWorkspace(c_ExternalTransfers)
      
      ' Մուտք Ուղարկվող հաձնարարագրեր թղթապանակ
      workEnvName = "|²ñï³ùÇÝ ÷áË³ÝóáõÙÝ»ñÇ ²Þî|ÂÕÃ³å³Ý³ÏÝ»ñ|àõÕ³ñÏíáÕ Ñ³ÝÓÝ³ñ³ñ³·ñ»ñ|àõÕ³ñÏíáÕ Ñ³ÝÓÝ³ñ³ñ³·ñ»ñ"
      workEnv = "Ուղարկվող հաձնարարագրեր"
      wStatus = False
      state = AccessFolder(workEnvName, workEnv, stRekName, wDate, endRekName, wDate, wStatus, isnRekName, fISN)
      If Not state Then
            Log.Error("Սխալ՝ Ուղարկվող հաձնարարագրեր թղթապանակ մուտք գործելիս")
            Exit Sub
      End If
      
      Log.Message("SQL Check 2") 
     ' SQL ստուգում 
     queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                               " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '10000.00' AND fOP = 'TRF' " & _ 
                               " AND fDBCR = 'C' AND fSUID = '77' AND fSUM = '10000.00' AND fBASEBRANCH = '00' AND fBASEDEPART = '1' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 

      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                               " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '10000.00' AND fOP = 'TRF' " & _ 
                               " AND fDBCR = 'D' AND fSUID = '77' AND fSUM = '10000.00' AND fBASEBRANCH = '00' AND fBASEDEPART = '1' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 
              
      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                               " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '80.00' AND fOP = 'FEE' " & _
                               " AND fDBCR = 'D' AND fSUID = '77' AND fSUM = '80.00' AND fBASEBRANCH = '00' AND fBASEDEPART = '1' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 
              
      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                               " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '80.00' AND fOP = 'FEE' " & _
                               " AND fDBCR = 'D' AND fSUID = '77' AND fSUM = '80.00' AND fBASEBRANCH = '00' AND fBASEDEPART = '1' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If       
              
      ' Վճարման հանձնարարագիրն ուղարկել Bank Mail բաժին   
      colN = 2
      action = c_SendToBM
      doNum = 5
      doActio = "²Ûá"
      state = ConfirmContractDoc(colN, docNum, action, doNum, doActio)
      If Not state Then
            Log.Error("Վճարման հանձնարարագիրն առկա չէ ուղարկվող հաձնարարագրեր թղթապանակում")
            Exit Sub  
      End If
      
      BuiltIn.Delay(1000)
      wMDIClient.VBObject("frmPttel").Close
      
      ' Մուտք Ուղարկված BankMail թղթապանակ
      workEnvName = "|²ñï³ùÇÝ ÷áË³ÝóáõÙÝ»ñÇ ²Þî|ÂÕÃ³å³Ý³ÏÝ»ñ|àõÕ³ñÏí³Í  Ñ³ÝÓÝ³ñ³ñ³·ñ»ñ|àõÕ³ñÏí³Í BankMail"
      workEnv = "Ուղարկված BankMail"
      state = AccessFolder(workEnvName, workEnv, stRekName, wDate, endRekName, wDate, wStatus, isnRekName, fISN)
      If Not state Then
            Log.Error("Սխալ՝ Ուղարկված BankMail թղթապանակը մուտք գործելիս")
            Exit Sub
      End If
      
      ' Ստուգում որ Վճարման հանձնարարագիրն առկա է ուղարկված BankMail թղթապանակում
      colN = 1
      state = CheckContractDoc(colN, docNum)
      If Not state Then
            Log.Error("Վճարման հանձնարարագիրն առկա չէ ուղարկված BankMail թղթապանակում")
            Exit Sub  
      End If
      
      Log.Message("SQL Check 3")   
     ' SQL ստուգում HI աղյուսակում
     queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                               " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '10000.00' AND fOP = 'TRF' " & _ 
                               " AND fDBCR = 'C' AND fSUID = '77' AND fSUM = '10000.00' AND fBASEBRANCH = '00' AND fBASEDEPART = '1' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 

      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                               " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '10000.00' AND fOP = 'TRF' " & _ 
                               " AND fDBCR = 'D' AND fSUID = '77' AND fSUM = '10000.00' AND fBASEBRANCH = '00' AND fBASEDEPART = '1' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 
              
      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                               " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '80.00' AND fOP = 'FEE' " & _
                               " AND fDBCR = 'D' AND fSUID = '77' AND fSUM = '80.00' AND fBASEBRANCH = '00' AND fBASEDEPART = '1' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 
              
      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                               " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '80.00' AND fOP = 'FEE' " & _
                               " AND fDBCR = 'D' AND fSUID = '77' AND fSUM = '80.00' AND fBASEBRANCH = '00' AND fBASEDEPART = '1' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If           
              
      ' Փակել ուղարկված BankMail թղթապանակը
      BuiltIn.Delay(1000)
      wMDIClient.VBObject("frmPttel").Close
      
      ' Մուտք BANKMAIL օգտագործողով
      Login("BANKMAIL")
       
      ' Մուտք ուղարկված փոխանցումներ  
      Call ChangeWorkspace(c_BM) 

      ' Դիտել Վճարման հանձնարարագիրը 
      status = True
      Call WiewPayOrderFromTransferSent(wDate, fISN, childISN, status, wDateTime)
      If  childISN = " " Then
            Log.Error("Վճարման հանձնարարագիրն առկա չէ ուղարկված փոխանցումներ թղթապանակում")
            Exit Sub  
      End If
      
      ' Ծնող-զավակ կապի ստուգում  
      queryString = "SELECT fISN FROM DOCP WHERE  fPARENTISN = " & fISN
      wChildISN = Get_Query_Result(queryString)
      Log.Message("Զավակ փաստաթղթի ISN` " & childISN)
      If  Trim(wChildISN) <> Trim(childISN) Then
            Log.Error("Ծնող-զավակ կապի բացակայություն")
      End If
      
      ' Պայմանագրին ուղարկել BankMail
      colN = 2
      state = Contract_To_Bank_Mail(colN, fISN)
      If Not state Then
            Log.Error("Պայմանագիրը չի գտնվել Bank Mail ուղարկելու համար")
            Exit Sub
      End If
      
      BuiltIn.Delay(1000)
      wMDIClient.VBObject("frmPttel").Close
              
      ' Այսօրվա ամսաթվի ստացում
      tdDate = aqConvert.DateTimeToFormatStr(aqDateTime.Now(), "%d%m%y")
      
      ' Մուտք ուղարկված փոխանցումներ թղթապանակ
      workEnvName = "|BankMail ²Þî|öáË³ÝóáõÙÝ»ñ|àõÕ³ñÏí³Í ÷áË³ÝóáõÙÝ»ñ"
      workEnv = "Ուղարկված փոխանցումներ"
      state = AccessFolder(workEnvName, workEnv, stRekName, tdDate, endRekName, tdDate, wStatus, isnRekName, fISN)
      If Not state Then
            Log.Error("Սխալ՝ Ուղարկված փոխանցումներ թղթապանակ մուտք գործելիս")
            Exit Sub
      End If
      
      ' Պայմանագրի առկա լինելը ստուգող ֆունկցիա
      colN = 3
      state = CheckContractDoc(colN, fISN)
      If Not state Then
          Log.Error("BankMail ուղարկված հաղորդագրությունը բացակայում է ուղարկված հաղորդագրություններ թղթապանակից")
          Exit Sub
      End If
      
      sBody = ":20:" & fISN & vbCRLF _
                  & ":23E:TUBG" & vbCRLF _ 
                  & ":30A:" & tdDate & Replace(wDateTime,":","") & vbCRLF _
                  & ":32A:" & Replace(wDate,"/","") & "AMD10000," & vbCRLF _
                  & ":23P:NP" & vbCRLF _
                  & ":50E:" & Replace(accDB, "/", "") & vbCRLF _ 
                  & "1/" & payer & vbCRLF _
                  & "3/ZA-12-15" & vbCRLF _
                  & "8/Adress" & vbCRLF _ 
                  & ":23Q:LP" & vbCRLF _          
                  & ":59E:" & Replace(Trim(accCR), "/", "") & vbCRLF _
                  & "1/" & receiver & vbCRLF _
                  & ":70A:" & Left(wAim,35)  & vbCRLF _
                            & trim(Mid(wAim,36))  & vbCRLF _
                  & ":72B:" & sMes1 & vbCRLF _    
                            & sMes2 & vbCRLF _  
                  & ":77B:PTD/OTM000000E000000OT/0/0"  
          
      ' Տվյալների ստուգում [qasql2017].BankMail_Testing.dbo.bmInterface աղյուսակում
      queryString = " SELECT Body FROM [qasql2017].BankMail_Testing.dbo.bmInterface WHERE AS_ISN = " & wChildISN
      bodyValue = Get_Query_Result(queryString)
      If  Trim(sBody) <> Trim(bodyValue) Then
            Log.Error("Փաստաթղթի տվյալները BankMail-ում չեն համապատասխանում dictionary-ով փոխանցվող տվյալների հետ")
      End If
         
      BuiltIn.Delay(1000)
      wMDIClient.VBObject("frmPttel").Close
      
      ' Փակել ծրագիրը
      Call Close_AsBank()
End Sub