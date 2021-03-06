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

'Test Case ID 183407

Dim sDate, eDate, folderName, expectedFile, actualFilePath, actualFile
Dim cashOutputCreate, cashOutputEdit, workingDocs, verifyDoc, currentDate, param
Dim fBODY, dbo_FOLDERS(2), dbo_PAYMENTS

Sub Cash_Output_Check_Cache_Test()
				Call Test_Inintialize()

				' Համակարգ մուտք գործել ARMSOFT օգտագործողով
				Log.Message "Համակարգ մուտք գործել ARMSOFT օգտագործողով", "", pmNormal, DivideColor
				Call Test_StartUp()
				
				' Մուտք գործել Հաշիվներ թղթապանակ
				Log.Message "Մուտք գործել Հաշիվներ թղթապանակ", "", pmNormal, DivideColor
				Call OpenAccauntsFolder(folderName & "Ð³ßÇíÝ»ñ","1","","00000111621","","","","","","",0,"","","","","",0,0,0,"","","","","","ACCS","0")		
				Call CheckPttel_RowCount("frmPttel", 1) 
		
				' Ստեղծել Կանխիկ ելք փաստաթղթի սևագիր
				Log.Message "Ստեղծել Կանխիկ ելք փաստաթղթի սևագիր", "", pmNormal, DivideColor
				Call Create_Cash_Output(cashOutputCreate, "ê¨³·Çñ")
    
    ' Փակել Հաշիվներ թղթապանակը
				Call Close_Window(wMDIClient, "frmPttel")
    
    ' Կանխիկ ելք փաստաթղթի սևագրի ստեղծումից հետո SQL ստուգում
    Log.Message "Կանխիկ ելք փաստաթղթի սևագրի ստեղծումից հետո SQL ստուգում", "", pmNormal, DivideColor
    Call DB_Initialize()
    Call Check_DB_Draft()
    
    ' Մուտք գործել Օգտագործողսի Սևագրեր թղթապանակ
    Log.Message "Մուտք գործել Օգտագործողսի Սևագրեր թղթապանակ", "", pmNormal, DivideColor
    Call wTreeView.DblClickItem("|¶ÉË³íáñ Ñ³ßí³å³ÑÇ ²Þî|ÂÕÃ³å³Ý³ÏÝ»ñ|ú·ï³·áñÍáÕÇ ë¨³·ñ»ñ")
    ' Կատարել կոճակի սեղմում
    Call ClickCmdButton(2, "Î³ï³ñ»É")
    
    ' Ստեղծել Կանխիկ ելք փաստաթուղթը սևագրերից
    Log.Message "Ստեղծել Կանխիկ ելք փաստաթուղթը սևագրերից", "", pmNormal, DivideColor
    If SearchInPttel("frmPttel", 2, cashOutputCreate.fIsn) Then
        BuiltIn.Delay(3000)
        With cashOutputCreate
            .coinTab.coinForCheck = "36.00"
            .chargeTab.buyAndSell = ""
            .chargeTab.commentForCheck = "²ñï³ñÅ.ÙÇçí×. ·³ÝÓáõÙ"
        End With
        Call wMainForm.MainMenu.Click(c_AllActions)
        Call wMainForm.PopupMenu.Click(c_ToEdit)
        If wMDIClient.WaitvbObject("frmASDocForm", 3000).Exists Then
            Call Fill_CashOut_Common(cashOutputCreate.commonTab)
            Call Fill_CashOut_Charge(cashOutputCreate.chargeTab, cashOutputCreate.commonTab.payerLegalStatus)
            Call Check_Cash_Output(cashOutputCreate)
            Call ClickCmdButton(1, "Î³ï³ñ»É")
        End If
    Else
        Log.Error "Can't find searched row.", "", pmNormal, ErrorColor
    End If
    
				' Քաղվածքի պահպանում 
				Log.Message "Քաղվածքի պահպանում", "", pmNormal, DivideColor
    Call SaveDoc(actualFilePath, actualFile) 
				
				' Փակել Քաղվածքի պատուհանը 
				Call Close_Window(wMDIClient, "FrmSpr")
    
    ' Կանխիկ ելք փաստաթուղթը սևագրերից ստեղծումից հետո SQL ստուգում
    Log.Message "Կանխիկ ելք փաստաթուղթը սևագրերից ստեղծումից հետո SQL ստուգում", "", pmNormal, DivideColor
    Call Check_DB_Create()
				
				' Փաստացի քաղվածքի համեմատում սպասվողի հետ
				Log.Message "Փաստացի քաղվածքի համեմատում սպասվողի հետ", "", pmNormal, DivideColor
				param = "N\s\d{1,6}\s*.\d{1,10}\s{0,}.|Date\s\d{1,2}.\d{1,2}.\d{1,2}\s(\d{1,2}:\d{1,2})*"
    Call Compare_Files(actualFilePath & actualFile, expectedFile, param)
				
				' Փակել Օգտագործողի սևագրեր թղթապանակը
				Call Close_Window(wMDIClient, "frmPttel")
				
				' Մուտք գործել Աշխատանքային փաստաթղթեր թղթապանակ
				folderName = "|¶ÉË³íáñ Ñ³ßí³å³ÑÇ ²Þî|ÂÕÃ³å³Ý³ÏÝ»ñ|"
				Call GoTo_MainAccWorkingDocuments(folderName, workingDocs)
				
				' Ստուգել ստեղծված փաստաթղթի արժեքները և խմբագրել այն 
				Log.Message "Ստուգել ստեղծված փաստաթղթի արժեքները և խմբագրել այն", "", pmNormal, DivideColor
				If SearchInPttel("frmPttel", 2, cashOutputCreate.commonTab.docNum) Then
    				Call Edit_Cash_Output(cashOutputCreate, cashOutputEdit, "Î³ï³ñ»É")
    Else
        Log.Error "Can't find searched row.", "", pmNormal, ErrorColor
    End If
    With cashOutputEdit
        .commonTab.idGiveDateForCheck = "24/06/2007"
        .commonTab.idValidUntilForCheck = "30/10/2027"
        .chargeTab.operAreaForCheck = "96"
        .chargeTab.legalStatusForCheck = "33"
        .chargeTab.nonResidentForCheck = 1
        .chargeTab.commentForCheck = "²ñï³ñÅ. ·³ÝÓáõÙ"
        .coinTab.coinForCheck = "95.26"
    End With
    
    ' Կանխիկ ելք փաստաթուղթը խմբագրելուց հետո SQL ստուգում
    Log.Message "Կանխիկ ելք փաստաթուղթը խմբագրելուց հետո SQL ստուգում", "", pmNormal, DivideColor
    Call Check_DB_Edit()
				
				' Ուղարկել դրամարկղ
				Log.Message "Ուղարկել դրամարկղ", "", pmNormal, DivideColor
				Call Online_PaySys_Send_To_Verify(1)
    
    ' Ուղարկել դրամարկղից հետո SQL ստուգում
    Log.Message "Ուղարկել դրամարկղից հետո SQL ստուգում", "", pmNormal, DivideColor
    Call Check_DB_SendToVerify()
				
				' Մուտք գործել Աշխատանքային փաստաթղթեր թղթապանակ
				Call GoTo_MainAccWorkingDocuments(folderName, workingDocs)
    
    ' Ստուգել, որ առկա է մեր ավելացրած փաստաթուղթը
				Log.Message "Ստուգել, որ առկա է մեր ավելացրած փաստաթուղթը", "", pmNormal, DivideColor
				If SearchInPttel("frmPttel", 2, cashOutputEdit.commonTab.docNum) Then
        wMDIClient.vbObject("frmPttel").Keys("^w")
        If wMDIClient.WaitVBObject("frmASDocForm", 3000).Exists Then
            Call Check_Cash_Output(cashOutputEdit)
            Call ClickCmdButton(1, "OK") 
        Else 
            Log.Error "Can't open frmASDocForm window.", "", pmNormal, ErrorColor
        End If
    Else
        Log.Error "Can't find searched row.", "", pmNormal, ErrorColor
    End If
				
				' Վավերացնել փաստաթուղթը
				Log.Message "Վավերացնել փաստաթուղթը", "", pmNormal, DivideColor
				Call Validate_Doc()
				
				' Փակել Աշխատանքային փաստաթղթեր թղթապանակը
				Call Close_Window(wMDIClient, "frmPttel")
    
    ' Վավերացումից հետո SQL ստուգում
    Log.Message "Վավերացումից հետո SQL ստուգում", "", pmNormal, DivideColor
    Call Check_DB_Validate()
				
				' Մուտք գործել Ստեղծված փաստաթղթեր թղթապանակ
				currentDate = aqConvert.DateTimeToFormatStr(aqDateTime.Now(),"%d%m%y")
				Call OpenCreatedDocFolder(folderName & "êï»ÕÍí³Í ÷³ëï³ÃÕÃ»ñ", currentDate, currentDate, null, "KasRsOrd")
				
				' Ստուգել, որ առկա է մեր ավելացրած փաստաթուղթը
				Log.Message "Ստուգել, որ առկա է մեր ավելացրած փաստաթուղթը", "", pmNormal, DivideColor
				If SearchInPttel("frmPttel", 2, cashOutputEdit.fIsn) Then
    				wMDIClient.vbObject("frmPttel").Keys("^w")
        If wMDIClient.WaitVBObject("frmASDocForm", 3000).Exists Then
            Call Check_Cash_Output(cashOutputEdit)
            Call ClickCmdButton(1, "OK") 
        Else 
            Log.Error "Can't open frmASDocForm window.", "", pmNormal, ErrorColor
        End If
    Else
        Log.Error "Can't find searched row.", "", pmNormal, ErrorColor
    End If
				
				' Ջնջել Կանխիկի մուտք փաստաթուղթը
				Log.Message "Ջնջել Կանխիկի մուտք փաստաթուղթը", "", pmNormal, DivideColor
				Call SearchAndDelete("frmPttel", 2, cashOutputEdit.fIsn, "Ð³ëï³ï»ù ÷³ëï³ÃÕÃÇ çÝç»ÉÁ")
				
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
				' Մուտք Գլխավոր հաշվապահի ԱՇՏ
				Call ChangeWorkspace(c_ChiefAcc)
End Sub

Sub Test_Inintialize()
				sDate = "20030101"
				eDate = "20250101"
		
				folderName = "|¶ÉË³íáñ Ñ³ßí³å³ÑÇ ²Þî|"
				expectedFile = Project.Path &  "Stores\Cash_Input_Output\Expected\Expected_Cash_Output_Cache.txt"
				actualFilePath = Project.Path &  "Stores\Cash_Input_Output\Actual\"
    actualFile = "Actual_Cash_Output_Cache.txt"
		
				Set cashOutputCreate = New_CashOutput(1, 1, 0)
				With cashOutputCreate
								.commonTab.office = "00"
        .commonTab.department = "1"
        .commonTab.date = "281021"
        .commonTab.dateForCheck = "28/10/21"
        .commonTab.cashRegister = "001"
        .commonTab.cashRegisterAcc = "000001101  "
        .commonTab.curr = "001"
        .commonTab.accDebet = "00000111621"
        .commonTab.amount = "282460.36"
        .commonTab.amountForCheck = "282,460.36"
        .commonTab.cashierChar = "051"
        .commonTab.base = "Ð³ïÏ³óáõÙ êáó. ²å³Ñáí. ÐÇÙÝ³¹ñ³ÙÇÝ"
        .commonTab.aim = "Ð³Ù³Ó³ÛÝ ÃÇí ................... â»ÏÇ"
        .commonTab.payer = "00000669"
        .commonTab.payerLegalStatus = "ֆիզԱնձ"
        .commonTab.name = "äáÕáë"
        .commonTab.surname = "ê³ñ·ëÛ³Ý"
        .commonTab.id = "AM00000669"
        .commonTab.idForCheck = "AM00000669"
        .commonTab.idType = "06"
        .commonTab.idTypeForCheck = "06"
        .commonTab.idGivenBy = "017"
        .commonTab.idGivenByForCheck = "017"
        .commonTab.idGiveDate = "13082010"
        .commonTab.idGiveDateForCheck = "13/08/2010"
        .commonTab.idValidUntil = "13082023"
        .commonTab.idValidUntilForCheck = "13/08/2023"
        .commonTab.birthDate = "28021998"
        .commonTab.birthDateForCheck = "28/02/1998"
        .commonTab.citizenship = "1"
        .commonTab.country = "CY"
        .commonTab.residence = "990000002"
        .commonTab.city = "ÜÇÏáëÇ³"
        .commonTab.street = "ÎáÙåá½ÇïáñÝ»ñÇ"
        .commonTab.apartment = "µÝ. 13    "
        .commonTab.house = "6         "
        .commonTab.email = "cyprosFrom@mail.ru"
        .commonTab.emailForCheck = "cyprosFrom@mail.ru"
        .chargeTab.office = .commonTab.office
        .chargeTab.department = .commonTab.department
        .chargeTab.chargeAcc = "000001101  "
        .chargeTab.chargeAccForCheck = "000001100  "
        .chargeTab.chargeCurr = "001"
        .chargeTab.chargeCurrForCheck = "001"
        .chargeTab.cbExchangeRate = "400.0000/1"
        .chargeTab.chargeType = "02"
        .chargeTab.chargeAmount = "1412.30"
        .chargeTab.chargeAmoForCheck = "1,412.30"
        .chargeTab.chargePercent = "0.5000"
        .chargeTab.chargePerForCheck = "0.5000"
        .chargeTab.incomeAcc = "000919400  "
        .chargeTab.incomeAccCurr = "000"
        .chargeTab.buyAndSell = "1"
        .chargeTab.buyAndSellForCheck = "1"
        .chargeTab.operType = "1"
        .chargeTab.operPlace = "3"
        .chargeTab.operArea = "7"
        .chargeTab.operAreaForCheck = "7"
        .chargeTab.nonResident = 0
        .chargeTab.nonResidentForCheck = 0
        .chargeTab.legalStatus = "22"
        .chargeTab.legalStatusForCheck = "22"
        .chargeTab.comment = "²ñï³ñÅ.ÙÇçí×. ·³ÝÓáõÙ"
        .chargeTab.commentForCheck = "²ñï³ñÅ.ÙÇçí×. ·³ÝÓáõÙ"
        .chargeTab.clientAgreeData = "ÎÇåñáëÇ ù³Õ³ù³óÇ"
        .coinTab.coin = "36.00"
        .coinTab.coinForCheck = "0.00"
        .coinTab.coinPayCurr = "000"
        .coinTab.coinBuyAndSell = "1"
        .coinTab.coinPayAcc = "000001100  "
        .coinTab.coinExchangeRate = "340.0000/1"
        .coinTab.coinCBExchangeRate = "400.0000/1"
        .coinTab.coinPayAmount = "12240.00"
        .coinTab.coinPayAmountForCheck = "12,240.00"
        .coinTab.amountWithMainCurr = "282,424.36"
        .coinTab.amountCurrForCheck = "282,424.36"
        .coinTab.incomeOutChange = "000931900  "
        .coinTab.damagesOutChange = "001434300  "
        .attachedTab.addFiles(0) = Project.Path & "Stores\Attach file\Photo.jpg"
        .attachedTab.fileName(0) = "Photo.jpg"
        .attachedTab.linkName(0) = "attachedLink_1"
        .attachedTab.addLinks(0) = Project.Path & "Stores\Attach file\Photo.jpg"
				End With
				
				Set cashOutputEdit = New_CashOutput(1, 0, 1)
				With cashOutputEdit
								.commonTab.office = "00"
        .commonTab.department = "1"
        .commonTab.date = "020222"
        .commonTab.dateForCheck = "02/02/22"
        .commonTab.cashRegister = "001"
        .commonTab.cashRegisterAcc = "000001101  "
        .commonTab.curr = "001"
        .commonTab.accDebet = "00000111621"
        .commonTab.amount = "36800.68"
        .commonTab.amountForCheck = "36,800.68"
        .commonTab.cashierChar = "07 "
        .commonTab.base = "ÇÝÏ³ë³óÇáÝ å³ñÏ"
        .commonTab.aim = "Ï³ñ·³·Çñ"
        .commonTab.payer = "00000669"
        .commonTab.payerLegalStatus = "ֆիզԱնձ"
        .commonTab.name = "äáÕáë"
        .commonTab.surname = "ê³ñ·ëÛ³Ý"
        .commonTab.id = "RN00000669"
        .commonTab.idForCheck = "AM00000669"
        .commonTab.idType = "11"
        .commonTab.idTypeForCheck = "06"
        .commonTab.idGivenBy = "036"
        .commonTab.idGivenByForCheck = "017"
        .commonTab.idGiveDate = "24062007"
        .commonTab.idGiveDateForCheck = "13/08/2010"
        .commonTab.idValidUntil = "30102027"
        .commonTab.idValidUntilForCheck = "13/08/2023"
        .commonTab.birthDate = "28021998"
        .commonTab.birthDateForCheck = "28/02/1998"
        .commonTab.citizenship = "1"
        .commonTab.country = "CY"
        .commonTab.residence = "990000002"
        .commonTab.city = "ÜÇÏáëÇ³"
        .commonTab.street = "ÎáÙåá½ÇïáñÝ»ñÇ"
        .commonTab.apartment = "µÝ. 13    "
        .commonTab.house = "6         "
        .commonTab.email = "nicosianin@gmail.com"
        .commonTab.emailForCheck = "cyprosFrom@mail.ru"
        .chargeTab.office = .commonTab.office
        .chargeTab.department = .commonTab.department
        .chargeTab.chargeAcc = "000001101  "
        .chargeTab.chargeAccForCheck = "000001101"
        .chargeTab.chargeCurr = "001"
        .chargeTab.chargeCurrForCheck = "001"
        .chargeTab.cbExchangeRate = "400.0000/1"
        .chargeTab.chargeType = "03"
        .chargeTab.chargeAmount = "110.40"
        .chargeTab.chargeAmoForCheck = "110.40"
        .chargeTab.chargePercent = "0.3000"
        .chargeTab.chargePerForCheck = "0.3000"
        .chargeTab.incomeAcc = "000450000  "
        .chargeTab.incomeAccCurr = "000"
        .chargeTab.buyAndSell = "1"
        .chargeTab.buyAndSellForCheck = "1"
        .chargeTab.operType = "1"
        .chargeTab.operPlace = "3"
        .chargeTab.operArea = "96"
        .chargeTab.operAreaForCheck = "7"
        .chargeTab.nonResident = 1
        .chargeTab.nonResidentForCheck = 0
        .chargeTab.legalStatus = "33"
        .chargeTab.legalStatusForCheck = "22"
        .chargeTab.comment = "²ñï³ñÅ. ·³ÝÓáõÙ"
        .chargeTab.commentForCheck = "²ñï³ñÅ.ÙÇçí×. ·³ÝÓáõÙ"
        .chargeTab.clientAgreeData = "ÎÇåñáëÇ ù³Õ³ù³óÇ"
        .coinTab.coin = "95.26"
        .coinTab.coinForCheck = "36.00"
        .coinTab.coinPayCurr = "000"
        .coinTab.coinBuyAndSell = "1"
        .coinTab.coinPayAcc = "000001100  "
        .coinTab.coinExchangeRate = "340.0000/1"
        .coinTab.coinCBExchangeRate = "400.0000/1"
        .coinTab.coinPayAmount = "32388.40"
        .coinTab.coinPayAmountForCheck = "32,388.40"
        .coinTab.amountWithMainCurr = "36705.42"
        .coinTab.amountCurrForCheck = "36,705.42"
        .coinTab.incomeOutChange = "000931900  "
        .coinTab.damagesOutChange = "001434300  "
        .attachedTab.addFiles(0) = Project.Path & "Stores\Attach file\Photo.jpg"
        .attachedTab.fileName(0) = "Photo.jpg"
        .attachedTab.delFiles(0) = Project.Path & "Stores\Attach file\Photo.jpg"
				End With
				
				Set workingDocs = New_MainAccWorkingDocuments()
				With workingDocs
								.startDate = cashOutputCreate.commonTab.date
								.endDate = cashOutputEdit.commonTab.date
				End With
				
				Set verifyDoc = New_VerificationDocument()
				verifyDoc.DocType = "KasRsOrd"
End Sub

Sub DB_Initialize()
    Set dbo_FOLDERS(0) = New_DB_FOLDERS()
    With dbo_FOLDERS(0)
        .fKEY = cashOutputCreate.fIsn
        .fISN = cashOutputCreate.fIsn
        .fNAME = "KasRsOrd"
        .fSTATUS = "1"
        .fFOLDERID = ".D.GlavBux "
        .fCOM = "Î³ÝËÇÏ »Éù"
        .fDCBRANCH = "00 "
        .fDCDEPART = "1  "
    End With
    
    Set dbo_PAYMENTS = New_DB_PAYMENTS()
    With dbo_PAYMENTS
        .fDOCTYPE = "KasRsOrd"
        .fDATE = "2022-02-02"
        .fSTATE = "14"
        .fCLIENT = "00000669"
        .fACCDB = "7770000000111621"
        .fPAYER = "äáÕáë ê³ñ·ëÛ³Ý"
        .fCUR = "001"
        .fSUMMA = "36800.68"
        .fSUMMAAMD = "14720272.00"
        .fSUMMAUSD = "36800.68"
        .fCOM = "Ï³ñ·³·Çñ ÇÝÏ³ë³óÇáÝ å³ñÏ                                                                                                                    "
        .fPASSPORT = "RN00000669 036 24/06/2007"
        .fCOUNTRY = "AM"
        .fACSBRANCH = "00 "
        .fACSDEPART = "1  "
    End With
End Sub

Sub Check_DB_Draft()
    'SQL Ստուգում DOCLOG աղուսյակում համար
    Log.Message "SQL Ստուգում DOCLOG աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCLOG", "fISN", cashOutputCreate.fIsn, 2)
    Call CheckDB_DOCLOG(cashOutputCreate.fIsn, "77", "N", "0", "", 1)
    Call CheckDB_DOCLOG(cashOutputCreate.fIsn, "77", "F", "0", "", 1)
    
    'SQL Ստուգում DOCSATTACH աղուսյակում 
    Log.Message "SQL Ստուգում DOCSATTACH աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCSATTACH", "fISN", cashOutputCreate.fIsn, 2)
    Call CheckDB_DOCSATTACH(cashOutputCreate.fIsn, Project.Path &  "Stores\Attach file\Photo.jpg", "1", "attachedLink_1                                    ", 1)
    Call CheckDB_DOCSATTACH(cashOutputCreate.fIsn, "Photo.jpg", "0", "", 1)
  
    'SQL Ստուգում DOCS աղուսյակում 
    Log.Message "SQL Ստուգում DOCS աղուսյակում", "", pmNormal, SqlDivideColor
    fBODY = " ACSBRANCH:00 ACSDEPART:1 TYPECODE:-20 21 22 23 24 30 31 32 25 26 92 93 11 27 33 28 USERID:  77 DOCNUM:" & cashOutputCreate.commonTab.docNum & " DATE:20211028 ACCDB:00000111621 CUR:001 KASSA:001 ACCCR:000001101 SUMMA:282460.36 KASSIMV:051 BASE:Ð³ïÏ³óáõÙ êáó. ²å³Ñáí. ÐÇÙÝ³¹ñ³ÙÇÝ AIM:Ð³Ù³Ó³ÛÝ ÃÇí ................... â»ÏÇ CLICODE:00000669 RECEIVER:äáÕáë RECEIVERLASTNAME:ê³ñ·ëÛ³Ý PASSNUM:AM00000669 PASTYPE:06 PASBY:017 DATEPASS:20100813 DATEEXPIRE:20230813 DATEBIRTH:19980228 CITIZENSHIP:1 COUNTRY:CY COMMUNITY:990000002 CITY:ÜÇÏáëÇ³ APARTMENT:µÝ. 13 ADDRESS:ÎáÙåá½ÇïáñÝ»ñÇ BUILDNUM:6 EMAIL:cyprosFrom@mail.ru FROMPAYORD:0 ACSBRANCHINC:00 ACSDEPARTINC:1 CHRGACC:000001101 TYPECODE2:-20 21 22 23 24 30 31 32 25 26 92 93 11 27 33 28 CHRGCUR:001 CHRGCBCRS:400.0000/1 PAYSCALE:02 CHRGSUM:1412.3 PRSNT:0.5 CHRGINC:000919400 FRSHNOCRG:0 CUPUSA:1 CURTES:1 CURVAIR:3 VOLORT:7 NONREZ:0 JURSTAT:22 COMM:²ñï³ñÅ.ÙÇçí×. ·³ÝÓáõÙ AGRDETAILS:ÎÇåñáëÇ ù³Õ³ù³óÇ PAYSYSIN:Ð XSUM:36 XCUR:000 XACC:000001100 XDLCRS:340/1 XDLCRSNAME:000 / 001 XCBCRS:400.0000/1 XCBCRSNAME:000 / 001 XCUPUSA:1 XCURSUM:12240 XSUMMAIN:282424.36 XINC:000931900 XEXP:001434300 NOTSENDABLE:0 " 
    fBODY = Replace(fBODY, " ", "%")
    Call CheckQueryRowCount("DOCS", "fISN", cashOutputCreate.fIsn, 1)
    Call CheckDB_DOCS(cashOutputCreate.fIsn, "KasRsOrd", "0", fBODY, 1)
  
    'SQL Ստուգում FOLDERS աղուսյակում 
    Log.Message "SQL Ստուգում FOLDERS աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("FOLDERS", "fISN", cashOutputCreate.fIsn, 1)
    Call CheckDB_FOLDERS(dbo_FOLDERS(0), 1)
End Sub

Sub Check_DB_Create()
    'SQL Ստուգում DOCLOG աղուսյակում համար
    Log.Message "SQL Ստուգում DOCLOG աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCLOG", "fISN", cashOutputCreate.fIsn, 3)
    Call CheckDB_DOCLOG(cashOutputCreate.fIsn, "77", "E", "2", "", 1)
  
    'SQL Ստուգում DOCS աղուսյակում 
    Log.Message "SQL Ստուգում DOCS աղուսյակում", "", pmNormal, SqlDivideColor
    fBODY = " ACSBRANCH:00 ACSDEPART:1 BLREP:0 OPERTYPE:MSC TYPECODE:-20 21 22 23 24 30 31 32 25 26 92 93 11 27 33 28 USERID:  77 DOCNUM:" & cashOutputCreate.commonTab.docNum & " DATE:20211028 ACCDB:00000111621 CUR:001 KASSA:001 ACCCR:000001101 SUMMA:282460.36 TOTAL:283872.66 KASSIMV:051 BASE:Ð³ïÏ³óáõÙ êáó. ²å³Ñáí. ÐÇÙÝ³¹ñ³ÙÇÝ AIM:Ð³Ù³Ó³ÛÝ ÃÇí ................... â»ÏÇ CLICODE:00000669 RECEIVER:äáÕáë RECEIVERLASTNAME:ê³ñ·ëÛ³Ý PASSNUM:AM00000669 PASTYPE:06 PASBY:017 DATEPASS:20100813 DATEEXPIRE:20230813 DATEBIRTH:19980228 CITIZENSHIP:1 COUNTRY:CY COMMUNITY:990000002 CITY:ÜÇÏáëÇ³ APARTMENT:µÝ. 13 ADDRESS:ÎáÙåá½ÇïáñÝ»ñÇ BUILDNUM:6 EMAIL:cyprosFrom@mail.ru FROMPAYORD:0 ACSBRANCHINC:00 ACSDEPARTINC:1 CHRGACC:000001101 TYPECODE2:-20 21 22 23 24 30 31 32 25 26 92 93 11 27 33 28 CHRGCUR:001 CHRGCBCRS:400.0000/1 PAYSCALE:02 CHRGSUM:1412.3 PRSNT:0.5 CHRGINC:000919400 FRSHNOCRG:0 CUPUSA:1 CURTES:1 CURVAIR:3 OLORT:7 NONREZ:0 JURSTAT:22 COMM:²ñï³ñÅ.ÙÇçí×. ·³ÝÓáõÙ AGRDETAILS:ÎÇåñáëÇ ù³Õ³ù³óÇ PAYSYSIN:Ð XSUM:36 XCUR:000 XACC:000001100 XDLCRS:   340.0000/    1 XDLCRSNAME:000 / 001 XCBCRS:400.0000/1 XCBCRSNAME:000 / 001 XCUPUSA:1 XCURSUM:12240 XSUMMAIN:282424.36 XINC:000931900 XEXP:001434300 NOTSENDABLE:0 "  
    fBODY = Replace(fBODY, " ", "%")
    Call CheckQueryRowCount("DOCS", "fISN", cashOutputCreate.fIsn, 1)
    Call CheckDB_DOCS(cashOutputCreate.fIsn, "KasRsOrd", "2", fBODY, 1)
  
    'SQL Ստուգում FOLDERS աղուսյակում 
    Log.Message "SQL Ստուգում FOLDERS աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("FOLDERS", "fISN", cashOutputCreate.fIsn, 2)
    With dbo_FOLDERS(0)
        .fSTATUS = "5"
        .fFOLDERID = "C.889132602"
        .fSPEC = "²Ùë³ÃÇí- 28/10/21 N- " & cashOutputCreate.commonTab.docNum & " ¶áõÙ³ñ-           282,460.36 ²ñÅ.- 001 [Üáñ]"
        .fECOM = "Cash Withdrawal Advice"
        .fDCBRANCH = ""
        .fDCDEPART = ""
    End With
    Call CheckDB_FOLDERS(dbo_FOLDERS(0), 1)
    Set dbo_FOLDERS(1) = New_DB_FOLDERS()
    With dbo_FOLDERS(1)
        .fKEY = cashOutputCreate.fIsn
        .fISN = cashOutputCreate.fIsn
        .fNAME = "KasRsOrd"
        .fSTATUS = "5"
        .fFOLDERID = "Oper.20211028"
        .fCOM = "Î³ÝËÇÏ »Éù"
        .fSPEC = cashOutputCreate.commonTab.docNum & "777000000011162177700000001101         282460.36001Üáñ                                                   77äáÕáë ê³ñ·ëÛ³Ý                  AM00000669 017 13/08/2010                              Ð        Ð³Ù³Ó³ÛÝ ÃÇí ................... â»ÏÇ Ð³ïÏ³óáõÙ êáó. ²å³Ñáí. ÐÇÙÝ³¹ñ³ÙÇÝ                                                                    "
        .fECOM = "Cash Withdrawal Advice"
        .fDCBRANCH = "00 "
        .fDCDEPART = "1  "
    End With
    Call CheckDB_FOLDERS(dbo_FOLDERS(1), 1)
  
    'SQL Ստուգում HI աղուսյակում համար
    Log.Message "SQL Ստուգում HI աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("HI", "fBASE", cashOutputCreate.fIsn, 8)
    Call Check_HI_CE_accounting ("2021-10-28", cashOutputCreate.fIsn, "11", "1630171", "112969744.00", "001", "282424.36", "MSC", "C")
    Call Check_HI_CE_accounting ("2021-10-28", cashOutputCreate.fIsn, "11", "1176308196", "112969744.00", "001", "282424.36", "MSC", "D")
    Call Check_HI_CE_accounting ("2021-10-28", cashOutputCreate.fIsn, "11", "1629177", "2160.00", "000", "2160.00", "MSC", "C")
    Call Check_HI_CE_accounting ("2021-10-28", cashOutputCreate.fIsn, "11", "1176308196", "2160.00", "001", "0.00", "MSC", "D")
    Call Check_HI_CE_accounting ("2021-10-28", cashOutputCreate.fIsn, "11", "1630170", "12240.00", "000", "12240.00", "CEX", "C")
    Call Check_HI_CE_accounting ("2021-10-28", cashOutputCreate.fIsn, "11", "1176308196", "12240.00", "001", "36.00", "CEX", "D")
    Call Check_HI_CE_accounting ("2021-10-28", cashOutputCreate.fIsn, "11", "1630171", "564920.00", "001", "1412.30", "FEX", "D")
    Call Check_HI_CE_accounting ("2021-10-28", cashOutputCreate.fIsn, "11", "1630420", "564920.00", "000", "564920.00", "FEX", "C")
End Sub

Sub Check_DB_Edit()
    'SQL Ստուգում DOCLOG աղուսյակում համար
    Log.Message "SQL Ստուգում DOCLOG աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCLOG", "fISN", cashOutputEdit.fIsn, 4)
    Call CheckDB_DOCLOG(cashOutputEdit.fIsn, "77", "E", "2", "", 2)
  
    'SQL Ստուգում DOCS աղուսյակում 
    Log.Message "SQL Ստուգում DOCS աղուսյակում", "", pmNormal, SqlDivideColor
    fBODY = " ACSBRANCH:00 ACSDEPART:1 BLREP:0 OPERTYPE:MSC TYPECODE:-20 21 22 23 24 30 31 32 25 26 92 93 11 27 33 28 USERID:  77 DOCNUM:" & cashOutputEdit.commonTab.docNum & " DATE:20220202 ACCDB:00000111621 CUR:001 KASSA:001 ACCCR:000001101 SUMMA:36800.68 TOTAL:283872.66 KASSIMV:07 BASE:ÇÝÏ³ë³óÇáÝ å³ñÏ AIM:Ï³ñ·³·Çñ CLICODE:00000669 RECEIVER:äáÕáë RECEIVERLASTNAME:ê³ñ·ëÛ³Ý PASSNUM:RN00000669 PASTYPE:11 PASBY:036 DATEPASS:20070624 DATEEXPIRE:20271030 DATEBIRTH:19980228 CITIZENSHIP:1 COUNTRY:CY COMMUNITY:990000002 CITY:ÜÇÏáëÇ³ APARTMENT:µÝ. 13 ADDRESS:ÎáÙåá½ÇïáñÝ»ñÇ BUILDNUM:6 EMAIL:nicosianin@gmail.com FROMPAYORD:0 ACSBRANCHINC:00 ACSDEPARTINC:1 CHRGACC:000001101 TYPECODE2:-20 21 22 23 24 30 31 32 25 26 92 93 11 27 33 28 CHRGCUR:001 HRGCBCRS:400.0000/1 PAYSCALE:03 CHRGSUM:110.4 PRSNT:0.3 CHRGINC:000450000 FRSHNOCRG:0 CUPUSA:1 CURTES:1 CURVAIR:3 VOLORT:96 NONREZ:1 JURSTAT:33 COMM:²ñï³ñÅ. ·³ÝÓáõÙ AGRDETAILS:ÎÇåñáëÇ ù³Õ³ù³óÇ PAYSYSIN:Ð XSUM:95.26 XCUR:000 XACC:000001100 XDLCRS:340/1 XDLCRSNAME:000 / 001 XCBCRS:400.0000/1 XCBCRSNAME:000 / 001 XCUPUSA:1 XCURSUM:32388.4 XSUMMAIN:36705.42 XINC:000931900 XEXP:001434300 NOTSENDABLE:0 "     
    fBODY = Replace(fBODY, " ", "%")
    Call CheckQueryRowCount("DOCS", "fISN", cashOutputEdit.fIsn, 1)
    Call CheckDB_DOCS(cashOutputEdit.fIsn, "KasRsOrd", "2", fBODY, 1)
  
    'SQL Ստուգում DOCSATTACH աղուսյակում 
    Log.Message "SQL Ստուգում DOCSATTACH աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCSATTACH", "fISN", cashOutputEdit.fIsn, 1)
    Call CheckDB_DOCSATTACH(cashOutputEdit.fIsn, "Photo.jpg", "0", "", 1)
    
    'SQL Ստուգում FOLDERS աղուսյակում 
    Log.Message "SQL Ստուգում FOLDERS աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("FOLDERS", "fISN", cashOutputEdit.fIsn, 2)
    dbo_FOLDERS(0).fSPEC = "²Ùë³ÃÇí- 02/02/22 N- " & cashOutputEdit.commonTab.docNum & " ¶áõÙ³ñ-            36,800.68 ²ñÅ.- 001 [ÊÙµ³·ñíáÕ]"
    Call CheckDB_FOLDERS(dbo_FOLDERS(0), 1)
    With dbo_FOLDERS(1)
        .fFOLDERID = "Oper.20220202"
        .fSPEC = cashOutputEdit.commonTab.docNum & "777000000011162177700000001101          36800.68001ÊÙµ³·ñíáÕ                                             77äáÕáë ê³ñ·ëÛ³Ý                  RN00000669 036 24/06/2007                              Ð        Ï³ñ·³·Çñ ÇÝÏ³ë³óÇáÝ å³ñÏ                                                                                                                    "
    End With
    Call CheckDB_FOLDERS(dbo_FOLDERS(1), 1)
  
    'SQL Ստուգում HI աղուսյակում համար
    Log.Message "SQL Ստուգում HI աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("HI", "fBASE", cashOutputEdit.fIsn, 8)
    Call Check_HI_CE_accounting ("2022-02-02", cashOutputEdit.fIsn, "11", "1630171", "14682168.00", "001", "36705.42", "MSC", "C")
    Call Check_HI_CE_accounting ("2022-02-02", cashOutputEdit.fIsn, "11", "1176308196", "14682168.00", "001", "36705.42", "MSC", "D")
    Call Check_HI_CE_accounting ("2022-02-02", cashOutputEdit.fIsn, "11", "1629177", "5715.60", "000", "5715.60", "MSC", "C")
    Call Check_HI_CE_accounting ("2022-02-02", cashOutputEdit.fIsn, "11", "1176308196", "5715.60", "001", "0.00", "MSC", "D")
    Call Check_HI_CE_accounting ("2022-02-02", cashOutputEdit.fIsn, "11", "1630170", "32388.40", "000", "32388.40", "CEX", "C")
    Call Check_HI_CE_accounting ("2022-02-02", cashOutputEdit.fIsn, "11", "1176308196", "32388.40", "001", "95.26", "CEX", "D")
    Call Check_HI_CE_accounting ("2022-02-02", cashOutputEdit.fIsn, "11", "1629214", "44160.00", "000", "44160.00", "FEX", "C")
    Call Check_HI_CE_accounting ("2022-02-02", cashOutputEdit.fIsn, "11", "1630171", "44160.00", "001", "110.40", "FEX", "D")
End Sub

Sub Check_DB_SendToVerify()
    'SQL Ստուգում DOCLOG աղուսյակում համար
    Log.Message "SQL Ստուգում DOCLOG աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCLOG", "fISN", cashOutputEdit.fIsn, 5)
    Call CheckDB_DOCLOG(cashOutputEdit.fIsn, "77", "M", "11", "àõÕ³ñÏí»É ¿ ¹ñ³Ù³ñÏÕ", 1)
  
    'SQL Ստուգում DOCS աղուսյակում 
    Log.Message "SQL Ստուգում DOCS աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCS", "fISN", cashOutputEdit.fIsn, 1)
    Call CheckDB_DOCS(cashOutputEdit.fIsn, "KasRsOrd", "11", fBODY, 1)
  
    'SQL Ստուգում FOLDERS աղուսյակում 
    Log.Message "SQL Ստուգում FOLDERS աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("FOLDERS", "fISN", cashOutputEdit.fIsn, 3)
    With dbo_FOLDERS(0)
        .fSTATUS = "4"
        .fSPEC = "²Ùë³ÃÇí- 02/02/22 N- " & cashOutputEdit.commonTab.docNum & " ¶áõÙ³ñ-            36,800.68 ²ñÅ.- 001 [àõÕ³ñÏí»É ¿ ¹ñ³Ù³ñÏÕ]"
    End With
    Call CheckDB_FOLDERS(dbo_FOLDERS(0), 1)
    With dbo_FOLDERS(1)
        .fSTATUS = "4"
        .fFOLDERID = "CashOper.20220202"
        .fSPEC = cashOutputEdit.commonTab.docNum & "777000000011162177700000001101          36800.68001àõÕ³ñÏí»É ¿ ¹ñ³Ù³ñÏÕ  77Ï³ñ·³·Çñ ÇÝÏ³ë³óÇáÝ å³ñÏ        äáÕáë ê³ñ·ëÛ³Ý                  RN00000669 036 24/06/2007       001ºÉù          36705.42001Øáõïù          110.40001"
    End With
    Call CheckDB_FOLDERS(dbo_FOLDERS(1), 1)
    Set dbo_FOLDERS(2) = New_DB_FOLDERS()
    With dbo_FOLDERS(2)
        .fKEY = cashOutputEdit.fIsn
        .fISN = cashOutputEdit.fIsn
        .fNAME = "KasRsOrd"
        .fSTATUS = "4"
        .fFOLDERID = "Oper.20220202"
        .fCOM = "Î³ÝËÇÏ »Éù"
        .fSPEC = cashOutputEdit.commonTab.docNum & "777000000011162177700000001101          36800.68001àõÕ³ñÏí»É ¿ ¹ñ³Ù³ñÏÕ                                  77äáÕáë ê³ñ·ëÛ³Ý                  RN00000669 036 24/06/2007       001                    Ð        Ï³ñ·³·Çñ ÇÝÏ³ë³óÇáÝ å³ñÏ                                                                                                                    "
        .fECOM = "Cash Withdrawal Advice"
        .fDCBRANCH = "00 "
        .fDCDEPART = "1  "
    End With
    Call CheckDB_FOLDERS(dbo_FOLDERS(2), 1)
End Sub

Sub Check_DB_Validate()
    'SQL Ստուգում DOCLOG աղուսյակում համար
    Log.Message "SQL Ստուգում DOCLOG աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCLOG", "fISN", cashOutputEdit.fIsn, 7)
    Call CheckDB_DOCLOG(cashOutputEdit.fIsn, "77", "W", "12", "", 1)
    Call CheckDB_DOCLOG(cashOutputEdit.fIsn, "77", "M", "14", "¶ñ³Ýóí»É »Ý Ó¨³Ï»ñåáõÙÝ»ñÁ", 1)
  
    'SQL Ստուգում DOCS աղուսյակում 
    Log.Message "SQL Ստուգում DOCS աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCS", "fISN", cashOutputEdit.fIsn, 1)
    Call CheckDB_DOCS(cashOutputEdit.fIsn, "KasRsOrd", "14", fBODY, 1)
    
    'SQL Ստուգում FOLDERS աղուսյակում 
    Log.Message "SQL Ստուգում FOLDERS աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("FOLDERS", "fISN", cashOutputEdit.fIsn, 0)
  
    'SQL Ստուգում PAYMENTS աղուսյակում 
    Log.Message "SQL Ստուգում PAYMENTS աղուսյակում", "", pmNormal, SqlDivideColor
    With dbo_PAYMENTS
        .fISN = cashOutputEdit.fIsn
        .fDOCNUM = cashOutputEdit.commonTab.docNum
    End With
    Call CheckQueryRowCount("PAYMENTS", "fISN", cashOutputEdit.fIsn, 1)
    Call CheckDB_PAYMENTS(dbo_PAYMENTS, 1)
    
    'SQL Ստուգում HI աղուսյակում համար
    Log.Message "SQL Ստուգում HI աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("HI", "fBASE", cashOutputEdit.fIsn, 10)
    Call Check_HI_CE_accounting ("2022-02-02", cashOutputEdit.fIsn, "01", "1630171", "14682168.00", "001", "36705.42", "MSC", "C")
    Call Check_HI_CE_accounting ("2022-02-02", cashOutputEdit.fIsn, "01", "1176308196", "14682168.00", "001", "36705.42", "MSC", "D")
    Call Check_HI_CE_accounting ("2022-02-02", cashOutputEdit.fIsn, "01", "1629177", "5715.60", "000", "5715.60", "MSC", "C")
    Call Check_HI_CE_accounting ("2022-02-02", cashOutputEdit.fIsn, "01", "1176308196", "5715.60", "001", "0.00", "MSC", "D")
    Call Check_HI_CE_accounting ("2022-02-02", cashOutputEdit.fIsn, "01", "1630170", "32388.40", "000", "32388.40", "CEX", "C")
    Call Check_HI_CE_accounting ("2022-02-02", cashOutputEdit.fIsn, "01", "1176308196", "32388.40", "001", "95.26", "CEX", "D")
    Call Check_HI_CE_accounting ("2022-02-02", cashOutputEdit.fIsn, "CE", "1578250", "32388.40", "001", "95.26", "PUR", "D")
    Call Check_HI_CE_accounting ("2022-02-02", cashOutputEdit.fIsn, "01", "1629214", "44160.00", "000", "44160.00", "FEX", "C")
    Call Check_HI_CE_accounting ("2022-02-02", cashOutputEdit.fIsn, "01", "1630171", "44160.00", "001", "110.40", "FEX", "D")
    Call Check_HI_CE_accounting ("2022-02-02", cashOutputEdit.fIsn, "CE", "1578250", "44160.00", "001", "110.40", "PUR", "D")
End Sub

Sub Check_DB_Delete()
    'SQL Ստուգում DOCLOG աղուսյակում համար
    Log.Message "SQL Ստուգում DOCLOG աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCLOG", "fISN", cashOutputEdit.fIsn, 8)
    Call CheckDB_DOCLOG(cashOutputEdit.fIsn, "77", "D", "999", "", 1)
				
    'SQL Ստուգում DOCS աղուսյակում համար
    Log.Message "SQL Ստուգում DOCS աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCS", "fISN", cashOutputEdit.fIsn, 1)
    Call CheckDB_DOCS(cashOutputEdit.fIsn, "KasRsOrd", "999", fBODY, 1)
		
    'SQL Ստուգում FOLDERS աղուսյակում
    Log.Message "SQL Ստուգում FOLDERS աղուսյակում", "", pmNormal, SqlDivideColor
    With dbo_FOLDERS(0)
        .fNAME = "KasRsOrd"
        .fSTATUS = "0"
        .fFOLDERID = ".R." & aqConvert.DateTimeToFormatStr(aqDateTime.Now(), "%Y%m%d")
        .fSPEC = Left_Align(Get_Compname_DOCLOG(cashOutputEdit.fIsn), 16) & "GlavBux ARMSOFT                       1114 "
        .fCOM = ""
        .fECOM = ""
        .fDCBRANCH = "00 "
        .fDCDEPART = "1  "
    End With
    Call CheckQueryRowCount("FOLDERS", "fISN", cashOutputEdit.fIsn, 1)
    Call CheckDB_FOLDERS(dbo_FOLDERS(0), 1)
End Sub