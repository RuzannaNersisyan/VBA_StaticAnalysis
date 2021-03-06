Option Explicit
'USEUNIT Library_Common
'USEUNIT Payment_Order_ConfirmPhases_Library
'USEUNIT Subsystems_SQL_Library
'USEUNIT Online_PaySys_Library
'USEUNIT BankMail_Library
'USEUNIT BankMail_Library
'USEUNIT Library_CheckDB
'USEUNIT Constants
'USEUNIT Library_Contracts

' Test Case ID 165074

Sub PayOrder_Verify_and_SendBankMail_File_Test_New()

      Dim file_HT100_Etalon, dictExcludedPatterns
      Dim payScale, chrgSum, volort
      Dim ordType, fISN, wAcsBranch, wAcsDepart, wDate, docNum, cliCode, accDB, payer, ePayer, taxCods,_
              jurState, dbDropDown, coaNum, balAcc, accMask, accCur, accType, cliName, cCode, accNote, accNote2,_
              accNote3, acsBranch, acsDepart, acsType, pCardNum, socCard, accCR, receiver, eReceiver, summa, wCur,_
              wAim, jurStatR, bankCr, authorPerson, addInfo, wAddress, authPerson, rInfo
      Dim verify, emptyPath, fileOut, userID
      Dim paramName, paramValue, confPath, confInput
      Dim queryString, sqlValue, colNum, sql_isEqual
      Dim wPayDate, paymentCode, status, rekvNum, docTypeName, commentName
      Dim workEnvName, workEnv, stRekName, endRekName, wStatus, isnRekName
      Dim colN, action, doNum, doActio, tdDate, state
      Dim childISN, wChildISN, wDateTime
      Dim sBody, bodyValue
      Dim startDate, fDate, verifyDocuments
     
      startDate = "20030101"
      fDate = "20250101"
      Call Initialize_AsBank("bank", startDate, fDate)
               
      ' Մուտք համակարգ ARMSOFT օգտագործողով
      Call Create_Connection()
      Login("ARMSOFT")
      
      file_HT100_Etalon = "X:\Testing\BankMail files for compare\HT100\IA000001.BMA"
      
      ' BMUSEDB պարամետրի արժեքի ճշգրտում   
      paramName = "BMUSEDB"
      paramValue = "0"
      Call  SetParameter(paramName, paramValue)
      
      ' Կարգավորումների ներմուծում
      confPath = "X:\Testing\Order confirm phases\Verify_1,3,2_New.txt"
      confInput = Input_Config(confPath)
      If Not confInput Then
          Log.Error("Կարգավորումները չեն ներմուծվել")
         Exit Sub
      End If
      
      ' Մուտք Հաճախորդների սպասարկում և դրամարկղ(Ընդլայնված)
      Call ChangeWorkspace(c_CustomerService)
      
      ' Մուտք աշխատանքային փաստաթղթեր
      workEnvName = "|Ð³×³Ëáñ¹Ç ëå³ë³ñÏáõÙ ¨ ¹ñ³Ù³ñÏÕ |²ßË³ï³Ýù³ÛÇÝ ÷³ëï³ÃÕÃ»ñ"
      workEnv = "Աշխատանքային փաստաթղթեր"
      wDate = "290517"
      stRekName = "PERN"
      endRekName = "PERK"
      wStatus = False
      state =  AccessFolder(workEnvName, workEnv, stRekName, wDate, endRekName, wDate, wStatus, isnRekName, fISN)
      If Not state Then
            Log.Error("Սխալ՝ Աշխատանքային փաստաթղթեր թղթապանակ մուտք գործելիս")
            Exit Sub
      End If
      
      ordType = "PAY"
      dbDropDown = False
      accDB = "77700/000001100"
      payer = "Ð³Ùß»Ý³Ñ³Û»ñÇ ÙÇáõÃÛáõÝ"
      accCR = "11500/00000060000"
      receiver = "²ñ³ ²µñ³Ñ³ÙÛ³ÝÇ ýáÝ¹"
      eReceiver = "To be fond of Ara Abrahamyan"
      summa = "4500.00"
      wAim = "ú·ÝáõÃÛáõÝ Ñ³Û »Õµ³ÛñÝ»ñáõÝ"
           
      ' Վճարման հանձնարարագրի լրացում
      Call PaymOrdToBeSentFill(ordType, fISN, wAcsBranch, wAcsDepart, wDate, docNum, cliCode, accDB, payer, ePayer, taxCods,_
                                                          jurState, dbDropDown, coaNum, balAcc, accMask, accCur, accType, cliName, cCode, accNote, accNote2,_
                                                          accNote3, acsBranch, acsDepart, acsType, pCardNum, socCard, accCR, receiver, eReceiver, summa, wCur,_
                                                          wAim, jurStatR, bankCr, authorPerson, addInfo, wAddress, authPerson, rInfo)
      Log.Message(fISN)
      Log.Message(docNum)
    
      ' Խմբագրել վճարման հանձնարարագիրը
      jurState = "12"
      volort = "6"
      payScale = "55"
      chrgSum = "1800.00"
      state = EditPeymentOrder(jurState, volort, payScale, chrgSum) 
      If Not state Then
            Log.Error("Սխալ՝ Վճարման հանձնարարագրի պայմանագրի խմբագրման ժամանակ")
            Exit Sub
      End If
      
      Log.Message("SQL Check 1") 
     ' SQL ստուգում 
     queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                              " AND fTYPE = '11' AND fCUR = '000'   AND fCURSUM = '4500.00' AND fOP = 'TRF' " & _
                              " AND fDBCR = 'C' AND fSUID = '77' AND fSUM = '4500.00' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 

      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                               " AND fTYPE = '11' AND fCUR = '000'   AND fCURSUM = '4500.00' AND fOP = 'TRF' " & _
                               " AND fDBCR = 'D' AND fSUID = '77' AND fSUM = '4500.00' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 
              
      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                               " AND fTYPE = '11' AND fCUR = '000'   AND fCURSUM = '1800.00' AND fOP = 'FEE' " & _
                               " AND fDBCR = 'C' AND fSUID = '77' AND fSUM = '1800.00' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 
              
      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                              " AND fTYPE = '11' AND fCUR = '000'   AND fCURSUM = '1800.00' AND fOP = 'FEE' " & _
                              " AND fDBCR = 'D' AND fSUID = '77' AND fSUM = '1800.00' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 

      ' Վճարման հանձնարարագիրն ուղարկել հաստատման
      Call PaySys_Send_To_Verify()
      
      ' Փակել աշխատանքային փաստաթղթեր թղթապանակը
      BuiltIn.Delay(1000)
      wMDIClient.VBObject("frmPttel").Close
      
      ' Մուտք գործել VERIFIER օգտագործողով 
      Login("VERIFIER")
      
      ' Մուտք հաստատվող վճարային փաստաթղթեր
'      Call wTreeView.DblClickItem("|Ð³ëï³ïáÕ I ²Þî|Ð³ëï³ïíáÕ í×³ñ³ÛÇÝ ÷³ëï³ÃÕÃ»ñ")
      Set verifyDocuments = New_VerificationDocument()
      verifyDocuments.User = "^A[Del]"
      Call GoToVerificationDocument("|Ð³ëï³ïáÕ I ²Þî|Ð³ëï³ïíáÕ í×³ñ³ÛÇÝ ÷³ëï³ÃÕÃ»ñ",verifyDocuments)
      'êïáõ·»É, áñ ³éÏ³ ã¿
      colN = 3
      state = CheckContractDoc(colN, docNum)
      If state Then
            Log.Error("Վճարման հանձնարարագրի պայմանագիրը չպետք է առկա լինի հաստատվող վճարային փաստաթղթեր թղթապանակում")
            Exit Sub
      End If
      
      ' Մուտք գործել VERIFIER3 օգտագործողով 
      Login("VERIFIER3")
      
      ' Մուտք հաստատվող վճարային փաստաթղթեր
'      Call wTreeView.DblClickItem("|Ð³ëï³ïáÕ III ²Þî|Ð³ëï³ïíáÕ í×³ñ³ÛÇÝ ÷³ëï³ÃÕÃ»ñ")
      Set verifyDocuments = New_VerificationDocument()
      verifyDocuments.User = "^A[Del]"
      Call GoToVerificationDocument("|Ð³ëï³ïáÕ III ²Þî|Ð³ëï³ïíáÕ í×³ñ³ÛÇÝ ÷³ëï³ÃÕÃ»ñ",verifyDocuments)
      
      ' Ստուգել որ վճարման հանձնարարագրի պայմանագիրն առկա է
      colN = 3
      action = c_ToConfirm
      doNum = 1
      doActio = "Ð³ëï³ï»É"
      state = ConfirmContractDoc(colN, docNum, action, doNum, doActio)
      If Not state Then
            Log.Error("Վճարման հանձնարարագրի պայմանագիրն առկա չէ")
            Exit Sub
      End If
      
      ' Մուտք գործել VERIFIER2 օգտագործողով 
      Login("VERIFIER2")
      
      ' Մուտք հաստատվող վճարային փաստաթղթեր
'      Call wTreeView.DblClickItem("|Ð³ëï³ïáÕ II ²Þî|Ð³ëï³ïíáÕ í×³ñ³ÛÇÝ ÷³ëï³ÃÕÃ»ñ")
      Set verifyDocuments = New_VerificationDocument()
      verifyDocuments.User = "^A[Del]"
      Call GoToVerificationDocument("|Ð³ëï³ïáÕ II ²Þî|Ð³ëï³ïíáÕ í×³ñ³ÛÇÝ ÷³ëï³ÃÕÃ»ñ",verifyDocuments)
      
      ' Ստուգել որ վճարման հանձնարարագիրն առկա է հաստատվող վճարային փաստաթղթեր թղթապանակում
      colN = 3
      action = c_ToConfirm
      doNum = 1
      doActio = "Ð³ëï³ï»É"
      state = ConfirmContractDoc(colN, docNum, action, doNum, doActio)
      If Not state Then
            Log.Error("Վճարման հանձնարարագիրն առկա չէ հաստատվող վճարային փաստաթղթեր թղթապանակում")
            Exit Sub
      End If
      
      ' Մուտք գործել ARMSOFT օգտագործողով 
      Login("ARMSOFT")
      
      ' Մուտք Գլխավոր հաշվապահի ԱՇՏ  
      Call ChangeWorkspace(c_ChiefAcc)
      
      ' Մուտք Հաշվառված Վճարային փաստաթղթեր թղթապանակ
      workEnvName = "|¶ÉË³íáñ Ñ³ßí³å³ÑÇ ²Þî|ÂÕÃ³å³Ý³ÏÝ»ñ|Ð³ßí³éí³Í í×³ñ³ÛÇÝ ÷³ëï³ÃÕÃ»ñ"
      workEnv = "Հաշվառված վճարային փաստաթղթեր"
      isnRekName = "DOCISN"
      wStatus = True
      state = AccessFolder(workEnvName, workEnv, stRekName, wDate, endRekName, wDate, wStatus, isnRekName, fISN)
      If Not state Then
            Log.Error("Սխալ՝  Հաշվառված Վճարային փաստաթղթեր թղթապանակ մուտք գործելիս")
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
                              " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '4500.00' AND fOP = 'TRF' " & _
                              " AND fDBCR = 'C' AND fSUID = '77' AND fSUM = '4500.00' AND fBASEBRANCH = '00' AND fBASEDEPART = '1' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 

      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                               " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '4500.00' AND fOP = 'TRF' " & _
                               " AND fDBCR = 'D' AND fSUID = '77' AND fSUM = '4500.00' AND fBASEBRANCH = '00' AND fBASEDEPART = '1' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 
              
      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                               " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '1800.00' AND fOP = 'FEE' " & _
                               " AND fDBCR = 'C' AND fSUID = '77' AND fSUM = '1800.00' AND fBASEBRANCH = '00' AND fBASEDEPART = '1' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 
              
      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                              " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '1800.00' AND fOP = 'FEE' " & _
                              " AND fDBCR = 'D' AND fSUID = '77' AND fSUM = '1800.00' AND fBASEBRANCH = '00' AND fBASEDEPART = '1' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 

      ' Վճարման հանձնարարագրի պայմանագիրն ուղարկել BankMail բաժին   
      colN = 2
      action = c_SendToBM
      doNum = 5
      doActio = "²Ûá"
      state = ConfirmContractDoc(colN, docNum, action, doNum, doActio)
      If Not state Then
            Log.Error("Վճարման հանձնարարագրի պայմանագիրն առկա չէ Ուղարկվող հաձնարարագրեր թղթապանակում")
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
      
      ' Ստուգում որ Վճարման հանձնարարագրի պայմանագիրն առկա է
      colN = 1
      state = CheckContractDoc(colN, docNum)
      If Not state Then
            Log.Error("Վճարման հանձնարարագրի պայմանագիրն առկա չէ Ուղարկված BankMail թղթապանակում")
            Exit Sub  
      End If
      
      Log.Message("SQL Check 3") 
    ' SQL ստուգում 
     queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                              " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '4500.00' AND fOP = 'TRF' " & _
                              " AND fDBCR = 'C' AND fSUID = '77' AND fSUM = '4500.00' AND fBASEBRANCH = '00' AND fBASEDEPART = '1' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 

      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                               " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '4500.00' AND fOP = 'TRF' " & _
                               " AND fDBCR = 'D' AND fSUID = '77' AND fSUM = '4500.00' AND fBASEBRANCH = '00' AND fBASEDEPART = '1' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 
              
      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                               " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '1800.00' AND fOP = 'FEE' " & _
                               " AND fDBCR = 'C' AND fSUID = '77' AND fSUM = '1800.00' AND fBASEBRANCH = '00' AND fBASEDEPART = '1' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 
              
      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                              " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '1800.00' AND fOP = 'FEE' " & _
                              " AND fDBCR = 'D' AND fSUID = '77' AND fSUM = '1800.00' AND fBASEBRANCH = '00' AND fBASEDEPART = '1' "
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 

      ' Մուտք BANKMAIL օգտագործողով 
      Login("BANKMAIL")
       
      ' Մուտք ուղարկվող փոխանցումներ  
      Call ChangeWorkspace(c_BM) 

      ' Դիտել Վճարման հանձնարարագրի պայմանագիրն 
      status = False
      Call WiewPayOrderFromTransferSent(wDate, fISN, childISN, status, wDateTime)
      If  childISN = " " Then
            Log.Error("Վճարման հանձնարարագրի պայմանագիրն առկա չէ ուղարկվող փոխանցումներ թղթապանակում")
            Exit Sub  
      End If
      
      ' Ծնող-զավակ կապի ստուգում
      queryString = "SELECT fISN FROM DOCP WHERE  fPARENTISN = " & fISN
      wChildISN = Get_Query_Result(queryString)
      Log.Message(childISN)
      If  Trim(wChildISN) <> Trim(childISN) Then
            Log.Error("Ծնող-զավակ կապի բացակայություն")
      End If

      ' Ֆայլային համակարգով ուղարկելուց առաջ թղթապանակի դատարկում 
      emptyPath = "X:\Testing\POST\INP\"
      Call Empty_Folder(emptyPath)
       
      ' Պայմանագիրն ուղարկել BankMail
      colN = 2
      state = Contract_To_Bank_Mail(colN, fISN)
      BuiltIn.Delay(3000)
      If Not state Then
            Log.Error("Պայմանագիրը չի գտնվել BankMail ուղարկելու համար")
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
      
      ' Պայմանագրի առկայության ստուգում
      colN = 3
      state = CheckContractDoc(colN, fISN)
      If Not state Then
          Log.Error("BankMail ուղարկված հաղորդագրությունը բացակայում է ուղարկված հաղորդագրություններ թղթապանակից")
          Exit Sub
      End If
      
      ' Համեմատում արտահանման արդյունքի հետ(ֆայլային)         
      ' Արտահանված ֆայլի լրիվ հասցեն
      fileOut = Get_File_Name(fISN)
      If IsNull(fileOut) Then
          Log.Error("Ֆայլի անունը լրացված չէ")
          Exit Sub
      End If
      
      userID = 77
      fileOut = Param("BMPAYIN", userID) & fileOut
      Log.Message("Output file is` " & fileOut)
              
      ' Էտալոնային ֆայլի համեմատում արտահանված ֆայլի հետ
      Set dictExcludedPatterns = CreateObject("Scripting.Dictionary")
      dictExcludedPatterns.Add 1, ":20:\d{9,10}"
              
      If Not Compare_Files_With_Patterns_Array(fileOut, file_HT100_Etalon, dictExcludedPatterns) Then
        Log.Error("Համեմատվող ֆայլերը չեն համընկնում")
      End If
      
      ' Փակել ՀԾ-Բանկ ծրագիրը
      Call Close_AsBank()
End Sub