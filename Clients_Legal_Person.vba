Option Explicit
'USEUNIT  Clients_Library
'USEUNIT Subsystems_SQL_Library
'USEUNIT  Library_Common
'USEUNIT Constants
'USEUNIT BankMail_Library
'USEUNIT Acc_Statements_Library
'USEUNIT  Payment_Except_Library
'USEUNIT  SWIFT_International_Payorder_Library
'USEUNIT  Payment_Order_ConfirmPhases_Library
'USEUNIT BankMail_Library
'USEUNIT SWIFT_International_Payorder_Library
'USEUNIT Mortgage_Library
'Test Case 125661

' Հաճախորդի (իրավաբանական անձի) ստեղծում
Sub Clients_Legal_Person_Test()

      Dim buttonName, fISN, cliCode, jurStat, socialCard, pasCode, passType, firstName, passBy, datePass, dateExpire, _
               lastName, patrName, rezident, cliNote, todayDMY, wName, wVolort, petBuj, gender, citizenship, bidthPlace,wCountry,_
               wDistrict, wCommunity, wCity, wStreet, buildNum, wApartment, wCountry2, wDistrict2, wCommunity2, _
               wCity2, wStreet2, buildNum2, wApartment2, wCheckBox, accStatForm, cardStatForm, sencAddress, _
               stDate, wMonth, wDay, fileName, fileName2, fileName3
                                               
      Dim colN, action, doNum, doActio, state, frmPttel, dacsType
      Dim folderDirect, rekvName, folderName, frmPttel2, windName
      Dim accType, curSum, fillOffSect, accISN, BalanceAcc, clName, dbtOrKrd, codVal, wAcc, wAccType, openDate, acsType
      Dim inOrOut, wDate, wKassa, wSumma, wAim, accCr, wPayer, accDb
      Dim docTypeName, commentName, docNumIn, docNumOut, outISN, inISN, cardISN
      Dim docN, feeAcc, payerName, wService, wPlace, minSum, maxSum
      Dim workEnvName, workEnv, stRekName, endRekName, wStatus, isnRekName
      Dim stateType, showOverdrOpers, shDraft, shCorName, accTmp, stateimOut
      Dim codBal, balName, balAccType, balAcc, deletDocNum
      Dim savePath, fName, fileName4, fileName5, fIdent, cash
      Dim param, toFile, fileNameN, isExists, payerLName
      Dim pcStand, quantity, acsBranch, acsDepart, docNum, wPcStand, cardType, cardNum, _
          motherCard, wPass, validFrom, valDate, payDate, cardSort, smartCard
      Dim startDate, standart, duration, endDate, dBoxType, dBoxNumber, wCliCode, payType, depSumma
      Dim confPath, confInput, queryString, paramName, paramValue
      Dim fDATE, sDATE
      
      fDATE = "20250101"
      sDATE = "20120101"
      Call Initialize_AsBank("bank", sDATE, fDATE)
      
      ' Մուտք գործել համակարգ ARMSOFT օգտագործողով 
      Call Create_Connection()
      Login("ARMSOFT")
      
      ' Մուտք ադմինիստրատորի ԱՇՏ
      Call ChangeWorkspace(c_Admin)
      
      ' Կարգավորումների ներմուծում
      confPath = Project.Path & "Stores\Verifier\CashInput_Allverify.txt"
      confInput = Input_Config(confPath)
      If Not confInput Then
          Log.Error("Կարգավորումները չեն ներմուծվել")
         Exit Sub
      End If
      
      Call ChangeWorkspace(c_Admin)
      
      ' Կարգավորումների ներմուծում
      confPath = Project.Path & "Stores\Verifier\CashOutput_Allverify.txt"
      confInput = Input_Config(confPath)
      If Not confInput Then
          Log.Error("Կարգավորումները չեն ներմուծվել")
         Exit Sub
      End If
      
      ' Մուտք ադմինիստրատորի ԱՇՏ4.0
      Call ChangeWorkspace(c_Admin40)
      
      ' Մուտք Հաճախորդներ թղթապանակ 
      folderDirect = "|²¹ÙÇÝÇëïñ³ïáñÇ ²Þî 4.0|î»Õ»Ï³ïáõÝ»ñ|Ð³×³Ëáñ¹Ý»ñ"
      folderName = "Հաճախորդներ"
      state = OpenFolderClickDo(folderDirect, folderName)
      
      If Not state Then
            Log.Error("Սխալ՝ Հաճախորդներ թղթապանակ մուտք գործելիս")
            Exit Sub
      End If
      
      buttonName = "RadioButton_3"
      jurStat = "11"
      socialCard = "0123456789"
      wName = "Î³ñ»Ý Î³ñ»ÝÇ Î³ñ»ÝÛ³Ý"
      rezident = "1"
      cliNote = "12"
      todayDMY = aqConvert.DateTimeToFormatStr(aqDateTime.Today,"%d/%m/%y")
      wVolort = "11"
      wCountry = "AM"
      wDistrict = "001"
      wCommunity = "010010635"
      wStreet = "î»ñÛ³Ý"
      buildNum = "îáõÝ"
      wApartment = "8"
      wCountry2 = "AM"
      wDistrict2 = "001"
      wCommunity2 = "010010635"
      wStreet2 = "²µáíÛ³Ý"
      buildNum2 = "Þ»Ýù"
      wApartment2 = "5"
      wCheckBox = 1
      wMonth = "1"
      wDay = "15"
      accStatForm = "1"
      cardStatForm = "1"
      sencAddress = "1"
      fileName = "\\host2\Sys\Testing\ClientsTest\AsDE4C.doc"
      fileName2 = "\\host2\Sys\Testing\ClientsTest\Capture.PNG"
      fileName3 = "\\host2\Sys\Testing\ClientsTest\ForTest.txt"
           
      ' Հաճախորդի ստեղծում
      Call CheckClient(buttonName, fISN, cliCode, jurStat, socialCard, pasCode, passType, passBy, datePass, dateExpire, firstName, _
                                       lastName, patrName, rezident, cliNote, todayDMY, wName, wVolort, petBuj, gender, citizenship, bidthPlace,wCountry,_
                                       wCommunity, wCity, wStreet, buildNum, wApartment, wCountry2,wCommunity2, _
                                       wCity2, wStreet2, buildNum2, wApartment2, wCheckBox, accStatForm, cardStatForm, sencAddress, _
                                       todayDMY, wMonth, wDay, fileName, fileName2, fileName3)
                                
      Log.Message(cliCode)
      Log.Message(fISN)
      BuiltIn.Delay(5000)
      
      ' Ստուգում որ հաճախորդը ստեղծվել է
      colN = 0
      state = CheckContractDoc(colN, cliCode)
      
      If Not state Then
            Log.Error("Հաճախորդի փաստաթուղթը չի ստեղծվել")
            Exit Sub
      End If

      ' Ստեղծել հաշիվ
      accType = "01"
      curSum = "000"
      fillOffSect = "1"
      balAcc = "3022000"
      dbtOrKrd = "2"
      wAccType = "01"
      acsType = "99"
      Call CreateAccount(accType, curSum, dacsType, fillOffSect, accISN, balAcc, clName, dbtOrKrd, codVal, wAccType, openDate, wAcc, acsType)
      Log.Message(accISN)
      Log.Message(wAcc)
      
      Call Close_Pttel("frmPttel")
      
      ' Մուտք Հաշիվներ թղթապանակ 
      folderDirect = "|²¹ÙÇÝÇëïñ³ïáñÇ ²Þî 4.0|î»Õ»Ï³ïáõÝ»ñ|Ð³ßÇíÝ»ñ"
      rekvName = "CLICOD"
      folderName = "Հաշիվներ"
      state =  OpenFolder(folderDirect, folderName, rekvName, cliCode)
      
      If Not state Then
            Log.Error("Սխալ՝ Հաշիվներ թղթապանակ մուտք գործելիս")
            Exit Sub
      End If
 
      ' Կանխիկ մուտք փաստաթղթի ստեղծում
      inOrOut = c_CashIn
      wSumma = 10000.00
      wAim = "test"
      wPayer = "Î³ñ»Ý"
      payerLName = "Î³ñ»ÝÛ³Ý"
      Call CashInOut(inOrOut, inISN, docNumIn, wDate, wKassa, wSumma, wAim, accCr, accDb, jurStat, cliCode, wPayer, payerLName)
      
      ' Կանխիկ ելք փաստաթղթի ստեղծում
      inOrOut = c_CashOut
      wSumma = 1000
      Call CashInOut(inOrOut, outISN, docNumOut, wDate, wKassa, wSumma, wAim, accCr, accDb, jurStat, cliCode, wPayer, payerLName)
      
      ' Փակել հաշիվներ թղթապանակը
      Call Close_Pttel("frmPttel")
      
'      ' Մուտք Հաճախորդներ թղթապանակ
'      folderDirect = "|²¹ÙÇÝÇëïñ³ïáñÇ ²Þî 4.0|î»Õ»Ï³ïáõÝ»ñ|Ð³×³Ëáñ¹Ý»ñ"
'      rekvName = "CLIMASK"
'      folderName = "Հաճախորդներ"
'      state = OpenFolder(folderDirect, folderName, rekvName, cliCode)
'      
'      If Not state Then
'            Log.Error("Սխալ՝ հաճախորդներ թղթապանակ մուտք գործելիս")
'            Exit Sub
'      End If
'      
'      ' Կանխիկ մուտք փաստաթղթի առկայության ստուգում Հաճախորդներ թղթապանակում
'      docTypeName = "Î³ÝËÇÏ Ùáõïù"
'      commentName = "²Ùë³ÃÇí- "& todayDMY &" N- "& docNumIn &" ¶áõÙ³ñ-            10,000.00 ²ñÅ.- "& curSum &" [Üáñ]"
'      state = CheckPayOrderAvailableOrNot(docTypeName, commentName)
'      BuiltIn.Delay(10000)
'      
'      If Not state Then
'            Log.Error("Կանխիկ մուտք փաստաթղթն առկա չէ Հաճախորդներ թղթապանակում")
'            Exit Sub
'      End If
'      
'      Call Close_Pttel("frmPttel_2")
'      
'      ' Կանխիկ ելք փաստաթղթի առկայության ստուգում Հաճախորդներ թղթապանակում
'      docTypeName = "Î³ÝËÇÏ »Éù"
'      commentName = "²Ùë³ÃÇí- "& todayDMY &" N- "& docNumOut &" ¶áõÙ³ñ-             1,000.00 ²ñÅ.- "& curSum &" [Üáñ]"
'      state = CheckPayOrderAvailableOrNot(docTypeName, commentName)
'      
'      If Not state Then
'            Log.Error("Կանխիկ ելք փաստաթղթն առկա չէ Հաճախորդներ թղթապանակում")
'            Exit Sub
'      End If
'      
'      Call Close_Pttel("frmPttel_2")
'      Call Close_Pttel("frmPttel")
      
      ' Մուտք Աշխատանքային փաստաթղթեր թղթապանակ
      workEnvName = "|²¹ÙÇÝÇëïñ³ïáñÇ ²Þî 4.0|ÂÕÃ³å³Ý³ÏÝ»ñ|²ßË³ï³Ýù³ÛÇÝ ÷³ëï³ÃÕÃ»ñ"
      workEnv = "Աշխատանքային փաստաթղթեր"
      stRekName = "PERN"
      wStatus = False
      endRekName = "PERK"
      state = AccessFolder(workEnvName, workEnv, stRekName, todayDMY, endRekName, todayDMY, wStatus, isnRekName, fISN)
      
      If Not state Then
            Log.Error("Մուտք Աշխատանքային փաստաթղթեր թղթապանակ ձախողվել է")
            Exit Sub
      End If
      
      ' Կանխիկ մուտք փաստաթուղթն ուղարկել հաստատման Verifier
      colN = 2
      action = c_SendToVer
      doNum = 2
      doActio = "Î³ï³ñ»É"
      state = ConfirmContractDoc(colN, docNumIn, action, doNum, doActio)
      
      If Not state Then
            Log.Error("Կանխիկ մուտք փաստաթուղթը չի ուղարկվել հաստատման")
            Exit Sub
      End If
      
      Call Close_Pttel("frmPttel")
      
      ' Մուտք համակարգ VERIFIER օգտագործողով
      Login("VERIFIER")
      ' Մուտք հաստատվող վճարային փաստաթղթեր թղթապանակ
      Call wTreeView.DblClickItem("|Ð³ëï³ïáÕ I ²Þî|Ð³ëï³ïíáÕ í×³ñ³ÛÇÝ ÷³ëï³ÃÕÃ»ñ")
      BuiltIn.Delay(2000)
      Call Rekvizit_Fill("Dialog", 1, "General", "USER","^A[Del]" & "")
      Call ClickCmdButton(2, "Î³ï³ñ»É")
      BuiltIn.Delay(2000)
      
      ' Վավերացնել Կանխիկ մուտքի փաստաթուղթը
      colN = 3
      action = c_ToConfirm
      doNum = 1
      doActio = "Ð³ëï³ï»É"
      state = ConfirmContractDoc(colN, docNumIn, action, doNum, doActio)
      
      If Not state Then
            Log.Error("Կանխիկ մուտքի փաստաթուղթը չի վավերացվել")
            Exit Sub
      End If
      
      Call Close_Pttel("frmPttel") 
      
      Login("ARMSOFT")
      
      ' Մուտք ադմինիստրատորի ԱՇՏ4.0
      Call ChangeWorkspace(c_Admin40)
      
      ' Մուտք Աշխատանքային փաստաթղթեր թղթապանակ
      workEnvName = "|²¹ÙÇÝÇëïñ³ïáñÇ ²Þî 4.0|ÂÕÃ³å³Ý³ÏÝ»ñ|²ßË³ï³Ýù³ÛÇÝ ÷³ëï³ÃÕÃ»ñ"
      workEnv = "Աշխատանքային փաստաթղթեր "
      stRekName = "PERN"
      wStatus = False
      endRekName = "PERK"
      state = AccessFolder(workEnvName, workEnv, stRekName, todayDMY, endRekName, todayDMY, wStatus, isnRekName, fISN)
      
      ' Վավերացնել Կանխիկ մուտք փաստաթուղթը
      colN = 2
      action = c_ToConfirm
      doNum = 1
      doActio = "Ð³ëï³ï»É"
      state = ConfirmContractDoc(colN, docNumIn, action, doNum, doActio)
      
      If Not state Then
            Log.Error("Կանխիկ մուտքի փաստաթուղթը չի վավերացվել")
            Exit Sub
      End If
      Call Close_Pttel("frmPttel")

      ' Մուտք Հաշիվներ թղթապանակ 
      folderDirect = "|²¹ÙÇÝÇëïñ³ïáñÇ ²Þî 4.0|î»Õ»Ï³ïáõÝ»ñ|Ð³ßÇíÝ»ñ"
      rekvName = "CLICOD"
      folderName = "Հաշիվներ"
      state =  OpenFolder(folderDirect, folderName, rekvName, cliCode)
      
      If Not state Then
            Log.Error("Սխալ՝ Հաշիվներ թղթապանակ մուտք գործելիս")
            Exit Sub
      End If
      
      ' Քաղվածքի ստեղծում
      stateType = "2"
      showOverdrOpers = 1
      shDraft = 0
      shCorName = 0
      accTmp = "AccState_AS\7"
      state  = ViewAccExcerption(todayDMY, todayDMY, stateType, showOverdrOpers, shDraft, shCorName, accTmp, stateimOut)
      
      If Not state Then
            Log.Error("Քաղվածքը չի ստեղծվել") 
            Exit Sub
      End If
      
      BuiltIn.Delay(1000) 
      
      ' Ջնջել ATTACHMENTS թղթապանակը AS-BANK թղթապանակից
      aqFileSystem.DeleteFolder("C:\Users\"& Sys.UserName & "\AppData\Local\Temp\AS-BANK\ATTACHMENTS")
      
      ' Կատարում է ստուգում,եթե նման անունով ֆայլ կա տրված թղթապանակում ,ջնջում է
      isExists = aqFile.Exists(Project.Path& "Stores\Clients\Actual\legelPersonActual.txt")
      If isExists Then
        aqFileSystem.DeleteFile(Project.Path& "Stores\Clients\Actual\legelPersonActual.txt")
      End If
    
      BuiltIn.Delay(4000) 
      fileNameN = ListFiles("C:\Users\"& Sys.UserName & "\AppData\Local\Temp\AS-BANK")
      BuiltIn.Delay(4000) 
      fileName4 = "C:\Users\" & Sys.UserName & "\AppData\Local\Temp\AS-BANK\" & Trim(fileNameN)
      BuiltIn.Delay(5000) 
      fileName5 = Project.Path & "Stores\Clients\Expected\legelPersonExpec.txt"
      BuiltIn.Delay(5000) 
      Log.Message(fileName4)
      toFile = Project.Path & "Stores\Clients\Actual\legelPersonActual.txt"
      BuiltIn.Delay(3000) 
      Call Read_Write_File(fileName4, toFile)
      BuiltIn.Delay(3000) 
      
      ' Համեմատել ֆայլերը
      param = "([0-9]{2}[/][0-9]{2}[/][0-9]{2}).[0-9] [0-9]{2}[:][0-9]{2}|([0-9]{2}[/][0-9]{2}[/][0-9]{2})|(<td class=""statement-trxn-docnum table-cell"">[0][0][0]([0-9]{3})<[/]td>)"
      Call Compare_Files(fileName5, toFile,param)

      Call Close_Pttel("frmPttel")  
      
      ' Մուտք Աշխատանքային փաստաթղթեր թղթապանակ
      workEnvName = "|²¹ÙÇÝÇëïñ³ïáñÇ ²Þî 4.0|ÂÕÃ³å³Ý³ÏÝ»ñ|²ßË³ï³Ýù³ÛÇÝ ÷³ëï³ÃÕÃ»ñ"
      workEnv = "Աշխատանքային փաստաթղթեր "
      stRekName = "PERN"
      wStatus = False
      endRekName = "PERK"
      state = AccessFolder(workEnvName, workEnv, stRekName, todayDMY, endRekName, todayDMY, wStatus, isnRekName, fISN)
      
      If Not state Then
            Log.Error("Մուտք Աշխատանքային փաստաթղթեր թղթապանակ ձախողվել է")
            Exit Sub
      End If
      
      ' Կանխիկ ելք փաստաթուղթն ուղարկել հաստատման Verifier
      action = c_SendToVer
      doNum = 2
      doActio = "Î³ï³ñ»É"
      state = ConfirmContractDoc(colN, docNumOut, action, doNum, doActio)
      
      If Not state Then
            Log.Error("Կանխիկ ելք փաստաթուղթը չի ուղարկվել հաստատման")
            Exit Sub
      End If
      
      Call Close_Pttel("frmPttel")
      
      ' Մուտք համակարգ VERIFIER օգտագործողով
      Login("VERIFIER")
      
      ' Մուտք հաստատվող վճարային փաստաթղթեր թղթապանակ
      Call wTreeView.DblClickItem("|Ð³ëï³ïáÕ I ²Þî|Ð³ëï³ïíáÕ í×³ñ³ÛÇÝ ÷³ëï³ÃÕÃ»ñ")
      BuiltIn.Delay(2000)
      Call Rekvizit_Fill("Dialog", 1, "General", "USER","^A[Del]" & "")
      Call ClickCmdButton(2, "Î³ï³ñ»É")
      BuiltIn.Delay(2000)
      
      If Not Sys.Process("Asbank").VBObject("MainForm").Window("MDIClient", "", 1).VBObject("frmPttel").Exists Then
            Log.Error("Հաստատվող վճարային փաստաթղթեր թղթապանակը չի բացվել")
            Exit Sub
      End If
      
      ' Վավերացնել Կանխիկ ելք փաստաթուղթը
      colN = 3
      action = c_ToConfirm
      doNum = 1
      doActio = "Ð³ëï³ï»É"
      state = ConfirmContractDoc(colN, docNumOut, action, doNum, doActio)
      
      If Not state Then
            Log.Error("Կանխիկ ելք փաստաթուղթը չի վավերացվել")
            Exit Sub
      End If
      
      Call Close_Pttel("frmPttel")
      
      ' Մուտք համակարգ ARMSOFT օգտագործողով
      Login("ARMSOFT")
      
      ' Մուտք ադմինիստրատորի ԱՇՏ4.0
      Call ChangeWorkspace(c_Admin40)
      
      ' Մուտք Հաճախորդներ թղթապանակ    
      folderDirect = "|²¹ÙÇÝÇëïñ³ïáñÇ ²Þî 4.0|î»Õ»Ï³ïáõÝ»ñ|Ð³×³Ëáñ¹Ý»ñ"
      rekvName = "CLIMASK"
      folderName = "Հաճախորդներ"
      state =  OpenFolder(folderDirect, folderName, rekvName, cliCode)
      
      If Not state Then
            Log.Error("Սխալ՝ Հաճախորդներ թղթապանակ մուտք գործելիս")
            Exit Sub
      End If
      
      ' Ետհաշվեկշռային հաշվի ստեղծում
      codBal = "8300000" 
      curSum = "000"
      balAccType = "20"
      Call CreateBalanceSheetAccount(codBal, balName, curSum, balAccType, openDate, BalanceAcc)
      Log.Message(balAcc)
      Call Close_Pttel("frmPttel")
      
      ' Ետհաշվեկշռային հաշվի փաստաթղթի առկայության ստուգում Ետհաշվեկշռային հաշիվներ թղթապանակում       
      folderDirect = "|²¹ÙÇÝÇëïñ³ïáñÇ ²Þî 4.0|î»Õ»Ï³ïáõÝ»ñ|ºïÑ³ßí»Ïßé³ÛÇÝ Ñ³ßÇíÝ»ñ"
      rekvName = "CLICOD"
      folderName = "Ետհաշվեկշռային հաշիվներ"
      state =  OpenFolder(folderDirect, folderName, rekvName, cliCode)
      
      If Not state Then
            Log.Error("Սխալ՝ Ետհաշվեկշռային հաշիվներ թղթապանակ մուտք գործելիս")
            Exit Sub
      End If
      Call Close_Pttel("frmPttel")
      
      ' Մուտք Հաճախորդներ թղթապանակ    
      folderDirect = "|²¹ÙÇÝÇëïñ³ïáñÇ ²Þî 4.0|î»Õ»Ï³ïáõÝ»ñ|Ð³×³Ëáñ¹Ý»ñ"
      rekvName = "CLIMASK"
      folderName = "Հաճախորդներ"
      state =  OpenFolder(folderDirect, folderName, rekvName, cliCode)
      
      If Not state Then
            Log.Error("Սխալ՝ Հաճախորդներ թղթապանակ մուտք գործելիս")
            Exit Sub
      End If
      
      ' Պարբերական կոմունալ վճարումների պայամանագրի ստեղծում
      feeAcc = "00000293022"
      wService = "PA"
      wPlace = "11"
      minSum = "1000"
      maxSum = "2000"
      Call RegularUtilityPayments(docN, cliCode, payerName, feeAcc, wService, wPlace, minSum, maxSum)
      
      ' Պարբերական կոմունալ վճարումների պայամանագրի առկայության ստուգում Հաճախորդներ թղթապանակում
      docTypeName = "ä³ñµ»ñ³Ï³Ý ÏáÙáõÝ³É í×³ñáõÙÝ»ñÇ å³ÛÙ³Ý³·Çñ"
      commentName = "²Ùë³ÃÇí- "& todayDMY &" N- "& docN &" [Üáñ]"
      state = CheckPayOrderAvailableOrNot(docTypeName, commentName)
      
      If Not state Then
            Log.Error("Կանխիկ ելք փաստաթուղթն առկա չէ Հաճախորդներ թղթապանակում")
            Exit Sub
      End If
      
      Call Close_Pttel("frmPttel_2")
      BuiltIn.Delay(1500)
      Call Close_Pttel("frmPttel")
      
      ' Մուտք Հաճախորդներ թղթապանակ    
      folderDirect = "|²¹ÙÇÝÇëïñ³ïáñÇ ²Þî 4.0|î»Õ»Ï³ïáõÝ»ñ|Ð³×³Ëáñ¹Ý»ñ"
      rekvName = "CLIMASK"
      folderName = "Հաճախորդներ"
      state =  OpenFolder(folderDirect, folderName, rekvName, cliCode)
      
      If Not state Then
            Log.Error("Սխալ՝ Հաճախորդներ թղթապանակ մուտք գործելիս")
            Exit Sub
      End If
      
'      ' Բացել պլաստիկ քարտ
'      pcStand = "110"
'      quantity = "1"
'      acsBranch = "00"
'      acsDepart = "1"
'      wAcc = "00000373022"
'      cardType = "110"
'      cardNum = "9051190200005872"
'      motherCard = "4847010000102812"
'      wPass = "1111"
'      valDate = "010125"
'      cardSort = "1"
'      smartCard = "0"
'      Call CreatePlasticCard(pcStand, quantity, acsBranch, acsDepart, cardISN, docNum, wAcc, pcStand, clName, cardType, cardNum, _
'                                                  motherCard, wPass, todayDMY, valDate, todayDMY, cardSort, smartCard)
'                                                  
'      Log.Message(cardISN)
      
      ' Հաճախորդին գրանցել սև ցուցակում
      colN = 0
      action = c_FreBlackLock & "|" & c_RegToBlackList
      doNum = 2
      doActio = "Î³ï³ñ»É"
      state = ConfirmContractDoc(colN, cliCode, action, doNum, doActio)
      
      If Not state Then
            Log.Error("Հաճախորդը չի գրանցվել սև ցուցակում")
            Exit Sub
      End If
      
      Call Close_Pttel("frmPttel")
      
      ' Մուտք Սև ցուցակ վարողի ԱՇՏ
      Call ChangeWorkspace(c_BLKeeper)
      
      ' Մուտք Սև ցուցակ թղթապանակ    
      folderDirect = "|§ê¨ óáõó³Ï¦ í³ñáÕÇ ²Þî|§ê¨ óáõó³Ï¦"
      rekvName = "CLICODE1"
      folderName = "Սև ցուցակ"
      state =  OpenFolder(folderDirect, folderName, rekvName, cliCode)
      
      If Not state Then
            Log.Error("Սխալ՝ Սև ցուցակ թղթապանակ մուտք գործելիս")
            Exit Sub
      End If
      
      ' Ջնջել հաճախորդին սև ցուցակից
      colN = 12
      action = c_Delete
      state = ConfirmContractDoc(colN, cliCode, action, doNum, doActio)
      
      If Not state Then
            Log.Error("Հաճախորդը չի գտնվել և չի ջնջվել")
            Exit Sub
      End If
      
      BuiltIn.Delay(4000) 
      Call Close_Pttel("frmPttel")
      BuiltIn.Delay(2000) 
      
      ' Մուտք ադմինիստրատորի ԱՇՏ4.0
      Call ChangeWorkspace(c_Admin40)

      ' Մուտք ստեղծված փաստաթղթեր թղթապանակ
      workEnvName = "|²¹ÙÇÝÇëïñ³ïáñÇ ²Þî 4.0|ÂÕÃ³å³Ý³ÏÝ»ñ|êï»ÕÍí³Í ÷³ëï³ÃÕÃ»ñ"
      workEnv = "Ստեղծված փաստաթղթեր"
      stRekName = "SDATE"
      endRekName = "EDATE"
      wStatus = True
      isnRekName = "ISN"
      state = AccessFolder(workEnvName, workEnv, stRekName, todayDMY, endRekName, todayDMY, wStatus, isnRekName, outISN)
      
      If Not state Then
            Log.Error("Սխալ՝ Ստեղծված փաստաթղթեր թղթապանակ մուտք գործելիս")
            Exit Sub
      End If
      
      ' Կանխիկ ելք փաստաթղթի ջնջում
      cash = False
      Call Paysys_Delete_Doc(cash)
      Call Close_Pttel("frmPttel")
      
      ' Մուտք ստեղծված փաստաթղթեր թղթապանակ
      state = AccessFolder(workEnvName, workEnv, stRekName, todayDMY, endRekName, todayDMY, wStatus, isnRekName, inISN)
      
      If Not state Then
            Log.Error("Սխալ՝ Ստեղծված փաստաթղթեր թղթապանակ մուտք գործելիս")
            Exit Sub
      End If
      
      ' Կանխիկ մուտք փաստաթղթի ջնջում
      Call Paysys_Delete_Doc(cash)
      Call Close_Pttel("frmPttel")
      
      
      
'      ' Կատարել բոլոր գործողությունները
'      Call wMainForm.MainMenu.Click(c_AllActions)
'      ' Հաճախորդի թղթապանակի բացում
'      Call wMainForm.PopupMenu.Click(c_ClFolder)

'      ' Ջնջել տոկոսի հաշվարկման պայմանագիրը
'      colN = 0
'      deletDocNum = " îáÏáëÇ Ñ³ßí³ñÏÙ³Ý å³ÛÙ³Ý³·Çñ"
'      action = c_Delete
'      windName = "frmPttel_2"
'      state = DeleteFromCustomFolder(windName, colN, deletDocNum, action)
'      BuiltIn.Delay(1000) 
'      
'      If Not state Then
'            Log.Error("Տոկոսի հաշվարկման պայմանագիրը չի գտնվել և չի ջնջվել")
'            Exit Sub
'      End If
      
'      Call Close_Pttel("frmPttel_2")
      
'      ' Կատարել բոլոր գործողությունները
'      Call wMainForm.MainMenu.Click(c_AllActions)
'      ' Հաճախորդի թղթապանակի բացում
'      Call wMainForm.PopupMenu.Click(c_ClFolder)
'      
'      ' Ջնջել Պլաստիկ քարտ փաստաթուղթը
'      colN = 0
'      deletDocNum = "  äÉ³ëïÇÏ ù³ñï"
'      action = c_Delete
'      doNum = 5
'      doActio = "àã"
'      state = ActionWithDocument(windName, colN, deletDocNum, action, doNum, doActio)
'      BuiltIn.Delay(1000) 
'      Call ClickCmdButton(3 ,"²Ûá")
'      
'      If Not state Then
'            Log.Error("Պարբերական կոմունալ վճարումների պայմանագիրը չի գտնվել և չի ջնջվել")
'            Exit Sub
'      End If
'      
'      Call Close_Pttel("frmPttel_2")
      
      ' Ջնջել Ետհաշվեկշռային հաշվի փաստաթղթը     
      folderDirect = "|²¹ÙÇÝÇëïñ³ïáñÇ ²Þî 4.0|î»Õ»Ï³ïáõÝ»ñ|ºïÑ³ßí»Ïßé³ÛÇÝ Ñ³ßÇíÝ»ñ"
      rekvName = "CLICOD"
      folderName = "Ետհաշվեկշռային հաշիվներ"
      state =  OpenFolder(folderDirect, folderName, rekvName, cliCode)
      
      If Not state Then
            Log.Error("Սխալ՝ Ետհաշվեկշռային հաշիվներ թղթապանակ մուտք գործելիս")
            Exit Sub
      End If
      
      windName = "frmPttel"
      colN = 5
      action = c_Delete
      doNum = 3
      doActio = "²Ûá"
      state = ActionWithDocument(windName, colN, cliCode, action, doNum, doActio)
      
      If Not state Then
            Log.Error("Պարբերական կոմունալ վճարումների պայմանագիրը չի գտնվել և չի ջնջվել")
            Exit Sub
      End If
      Call Close_Pttel("frmPttel")
      
      ' Մուտք Հաճախորդներ թղթապանակ    
      folderDirect = "|²¹ÙÇÝÇëïñ³ïáñÇ ²Þî 4.0|î»Õ»Ï³ïáõÝ»ñ|Ð³×³Ëáñ¹Ý»ñ"
      rekvName = "CLIMASK"
      folderName = "Հաճախորդներ"
      state =  OpenFolder(folderDirect, folderName, rekvName, cliCode)
      
      If Not state Then
            Log.Error("Սխալ՝ Հաճախորդներ թղթապանակ մուտք գործելիս")
            Exit Sub
      End If
      
      ' Կատարել բոլոր գործողությունները
      Call wMainForm.MainMenu.Click(c_AllActions)
      ' Հաճախորդի թղթապանակի բացում
      Call wMainForm.PopupMenu.Click(c_ClFolder)
      
      ' Ջնջել Պարբերական կոմունալ վճարումների պայմանագիրը
      windName = "frmPttel_2"
      colN = 0
      deletDocNum = "ä³ñµ»ñ³Ï³Ý ÏáÙáõÝ³É í×³ñáõÙÝ»ñÇ å³ÛÙ³Ý³·Çñ"
      action = c_Delete
      doNum = 3
      doActio = "²Ûá"
      state = ActionWithDocument(windName, colN, deletDocNum, action, doNum, doActio)
      
      If Not state Then
            Log.Error("Պարբերական կոմունալ վճարումների պայմանագիրը չի գտնվել և չի ջնջվել")
            Exit Sub
      End If

      Call Close_Pttel("frmPttel_2")
      
      ' Փնտրել Հաշիվ փաստաթուղթը
      docTypeName = "  Ð³ßÇí"
      commentName = ""& feeAcc &"  ²ñÅ.- "& curSum &"  îÇå- 01  Ð/Ð³ßÇí- "& balAcc &"   ²Ýí³ÝáõÙ-"& wName &""
      state = CheckPayOrderAvailableOrNot(docTypeName, commentName)
      
      If Not state Then
            Log.Error("Հաշիվ փաստաթուղթը չի գտնվել և չի ջնջվել")
            Exit Sub
      End If
      
      ' Ջնջել Հաշիվ փասատթուղթը 
      Call Paysys_Delete_Doc(cash)
      
      Call Close_Pttel("frmPttel_2")
      
'      ' Փնտրել Հաշիվ փաստաթուղթը
'      docTypeName = "  Ð³ßÇí"
'      commentName = "00000453022  ²ñÅ.- "& curSum &"  Ð/Ð³ßÇí- 30221NI   ²Ýí³ÝáõÙ-"& wName &"- ù³ñï- % Ï.Ñ."
'      state = CheckPayOrderAvailableOrNot(docTypeName, commentName)
'      
'      If Not state Then
'            Log.Error("Հաշիվ փաստաթուղթը չի գտնվել և չի ջնջվել")
'            Exit Sub
'      End If
'      
'      ' Ջնջել Հաշիվ փասատթուղթը 
'      Call Paysys_Delete_Doc(cash)
'      
'      Call Close_Pttel("frmPttel_2") 
'      
'      ' Փնտրել Հաշիվ փաստաթուղթը
'      docTypeName = "  Ð³ßÇí"
'      commentName = ""& wAcc &"  ²ñÅ.- "& curSum &"  Ð/Ð³ßÇí- "& balAcc &"   ²Ýí³ÝáõÙ-"& wName &"- ù³ñï"
'      state = CheckPayOrderAvailableOrNot(docTypeName, commentName)
'      
'      If Not state Then
'            Log.Error("Հաշիվ փաստաթուղթը չի գտնվել և չի ջնջվել")
'            Exit Sub
'      End If
'      
'      ' Ջնջել Հաշիվ փասատթուղթը 
'      Call Paysys_Delete_Doc(cash)
'      
'      Call Close_Pttel("frmPttel_2")      
      
      ' Հաճախորդ փաստաթղթի ջնջում
      Call Paysys_Delete_Doc(cash)
      Call Close_Pttel("frmPttel")
      
      ' Փակել ՀԾ-Բանկ ծրագիրը
      Call Close_AsBank
      
End Sub