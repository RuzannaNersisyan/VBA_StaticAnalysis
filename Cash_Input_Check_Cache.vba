'USEUNIT Library_Common
'USEUNIT Library_Contracts
'USEUNIT Constants
'USEUNIT Library_Colour
'USEUNIT DAHK_Library_Filter
'USEUNIT CashInput_Confirmphases_Library
'USEUNIT Payment_Except_Library
'USEUNIT Akreditiv_Library
'USEUNIT Main_Accountant_Filter_Library
'USEUNIT SWIFT_International_Payorder_Library
'USEUNIT Library_CheckDB 
Option Explicit

'Test Case ID 183402

Dim sDate, eDate, folderName, expectedFile, actualFilePath, actualFile
Dim cashInputCreate, cashInputEdit, workingDocs, verifyDoc, currentDate, param
Dim fBODY, dbo_FOLDERS(2)

Sub Cash_Input_Check_Cache_Test()
				Call Test_Inintialize()

				' Համակարգ մուտք գործել ARMSOFT օգտագործողով
				Log.Message "Համակարգ մուտք գործել ARMSOFT օգտագործողով", "", pmNormal, DivideColor
				Call Test_StartUp()
				
				' Մուտք գործել Հաշիվներ թղթապանակ
				Log.Message "Մուտք գործել Հաշիվներ թղթապանակ", "", pmNormal, DivideColor
				Call OpenAccauntsFolder(folderName & "Ð³ßÇíÝ»ñ","1","","77790393321","","","","","","",0,"","","","","",0,0,0,"","","","","","ACCS","0")		
				Call CheckPttel_RowCount("frmPttel", 1) 
		
				' Ստեղծել Կանխիկ մուտք փաստաթղթի սևագիր
				Log.Message "Ստեղծել Կանխիկ մուտք փաստաթղթի սևագիր", "", pmNormal, DivideColor
				Call Create_Cash_Input(cashInputCreate, "ê¨³·Çñ")
    
    ' Փակել Հաշիվներ թղթապանակը
				Call Close_Window(wMDIClient, "frmPttel")
    
    ' Կանխիկ մուտք փաստաթղթի սևագրի ստեղծումից հետո SQL ստուգում
    Log.Message "Կանխիկ մուտք փաստաթղթի սևագրի ստեղծումից հետո SQL ստուգում", "", pmNormal, DivideColor
    Call DB_Initialize()
    Call Check_DB_Draft()
    
    ' Մուտք գործել Օգտագործողսի Սևագրեր թղթապանակ
    Log.Message "Մուտք գործել Օգտագործողսի Սևագրեր թղթապանակ", "", pmNormal, DivideColor
    Call wTreeView.DblClickItem("|¶ÉË³íáñ Ñ³ßí³å³ÑÇ ²Þî|ÂÕÃ³å³Ý³ÏÝ»ñ|ú·ï³·áñÍáÕÇ ë¨³·ñ»ñ")
    ' Կատարել կոճակի սեղմում
    Call ClickCmdButton(2, "Î³ï³ñ»É")
    
    ' Ստեղծել Կանխիկ մուտք փաստաթուղթը սևագրերից
    Log.Message "Ստեղծել Կանխիկ մուտք փաստաթուղթը սևագրերից", "", pmNormal, DivideColor
    If SearchInPttel("frmPttel", 2, cashInputCreate.fIsn) Then
        BuiltIn.Delay(3000)
        Call wMainForm.MainMenu.Click(c_AllActions)
        Call wMainForm.PopupMenu.Click(c_ToEdit)
        If wMDIClient.WaitvbObject("frmASDocForm", 3000).Exists Then
            Call Check_Cash_Input(cashInputCreate)
            Call ClickCmdButton(1, "Î³ï³ñ»É")
        Else 
            Log.Error "Can't find frmASDocForm window", "", pmNormal, ErrorColor
        End If
    End If
    
				' Քաղվածքի պահպանում 
				Log.Message "Քաղվածքի պահպանում", "", pmNormal, DivideColor
    Call SaveDoc(actualFilePath, actualFile) 
				
				' Փակել Քաղվածքի պատուհանը 
				Call Close_Window(wMDIClient, "FrmSpr")
    
    ' Կանխիկ մուտք փաստաթուղթը սևագրերից ստեղծումից հետո SQL ստուգում
    Log.Message "Կանխիկ մուտք փաստաթուղթը սևագրերից ստեղծումից հետո SQL ստուգում", "", pmNormal, DivideColor
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
    If SearchInPttel("frmPttel", 2, cashInputCreate.commonTab.docNum) Then
    				Call Edit_Cash_Input(cashInputCreate, cashInputEdit, "Î³ï³ñ»É")
    Else
        Log.Error "Can't find searched row.", "", pmNormal, ErrorColor
    End If
    
    ' Կանխիկ մուտք փաստաթուղթը խմբագրելուց հետո SQL ստուգում
    Log.Message "Կանխիկ մուտք փաստաթուղթը խմբագրելուց հետո SQL ստուգում", "", pmNormal, DivideColor
    Call Check_DB_Edit()
				
				' Ուղարկել հաստատման
				Log.Message "Ուղարկել հաստատման", "", pmNormal, DivideColor
				Call SendToVerify_Contrct(3, 2, "Î³ï³ñ»É")
    
    ' Ուղարկել հաստատման-ից հետո SQL ստուգում
    Log.Message "Ուղարկել հաստատման-ից հետո SQL ստուգում", "", pmNormal, DivideColor
    Call Check_DB_SendToVerify()
				
				' Մուտք գործել Հաստատվող փաստաթղթեր (|) թղթապանակ
				Call GoToVerificationDocument(folderName & "Ð³ëï³ïíáÕ ÷³ëï³ÃÕÃ»ñ (I)", verifyDoc)
    
    ' Ստուգել, որ առկա է մեր ավելացրած փաստաթուղթը
				Log.Message "Ստուգել, որ առկա է մեր ավելացրած փաստաթուղթը", "", pmNormal, DivideColor
    With cashInputEdit
        .commonTab.idForCheck = "AA111169874"
        .commonTab.idTypeForCheck = "10"
        .commonTab.idGivenByForCheck = "003"
        .commonTab.emailForCheck = "lenin@official.com"
        .commonTab.idValidUntilForCheck = "07/03/2024"
        .commonTab.idGiveDateForCheck = "08/05/1985"
    End With
				If SearchInPttel("frmPttel", 1, cashInputEdit.fIsn) Then
    				wMDIClient.vbObject("frmPttel").Keys("^w")
        If wMDIClient.WaitVBObject("frmASDocForm", 3000).Exists Then
            Call Check_Cash_Input(cashInputEdit)
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
				
				' Փակել Հաստատվող փաստաթղթեր (|) թղթապանակը
				Call Close_Window(wMDIClient, "frmPttel")
    
    ' Վավերացումից հետո SQL ստուգում
    Log.Message "Վավերացումից հետո SQL ստուգում", "", pmNormal, DivideColor
    Call Check_DB_Validate()
				
				' Մուտք գործել Ստեղծված փաստաթղթեր թղթապանակ
				currentDate = aqConvert.DateTimeToFormatStr(aqDateTime.Now(),"%d%m%y")
				Call OpenCreatedDocFolder(folderName & "êï»ÕÍí³Í ÷³ëï³ÃÕÃ»ñ", currentDate, currentDate, null, "KasPrOrd")
				
				' Ստուգել, որ առկա է մեր ավելացրած փաստաթուղթը
				Log.Message "Ստուգել, որ առկա է մեր ավելացրած փաստաթուղթը", "", pmNormal, DivideColor
				If SearchInPttel("frmPttel", 2, cashInputEdit.fIsn) Then
    				wMDIClient.vbObject("frmPttel").Keys("^w")
        If wMDIClient.WaitVBObject("frmASDocForm", 3000).Exists Then
            Call Check_Cash_Input(cashInputEdit)
            Call ClickCmdButton(1, "OK") 
        Else 
            Log.Error "Can't open frmASDocForm window.", "", pmNormal, ErrorColor
        End If
    Else
        Log.Error "Can't find searched row.", "", pmNormal, ErrorColor
    End If
				
				' Ջնջել Կանխիկի մուտք փաստաթուղթը
				Log.Message "Ջնջել Կանխիկի մուտք փաստաթուղթը", "", pmNormal, DivideColor
				Call SearchAndDelete("frmPttel", 2, cashInputEdit.fIsn, "Ð³ëï³ï»ù ÷³ëï³ÃÕÃÇ çÝç»ÉÁ")
				
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
				expectedFile = Project.Path &  "Stores\Cash_Input_Output\Expected\Expected_Cash_Input_Cache.txt"
				actualFilePath = Project.Path &  "Stores\Cash_Input_Output\Actual\"
    actualFile = "Actual_Cash_Input_Cache.txt"
		
				Set cashInputCreate = New_CashInput(0, 0, 0)
				With cashInputCreate
								.commonTab.office = "00"
        .commonTab.department = "1"
        .commonTab.date = "161221"
        .commonTab.dateForCheck = "16/12/21"
        .commonTab.cashRegister = "001"
        .commonTab.cashRegisterAcc = "000001100  "
        .commonTab.curr = "000"
        .commonTab.accCredit = "77790393321"
        .commonTab.amount = "16259.38"
        .commonTab.amountForCheck = "16,259.40"
        .commonTab.cashierChar = "021"
        .commonTab.base = "öáË³ÝóáõÙ å»ïµÛáõç»"
        .commonTab.aim = "ºÏ³Ùï³Ñ³ñÏ  ³Ùëí³ Ñ³Ù³ñ"
        .commonTab.payer = "00000235"
        .commonTab.payerLegalStatus = "ֆիզԱնձ"
        .commonTab.name = "È»ÝÇÝ"
        .commonTab.surname = "ìÉ³¹ÇÙÇñ"
        .commonTab.id = "AA111111111"
        .commonTab.idForCheck = "AA111111111"
        .commonTab.idType = "01"
        .commonTab.idTypeForCheck = "01"
        .commonTab.idGivenBy = "002"
        .commonTab.idGivenByForCheck = "002"
        .commonTab.idGiveDate = "22041986"
        .commonTab.idGiveDateForCheck = "22/04/1986"
        .commonTab.idValidUntil = "15062026"
        .commonTab.idValidUntilForCheck = "15/06/2026"
        .commonTab.birthDate = "19011986"
        .commonTab.birthDateForCheck = "19/01/1986"
        .commonTab.citizenship = "4"
        .commonTab.country = "RU"
        .commonTab.residence = "990000002"
        .commonTab.city = "ØáëÏí³"
        .commonTab.street = "Î³ñÙÇñ Ññ³å³ñ³Ï 1"
        .commonTab.apartment = "´Ý³Ï³ñ³Ý 5"
        .commonTab.house = "Þ»Ýù 1    "
        .commonTab.email = "lenin@ulianov.net"
        .commonTab.emailForCheck = "lenin@ulianov.net"
        .chargeTab.office = .commonTab.office
        .chargeTab.department = .commonTab.department
        .chargeTab.chargeAcc = "77790393321"
        .chargeTab.chargeAccForCheck = "77790393321"
        .chargeTab.chargeCurr = "000"
        .chargeTab.chargeCurrForCheck = "000"
        .chargeTab.cbExchangeRate = "1.0000/1"
        .chargeTab.chargeType = "02"
        .chargeTab.chargeAmount = "24.40"
        .chargeTab.chargeAmoForCheck = "24.40"
        .chargeTab.chargePercent = "0.1501"
        .chargeTab.chargePerForCheck = "0.1501"
        .chargeTab.incomeAcc = "000434400  "
        .chargeTab.incomeAccCurr = "000"
        .chargeTab.buyAndSell = ""
        .chargeTab.buyAndSellForCheck = ""
        .chargeTab.operType = ""
        .chargeTab.operPlace = ""
        .chargeTab.operArea = "7"
        .chargeTab.operAreaForCheck = "7"
        .chargeTab.nonResident = 1
        .chargeTab.nonResidentForCheck = 1
        .chargeTab.legalStatus = "21"
        .chargeTab.legalStatusForCheck = "21"
        .chargeTab.comment = "¶³ÝÓáõÙ Ï³ÝËÇÏ ÙáõïùÇ Ñ³Ù³ñ"
        .chargeTab.commentForCheck = "¶³ÝÓáõÙ Ï³ÝËÇÏ ÙáõïùÇ Ñ³Ù³ñ"
        .chargeTab.clientAgreeData = "Ñ³×³Ëáñ¹Ç ïíÛ³ÉÝ»ñ"
				End With
				
    Set cashInputEdit = New_CashInput(0, 0, 0)
				With cashInputEdit
        .commonTab.office = "00"
        .commonTab.department = "1"
        .commonTab.date = "010122"
        .commonTab.dateForCheck = "01/01/22"
        .commonTab.cashRegister = "001"
        .commonTab.cashRegisterAcc = "000001100  "
        .commonTab.curr = "000"
        .commonTab.accCredit = "77790393321"
        .commonTab.amount = "2,608.69"
        .commonTab.amountForCheck = "2,608.70"
        .commonTab.cashierChar = "022"
        .commonTab.base = "ÂÕÃ³Ïó³ÛÇÝ Ñ³ßíÇ ³Ùñ³óáõÙ"
        .commonTab.aim = "Ð³Ù³Ó³ÛÝ Ñ³ßÇí-³åñ³Ýù³·ñÇ Ã."
        .commonTab.payer = "00000235"
        .commonTab.payerLegalStatus = "ֆիզԱնձ"
        .commonTab.name = "È»ÝÇÝ"
        .commonTab.surname = "ìÉ³¹ÇÙÇñ"
        .commonTab.id = "AA111169874"
        .commonTab.idForCheck = "AA111111111"
        .commonTab.idType = "10"
        .commonTab.idTypeForCheck = "01"
        .commonTab.idGivenBy = "003"
        .commonTab.idGivenByForCheck = "002"
        .commonTab.idGiveDate = "08051985"
        .commonTab.idGiveDateForCheck = "22/04/1986"
        .commonTab.idValidUntil = "07032024"
        .commonTab.idValidUntilForCheck = "15/06/2026"
        .commonTab.birthDate = "19011986"
        .commonTab.birthDateForCheck = "19/01/1986"
        .commonTab.citizenship = "4"
        .commonTab.country = "RU"
        .commonTab.residence = "990000002"
        .commonTab.city = "ØáëÏí³"
        .commonTab.street = "Î³ñÙÇñ Ññ³å³ñ³Ï 1"
        .commonTab.apartment = "´Ý³Ï³ñ³Ý 5"
        .commonTab.house = "Þ»Ýù 1    "
        .commonTab.email = "lenin@official.com"
        .commonTab.emailForCheck = "lenin@ulianov.net"
        .chargeTab.office = .commonTab.office
        .chargeTab.department = .commonTab.department
        .chargeTab.chargeAcc = "555555555  "
        .chargeTab.chargeAccForCheck = "77790393321"
        .chargeTab.chargeCurr = "000"
        .chargeTab.chargeCurrForCheck = "000"
        .chargeTab.cbExchangeRate = "1.0000/1"
        .chargeTab.chargeType = "02"
        .chargeTab.chargeAmount = "3.90"
        .chargeTab.chargeAmoForCheck = "3.90"
        .chargeTab.chargePercent = "0.1495"
        .chargeTab.chargePerForCheck = "0.1495"
        .chargeTab.incomeAcc = "000447600  "
        .chargeTab.incomeAccCurr = "000"
        .chargeTab.buyAndSell = ""
        .chargeTab.buyAndSellForCheck = ""
        .chargeTab.operType = ""
        .chargeTab.operPlace = ""
        .chargeTab.operArea = "7"
        .chargeTab.operAreaForCheck = "7"
        .chargeTab.nonResident = 1
        .chargeTab.nonResidentForCheck = 1
        .chargeTab.legalStatus = "21"
        .chargeTab.legalStatusForCheck = "21"
        .chargeTab.comment = "¶³ÝÓáõÙ Ï³ÝËÇÏ ÙáõïùÇ Ñ³Ù³ñ"
        .chargeTab.commentForCheck = "¶³ÝÓáõÙ Ï³ÝËÇÏ ÙáõïùÇ Ñ³Ù³ñ"
        .chargeTab.clientAgreeData = "Ñ³×³Ëáñ¹Ç ïíÛ³ÉÝ»ñ"
				End With
				
				Set workingDocs = New_MainAccWorkingDocuments()
				With workingDocs
								.startDate = cashInputCreate.commonTab.date
								.endDate = cashInputEdit.commonTab.date
				End With
				
				Set verifyDoc = New_VerificationDocument()
				verifyDoc.DocType = "KasPrOrd"
End Sub

Sub DB_Initialize()		
    Set dbo_FOLDERS(0) = New_DB_FOLDERS()
    With dbo_FOLDERS(0)
        .fKEY = cashInputCreate.fIsn
        .fISN = cashInputCreate.fIsn
        .fNAME = "KasPrOrd"
        .fSTATUS = "1"
        .fFOLDERID = ".D.GlavBux "
        .fCOM = "Î³ÝËÇÏ Ùáõïù"
        .fDCBRANCH = "00 "
        .fDCDEPART = "1  "
    End With 
End	Sub

Sub Check_DB_Draft()
    'SQL Ստուգում DOCLOG աղուսյակում համար
    Log.Message "SQL Ստուգում DOCLOG աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCLOG", "fISN", cashInputCreate.fIsn, 2)
    Call CheckDB_DOCLOG(cashInputCreate.fIsn, "77", "N", "0", "", 1)
    Call CheckDB_DOCLOG(cashInputCreate.fIsn, "77", "F", "0", "", 1)
  
    'SQL Ստուգում DOCS աղուսյակում 
    Log.Message "SQL Ստուգում DOCS աղուսյակում", "", pmNormal, SqlDivideColor
    fBODY = " ACSBRANCH:00 ACSDEPART:1 TYPECODE:-20 21 22 23 24 30 31 32 25 26 92 93 11 27 33 28 USERID:  77 DOCNUM:" & cashInputCreate.commonTab.docNum & " DATE:20211216 KASSA:001 ACCDB:000001100 CUR:000 ACCCR:77790393321 SUMMA:16259.4 KASSIMV:021 BASE:öáË³ÝóáõÙ å»ïµÛáõç» AIM:ºÏ³Ùï³Ñ³ñÏ  ³Ùëí³ Ñ³Ù³ñ CLICODE:00000235 PAYER:È»ÝÇÝ PAYERLASTNAME:ìÉ³¹ÇÙÇñ PASSNUM:AA111111111 PASTYPE:01 PASBY:002 DATEPASS:19860422 DATEEXPIRE:20260615 DATEBIRTH:19860119 CITIZENSHIP:4 COUNTRY:RU COMMUNITY:990000002 CITY:ØáëÏí³ APARTMENT:´Ý³Ï³ñ³Ý 5 ADDRESS:Î³ñÙÇñ Ññ³å³ñ³Ï BUILDNUM:Þ»Ýù 1 EMAIL:lenin@ulianov.net ACSBRANCHINC:00 ACSDEPARTINC:1 CHRGACC:77790393321 TYPECODE2:-20 21 22 23 24 30 31 32 25 26 92 93 11 27 33 28 CHRGCUR:000 CHRGCBCRS:1/1 PAYSCALE:02 CHRGSUM:24.4 PRSNT:0.1501 CHRGINC:000434400 VOLORT:7 NONREZ:1 JURSTAT:21 COMM:¶³ÝÓáõÙ Ï³ÝËÇÏ ÙáõïùÇ Ñ³Ù³ñ AGRDETAILS:Ñ³×³Ëáñ¹Ç ïíÛ³ÉÝ»ñ USEOVERLIMIT:0 NOTSENDABLE:0 " 
    fBODY = Replace(fBODY, " ", "%")
    Call CheckQueryRowCount("DOCS", "fISN", cashInputCreate.fIsn, 1)
    Call CheckDB_DOCS(cashInputCreate.fIsn, "KasPrOrd", "0", fBODY, 1)
  
    'SQL Ստուգում FOLDERS աղուսյակում 
    Log.Message "SQL Ստուգում FOLDERS աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("FOLDERS", "fISN", cashInputCreate.fIsn, 1)
    Call CheckDB_FOLDERS(dbo_FOLDERS(0), 1)
End	Sub

Sub Check_DB_Create()
    'SQL Ստուգում DOCLOG աղուսյակում համար
    Log.Message "SQL Ստուգում DOCLOG աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCLOG", "fISN", cashInputCreate.fIsn, 3)
    Call CheckDB_DOCLOG(cashInputCreate.fIsn, "77", "E", "2", "", 1)
  
    'SQL Ստուգում DOCS աղուսյակում 
    Log.Message "SQL Ստուգում DOCS աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCS", "fISN", cashInputCreate.fIsn, 1)
    Call CheckDB_DOCS(cashInputCreate.fIsn, "KasPrOrd", "2", fBODY, 1)
  
    'SQL Ստուգում FOLDERS աղուսյակում 
    Log.Message "SQL Ստուգում FOLDERS աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("FOLDERS", "fISN", cashInputCreate.fIsn, 2)
    With dbo_FOLDERS(0)
        .fSTATUS = "5"
        .fFOLDERID = "C.1734250"
        .fSPEC = "²Ùë³ÃÇí- 16/12/21 N- " & cashInputCreate.commonTab.docNum & " ¶áõÙ³ñ-            16,259.40 ²ñÅ.- 000 [Üáñ]"
        .fECOM = "Cash Deposit Advice"
        .fDCBRANCH = ""
        .fDCDEPART = ""
    End With 
    Call CheckDB_FOLDERS(dbo_FOLDERS(0), 1)
    Set dbo_FOLDERS(1) = New_DB_FOLDERS()
    With dbo_FOLDERS(1)
        .fKEY = cashInputCreate.fIsn
        .fISN = cashInputCreate.fIsn
        .fNAME = "KasPrOrd"
        .fSTATUS = "5"
        .fFOLDERID = "Oper.20211216 "
        .fCOM = "Î³ÝËÇÏ Ùáõïù"
        .fSPEC = cashInputCreate.commonTab.docNum & "77700000001100  7770077790393321        16259.40000Üáñ                                                   77È»ÝÇÝ ìÉ³¹ÇÙÇñ                  AA111111111 002 22/04/1986                                      ºÏ³Ùï³Ñ³ñÏ  ³Ùëí³ Ñ³Ù³ñ öáË³ÝóáõÙ å»ïµÛáõç»                                                                                                 "
        .fECOM = "Cash Deposit Advice"
        .fDCBRANCH = "00 "
        .fDCDEPART = "1  "
    End With 
    Call CheckDB_FOLDERS(dbo_FOLDERS(1), 1)
  
    'SQL Ստուգում HI աղուսյակում համար
    Log.Message "SQL Ստուգում HI աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("HI", "fBASE", cashInputCreate.fIsn, 4)
    Call Check_HI_CE_accounting ("2021-12-16", cashInputCreate.fIsn, "11", "1630170", "16259.40", "000", "16259.40", "MSC", "D")
    Call Check_HI_CE_accounting ("2021-12-16", cashInputCreate.fIsn, "11", "1734253", "16259.40", "000", "16259.40", "MSC", "C")
    Call Check_HI_CE_accounting ("2021-12-16", cashInputCreate.fIsn, "11", "1629198", "24.40", "000", "24.40", "FEE", "C")
    Call Check_HI_CE_accounting ("2021-12-16", cashInputCreate.fIsn, "11", "1734253", "24.40", "000", "24.40", "FEE", "D")
End Sub

Sub Check_DB_Edit()
    'SQL Ստուգում DOCLOG աղուսյակում համար
    Log.Message "SQL Ստուգում DOCLOG աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCLOG", "fISN", cashInputEdit.fIsn, 4)
    Call CheckDB_DOCLOG(cashInputEdit.fIsn, "77", "E", "2", "", 2)
  
    'SQL Ստուգում DOCS աղուսյակում 
    Log.Message "SQL Ստուգում DOCS աղուսյակում", "", pmNormal, SqlDivideColor
    fBODY = " ACSBRANCH:00 ACSDEPART:1 BLREP:0 OPERTYPE:MSC TYPECODE:-20 21 22 23 24 30 31 32 25 26 92 93 11 27 33 28 USERID:  77 DOCNUM:" & cashInputEdit.commonTab.docNum & " DATE:20220101 KASSA:001 ACCDB:000001100 CUR:000 ACCCR:77790393321 SUMMA:2608.7 KASSIMV:022 BASE:ÂÕÃ³Ïó³ÛÇÝ Ñ³ßíÇ ³Ùñ³óáõÙ AIM:Ð³Ù³Ó³ÛÝ Ñ³ßÇí-³åñ³Ýù³·ñÇ Ã. CLICODE:00000235 PAYER:È»ÝÇÝ PAYERLASTNAME:ìÉ³¹ÇÙÇñ PASSNUM:AA111169874 PASTYPE:10 ASBY:003 DATEPASS:19850508 DATEEXPIRE:20240307 DATEBIRTH:19860119 CITIZENSHIP:4 COUNTRY:RU COMMUNITY:990000002 CITY:ØáëÏí³ APARTMENT:´Ý³Ï³ñ³Ý 5 ADDRESS:Î³ñÙÇñ Ññ³å³ñ³Ï BUILDNUM:Þ»Ýù 1 EMAIL:lenin@official.com ACSBRANCHINC:00 ACSDEPARTINC:1 CHRGACC:555555555 TYPECODE2:-20 21 22 23 24 30 31 32 25 26 92 93 11 27 33 28 CHRGCUR:000 CHRGCBCRS:1/1 PAYSCALE:02 CHRGSUM:3.9 PRSNT:0.1495 CHRGINC:000447600 VOLORT:7 NONREZ:1 JURSTAT:21 COMM:¶³ÝÓáõÙ Ï³ÝËÇÏ ÙáõïùÇ Ñ³Ù³ñ AGRDETAILS:Ñ³×³Ëáñ¹Ç ïíÛ³ÉÝ»ñ USEOVERLIMIT:0 NOTSENDABLE:0  " 
    fBODY = Replace(fBODY, " ", "%")
    Call CheckQueryRowCount("DOCS", "fISN", cashInputEdit.fIsn, 1)
    Call CheckDB_DOCS(cashInputEdit.fIsn, "KasPrOrd", "2", fBODY, 1)
  
    'SQL Ստուգում FOLDERS աղուսյակում 
    Log.Message "SQL Ստուգում FOLDERS աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("FOLDERS", "fISN", cashInputEdit.fIsn, 2)
    dbo_FOLDERS(0).fSPEC = "²Ùë³ÃÇí- 01/01/22 N- " & cashInputEdit.commonTab.docNum & " ¶áõÙ³ñ-             2,608.70 ²ñÅ.- 000 [ÊÙµ³·ñíáÕ]"
    Call CheckDB_FOLDERS(dbo_FOLDERS(0), 1)
    With dbo_FOLDERS(1)
        .fFOLDERID = "Oper.20220101"
        .fCOM = "Î³ÝËÇÏ Ùáõïù"
        .fSPEC = cashInputEdit.commonTab.docNum & "77700000001100  7770077790393321         2608.70000ÊÙµ³·ñíáÕ                                             77È»ÝÇÝ ìÉ³¹ÇÙÇñ                  AA111169874 003 08/05/1985                                      Ð³Ù³Ó³ÛÝ Ñ³ßÇí-³åñ³Ýù³·ñÇ Ã. ÂÕÃ³Ïó³ÛÇÝ Ñ³ßíÇ ³Ùñ³óáõÙ                                                                                      "
    End With 
    Call CheckDB_FOLDERS(dbo_FOLDERS(1), 1)
  
    'SQL Ստուգում HI աղուսյակում համար
    Log.Message "SQL Ստուգում HI աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("HI", "fBASE", cashInputEdit.fIsn, 4)
    Call Check_HI_CE_accounting ("2022-01-01", cashInputEdit.fIsn, "11", "1630170", "2608.70", "000", "2608.70", "MSC", "D")
    Call Check_HI_CE_accounting ("2022-01-01", cashInputEdit.fIsn, "11", "1734253", "2608.70", "000", "2608.70", "MSC", "C")
    Call Check_HI_CE_accounting ("2022-01-01", cashInputEdit.fIsn, "11", "1629211", "3.90", "000", "3.90", "FEE", "C")
    Call Check_HI_CE_accounting ("2022-01-01", cashInputEdit.fIsn, "11", "1716335", "3.90", "000", "3.90", "FEE", "D")
End Sub

Sub Check_DB_SendToVerify()
    'SQL Ստուգում DOCLOG աղուսյակում համար
    Log.Message "SQL Ստուգում DOCLOG աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCLOG", "fISN", cashInputEdit.fIsn, 5)
    Call CheckDB_DOCLOG(cashInputEdit.fIsn, "77", "M", "101", "àõÕ³ñÏí»É ¿ Ñ³ëï³ïÙ³Ý", 1)
  
    'SQL Ստուգում DOCS աղուսյակում 
    Log.Message "SQL Ստուգում DOCS աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCS", "fISN", cashInputEdit.fIsn, 1)
    Call CheckDB_DOCS(cashInputEdit.fIsn, "KasPrOrd", "101", fBODY, 1)
  
    'SQL Ստուգում FOLDERS աղուսյակում 
    Log.Message "SQL Ստուգում FOLDERS աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("FOLDERS", "fISN", cashInputEdit.fIsn, 3)
    With dbo_FOLDERS(0)
        .fSTATUS = "0"
        .fSPEC = "²Ùë³ÃÇí- 01/01/22 N- " & cashInputEdit.commonTab.docNum & " ¶áõÙ³ñ-             2,608.70 ²ñÅ.- 000 [àõÕ³ñÏí³Í I Ñ³ëï³ïÙ³Ý]"
    End With
    Call CheckDB_FOLDERS(dbo_FOLDERS(0), 1)
    With dbo_FOLDERS(1)
        .fSTATUS = "0"
        .fCOM = "Î³ÝËÇÏ Ùáõïù"
        .fSPEC = cashInputEdit.commonTab.docNum & "77700000001100  7770077790393321         2608.70000àõÕ³ñÏí³Í I Ñ³ëï³ïÙ³Ý                                 77È»ÝÇÝ ìÉ³¹ÇÙÇñ                                                  001                             Ð³Ù³Ó³ÛÝ Ñ³ßÇí-³åñ³Ýù³·ñÇ Ã. ÂÕÃ³Ïó³ÛÇÝ Ñ³ßíÇ ³Ùñ³óáõÙ                                                                                      "
    End With
    Call CheckDB_FOLDERS(dbo_FOLDERS(1), 1)
    Set dbo_FOLDERS(2) = New_DB_FOLDERS()
    With dbo_FOLDERS(2)
        .fKEY = cashInputEdit.fIsn
        .fISN = cashInputEdit.fIsn
        .fNAME = "KasPrOrd"
        .fSTATUS = "4"
        .fFOLDERID = "Ver.20220101001"
        .fCOM = "Î³ÝËÇÏ Ùáõïù"
        .fSPEC = cashInputEdit.commonTab.docNum & "77700000001100  7770077790393321         2608.70000  77Ð³Ù³Ó³ÛÝ Ñ³ßÇí-³åñ³Ýù³·ñÇ Ã.    ÂÕÃ³Ïó³ÛÇÝ Ñ³ßíÇ ³Ùñ³óáõÙ       È»ÝÇÝ ìÉ³¹ÇÙÇñ                  "
        .fECOM = "Cash Deposit Advice"
        .fDCBRANCH = "00 "
        .fDCDEPART = "1  "
    End With
    Call CheckDB_FOLDERS(dbo_FOLDERS(2), 1)
End Sub

Sub Check_DB_Validate()
    'SQL Ստուգում DOCLOG աղուսյակում համար
    Log.Message "SQL Ստուգում DOCLOG աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCLOG", "fISN", cashInputEdit.fIsn, 7)
    Call CheckDB_DOCLOG(cashInputEdit.fIsn, "77", "W", "102", "", 1)
    Call CheckDB_DOCLOG(cashInputEdit.fIsn, "77", "C", "15", "", 1)
  
    'SQL Ստուգում DOCS աղուսյակում 
    Log.Message "SQL Ստուգում DOCS աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCS", "fISN", cashInputEdit.fIsn, 1)
    Call CheckDB_DOCS(cashInputEdit.fIsn, "KasPrOrd", "15", fBODY, 1)
  
    'SQL Ստուգում FOLDERS աղուսյակում 
    Log.Message "SQL Ստուգում FOLDERS աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("FOLDERS", "fISN", cashInputEdit.fIsn, 2)
    With dbo_FOLDERS(0)
        .fSTATUS = "4"
        .fSPEC = "²Ùë³ÃÇí- 01/01/22 N- " & cashInputEdit.commonTab.docNum & " ¶áõÙ³ñ-             2,608.70 ²ñÅ.- 000 [Ð³ëï³ïí³Í]"
    End With
    Call CheckDB_FOLDERS(dbo_FOLDERS(0), 1)
    With dbo_FOLDERS(2)
        .fFOLDERID = "Oper.20220101"
        .fSPEC = cashInputEdit.commonTab.docNum & "77700000001100  7770077790393321         2608.70000Ð³ëï³ïí³Í                                             77È»ÝÇÝ ìÉ³¹ÇÙÇñ                  AA111169874 003 08/05/1985                                      Ð³Ù³Ó³ÛÝ Ñ³ßÇí-³åñ³Ýù³·ñÇ Ã. ÂÕÃ³Ïó³ÛÇÝ Ñ³ßíÇ ³Ùñ³óáõÙ                                                                                      "
    End With
    Call CheckDB_FOLDERS(dbo_FOLDERS(2), 1)
End Sub

Sub Check_DB_Delete()
    'SQL Ստուգում DOCLOG աղուսյակում համար
    Log.Message "SQL Ստուգում DOCLOG աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCLOG", "fISN", cashInputEdit.fIsn, 8)
    Call CheckDB_DOCLOG(cashInputEdit.fIsn, "77", "D", "999", "", 1)
				
    'SQL Ստուգում DOCS աղուսյակում համար
    Log.Message "SQL Ստուգում DOCS աղուսյակում", "", pmNormal, SqlDivideColor
    Call CheckQueryRowCount("DOCS", "fISN", cashInputEdit.fIsn, 1)
    Call CheckDB_DOCS(cashInputEdit.fIsn, "KasPrOrd", "999", fBODY, 1)
		
    'SQL Ստուգում FOLDERS աղուսյակում 
    Log.Message "SQL Ստուգում FOLDERS աղուսյակում", "", pmNormal, SqlDivideColor
    With dbo_FOLDERS(0)
        .fNAME = "KasPrOrd"
        .fSTATUS = "0"
        .fFOLDERID = ".R." & aqConvert.DateTimeToFormatStr(aqDateTime.Now(), "%Y%m%d")
        .fSPEC = Left_Align(Get_Compname_DOCLOG(cashInputEdit.fIsn), 16) & "GlavBux ARMSOFT                       0115 "
        .fCOM = ""
        .fDCBRANCH	= "00 "
        .fECOM = ""
        .fDCBRANCH = "00 "
        .fDCDEPART = "1  "
    End With
    Call CheckQueryRowCount("FOLDERS", "fISN", cashInputEdit.fIsn, 1)
    Call CheckDB_FOLDERS(dbo_FOLDERS(0), 1)
End Sub