'USEUNIT Library_Common
'USEUNIT Library_Contracts
'USEUNIT Constants
'USEUNIT Library_Colour
'USEUNIT DAHK_Library_Filter
'USEUNIT CashOutput_Confirmpases_Library
'USEUNIT Payment_Except_Library
'USEUNIT Akreditiv_Library
'USEUNIT Main_Accountant_Filter_Library
'USEUNIT SWIFT_International_Payorder_Library
'USEUNIT Library_CheckDB 
'USEUNIT Online_PaySys_Library
Option Explicit

'Test Case ID 183409

Dim sDate, eDate, folderName, expectedFile, expectedFileNext, actualFilePath, actualFile, actualFilePathNext, actualFileNext
Dim cashOutputCreate, cashOutputNextCreate, workingDocs, verifyDoc, currentDate, param
Dim fBODY, fBODYNext, dbo_FOLDERS(2), dbo_FOLDERSNext(2), dbo_PAYMENTS, dbo_PAYMENTSNext

Sub Cash_Output_Check_Next_Test()
				Call Test_Inintialize()

				' Համակարգ մուտք գործել ARMSOFT օգտագործողով
				Log.Message "Համակարգ մուտք գործել ARMSOFT օգտագործողով", "", pmNormal, DivideColor
				Call Test_StartUp()
				
				' Ստեղծել Կանխիկ ելք փաստաթուղթ
				Log.Message "Ստեղծել Կանխիկ ելք փաստաթուղթ", "", pmNormal, DivideColor
    wTreeView.DblClickItem(folderName & "Î³ÝËÇÏ »Éù")
    If wMDIClient.WaitvbObject("frmASDocForm", 3000).Exists Then 
        'ISN-ի վերագրում փոփոխականին
        cashOutputCreate.fIsn = wMDIClient.vbObject("frmASDocForm").DocFormCommon.Doc.isn
        Call Fill_CashOutput(cashOutputCreate, "Ð³çáñ¹Á")
    Else 
        Log.Error "Can't open frmASDocForm window.", "", pmNormal, ErrorColor 
    End If
    
    ' Քաղվածքի պահպանում 
				Log.Message "Քաղվածքի պահպանում", "", pmNormal, DivideColor
    wMDIClient.vbObject("frmASDocForm").Keys("^[Tab]")
    Call SaveDoc(actualFilePath, actualFile) 
				
				' Փակել Քաղվածքի պատուհանը 
				Call Close_Window(wMDIClient, "FrmSpr")
    
    ' Կանխիկ ելք փաստաթղթի ստեղծումից հետո SQL ստուգում
    Log.Message "Կանխիկ ելք փաստաթղթի ստեղծումից հետո SQL ստուգում", "", pmNormal, DivideColor
    Call DB_Initialize()
    Call Check_DB_Create()
    
    ' Փաստացի քաղվածքի համեմատում սպասվողի հետ
				Log.Message "Փաստացի քաղվածքի համեմատում սպասվողի հետ", "", pmNormal, DivideColor
				param = "N\s\d{1,6}\s*.\d{1,10}\s{0,}.|Date\s\d{1,2}.\d{1,2}.\d{1,2}\s(\d{1,2}:\d{1,2})*"
    Call Compare_Files(actualFilePath & actualFile, expectedFile, param)
    
    ' Ստեղծել Կանխիկ ելք փաստաթուղթ հաջորդից
    Log.Message "Ստեղծել Կանխիկ ելք փաստաթուղթ հաջորդից", "", pmNormal, DivideColor
    wMDIClient.vbObject("frmExplorer").Keys("^[Tab]")
    If wMDIClient.WaitvbObject("frmASDocForm", 3000).Exists Then 
        'ISN-ի վերագրում փոփոխականին
        cashOutputNextCreate.fIsn = wMDIClient.vbObject("frmASDocForm").DocFormCommon.Doc.isn
        Call Fill_CashOutput(cashOutputNextCreate, "Î³ï³ñ»É")
    Else 
        Log.Error "Can't open frmASDocForm window.", "", pmNormal, ErrorColor 
    End If
    
				' Քաղվածքի պահպանում 
				Log.Message "Քաղվածքի պահպանում", "", pmNormal, DivideColor
    Call SaveDoc(actualFilePathNext, actualFileNext) 
				
				' Փակել Քաղվածքի պատուհանը 
				Call Close_Window(wMDIClient, "FrmSpr")
    
    ' Կանխիկ ելք փաստաթուղթը հաջորդից ստեղծումից հետո SQL ստուգում
    Log.Message "Կանխիկ ելք փաստաթուղթը հաջորդից ստեղծումից հետո SQL ստուգում", "", pmNormal, DivideColor
    Call Check_DB_Next_Create()
				
				' Փաստացի քաղվածքի համեմատում սպասվողի հետ
				Log.Message "Փաստացի քաղվածքի համեմատում սպասվողի հետ", "", pmNormal, DivideColor
    Call Compare_Files(actualFilePathNext & actualFileNext, expectedFileNext, param)
				
				' Մուտք գործել Աշխատանքային փաստաթղթեր թղթապանակ
    folderName = "|Ð³×³Ëáñ¹Ç ëå³ë³ñÏáõÙ ¨ ¹ñ³Ù³ñÏÕ |ÂÕÃ³å³Ý³ÏÝ»ñ|"
				Call GoTo_MainAccWorkingDocuments(folderName, workingDocs)
				
				' Ստուգել ստեղծված փաստաթղթի արժեքները
				Log.Message "Ստուգել ստեղծված փաստաթղթի արժեքները", "", pmNormal, DivideColor
    If SearchInPttel("frmPttel", 2, cashOutputCreate.commonTab.docNum) Then
        wMDIClient.vbObject("frmPttel").Keys("^w")
        If wMDIClient.WaitVBObject("frmASDocForm", 3000).Exists Then
            Call Check_Cash_Output(cashOutputCreate)
            Call ClickCmdButton(1, "OK") 
        Else 
            Log.Error "Can't open frmASDocForm window.", "", pmNormal, ErrorColor
        End If
    Else
        Log.Error "Can't find searched row.", "", pmNormal, ErrorColor
    End If
    
    ' Ուղարկել դրամարկղ
				Log.Message "Ուղարկել դրամարկղ", "", pmNormal, DivideColor
				Call Online_PaySys_Send_To_Verify(1)
    
    ' Ուղարկել դրամարկղից հետո SQL ստուգում
    Log.Message "Ուղարկել դրամարկղից հետո SQL ստուգում", "", pmNormal, DivideColor
    Call Check_DB_SendToVerify()
    
    ' Մուտք գործել Աշխատանքային փաստաթղթեր թղթապանակ
    folderName = "|Ð³×³Ëáñ¹Ç ëå³ë³ñÏáõÙ ¨ ¹ñ³Ù³ñÏÕ |ÂÕÃ³å³Ý³ÏÝ»ñ|"
				Call GoTo_MainAccWorkingDocuments(folderName, workingDocs)
    
    ' Ստուգել հաջորդից ստեղծված փաստաթղթի արժեքները
				Log.Message "Ստուգել հաջորդից ստեղծված փաստաթղթի արժեքները", "", pmNormal, DivideColor
    cashOutputNextCreate.coinTab.coinForCheck = "0.06"
				If SearchInPttel("frmPttel", 2, cashOutputNextCreate.commonTab.docNum) Then
        wMDIClient.vbObject("frmPttel").Keys("^w")
        If wMDIClient.WaitVBObject("frmASDocForm", 3000).Exists Then
            Call Check_Cash_Output(cashOutputNextCreate)
            Call ClickCmdButton(1, "OK") 
        Else 
            Log.Error "Can't open frmASDocForm window.", "", pmNormal, ErrorColor
        End If
				Else
        Log.Error "Can't find searched row.", "", pmNormal, ErrorColor
    End If
				
				' Ուղարկել դրամարկղ
				Log.Message "Ուղարկել դրամարկղ", "", pmNormal, DivideColor
				Call Online_PaySys_Send_To_Verify(1)
    
    ' Ուղարկել դրամարկղից հետո SQL ստուգում
    Log.Message "Ուղարկել դրամարկղից հետո SQL ստուգում", "", pmNormal, DivideColor
    Call Check_DB_SendToVerify_Next()
				
				' Մուտք գործել Աշխատանքային փաստաթղթեր թղթապանակ
				Call GoTo_MainAccWorkingDocuments(folderName, workingDocs)
				
				' Վավերացնել փաստաթղթերը
				Log.Message "Վավերացնել փաստաթղթերը", "", pmNormal, DivideColor
    If SearchInPttel("frmPttel", 2, cashOutputCreate.commonTab.docNum) Then
    				Call Validate_Doc()
    Else
        Log.Error "Can't find searched row.", "", pmNormal, ErrorColor
    End If
    If SearchInPttel("frmPttel", 2, cashOutputNextCreate.commonTab.docNum) Then
    				Call Validate_Doc()
    Else
        Log.Error "Can't find searched row.", "", pmNormal, ErrorColor
    End If
				
				' Փակել Աշխատանքային փաստաթղթեր թղթապանակ
				Call Close_Window(wMDIClient, "frmPttel")
    
    ' Վավերացումից հետո SQL ստուգում
    Log.Message "Վավերացումից հետո SQL ստուգում", "", pmNormal, DivideColor
    Call Check_DB_Validate()
				
				' Մուտք գործել Ստեղծված փաստաթղթեր թղթապանակ
				currentDate = aqConvert.DateTimeToFormatStr(aqDateTime.Now(),"%d%m%y")
				Call OpenCreatedDocFolder(folderName & "êï»ÕÍí³Í ÷³ëï³ÃÕÃ»ñ", currentDate, currentDate, null, "KasRsOrd")
				
				' Ստուգել, որ առկա է մեր ավելացրած փաստաթղթերը
				Log.Message "Ստուգել, որ առկա է մեր ավելացրած փաստաթղթերը", "", pmNormal, DivideColor
				If SearchInPttel("frmPttel", 2, cashOutputCreate.fIsn) Then
    				wMDIClient.vbObject("frmPttel").Keys("^w")
        If wMDIClient.WaitVBObject("frmASDocForm", 3000).Exists Then
            Call Check_Cash_Output(cashOutputCreate)
            Call ClickCmdButton(1, "OK") 
        Else 
            Log.Error "Can't open frmASDocForm window.", "", pmNormal, ErrorColor
        End If
    Else
        Log.Error "Can't find searched row.", "", pmNormal, ErrorColor
    End If
    
   If SearchInPttel("frmPttel", 2, cashOutputNextCreate.fIsn) Then
    				wMDIClient.vbObject("frmPttel").Keys("^w")
        If wMDIClient.WaitVBObject("frmASDocForm", 3000).Exists Then
            Call Check_Cash_Output(cashOutputNextCreate)
            Call ClickCmdButton(1, "OK") 
        Else 
            Log.Error "Can't open frmASDocForm window.", "", pmNormal, ErrorColor
        End If
    Else
        Log.Error "Can't find searched row.", "", pmNormal, ErrorColor
    End If
				
				' Ջնջել Կանխիկի ելք փաստաթղթերը
				Log.Message "Ջնջել Կանխիկի մուտք փաստաթղթերը", "", pmNormal, DivideColor
				Call SearchAndDelete("frmPttel", 2, cashOutputCreate.fIsn, "Ð³ëï³ï»ù ÷³ëï³ÃÕÃÇ çÝç»ÉÁ")
    Call SearchAndDelete("frmPttel", 2, cashOutputNextCreate.fIsn, "Ð³ëï³ï»ù ÷³ëï³ÃÕÃÇ çÝç»ÉÁ")
				
				' Փակել Ստեղծված փաստաթղթեր թղթապանակը
				Call Close_Window(wMDIClient, "frmPttel")
    
    ' Ջնջելուց հետո SQL ստուգում
    Log.Message "Ջնջելուց հետո SQL ստուգում", "", pmNormal, DivideColor
    Call Check_DB_Delete()
				
				' Փակել ծրագիրը
				Call Close_AsBank()
End	Sub

Sub Test_StartUp()
				Call Initialize_AsBank("bank", sDate, eDate)   
				Login("ARMSOFT")
				' Մուտք Հաճախորդի սպասարկում և դրամարկղ ընդլայնված ԱՇՏ
				Call ChangeWorkspace(c_CustomerService)
End Sub

Sub Test_Inintialize()
				sDate = "20030101"
				eDate = "20250101"
		
				folderName = "|Ð³×³Ëáñ¹Ç ëå³ë³ñÏáõÙ ¨ ¹ñ³Ù³ñÏÕ |Üáñ ÷³ëï³ÃÕÃ»ñ|ì×³ñ³ÛÇÝ ÷³ëï³ÃÕÃ»ñ|"
    
				expectedFile = Project.Path &  "Stores\Cash_Input_Output\Expected\Expected_Cash_Output_Next_Create.txt"
				actualFilePath = Project.Path &  "Stores\Cash_Input_Output\Actual\"
    actualFile = "Actual_Cash_Output_Next_Create.txt"
    
    expectedFileNext = Project.Path &  "Stores\Cash_Input_Output\Expected\Expected_Cash_Output_Next_Create2.txt"
				actualFilePathNext = Project.Path &  "Stores\Cash_Input_Output\Actual\"
    actualFileNext = "Actual_Cash_Output_Next_Create2.txt"
		
				Set cashOutputCreate = New_CashOutput(1, 1, 0)
				With cashOutputCreate
								.commonTab.office = "00"
        .commonTab.department = "1"
        .commonTab.date = "310122"
        .commonTab.dateForCheck = "31/01/22"
        .commonTab.cashRegister = "001"
        .commonTab.cashRegisterAcc = "000001100  "
        .commonTab.curr = "000"
        .commonTab.accDebet = "00000119999"
        .commonTab.amount = "16487.36"
        .commonTab.amountForCheck = "16,487.40"
        .commonTab.cashierChar = "07 "
        .commonTab.base = "Ð³ßíÇó Ï³ÝËÇÏ ¹áõñë·ñáõÙ"
        .commonTab.aim = "²ñï³ñÅáõÛÃÇ í³×³éù"
        .commonTab.payer = "00034856"
        .commonTab.name = "¶³ÝÓ³å»ï³ñ³Ý"
        .commonTab.surname = "¶³ÝÓ³å»ï"
        .commonTab.citizenship = "1"
        .commonTab.country = "AU"
        .commonTab.residence = "020020111"
        .chargeTab.office = .commonTab.office
        .chargeTab.department = .commonTab.department
        .chargeTab.chargeAcc = "00000119999 "
        .chargeTab.chargeAccForCheck = "00000119999 "
        .chargeTab.chargeCurr = "000"
        .chargeTab.chargeCurrForCheck = "000"
        .chargeTab.cbExchangeRate = "1.0000/1"
        .chargeTab.chargeType = "09"
        .chargeTab.chargeAmount = "8000.00"
        .chargeTab.chargeAmoForCheck = "8,000.00"
        .chargeTab.chargePercent = "48.5219"
        .chargeTab.chargePerForCheck = "48.5219"
        .chargeTab.incomeAcc = "000920200  "
        .chargeTab.incomeAccCurr = "000"
        .chargeTab.operArea = "9X"
        .chargeTab.operAreaForCheck = "9X"
        .chargeTab.nonResident = 0
        .chargeTab.nonResidentForCheck = 0
        .chargeTab.legalStatus = "33"
        .chargeTab.legalStatusForCheck = "33"
        .chargeTab.comment = "¶³ÝÓáõÙ Ï³ÝËÇÏ³óáõÙÇó"
        .chargeTab.commentForCheck = "¶³ÝÓáõÙ Ï³ÝËÇÏ³óáõÙÇó"
        .chargeTab.clientAgreeData = "¶³ÝÓ³å»ï Ï³ÝËÇÏ³óáõÙ"
        .attachedTab.addFiles(0) = Project.Path & "Stores\Attach file\Photo.jpg"
        .attachedTab.fileName(0) = "Photo.jpg"
        .attachedTab.linkName(0) = "attachedLink_1"
        .attachedTab.addLinks(0) = Project.Path & "Stores\Attach file\Photo.jpg"
				End With
				
    Set cashOutputNextCreate = New_CashOutput(0, 0, 0)
				With cashOutputNextCreate
        .commonTab.office = "00"
        .commonTab.department = "1"
        .commonTab.date = "010222"
        .commonTab.dateForCheck = "01/02/22"
        .commonTab.cashRegister = "001"
        .commonTab.cashRegisterAcc = "000001101  "
        .commonTab.curr = "001"
        .commonTab.accDebet = "72110255100"
        .commonTab.amount = "125.31"
        .commonTab.amountForCheck = "125.31"
        .commonTab.cashierChar = "053"
        .commonTab.aim = "Ð³Ù³Ó³ÛÝ Ã.001 å³Ñ³Ýç³·ñÇ"
        .chargeTab.office = .commonTab.office
        .chargeTab.department = .commonTab.department
        .chargeTab.chargeAcc = "03485010101  "
        .chargeTab.chargeAccForCheck = "000001100  "
        .chargeTab.chargeCurr = "001"
        .chargeTab.chargeCurrForCheck = "001"
        .chargeTab.cbExchangeRate = "400.0000/1"
        .chargeTab.chargeType = "02"
        .chargeTab.chargeAmount = "0.63"
        .chargeTab.chargeAmoForCheck = "0.63"
        .chargeTab.chargePercent = "0.5028"
        .chargeTab.chargePerForCheck = "0.5028"
        .chargeTab.incomeAcc = "7779526    "
        .chargeTab.incomeAccCurr = "000"
        .chargeTab.buyAndSell = "1"
        .chargeTab.buyAndSellForCheck = "1"
        .chargeTab.operType = "1"
        .chargeTab.operPlace = "3"
        .chargeTab.operArea = "12"
        .chargeTab.operAreaForCheck = "12"
        .chargeTab.nonResident = 1
        .chargeTab.nonResidentForCheck = 1
        .chargeTab.legalStatus = "11"
        .chargeTab.legalStatusForCheck = "11"
        .chargeTab.comment = "²ñï³ñÅ.ÙÇçí×. ·³ÝÓáõÙ"
        .chargeTab.commentForCheck = "²ñï³ñÅ.ÙÇçí×. ·³ÝÓáõÙ"
        .chargeTab.clientAgreeData = "ÙÇçí×. ÐÌ-´³ÝÏ  "
        .coinTab.coin = "0.06"
        .coinTab.coinForCheck = "0.00"
        .coinTab.coinPayCurr = "000"
        .coinTab.coinBuyAndSell = "1"
        .coinTab.coinPayAcc = "000001100  "
        .coinTab.coinExchangeRate = "340.0000/1"
        .coinTab.coinCBExchangeRate = "400.0000/1"
        .coinTab.coinPayAmount = "20.40"
        .coinTab.coinPayAmountForCheck = "20.40"
        .coinTab.amountWithMainCurr = "125.25"
        .coinTab.amountCurrForCheck = "125.25"
        .coinTab.incomeOutChange = "000931900  "
        .coinTab.damagesOutChange = "001434300  "
				End With
				
				Set workingDocs = New_MainAccWorkingDocuments()
				With workingDocs
								.startDate = cashOutputCreate.commonTab.date
								.endDate = cashOutputNextCreate.commonTab.date
				End With
				
				Set verifyDoc = New_VerificationDocument()
				verifyDoc.DocType = "KasRsOrd"
End Sub

Sub DB_Initialize()		
    Dim i 
    For i = 0 To 1
        Set dbo_FOLDERS(i) = New_DB_FOLDERS()
        With dbo_FOLDERS(i)
            .fKEY = cashOutputCreate.fIsn
            .fISN = cashOutputCreate.fIsn
            .fNAME = "KasRsOrd"
            .fSTATUS = "5"
            .fCOM = "Î³ÝËÇÏ »Éù"
            .fECOM = "Cash Withdrawal Advice"
        End With
    Next
    With dbo_FOLDERS(0)
        .fFOLDERID = "C.68249726"
        .fSPEC = "²Ùë³ÃÇí- 31/01/22 N- " & cashOutputCreate.commonTab.docNum & " ¶áõÙ³ñ-            16,487.40 ²ñÅ.- 000 [Üáñ]"
    End With
    With dbo_FOLDERS(1)
        .fFOLDERID = "Oper.20220131"
        .fSPEC = cashOutputCreate.commonTab.docNum & "777000000011999977700000001100          16487.40000Üáñ                                                   77¶³ÝÓ³å»ï³ñ³Ý ¶³ÝÓ³å»ï                                                                  Ð        ²ñï³ñÅáõÛÃÇ í³×³éù Ð³ßíÇó Ï³ÝËÇÏ ¹áõñë·ñáõÙ                                                                                                 "
        .fDCBRANCH = "00 "
        .fDCDEPART = "1  "
    End With
    
    Set dbo_FOLDERSNext(0) = New_DB_FOLDERS()
    With dbo_FOLDERSNext(0)
        .fNAME = "KasRsOrd"
        .fSTATUS = "5"
        .fCOM = "Î³ÝËÇÏ »Éù"
        .fECOM = "Cash Withdrawal Advice"
        .fFOLDERID = "Oper.20220201"
        .fDCBRANCH = "00 "
        .fDCDEPART = "1  "
    End With
    
    Set dbo_PAYMENTS = New_DB_PAYMENTS()
    With dbo_PAYMENTS
        .fDOCTYPE = "KasRsOrd"
        .fDATE = "2022-02-01"
        .fSTATE = "14"
        .fCLIENT = ""
        .fACCDB = "7770072110255100"
        .fPAYER = ""
        .fCUR = "001"
        .fSUMMA = "125.31"
        .fSUMMAAMD = "50124.00"
        .fSUMMAUSD = "125.31"
        .fCOM = "Ð³Ù³Ó³ÛÝ Ã.001 å³Ñ³Ýç³·ñÇ                                                                                                                   "
        .fPASSPORT = ""
        .fCOUNTRY = "AM"
        .fACSBRANCH = "00 "
        .fACSDEPART = "1  "
    End With
    
    Set dbo_PAYMENTSNext = New_DB_PAYMENTS()
    With dbo_PAYMENTSNext
        .fDOCTYPE = "KasRsOrd"
        .fDATE = "2022-01-31"
        .fSTATE = "14"
        .fCLIENT = "00034856"
        .fACCDB = "7770000000119999"
        .fPAYER = "¶³ÝÓ³å»ï³ñ³Ý ¶³ÝÓ³å»ï"
        .fCUR = "000"
        .fSUMMA = "16487.40"
        .fSUMMAAMD = "16487.40"
        .fSUMMAUSD = "41.2185"
        .fCOM = "²ñï³ñÅáõÛÃÇ í³×³éù Ð³ßíÇó Ï³ÝËÇÏ ¹áõñë·ñáõÙ                                                                                                 "
        .fPASSPORT = ""
        .fCOUNTRY = "AM"
        .fACSBRANCH = "00 "
        .fACSDEPART = "1  "
    End With
End	Sub

Sub Check_DB_Create()
    'SQL Ստուգում DOCLOG աղուսյակում համար
    Log.Message "SQL Ստուգում DOCLOG աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCLOG", "fISN", cashOutputCreate.fIsn, 2)
    Call CheckDB_DOCLOG(cashOutputCreate.fIsn, "77", "N", "1", "", 1)
    Call CheckDB_DOCLOG(cashOutputCreate.fIsn, "77", "C", "2", "", 1)
  
    'SQL Ստուգում DOCS աղուսյակում 
    Log.Message "SQL Ստուգում DOCS աղուսյակում", "", pmNormal, SqlDivideColor
    fBODY = " ACSBRANCH:00 ACSDEPART:1 BLREP:0 OPERTYPE:MSC TYPECODE:-20 21 22 23 24 30 31 32 25 26 92 93 11 27 33 28 USERID:  77 DOCNUM:" & cashOutputCreate.commonTab.docNum & " DATE:20220131 ACCDB:00000119999 CUR:000 KASSA:001 ACCCR:000001100 SUMMA:16487.4 KASSIMV:07 BASE:Ð³ßíÇó Ï³ÝËÇÏ ¹áõñë·ñáõÙ AIM:²ñï³ñÅáõÛÃÇ í³×³éù CLICODE:00034856 RECEIVER:¶³ÝÓ³å»ï³ñ³Ý RECEIVERLASTNAME:¶³ÝÓ³å»ï CITIZENSHIP:1 COUNTRY:AU COMMUNITY:020020111 FROMPAYORD:0 ACSBRANCHINC:00 ACSDEPARTINC:1 CHRGACC:00000119999 TYPECODE2:-20 21 22 23 24 30 31 32 25 26 92 93 11 27 33 28 CHRGCUR:000 CHRGCBCRS:1/1 PAYSCALE:09 CHRGSUM:8000 PRSNT:48.5219 CHRGINC:000920200 FRSHNOCRG:0 VOLORT:9X NONREZ:0 JURSTAT:33 COMM:¶³ÝÓáõÙ Ï³ÝËÇÏ³óáõÙÇó AGRDETAILS:¶³ÝÓ³å»ï Ï³ÝËÇÏ³óáõÙ PAYSYSIN:Ð NOTSENDABLE:0  "    
    fBODY = Replace(fBODY, " ", "%")
    Call CheckQueryRowCount("DOCS", "fISN", cashOutputCreate.fIsn, 1)
    Call CheckDB_DOCS(cashOutputCreate.fIsn, "KasRsOrd", "2", fBODY, 1)
    
    'SQL Ստուգում DOCSATTACH աղուսյակում 
    Log.Message "SQL Ստուգում DOCSATTACH աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCSATTACH", "fISN", cashOutputCreate.fIsn, 2)
    Call CheckDB_DOCSATTACH(cashOutputCreate.fIsn, Project.Path & "Stores\Attach file\Photo.jpg", "1", "attachedLink_1                                    ", 1)
    Call CheckDB_DOCSATTACH(cashOutputCreate.fIsn, "Photo.jpg", "0", "", 1)
  
    'SQL Ստուգում FOLDERS աղուսյակում 
    Log.Message "SQL Ստուգում FOLDERS աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("FOLDERS", "fISN", cashOutputCreate.fIsn, 2)
    Call CheckDB_FOLDERS(dbo_FOLDERS(0), 1)
    Call CheckDB_FOLDERS(dbo_FOLDERS(1), 1)
    
    'SQL Ստուգում HI աղուսյակում համար
    Log.Message "SQL Ստուգում HI աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("HI", "fBASE", cashOutputCreate.fIsn, 4)
    Call Check_HI_CE_accounting ("2022-01-31", cashOutputCreate.fIsn, "11", "1630170", "16487.40", "000", "16487.40", "MSC", "C")
    Call Check_HI_CE_accounting ("2022-01-31", cashOutputCreate.fIsn, "11", "1335852122", "16487.40", "000", "16487.40", "MSC", "D")
    Call Check_HI_CE_accounting ("2022-01-31", cashOutputCreate.fIsn, "11", "1630421", "8000.00", "000", "8000.00", "FEE", "C")
    Call Check_HI_CE_accounting ("2022-01-31", cashOutputCreate.fIsn, "11", "1335852122", "8000.00", "000", "8000.00", "FEE", "D")
End Sub

Sub Check_DB_Next_Create()
    'SQL Ստուգում DOCLOG աղուսյակում համար
    Log.Message "SQL Ստուգում DOCLOG աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCLOG", "fISN", cashOutputNextCreate.fIsn, 2)
    Call CheckDB_DOCLOG(cashOutputNextCreate.fIsn, "77", "N", "1", "", 1)
    Call CheckDB_DOCLOG(cashOutputNextCreate.fIsn, "77", "C", "2", "", 1)
  
    'SQL Ստուգում DOCS աղուսյակում 
    Log.Message "SQL Ստուգում DOCS աղուսյակում", "", pmNormal, SqlDivideColor
    fBODYNext = " ACSBRANCH:00 ACSDEPART:1 BLREP:0 OPERTYPE:MSC TYPECODE:-20 21 22 23 24 30 31 32 25 26 92 93 11 27 33 28 USERID:  77 DOCNUM:" & cashOutputNextCreate.commonTab.docNum & " DATE:20220201 ACCDB:72110255100 CUR:001 KASSA:001 ACCCR:000001101 SUMMA:125.31 KASSIMV:053 AIM:Ð³Ù³Ó³ÛÝ Ã.001 å³Ñ³Ýç³·ñÇ FROMPAYORD:0 ACSBRANCHINC:00 ACSDEPARTINC:1 CHRGACC:03485010101 TYPECODE2:-20 21 22 23 24 30 31 32 25 26 92 93 11 27 33 28 CHRGCUR:001 CHRGCBCRS:400.0000/1 PAYSCALE:02 CHRGSUM:0.63 PRSNT:0.5028 CHRGINC:7779526 FRSHNOCRG:0 CUPUSA:1 CURTES:1 CURVAIR:3 VOLORT:12 NONREZ:1 JURSTAT:11 COMM:²ñï³ñÅ.ÙÇçí×. ·³ÝÓáõÙ AGRDETAILS:ÙÇçí×. ÐÌ-´³ÝÏ PAYSYSIN:Ð XSUM:0.06 XCUR:000 XACC:000001100 XDLCRS:340/1 XDLCRSNAME:000 / 001 XCBCRS:400.0000/1 XCBCRSNAME:000 / 001 XCUPUSA:1 XCURSUM:20.4 XSUMMAIN:125.25 XINC:000931900 XEXP:001434300 NOTSENDABLE:0 "    
    fBODYNext = Replace(fBODYNext, " ", "%")
    Call CheckQueryRowCount("DOCS", "fISN", cashOutputNextCreate.fIsn, 1)
    Call CheckDB_DOCS(cashOutputNextCreate.fIsn, "KasRsOrd", "2", fBODYNext, 1)
  
    'SQL Ստուգում FOLDERS աղուսյակում 
    Log.Message "SQL Ստուգում FOLDERS աղուսյակում", "", pmNormal, SqlDivideColor
    With dbo_FOLDERSNext(0)
        .fKEY = cashOutputNextCreate.fIsn
        .fISN = cashOutputNextCreate.fIsn
        .fSPEC = cashOutputNextCreate.commonTab.docNum & "777007211025510077700000001101            125.31001Üáñ                                                   77                                                                                       Ð        Ð³Ù³Ó³ÛÝ Ã.001 å³Ñ³Ýç³·ñÇ                                                                                                                   "
    End With
    Call CheckQueryRowCount("FOLDERS", "fISN", cashOutputNextCreate.fIsn, 1)
    Call CheckDB_FOLDERS(dbo_FOLDERSNext(0), 1)
    
    'SQL Ստուգում HI աղուսյակում համար
    Log.Message "SQL Ստուգում HI աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("HI", "fBASE", cashOutputNextCreate.fIsn, 8)
    Call Check_HI_CE_accounting ("2022-02-01", cashOutputNextCreate.fIsn, "11", "1630171", "50100.00", "001", "125.25", "MSC", "C")
    Call Check_HI_CE_accounting ("2022-02-01", cashOutputNextCreate.fIsn, "11", "958184468", "50100.00", "001", "125.25", "MSC", "D")
    Call Check_HI_CE_accounting ("2022-02-01", cashOutputNextCreate.fIsn, "11", "1629177", "3.60", "000", "3.60", "MSC", "C")
    Call Check_HI_CE_accounting ("2022-02-01", cashOutputNextCreate.fIsn, "11", "958184468", "3.60", "001", "0.00", "MSC", "D")
    Call Check_HI_CE_accounting ("2022-02-01", cashOutputNextCreate.fIsn, "11", "1630170", "20.40", "000", "20.40", "CEX", "C")
    Call Check_HI_CE_accounting ("2022-02-01", cashOutputNextCreate.fIsn, "11", "958184468", "20.40", "001", "0.06", "CEX", "D")
    Call Check_HI_CE_accounting ("2022-02-01", cashOutputNextCreate.fIsn, "11", "1756824", "252.00", "000", "252.00", "FEX", "C")
    Call Check_HI_CE_accounting ("2022-02-01", cashOutputNextCreate.fIsn, "11", "494591021", "252.00", "001", "0.63", "FEX", "D")
End Sub

Sub Check_DB_SendToVerify()
    'SQL Ստուգում DOCLOG աղուսյակում համար
    Log.Message "SQL Ստուգում DOCLOG աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCLOG", "fISN", cashOutputCreate.fIsn, 3)
    Call CheckDB_DOCLOG(cashOutputCreate.fIsn, "77", "M", "11", "àõÕ³ñÏí»É ¿ ¹ñ³Ù³ñÏÕ", 1)
  
    'SQL Ստուգում DOCS աղուսյակում 
    Log.Message "SQL Ստուգում DOCS աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCS", "fISN", cashOutputCreate.fIsn, 1)
    Call CheckDB_DOCS(cashOutputCreate.fIsn, "KasRsOrd", "11", fBODY, 1)
  
    'SQL Ստուգում FOLDERS աղուսյակում 
    Log.Message "SQL Ստուգում FOLDERS աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("FOLDERS", "fISN", cashOutputCreate.fIsn, 3)
    With dbo_FOLDERS(0)
        .fSTATUS = "4"
        .fSPEC = "²Ùë³ÃÇí- 31/01/22 N- " & cashOutputCreate.commonTab.docNum & " ¶áõÙ³ñ-            16,487.40 ²ñÅ.- 000 [àõÕ³ñÏí»É ¿ ¹ñ³Ù³ñÏÕ]"
    End With
    Call CheckDB_FOLDERS(dbo_FOLDERS(0), 1)
    With dbo_FOLDERS(1)
        .fSTATUS = "4"
        .fSPEC = cashOutputCreate.commonTab.docNum & "777000000011999977700000001100          16487.40000àõÕ³ñÏí»É ¿ ¹ñ³Ù³ñÏÕ                                  77¶³ÝÓ³å»ï³ñ³Ý ¶³ÝÓ³å»ï                                           001                    Ð        ²ñï³ñÅáõÛÃÇ í³×³éù Ð³ßíÇó Ï³ÝËÇÏ ¹áõñë·ñáõÙ                                                                                                 "
    End With
    Call CheckDB_FOLDERS(dbo_FOLDERS(1), 1)
    Set dbo_FOLDERS(2) = New_DB_FOLDERS()
    With dbo_FOLDERS(2)
        .fKEY = cashOutputCreate.fIsn
        .fISN = cashOutputCreate.fIsn
        .fNAME = "KasRsOrd"
        .fSTATUS = "4"
        .fFOLDERID = "CashOper.20220131"
        .fCOM = "Î³ÝËÇÏ »Éù"
        .fSPEC = cashOutputCreate.commonTab.docNum & "777000000011999977700000001100          16487.40000àõÕ³ñÏí»É ¿ ¹ñ³Ù³ñÏÕ  77²ñï³ñÅáõÛÃÇ í³×³éù Ð³ßíÇó Ï³ÝËÇÏ¶³ÝÓ³å»ï³ñ³Ý ¶³ÝÓ³å»ï                                           001ºÉù          16487.40000                 0.00   "
        .fECOM = "Cash Withdrawal Advice"
        .fDCBRANCH = "00 "
        .fDCDEPART = "1  "
    End with
    Call CheckDB_FOLDERS(dbo_FOLDERS(2), 1)
End Sub

Sub Check_DB_SendToVerify_Next()
    'SQL Ստուգում DOCLOG աղուսյակում համար
    Log.Message "SQL Ստուգում DOCLOG աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCLOG", "fISN", cashOutputNextCreate.fIsn, 3)
    Call CheckDB_DOCLOG(cashOutputNextCreate.fIsn, "77", "M", "11", "àõÕ³ñÏí»É ¿ ¹ñ³Ù³ñÏÕ", 1)
  
    'SQL Ստուգում DOCS աղուսյակում 
    Log.Message "SQL Ստուգում DOCS աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCS", "fISN", cashOutputNextCreate.fIsn, 1)
    Call CheckDB_DOCS(cashOutputNextCreate.fIsn, "KasRsOrd", "11", fBODYNext, 1)
  
    'SQL Ստուգում FOLDERS աղուսյակում 
    Log.Message "SQL Ստուգում FOLDERS աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("FOLDERS", "fISN", cashOutputNextCreate.fIsn, 2)
    With dbo_FOLDERSNext(0)
        .fSTATUS = "4"
        .fSPEC = cashOutputNextCreate.commonTab.docNum & "777007211025510077700000001101            125.31001àõÕ³ñÏí»É ¿ ¹ñ³Ù³ñÏÕ                                  77                                                                001                    Ð        Ð³Ù³Ó³ÛÝ Ã.001 å³Ñ³Ýç³·ñÇ                                                                                                                   "
    End With
    Call CheckDB_FOLDERS(dbo_FOLDERSNext(0), 1)
    Set dbo_FOLDERSNext(1) = New_DB_FOLDERS()
    With dbo_FOLDERSNext(1)
        .fKEY = cashOutputNextCreate.fIsn
        .fISN = cashOutputNextCreate.fIsn
        .fNAME = "KasRsOrd"
        .fSTATUS = "4"
        .fFOLDERID = "CashOper.20220201"
        .fCOM = "Î³ÝËÇÏ »Éù"
        .fSPEC = cashOutputNextCreate.commonTab.docNum & "777007211025510077700000001101            125.31001àõÕ³ñÏí»É ¿ ¹ñ³Ù³ñÏÕ  77Ð³Ù³Ó³ÛÝ Ã.001 å³Ñ³Ýç³·ñÇ                                                                       001ºÉù            125.25001ºÉù             20.40000"
        .fECOM = "Cash Withdrawal Advice"
        .fDCBRANCH = "00 "
        .fDCDEPART = "1  "
    End With
    Call CheckDB_FOLDERS(dbo_FOLDERSNext(1), 1)
End Sub

Sub Check_DB_Validate()
    'SQL Ստուգում DOCLOG աղուսյակում համար
    Log.Message "SQL Ստուգում DOCLOG աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCLOG", "fISN", cashOutputCreate.fIsn, 5)
    Call CheckDB_DOCLOG(cashOutputCreate.fIsn, "77", "W", "12", "", 1)
    Call CheckDB_DOCLOG(cashOutputCreate.fIsn, "77", "M", "14", "¶ñ³Ýóí»É »Ý Ó¨³Ï»ñåáõÙÝ»ñÁ", 1)
    Call CheckQueryRowCount("DOCLOG", "fISN", cashOutputNextCreate.fIsn, 5)
    Call CheckDB_DOCLOG(cashOutputNextCreate.fIsn, "77", "W", "12", "", 1)
    Call CheckDB_DOCLOG(cashOutputNextCreate.fIsn, "77", "M", "14", "¶ñ³Ýóí»É »Ý Ó¨³Ï»ñåáõÙÝ»ñÁ", 1)
  
    'SQL Ստուգում DOCS աղուսյակում 
    Log.Message "SQL Ստուգում DOCS աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCS", "fISN", cashOutputCreate.fIsn, 1)
    Call CheckDB_DOCS(cashOutputCreate.fIsn, "KasRsOrd", "14", fBODY, 1)
    Call CheckQueryRowCount("DOCS", "fISN", cashOutputNextCreate.fIsn, 1)
    Call CheckDB_DOCS(cashOutputNextCreate.fIsn, "KasRsOrd", "14", fBODYNext, 1)
  
    'SQL Ստուգում FOLDERS աղուսյակում 
    Log.Message "SQL Ստուգում FOLDERS աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("FOLDERS", "fISN", cashOutputCreate.fIsn, 0)
    Call CheckQueryRowCount("FOLDERS", "fISN", cashOutputNextCreate.fIsn, 0)
    
    'SQL Ստուգում PAYMENTS աղուսյակում 
    Log.Message "SQL Ստուգում PAYMENTS աղուսյակում", "", pmNormal, SqlDivideColor
    With dbo_PAYMENTS
        .fISN = cashOutputNextCreate.fIsn
        .fDOCNUM = cashOutputNextCreate.commonTab.docNum
    End With
    With dbo_PAYMENTSNext
        .fISN = cashOutputCreate.fIsn
        .fDOCNUM = cashOutputCreate.commonTab.docNum
    End With
    Call CheckQueryRowCount("PAYMENTS", "fISN", cashOutputNextCreate.fIsn, 1)
    Call CheckDB_PAYMENTS(dbo_PAYMENTS, 1)
    Call CheckQueryRowCount("PAYMENTS", "fISN", cashOutputCreate.fIsn, 1)
    Call CheckDB_PAYMENTS(dbo_PAYMENTSNext, 1)
    
    'SQL Ստուգում HI աղուսյակում համար
    Log.Message "SQL Ստուգում HI աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("HI", "fBASE", cashOutputCreate.fIsn, 4)
    'SQL Ստուգում HI աղուսյակում համար
    Log.Message "SQL Ստուգում HI աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("HI", "fBASE", cashOutputNextCreate.fIsn, 10)
    Call Check_HI_CE_accounting ("2022-02-01", cashOutputNextCreate.fIsn, "CE", "1578250", "20.40", "001", "0.06", "PUR", "D")
    Call Check_HI_CE_accounting ("2022-02-01", cashOutputNextCreate.fIsn, "CE", "1578250", "252.00", "001", "0.63", "PUR", "D")
End Sub

Sub Check_DB_Delete()
    'SQL Ստուգում DOCLOG աղուսյակում համար
    Log.Message "SQL Ստուգում DOCLOG աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCLOG", "fISN", cashOutputCreate.fIsn, 6)
    Call CheckDB_DOCLOG(cashOutputCreate.fIsn, "77", "D", "999", "", 1)
    Call CheckQueryRowCount("DOCLOG", "fISN", cashOutputNextCreate.fIsn, 6)
    Call CheckDB_DOCLOG(cashOutputNextCreate.fIsn, "77", "D", "999", "", 1)
				
    'SQL Ստուգում DOCS աղուսյակում համար
    Log.Message "SQL Ստուգում DOCS աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCS", "fISN", cashOutputCreate.fIsn, 1)
    Call CheckDB_DOCS(cashOutputCreate.fIsn, "KasRsOrd", "999", fBODY, 1)
    Call CheckQueryRowCount("DOCS", "fISN", cashOutputNextCreate.fIsn, 1)
    Call CheckDB_DOCS(cashOutputNextCreate.fIsn, "KasRsOrd", "999", fBODYNext, 1)
		
    'SQL Ստուգում FOLDERS աղուսյակում 
    Log.Message "SQL Ստուգում FOLDERS աղուսյակում", "", pmNormal, SqlDivideColor
    With dbo_FOLDERS(0)
        .fKEY = cashOutputCreate.fIsn
        .fISN = cashOutputCreate.fIsn
        .fNAME = "KasRsOrd"
        .fSTATUS = "0"
        .fFOLDERID = ".R." & aqConvert.DateTimeToFormatStr(aqDateTime.Now(), "%Y%m%d")
        .fSPEC = Left_Align(Get_Compname_DOCLOG(cashOutputCreate.fIsn), 16) & "TellerX ARMSOFT                       1114 "
        .fCOM = ""
        .fECOM = ""
        .fDCBRANCH = "00 "
        .fDCDEPART = "1  "
    End With
    Call CheckQueryRowCount("FOLDERS", "fISN", cashOutputCreate.fIsn, 1)
    Call CheckDB_FOLDERS(dbo_FOLDERS(0), 1)
    Call CheckQueryRowCount("FOLDERS", "fISN", cashOutputNextCreate.fIsn, 1)
    With dbo_FOLDERS(0)
        .fKEY = cashOutputNextCreate.fIsn
        .fISN = cashOutputNextCreate.fIsn
        .fSPEC = Left_Align(Get_Compname_DOCLOG(cashOutputNextCreate.fIsn), 16) & "TellerX ARMSOFT                       1114 "
    End With
    Call CheckDB_FOLDERS(dbo_FOLDERS(0), 1)
End Sub