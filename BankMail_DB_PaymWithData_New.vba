Option Explicit
'USEUNIT Library_Common
'USEUNIT Library_Contracts
'USEUNIT Payment_Order_ConfirmPhases_Library
'USEUNIT Subsystems_SQL_Library
'USEUNIT Online_PaySys_Library
'USEUNIT BankMail_Library
'USEUNIT BankMail_Library
'USEUNIT Library_CheckDB
'USEUNIT Constants
' Test Case ID 165073

Sub  PaymWithData_SendBankMail_DB_Test_New()

      Dim paramName, paramValue, confPath, confInput
      Dim volort, payScale, verify, authorPersonN
      Dim ordType, fISN, wAcsBranch, wAcsDepart, wDate, docNum, cliCode, accDB, payer, ePayer, taxCods,_
              jurState, dbDropDown, coaNum, balAcc, accMask, accCur, accType, cliName, cCode, accNote, accNote2,_
              accNote3, acsBranch, acsDepart, acsType, pCardNum, socCard, accCR, receiver, eReceiver, summa, wCur,_
              wAim, jurStatR, bankCr, authorPerson, addInfo, wAddress, authPerson, rInfo
      Dim queryString, sqlValue, colNum, sql_isEqual, value
      Dim wPayDate, status, rekvNum, docTypeName, commentName
      Dim colN, action, doNum, doActio, tdDate, state
      Dim workEnvName, workEnv, stRekName, endRekName, wStatus, isnRekName
      Dim childISN, wChildISN, wDateTime
      Dim sBody, bodyValue
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
      confPath = "X:\Testing\Order confirm phases\BankMailNoVerify.txt"
      confInput = Input_Config(confPath)
      If Not confInput Then
          Log.Error("Կարգավորումները չեն ներմուծվել")
          Exit Sub
      End If
      
      ' Կարգավորումների ներմուծում
      confPath = "X:\Testing\Order confirm phases\NoVerify.txt"
      confInput = Input_Config(confPath)
      If Not confInput Then
          Log.Error("Կարգավորումները չեն ներմուծվել")
         Exit Sub
      End If
      
      ' Մուտք Հաճախորդների սպասարկում և դրամարկղ(Ընդլայնված) ԱՇՏ
      Call ChangeWorkspace(c_CustomerService)
      
      ' Մուտք աշխատանքային փաստաթղթեր թղթապանակ
      workEnvName = "|Ð³×³Ëáñ¹Ç ëå³ë³ñÏáõÙ ¨ ¹ñ³Ù³ñÏÕ |²ßË³ï³Ýù³ÛÇÝ ÷³ëï³ÃÕÃ»ñ"
      workEnv = "Աշխատանքային փաստաթղթեր"
      wDate = "300617"
      stRekName = "PERN"
      endRekName = "PERK"
      wStatus = False
      state =  AccessFolder(workEnvName, workEnv, stRekName, wDate, endRekName, wDate, wStatus, isnRekName, fISN)
      If Not state Then
            Log.Error("Մուտք Աշխատանքային փաստաթղթեր թղթապանակ ձախողվել է")
            Exit Sub
      End If
            
      accCR = "18100/03359330100"
      payer = "Ð»ñ³ øñáÝáëáíÝ³"
      wCur = "000"
      ordType = "WPD"
      wAim = "Best friends forever"
      summa = "154000"
      accDB = "77700/000001100"
      dbDropDown = False
      authorPerson = "¼¨ë"
      authorPersonN = "¼»õë"
      addInfo = "ØáïÇÏÝ»ñÝ ³ëáõÙ »Ý ¼áõëÛ³"
      wAddress = "úÉÇÙåáë"
      authPerson = "²ñï»ÙÇë"
      rInfo= "øñáç ÏáÕÙÇó"
      receiver = "²åáÉáÝÇã"
      jurStatR = "21"

      ' Վճարման հանձնարարագրի ստեղծում
      Call PaymOrdToBeSentFill(ordType, fISN, wAcsBranch, wAcsDepart, wDate, docNum, cliCode, accDB, payer, ePayer, taxCods,_
                                                          jurState, dbDropDown, coaNum, balAcc, accMask, accCur, accType, cliName, cCode, accNote, accNote2,_
                                                          accNote3, acsBranch, acsDepart, acsType, pCardNum, socCard, accCR, receiver, eReceiver, summa, wCur,_
                                                          wAim, jurStatR, bankCr, authorPerson, addInfo, wAddress, authPerson, rInfo)
                                                          
      Log.Message("Փաստաթղթի ISN` " & fISN)
      Log.Message("Փաստաթղթի համար՝ " & docNum)
      
      Log.Message("SQL Check 1") 
    ' SQL ստուգում 
     queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                              " AND fTYPE = '11' AND fCUR = '000'   AND fCURSUM = '154000.00' AND fOP = 'TRF' " & _ 
                              " AND fDBCR = 'C' AND fSUID = '77' AND fSUM = '154000.00'"
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 

      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                              " AND fTYPE = '11' AND fCUR = '000'   AND fCURSUM = '154000.00' AND fOP = 'TRF' " & _ 
                              " AND fDBCR = 'D' AND fSUID = '77' AND fSUM = '154000.00'"
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 
              
      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                               " AND fTYPE = '11' AND fCUR = '000'   AND fCURSUM = '15400.00' AND fOP = 'FEE' " & _
                               " AND fDBCR = 'C' AND fSUID = '77' AND fSUM = '15400.00' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 
              
      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                              " AND fTYPE = '11' AND fCUR = '000'   AND fCURSUM = '15400.00' AND fOP = 'FEE' " & _
                              " AND fDBCR = 'D' AND fSUID = '77' AND fSUM = '15400.00'"
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 
      
      BuiltIn.Delay(3000)
      ' Կատարել բոլոր գործողությունները
      Call wMainForm.MainMenu.Click(c_AllActions)
      ' Խմբագրել Վճարման հանձնարարագրի պայմանագիրը
      Call wMainForm.PopupMenu.Click(c_ToEdit)
      If Not wMDIClient.WaitVBObject("frmASDocForm", 2000).Exists Then
            Log.Error("Վճարման հանձնարարագիրը չի բացվել")
            Exit Sub
      End If
      
      jurState = "11"
      volort = "23"
      payScale = "01"
      ' Իրավաբանական կարգավիճակ(վճարող) դաշտի լրացում
      Call Rekvizit_Fill("Document", 1, "General", "JURSTAT", jurState)
      
      ' Անցում Գանձում փոխանցումից բաժին
      Call GoTo_ChoosedTab(4)
      ' Գանձման տեսակ դաշտի լրացում
      Call Rekvizit_Fill("Document", 4, "General", "PAYSCALE2", payScale)
      ' Գրոծունեության ոլորտ դաշտի լրացում
      Call Rekvizit_Fill("Document", 4, "General", "VOLORT", volort)
           
      ' Անցում Վճարման տվյալներ բաժին
      Call GoTo_ChoosedTab(6)
      ' Հանձնարարականի կոդ դաշտի արժեքի ստուգում
      rekvNum = GetVBObject("PAYMENTCODE", wMDIClient.vbObject("frmASDocForm"))
      value = wMDIClient.VBObject("frmASDocForm").vbObject("TabFrame_6").vbObject(rekvNum).VBObject("TDBMask").Text
          
      If value <> "BKBK" Then
        Log.Error("Հանձնարարականի կոդ դաշտի արժեքը BKBK չէ:")
      Else
        Log.Message("Հանձնարարականի կոդ դաշտի արժեքի ստուգում - OK")
      End If
      ' Կատարել կոճակի սեղմում
      Call ClickCmdButton(1, "Î³ï³ñ»É")
      
      Log.Message("SQL Check 2") 
     ' SQL ստուգում 
     queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                              " AND fTYPE = '11' AND fCUR = '000'   AND fCURSUM = '154000.00' AND fOP = 'TRF' " & _ 
                              " AND fDBCR = 'C' AND fSUID = '77' AND fSUM = '154000.00' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 

      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                               " AND fTYPE = '11' AND fCUR = '000'   AND fCURSUM = '154000.00' AND fOP = 'TRF' " & _ 
                               " AND fDBCR = 'D' AND fSUID = '77' AND fSUM = '154000.00' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 
              
      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                               " AND fTYPE = '11' AND fCUR = '000'   AND fCURSUM = '15400.00' AND fOP = 'FEE' " & _
                               " AND fDBCR = 'C' AND fSUID = '77' AND fSUM = '15400.00' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 
              
      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                              " AND fTYPE = '11' AND fCUR = '000'   AND fCURSUM = '15400.00' AND fOP = 'FEE' " & _
                              " AND fDBCR = 'D' AND fSUID = '77' AND fSUM = '15400.00'"
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If
              
      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                               " AND fTYPE = '11' AND fCUR = '000'   AND fCURSUM = '154.00' AND fOP = 'FEE' " & _
                               " AND fDBCR = 'C' AND fSUID = '77' AND fSUM = '154.00' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 
              
      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                              " AND fTYPE = '11' AND fCUR = '000'   AND fCURSUM = '154.00' AND fOP = 'FEE' " & _
                              " AND fDBCR = 'D' AND fSUID = '77' AND fSUM = '154.00' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If

      ' Փաստաթղթի վավերացում
      Call PaySys_Verify(True)
      
      ' Փակել աշխատանքային փաստաթղթեր թղթապանակը
      BuiltIn.Delay(1000)
      wMDIClient.VBObject("frmPttel").Close
      
      ' Մուտք Գլխավոր հաշվապահի ԱՇՏ   
      Call ChangeWorkspace(c_ChiefAcc)
      
      ' Մուտք Հաշվառված վճարային փաստաթղթեր թղթապանակ
      workEnvName = "|¶ÉË³íáñ Ñ³ßí³å³ÑÇ ²Þî|ÂÕÃ³å³Ý³ÏÝ»ñ|Ð³ßí³éí³Í í×³ñ³ÛÇÝ ÷³ëï³ÃÕÃ»ñ"
      workEnv = "Հաշվառված վճարային փաստաթղթեր "
      isnRekName = "DOCISN"
      wStatus = True
      state = AccessFolder(workEnvName, workEnv, stRekName, wDate, endRekName, wDate, wStatus, isnRekName, fISN)
      If Not state Then
            Log.Error("Մուտք Հաշվառված վճարային փաստաթղթեր թղթապանակ ձախողվել է")
            Exit Sub
      End If
      
      ' Փակել վճարային փաստաթղթեր թղթապանակը
      BuiltIn.Delay(1000)
      wMDIClient.VBObject("frmPttel").Close
      
      ' Մուտք Արտաքին փոխանցումների ԱՇՏ 
      Call ChangeWorkspace(c_ExternalTransfers)
      
      ' Մուտք Ուղարկվող հանձնարարագրեր թղթապանակ
      workEnvName = "|²ñï³ùÇÝ ÷áË³ÝóáõÙÝ»ñÇ ²Þî|ÂÕÃ³å³Ý³ÏÝ»ñ|àõÕ³ñÏíáÕ Ñ³ÝÓÝ³ñ³ñ³·ñ»ñ|àõÕ³ñÏíáÕ Ñ³ÝÓÝ³ñ³ñ³·ñ»ñ"
      workEnv = "Ուղարկվող հանձնարարագրեր "
      wStatus = False
      state = AccessFolder(workEnvName, workEnv, stRekName, wDate, endRekName, wDate, wStatus, isnRekName, fISN)
      If Not state Then
            Log.Error("Մուտք Ուղարկվող հանձնարարագրեր թղթապանակ ձախողվել է")
            Exit Sub
      End If
      
      Log.Message("SQL Check 3") 
     ' SQL ստուգում 
     queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                              " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '154000.00' AND fOP = 'TRF' " & _ 
                              " AND fDBCR = 'C' AND fSUID = '77' AND fSUM = '154000.00' AND fBASEBRANCH = '00' AND fBASEDEPART = '1' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 

      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                               " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '154000.00' AND fOP = 'TRF' " & _ 
                               " AND fDBCR = 'D' AND fSUID = '77' AND fSUM = '154000.00' AND fBASEBRANCH = '00' AND fBASEDEPART = '1' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 
              
      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                               " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '15400.00' AND fOP = 'FEE' " & _
                               " AND fDBCR = 'C' AND fSUID = '77' AND fSUM = '15400.00' AND fBASEBRANCH = '00' AND fBASEDEPART = '1' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 
              
      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                              " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '15400.00' AND fOP = 'FEE' " & _
                              " AND fDBCR = 'D' AND fSUID = '77' AND fSUM = '15400.00' AND fBASEBRANCH = '00' AND fBASEDEPART = '1' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If
              
      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                               " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '154.00' AND fOP = 'FEE' " & _
                               " AND fDBCR = 'C' AND fSUID = '77' AND fSUM = '154.00' AND fBASEBRANCH = '00' AND fBASEDEPART = '1' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 
              
      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                              " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '154.00' AND fOP = 'FEE' " & _
                              " AND fDBCR = 'D' AND fSUID = '77' AND fSUM = '154.00' AND fBASEBRANCH = '00' AND fBASEDEPART = '1' "
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
            Log.Error("Վճարման հանձնարարագրն առկա չէ")
            Exit Sub  
      End If
      
      BuiltIn.Delay(1000)
      wMDIClient.VBObject("frmPttel").Close
      
      ' Մուտք Ուղարկված BankMail թղթապանակ
      workEnvName = "|²ñï³ùÇÝ ÷áË³ÝóáõÙÝ»ñÇ ²Þî|ÂÕÃ³å³Ý³ÏÝ»ñ|àõÕ³ñÏí³Í  Ñ³ÝÓÝ³ñ³ñ³·ñ»ñ|àõÕ³ñÏí³Í BankMail"
      workEnv = "Ուղարկված BankMail "
      state = AccessFolder(workEnvName, workEnv, stRekName, wDate, endRekName, wDate, wStatus, isnRekName, fISN)
      If Not state Then
            Log.Error("Մուտք Ուղարկված BankMail թղթապանակ ձախողվել է")
            Exit Sub
      End If
      
      ' Ստուգում որ Վճարման հանձնարարագիրն առկա է
      colN = 1
      state = CheckContractDoc(colN, docNum)
      If Not state Then
            Log.Error("Վճարման հանձնարարագիրն առկա չէ Ուղարկված BankMail թղթապանակում")
            Exit Sub  
      End If
      
      Log.Message("SQL Check 4") 
     ' SQL ստուգում 
     queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                              " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '154000.00' AND fOP = 'TRF' " & _ 
                              " AND fDBCR = 'C' AND fSUID = '77' AND fSUM = '154000.00' AND fBASEBRANCH = '00' AND fBASEDEPART = '1' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 

      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                               " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '154000.00' AND fOP = 'TRF' " & _ 
                               " AND fDBCR = 'D' AND fSUID = '77' AND fSUM = '154000.00' AND fBASEBRANCH = '00' AND fBASEDEPART = '1' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 
              
      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                               " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '15400.00' AND fOP = 'FEE' " & _
                               " AND fDBCR = 'C' AND fSUID = '77' AND fSUM = '15400.00' AND fBASEBRANCH = '00' AND fBASEDEPART = '1' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 
              
      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                              " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '15400.00' AND fOP = 'FEE' " & _
                              " AND fDBCR = 'D' AND fSUID = '77' AND fSUM = '15400.00' AND fBASEBRANCH = '00' AND fBASEDEPART = '1' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If
              
      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                               " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '154.00' AND fOP = 'FEE' " & _
                               " AND fDBCR = 'C' AND fSUID = '77' AND fSUM = '154.00' AND fBASEBRANCH = '00' AND fBASEDEPART = '1' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 
              
      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                              " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '154.00' AND fOP = 'FEE' " & _
                              " AND fDBCR = 'D' AND fSUID = '77' AND fSUM = '154.00' AND fBASEBRANCH = '00' AND fBASEDEPART = '1' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If
              
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
      Log.Message(childISN)
      If  Trim(wChildISN) <> Trim(childISN) Then
            Log.Error("Ծնող-զավակ կապի բացակայություն")
      End If
      
      ' Պայմանագիրն ուղարկել BankMail
      colN = 2
      state = Contract_To_Bank_Mail(colN, fISN)
      BuiltIn.Delay(3000)
      If Not state Then
            Log.Error("Պայմանագիրը չի գտնվել Bank Mail ուղարկելու համար")
            Exit Sub
      End If
      
      
      BuiltIn.Delay(1000)
      wMDIClient.VBObject("frmPttel").Close
      
      ' Այսօրվա ամսաթվի ստացում
      tdDate = aqConvert.DateTimeToFormatStr(aqDateTime.Now(), "%d%m%y")
      
      ' Մուտք Ուղարկված փոխանցումներ թղթապանակ
      workEnvName = "|BankMail ²Þî|öáË³ÝóáõÙÝ»ñ|àõÕ³ñÏí³Í ÷áË³ÝóáõÙÝ»ñ"
      workEnv = "Ուղարկված փոխանցումներ "
      state = AccessFolder(workEnvName, workEnv, stRekName, tdDate, endRekName, tdDate, wStatus, isnRekName, fISN)
      If Not state Then
            Log.Error("Մուտք Ուղարկված փոխանցումներ թղթապանակ ձախողվել է")
            Exit Sub
      End If
      
      ' Պայմանագրի առկայության ստուգում ուղարկված փոխանցումներ թղթապանակում
      colN = 3
      state = CheckContractDoc(colN, fISN)
      If Not state Then
          Log.Error("BankMail ուղարկված հաղորդագրությունը բացակայում է ուղարկված փոխանցումներ թղթապանակից")
          Exit Sub
      End If
      
      sBody = ":20:" & fISN & vbCRLF _
                  & ":23E:BKBK" & vbCRLF _ 
                  & ":30A:" & tdDate & Replace(wDateTime,":","") & vbCRLF _
                  & ":32A:" & Replace(wDate,"/","") & "AMD154000," & vbCRLF _
                  & ":23P:LP" & vbCRLF _
                  & ":50F:" & Replace(accDB, "/", "") & vbCRLF _ 
                  & Left(accDB, 5) & vbCRLF _
                  & "1/" & payer & vbCRLF _
                  & "0/" & authorPersonN & vbCRLF _
                  & "9/" & addInfo & vbCRLF _ 
                  & ":23Q:NP" & vbCRLF _          
                  & ":59E:" & Replace(Trim(accCR), "/", "") & vbCRLF _
                  & "1/" & receiver & vbCRLF _
                  & "8/" & wAddress & vbCRLF _   
                  & "9/" & rInfo & vbCRLF _ 
                  & ":70A:" & wAim      
          
      ' Տվյալների ստուգում bmInterface աղյուսակում
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