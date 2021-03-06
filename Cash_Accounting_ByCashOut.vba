'USEUNIT Library_Common
'USEUNIT Library_Colour
'USEUNIT Library_CheckDB
'USEUNIT OLAP_Library
'USEUNIT Card_Library
'USEUNIT Mortgage_Library
'USEUNIT SWIFT_International_Payorder_Library
'USEUNIT DAHK_Library_Filter
'USEUNIT Library_Contracts
'USEUNIT Overlimit_Library
'USEUNIT CashOutput_Confirmpases_Library
'USEUNIT  Main_Accountant_Filter_Library

'USEUNIT Constants
Option Explicit

'Test Case Id - 165217

Dim dbFOLDERS(8),dbHI2(2)
    
Sub Cash_Accounting_ByCashOut()
  

    Dim sDATE,eDATE
    Dim CashAccountingObject,CashRemainderISN,VerificationDoc
    Dim CashOutIsn,CashOutObject
    
    'Համակարգ մուտք գործել ARMSOFT օգտագործողով
    sDATE = "20030101"
    eDATE = "20260101"
    Call Initialize_AsBank("bank", sDATE, eDATE)
    Login("ARMSOFT")
    
    'Մուտք Գլխավոր հաշվապահի ԱՇՏ
    Call ChangeWorkspace(c_ChiefAcc)
    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''-- Մուտք գործել Կանխիկ միջոցների հաշվառում թղթապանակ --''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "-- Մուտք գործել Կանխիկ միջոցների հաշվառում թղթապանակ --" ,,, DivideColor 
    
    Set CashAccountingObject = New_CashAccounting()
    With CashAccountingObject
      .ClientCode = "00000678"
      .Curr = "001"
      .LegalPosition = "1"
      .BusinessField = "9X"
      .StateStatus = "2"
      .Residence = "1"
      .ClientName = "KERAMIKA Ê³ã³ïãÛ³Ý ìÉ³¹»Ý ì³ÝÇÏÇ"
      .IdNumber = "AE1311511"
      .Note = ""
      .ShowClosedClients = 1
      .Date = "270606"
      .Division = "00"
      .Department = "2"
      .AccessType = "00"
    End With
    Call GoTo_CashAccounting(CashAccountingObject) 
    
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''-- Կատարել ԱջԿլիկ(Կանխիկ մնացորդի ճշտում) գործողությունը --''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "-- Կատարել (Կանխիկ մնացորդի ճշտում) գործողությունը --" ,,, DivideColor 
    
    CashRemainderISN =  CashRemainderRefining("00","1","00000678","001","010120","1","650000.55","1CashRemainderRefining97")
    
    Log.Message "fISN = " & CashRemainderISN ,,,SqlDivideColor
    
    Call SQL_Initialize_Cash_Accounting_ByAccount(CashRemainderISN)
    
    'SQL Ստուգում DOCS աղուսյակում
    fBODY = "  ACSBRANCH:00  ACSDEPART:1  USERID:  77  DATE:20200101  CLICODE:00000678  CUR:001  OPTP:1  SUMMA:650000.55  COMM:1CashRemainderRefining97  "
    fBODY = Replace(fBODY, "  ", "%")
    Call CheckQueryRowCount("DOCS","fISN",CashRemainderISN,1)
    Call CheckDB_DOCS(CashRemainderISN,"CashAcRf","2",fBODY,1)
    
    'SQL Ստուգում DOCLOG աղուսյակում 
    Call CheckQueryRowCount("DOCLOG","fISN",CashRemainderISN,2)
    Call CheckDB_DOCLOG(CashRemainderISN,"77","N","1"," ",1)
    Call CheckDB_DOCLOG(CashRemainderISN,"77","C","2"," ",1)
    
    'SQL Ստուգում FOLDERS աղուսյակում 
    Call CheckQueryRowCount("FOLDERS","fISN",CashRemainderISN,1)
    Call CheckDB_FOLDERS(dbFOLDERS(1),1)
    
    Call Close_Pttel("frmPttel")
    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''-- "Աշխատանքային փաստաթղթեր" թղթապանակից կատարել "Ուղարկել հաստատման" գործողությունը --'''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "-- Կատարել Ուղարկել հաստատման գործողությունը --",,,DivideColor       
    
    wTreeView.DblClickItem("|¶ÉË³íáñ Ñ³ßí³å³ÑÇ ²Þî|ÂÕÃ³å³Ý³ÏÝ»ñ|²ßË³ï³Ýù³ÛÇÝ ÷³ëï³ÃÕÃ»ñ") 
    'Լրացնել "Ամսաթիվ" դաշտերը
    Call Rekvizit_Fill("Dialog",1,"General","PERN", "010120")
    Call Rekvizit_Fill("Dialog",1,"General","PERK", "010120")
    Call ClickCmdButton(2, "Î³ï³ñ»É")
    
    If WaitForPttel("frmPttel") Then
        Call wMainForm.MainMenu.Click(c_AllActions)
        Call wMainForm.PopupMenu.Click(c_SendToVer)
        BuiltIn.Delay(2000)
        Call MessageExists(2,"àõÕ³ñÏ»É Ñ³ëï³ïÙ³Ý")
        Call ClickCmdButton(5, "²Ûá")
        Call Close_Pttel("frmPttel") 
    Else
        Log.Error "Can Not Open Աշխատանքային փաստաթղթեր pttel",,,ErrorColor      
    End If  
    
    'SQL Ստուգում DOCS աղուսյակում
    Call CheckQueryRowCount("DOCS","fISN",CashRemainderISN,1)
    Call CheckDB_DOCS(CashRemainderISN,"CashAcRf","101",fBODY,1)
    
    'SQL Ստուգում DOCLOG աղուսյակում 
    Call CheckQueryRowCount("DOCLOG","fISN",CashRemainderISN,3)
    Call CheckDB_DOCLOG(CashRemainderISN,"77","E","101"," ",1)
    
    'SQL Ստուգում FOLDERS աղուսյակում 
    dbFOLDERS(1).fSTATUS = "0"
    dbFOLDERS(1).fSPEC = "                                             650000.55001àõÕ³ñÏí³Í I Ñ³ëï³ïÙ³Ý                                 77                                                                                                1CashRemainderRefining97                                                                                                                    " 
    
    Call CheckQueryRowCount("FOLDERS","fISN",CashRemainderISN,2)
    Call CheckDB_FOLDERS(dbFOLDERS(1),1)
    Call CheckDB_FOLDERS(dbFOLDERS(2),1)

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''-- Գլխավոր հաշվապահ/Հաստատվող փաստաթղթեր(|) թղթապանակից կատարել "Վավերացնել" գործողությունը --''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "-- Կատարել Վավերացնել գործողությունը --",,,DivideColor   

    Set VerificationDoc = New_VerificationDocument()
        VerificationDoc.DocType = "CashAcRf"
    
    Call GoToVerificationDocument("|¶ÉË³íáñ Ñ³ßí³å³ÑÇ ²Þî|ÂÕÃ³å³Ý³ÏÝ»ñ|Ð³ëï³ïíáÕ ÷³ëï³ÃÕÃ»ñ (I)",VerificationDoc) 
    
    If WaitForPttel("frmPttel") Then
        If SearchInPttel("frmPttel",7, "650000.55") Then
            Call wMainForm.MainMenu.Click(c_AllActions)
            Call wMainForm.PopupMenu.Click(c_ToConfirm)
            BuiltIn.Delay(2000)
            Call ClickCmdButton(1, "Ð³ëï³ï»É")
        Else 
            Log.Error "Տողը չի գտնվել Հաստատվող փաստաթղթեր(|) թղթապանակում" ,,,ErrorColor
        End If
        Call Close_Pttel("frmPttel")
     Else
        Log.Error "Can Not Open Հաստատվող փաստաթղթեր(|) Window",,,ErrorColor      
     End If   
     
     'SQL Ստուգում DOCS աղուսյակում
    Call CheckQueryRowCount("DOCS","fISN",CashRemainderISN,1)
    Call CheckDB_DOCS(CashRemainderISN,"CashAcRf","6",fBODY,1)
    
    'SQL Ստուգում DOCLOG աղուսյակում 
    Call CheckQueryRowCount("DOCLOG","fISN",CashRemainderISN,6)
    Call CheckDB_DOCLOG(CashRemainderISN,"77","W","102"," ",1)
    Call CheckDB_DOCLOG(CashRemainderISN,"77","T","102"," ",1)
    Call CheckDB_DOCLOG(CashRemainderISN,"77","C","6"," ",1)
    
    'SQL Ստուգում FOLDERS աղուսյակում 
    Call CheckQueryRowCount("FOLDERS","fISN",CashRemainderISN,0) 
    
    'SQL Ստուգում HI2 աղուսյակում 
    Call CheckQueryRowCount("HI2","fBASE",CashRemainderISN,1)
    Call CheckDB_HI2(dbHI2(1),1)
    
    'SQL Ստուգում HIREST2 աղուսյակում 
    Call CheckDB_HIREST2("10","737994605","1578250","0.00","001","650000.55", 1)

    'SQL Ստուգում MEMORDERS աղուսյակում  
    Call CheckDB_MEMORDERS(CashRemainderISN,"CashAcRf","1","2020-01-01","6","650000.55","001",1)

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''-- Հաշիվներ թղթապանակից կատարել "Կանխիկ ելք" գործողությունը --'''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "-- Հաշիվներ թղթապանակից կատարել Կանխիկ ելք գործողությունը --" ,,, DivideColor 
    
    Call OpenAccauntsFolder("|¶ÉË³íáñ Ñ³ßí³å³ÑÇ ²Þî|Ð³ßÇíÝ»ñ","1","","00067860101","","","","","","",1,"","","","","",1,1,1,"","","","","","ACCS","0")
    Call CheckPttel_RowCount("frmPttel", 1)            
                                                  
    Call wMainForm.MainMenu.Click(c_AllActions)
    Call wMainForm.PopupMenu.Click(c_InnerOpers &"|"& c_CashOut)             
    
    Set CashOutObject = New_CashOut   
    With CashOutObject
        .DocNum = ""
        .Date = "020220"
        .Amount = "1155000.18"
        .CashLabel = "051"
        .Base = "Ð³Ù³Ó³ÛÝ å³ÛÙ³Ý³·ñÇ"
        .Aim = "Ð³Ù³Ó³ÛÝ Ã. Ñ³ßíÇ"
        .Depositor = "00000678"
        .FirstName = "master"
        .LastName = "1_²ÝáõÝ_²ÝáõÝ_²ÝáõÝ_²ÝáõÝ_²ÝáõÝ_²ÝáõÝ_²ÝáõÝ_²ÝáõÝ_²ÝáõÝ_²ÝáõÝ_²ÝáõÝ_22"
        .IdNumber = "AP125485124"
        .IdType = "01"
        .Issued = "005"
        .IssuedDate = "010103"
        .DateOfExpire = "010126"
        .DateOfBirth = "260797"
        .Citizenship = "1"
        .Country = "AM"
        .Community = "010010130"
        .City   = "Yerevan"
        .Flat  = "1212112111"
        .Street = "Mikoyan_Mikoyan_Mikoyan_Mikoyan_Mikoyan_Mikoyan_Mikoyan_Mikoyan_Mikoyan1"
        .House = "1222222222"
        .Email = "1aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa@mail.ru"
        .ChargesAccount = "00067860100"
        .Curr = "000"
        .ChargeType = "01"
        .ChargesAmount = "201,999.80"
        .Interest = "0.1000"
        .IncomeAccount = "000919400"
        .NonChargeableAmount = "650,000.55"
        .NonResident = 0
        .Comment = ""
        .CliAgrDetails = "Clients_Agreement_Clients_Agreement_Clients_Agre_1"
        .SubAmount = "111.01"
        .SubAmountToBePaid = "37,743.40"
        .AmountInPrimaryCurr = "1,154,889.17"
    End With 
    CashOutIsn = Fill_CashOut(CashOutObject)
    
    'Եթե քաղվածքի պատուհանը հայտնվել է, ապա փակում է
    If wMDIClient.VBObject("FrmSpr").Exists Then
        wMDIClient.VBObject("FrmSpr").Close
    Else
        Log.Error "Statement window doesn't exist!",,,ErrorColor
    End If
    Call Close_Pttel("frmPttel")

    Log.Message "DocNum = " & CashOutObject.DocNum,,,DivideColor2    
    Log.Message "fISN = " & CashOutIsn ,,,SqlDivideColor
    
     Call SQL_Initialize_Cash_Accounting_ByAccount(CashOutIsn)
     
    dbFOLDERS(3).fSPEC = "²Ùë³ÃÇí- 02/02/20 N- "&CashOutObject.DocNum&" ¶áõÙ³ñ-         1,155,000.18 ²ñÅ.- 001 [Üáñ]"
    dbFOLDERS(4).fSPEC = CashOutObject.DocNum&"777000006786010177700000001101        1155000.18001Üáñ                                                   77master 1_²ÝáõÝ_²ÝáõÝ_²ÝáõÝ_²ÝáõÝAP125485124 005 01/01/2003                             Ð        Ð³Ù³Ó³ÛÝ Ã. Ñ³ßíÇ Ð³Ù³Ó³ÛÝ å³ÛÙ³Ý³·ñÇ                                                                                                       "
        
    'SQL Ստուգում DOCS աղուսյակում
    fBODY = "  ACSBRANCH:00  ACSDEPART:1  BLREP:0  OPERTYPE:MSC  TYPECODE:-20 21 22 23 24 30 31 32 25 26 92 93 11 27 33 28  USERID:  77  DOCNUM:"&CashOutObject.DocNum&"  DATE:20200202  ACCDB:00067860101  CUR:001  KASSA:001  ACCCR:000001101  SUMMA:1155000.18  KASSIMV:051  BASE:Ð³Ù³Ó³ÛÝ å³ÛÙ³Ý³·ñÇ  AIM:Ð³Ù³Ó³ÛÝ Ã. Ñ³ßíÇ  CLICODE:00000678  RECEIVER:master  RECEIVERLASTNAME:1_²ÝáõÝ_²ÝáõÝ_²ÝáõÝ_²ÝáõÝ_²ÝáõÝ_²ÝáõÝ_²ÝáõÝ_²ÝáõÝ_²ÝáõÝ_²ÝáõÝ_²ÝáõÝ_22  PASSNUM:AP125485124  PASBY:005  DATEPASS:20030101  DATEEXPIRE:20260101  DATEBIRTH:19970726  CITIZENSHIP:1  COUNTRY:AM  COMMUNITY:010010130  CITY:Yerevan  APARTMENT:1212112111  ADDRESS:Mikoyan_Mikoyan_Mikoyan_Mikoyan_Mikoyan_Mikoyan_Mikoyan_Mikoyan_Mikoyan1  BUILDNUM:1222222222  EMAIL:1aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa@mail.ru  FROMPAYORD:0  ACSBRANCHINC:00  ACSDEPARTINC:1  CHRGACC:00067860100  TYPECODE2:-20 21 22 23 24 30 31 32 25 26 92 93 11 27 33 28  CHRGCUR:000  CHRGCBCRS:1/1  PAYSCALE:01  CHRGSUM:201999.8  PRSNT:0.1  CHRGINC:000919400  NOCRGSUM:650000.55  FRSHNOCRG:0  CURTES:1  CURVAIR:3  VOLORT:9X  NONREZ:0  JURSTAT:11  COMM:¶³ÝÓáõÙ Ï³ÝËÇÏ³óáõÙÇó  AGRDETAILS:Clients_Agreement_Clients_Agreement_Clients_Agre_1  PAYSYSIN:Ð  XSUM:111.01  XCUR:000  XACC:000001100  XDLCRS:   340.0000/    1  XDLCRSNAME:000 / 001  XCBCRS:400.0000/1  XCBCRSNAME:000 / 001  XCUPUSA:1  XCURSUM:37743.4  XSUMMAIN:1154889.17  XINC:000931900  XEXP:001434300  NOTSENDABLE:0  "
    fBODY = Replace(fBODY, "  ", "%")
    Call CheckQueryRowCount("DOCS","fISN",CashOutIsn,1)
    Call CheckDB_DOCS(CashOutIsn,"KasRsOrd","2",fBODY,1)
    
    'SQL Ստուգում DOCLOG աղուսյակում 
    Call CheckQueryRowCount("DOCLOG","fISN",CashOutIsn,2)
    Call CheckDB_DOCLOG(CashOutIsn,"77","N","1"," ",1)
    Call CheckDB_DOCLOG(CashOutIsn,"77","C","2"," ",1)
    
    'SQL Ստուգում FOLDERS աղուսյակում 
    Call CheckQueryRowCount("FOLDERS","fISN",CashOutIsn,2)
    Call CheckDB_FOLDERS(dbFOLDERS(3),1)
    Call CheckDB_FOLDERS(dbFOLDERS(4),1)
    
    'SQL Ստուգում HI աղուսյակում  
    Call CheckQueryRowCount("HI","fBASE",CashOutIsn,8)
    Call Check_HI_CE_accounting ("20200202",CashOutIsn, "11", "1630171","461955668.00", "001", "1154889.17", "MSC", "C")
    Call Check_HI_CE_accounting ("20200202",CashOutIsn, "11", "1088614277","461955668.00", "001", "1154889.17", "MSC", "D")
    
    Call Check_HI_CE_accounting ("20200202",CashOutIsn, "11", "1630171","461955668.00", "001", "1154889.17", "MSC", "C")
    Call Check_HI_CE_accounting ("20200202",CashOutIsn, "11", "1088614277","6660.60", "001", "0.00", "MSC", "D")
    
    Call Check_HI_CE_accounting ("20200202",CashOutIsn, "11", "1630170","37743.40", "000", "37743.40", "CEX", "C")
    Call Check_HI_CE_accounting ("20200202",CashOutIsn, "11", "1088614277","37743.40", "001", "111.01", "CEX", "D")
    
    Call Check_HI_CE_accounting ("20200202",CashOutIsn, "11", "1630420","201999.80", "000", "201999.80", "FEE", "C")
    Call Check_HI_CE_accounting ("20200202",CashOutIsn, "11", "175652599","201999.80", "000", "201999.80", "FEE", "D")
    
    'SQL Ստուգում HI2 աղուսյակում 
    dbHI2(1).fDATE = "2020-02-02"
    dbHI2(1).fDBCR = "C"
    Call CheckQueryRowCount("HI2","fBASE",CashRemainderISN,1)
    Call CheckDB_HI2(dbHI2(1),1)

    'SQL Ստուգում HIREST  աղուսյակում  
    Call CheckDB_HIREST("11", "1630171","600864234.50","001","1114673.19",1)
    Call CheckDB_HIREST("11", "1088614277","462000072.00","001","1155000.18",1)
    Call CheckDB_HIREST("11", "175652599","201999.80","000","201999.80",1)    

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''-- "Աշխատանքային փաստաթղթեր" թղթապանակից Կանխիկ ելք փաստաթուղթը "Ուղարկել հաստատման" --'''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "-- Աշխատանքային փաստաթղթեր թղթապանակից Կանխիկ ելք փաստաթուղթը Ուղարկել հաստատման --",,,DivideColor       
    
    Call ToCountPayment(c_SendToVer,"020220") 
    
    'SQL Ստուգում DOCS աղուսյակում
    Call CheckQueryRowCount("DOCS","fISN",CashOutIsn,1)
    Call CheckDB_DOCS(CashOutIsn,"KasRsOrd","101",fBODY,1)
    
    'SQL Ստուգում DOCLOG աղուսյակում 
    Call CheckQueryRowCount("DOCLOG","fISN",CashOutIsn,3)
    
    'SQL Ստուգում FOLDERS աղուսյակում
    dbFOLDERS(3).fSTATUS = "0"
    dbFOLDERS(3).fSPEC = "²Ùë³ÃÇí- 02/02/20 N- "&CashOutObject.DocNum&" ¶áõÙ³ñ-         1,155,000.18 ²ñÅ.- 001 [àõÕ³ñÏí³Í I Ñ³ëï³ïÙ³Ý]"
    dbFOLDERS(4).fSTATUS = "0"
    dbFOLDERS(4).fSPEC = CashOutObject.DocNum & "777000006786010177700000001101        1155000.18001àõÕ³ñÏí³Í I Ñ³ëï³ïÙ³Ý                                 77master 1_²ÝáõÝ_²ÝáõÝ_²ÝáõÝ_²ÝáõÝAP125485124 005 01/01/2003      001                    Ð        Ð³Ù³Ó³ÛÝ Ã. Ñ³ßíÇ Ð³Ù³Ó³ÛÝ å³ÛÙ³Ý³·ñÇ                                                                                                       "
    dbFOLDERS(5).fSPEC = CashOutObject.DocNum & "777000006786010177700000001101        1155000.18001  77Ð³Ù³Ó³ÛÝ Ã. Ñ³ßíÇ               Ð³Ù³Ó³ÛÝ å³ÛÙ³Ý³·ñÇ             master 1_²ÝáõÝ_²ÝáõÝ_²ÝáõÝ_²ÝáõÝ       Ð"
    
    Call CheckQueryRowCount("FOLDERS","fISN",CashOutIsn,3)
    Call CheckDB_FOLDERS(dbFOLDERS(3),1)
    Call CheckDB_FOLDERS(dbFOLDERS(4),1)
    Call CheckDB_FOLDERS(dbFOLDERS(5),1)
    
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''-- Գլխավոր հաշվապահ/Հաստատվող փաստաթղթեր(|) թղթապանակից կատարել "Վավերացնել" գործողությունը --''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "-- Կատարել Վավերացնել գործողությունը --",,,DivideColor   

    Set VerificationDoc = New_VerificationDocument()
        VerificationDoc.DocType = "KasRsOrd"
    
    Call GoToVerificationDocument("|¶ÉË³íáñ Ñ³ßí³å³ÑÇ ²Þî|ÂÕÃ³å³Ý³ÏÝ»ñ|Ð³ëï³ïíáÕ ÷³ëï³ÃÕÃ»ñ (I)",VerificationDoc) 
    
    If WaitForPttel("frmPttel") Then
        If SearchInPttel("frmPttel",7, "1155000.18") Then
            Call wMainForm.MainMenu.Click(c_AllActions)
            Call wMainForm.PopupMenu.Click(c_ToConfirm)
            BuiltIn.Delay(2000)
            Call ClickCmdButton(1, "Ð³ëï³ï»É")
        Else 
            Log.Error "Տողը չի գտնվել Հաստատվող փաստաթղթեր(|) թղթապանակում" ,,,ErrorColor
        End If
        Call Close_Pttel("frmPttel")
     Else
        Log.Error "Can Not Open Հաստատվող փաստաթղթեր(|) Window",,,ErrorColor      
     End If 
     
    'SQL Ստուգում DOCS աղուսյակում
    Call CheckQueryRowCount("DOCS","fISN",CashOutIsn,1)
    Call CheckDB_DOCS(CashOutIsn,"KasRsOrd","14",fBODY,1)
    
    'SQL Ստուգում DOCLOG աղուսյակում 
    Call CheckQueryRowCount("DOCLOG","fISN",CashOutIsn,5)
    Call CheckDB_DOCLOG(CashOutIsn,"77","W","102","",1)
    Call CheckDB_DOCLOG(CashOutIsn,"77","M","14","¶ñ³Ýóí»É »Ý Ó¨³Ï»ñåáõÙÝ»ñÁ",1)
    
    'SQL Ստուգում FOLDERS աղուսյակում
    Call CheckQueryRowCount("FOLDERS","fISN",CashOutIsn,0)

    'SQL Ստուգում HI աղուսյակում  
    Call CheckQueryRowCount("HI","fBASE",CashOutIsn,9)
    Call Check_HI_CE_accounting ("20200202",CashOutIsn, "01", "1630171","461955668.00", "001", "1154889.17", "MSC", "C")
    Call Check_HI_CE_accounting ("20200202",CashOutIsn, "01", "1088614277","461955668.00", "001", "1154889.17", "MSC", "D")
    Call Check_HI_CE_accounting ("20200202",CashOutIsn, "01", "1629177","6660.60", "000", "6660.60", "MSC", "C")
    Call Check_HI_CE_accounting ("20200202",CashOutIsn, "01", "1088614277","6660.60", "001", "0.00", "MSC", "D")
    Call Check_HI_CE_accounting ("20200202",CashOutIsn, "01", "1630170","37743.40", "000", "37743.40", "CEX", "C")
    Call Check_HI_CE_accounting ("20200202",CashOutIsn, "01", "1088614277","37743.40", "001", "111.01", "CEX", "D")
    Call Check_HI_CE_accounting ("20200202",CashOutIsn, "CE", "1578250","37743.40", "001", "111.01", "PUR", "D")
    
    'SQL Ստուգում HIREST  աղուսյակում  
    Call CheckDB_HIREST("01", "1630171","3993338317.90","001","9471369.61",1)
    Call CheckDB_HIREST("01", "1088614277","-166939428.00","001","-342474.82",1)
    Call CheckDB_HIREST("01", "175652599","-22184900.20","000","-22184900.20",1)    
     
    'SQL Ստուգում PAYMENTS աղուսյակում  
    Call CheckQueryRowCount("PAYMENTS","fISN",CashOutIsn,1)
     
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''-"Հաշվառված վճարային փաստաթղթերից" հեռացնել "Կանխիք ելք" և "Կանխիկ մնացորդի ճշտում" գործողությունները-'''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "--Հեռացնել Կանխիք ելք և Կանխիկ մնացորդի ճշտում գործողությունները --",,,DivideColor     
    
    wTreeView.DblClickItem("|¶ÉË³íáñ Ñ³ßí³å³ÑÇ ²Þî|ÂÕÃ³å³Ý³ÏÝ»ñ|Ð³ßí³éí³Í í×³ñ³ÛÇÝ ÷³ëï³ÃÕÃ»ñ")
    'Լրացնել "Ամսաթիվ" դաշտը
    Call Rekvizit_Fill("Dialog",1,"General","PERN", "010120")
    Call Rekvizit_Fill("Dialog",1,"General","PERK", "010121")
    Call ClickCmdButton(2, "Î³ï³ñ»É")
    
    If WaitForPttel("frmPttel") Then
        Call SearchAndDelete("frmPttel", 1, "Î³ÝËÇÏ »Éù", "Ð³ëï³ï»ù ÷³ëï³ÃÕÃÇ çÝç»ÉÁ") 
        BuiltIn.Delay(2000)
        Call SearchAndDelete("frmPttel", 1, "Î³ÝËÇÏ ÙÝ³óáñ¹Ç ×ßïáõÙ", "Ð³ëï³ï»ù ÷³ëï³ÃÕÃÇ çÝç»ÉÁ") 
        BuiltIn.Delay(2000)
        Call Close_Pttel("frmPttel")
     Else
        Log.Error "Can Not Open Հաշվառված վճարային փաստաթղթեր Window",,,ErrorColor      
     End If     
     
    'SQL Ստուգում DOCS աղուսյակում
    Call CheckDB_DOCS(CashOutIsn,"KasRsOrd","999",fBODY,1)
    
    fBODY = "  ACSBRANCH:00  ACSDEPART:1  USERID:  77  DATE:20200101  CLICODE:00000678  CUR:001  OPTP:1  SUMMA:650000.55  COMM:1CashRemainderRefining97  "
    fBODY = Replace(fBODY, "  ", "%")
    Call CheckQueryRowCount("DOCS","fISN",CashRemainderISN,1)
    Call CheckDB_DOCS(CashRemainderISN,"CashAcRf","999",fBODY,1)
    
    
    Call Close_AsBank()            
End Sub  


Sub SQL_Initialize_Cash_Accounting_ByAccount(fISN)

    Set dbFOLDERS(1) = New_DB_FOLDERS()
    With dbFOLDERS(1)
        .fFOLDERID = "Oper.20200101"
        .fNAME = "CashAcRf"
        .fKEY = fISN
        .fISN = fISN
        .fSTATUS = "1"
        .fCOM = "Î³ÝËÇÏ ÙÝ³óáñ¹Ç ×ßïáõÙ"
        .fSPEC = "                                             650000.55001Üáñ                                                   77                                                                                                1CashRemainderRefining97                                                                                                                    "
        .fECOM = "Cash Remainder Refining"
        .fDCBRANCH = "00"
        .fDCDEPART = "1"
    End With 

    Set dbFOLDERS(2) = New_DB_FOLDERS()
    With dbFOLDERS(2)
        .fFOLDERID = "Ver.20200101001"
        .fNAME = "CashAcRf"
        .fKEY = fISN
        .fISN = fISN
        .fSTATUS = "4"
        .fCOM = "Î³ÝËÇÏ ÙÝ³óáñ¹Ç ×ßïáõÙ"
        .fSPEC = "                                             650000.55001  771CashRemainderRefining97        "
        .fECOM = "Cash Remainder Refining"
        .fDCBRANCH = "00"
        .fDCDEPART = "1"
    End With  
    
    Set dbFOLDERS(3) = New_DB_FOLDERS()
    With dbFOLDERS(3)
        .fFOLDERID = "C.737994605"
        .fNAME = "KasRsOrd"
        .fKEY = fISN
        .fISN = fISN
        .fSTATUS = "5"
        .fCOM = "Î³ÝËÇÏ »Éù"
        .fSPEC = "²Ùë³ÃÇí- 02/02/20 N- 000898 ¶áõÙ³ñ-         1,155,000.18 ²ñÅ.- 001 [Üáñ]"
        .fECOM = "Cash Withdrawal Advice"
    End With  
    Set dbFOLDERS(4) = New_DB_FOLDERS()
    With dbFOLDERS(4)
        .fFOLDERID = "Oper.20200202"
        .fNAME = "KasRsOrd"
        .fKEY = fISN
        .fISN = fISN
        .fSTATUS = "5"
        .fCOM = "Î³ÝËÇÏ »Éù"
        .fSPEC = "000898777000006786010177700000001101        1155000.18001Üáñ                                                   77master 1_²ÝáõÝ_²ÝáõÝ_²ÝáõÝ_²ÝáõÝAP125485124 005 01/01/2003                             Ð        Ð³Ù³Ó³ÛÝ Ã. Ñ³ßíÇ Ð³Ù³Ó³ÛÝ å³ÛÙ³Ý³·ñÇ                                                                                                       "
        .fECOM = "Cash Withdrawal Advice"
        .fDCBRANCH = "00"
        .fDCDEPART = "1"
    End With  
    
    Set dbFOLDERS(5) = New_DB_FOLDERS()
    With dbFOLDERS(5)
        .fFOLDERID = "Ver.20200202001"
        .fNAME = "KasRsOrd"
        .fKEY = fISN
        .fISN = fISN
        .fSTATUS = "4"
        .fCOM = "Î³ÝËÇÏ »Éù"
        .fSPEC = "000868777000006786010177700000001101        1155000.18001  77Ð³Ù³Ó³ÛÝ Ã. Ñ³ßíÇ               Ð³Ù³Ó³ÛÝ å³ÛÙ³Ý³·ñÇ             master 1_²ÝáõÝ_²ÝáõÝ_²ÝáõÝ_²ÝáõÝ       Ð"
        .fECOM = "Cash Withdrawal Advice"
        .fDCBRANCH = "00"
        .fDCDEPART = "1"
    End With 
    
    Set dbHI2(1) = New_DB_HI2()
    With dbHI2(1)
        .fDATE = "2020-01-01"
        .fTYPE = "10"
        .fOBJECT = "737994605"
        .fGLACC = "1578250"
        .fSUM = "0.00"
        .fCUR = "001"
        .fCURSUM = "650000.55"
        .fOP = "MSC"
        .fBASE = fISN
        .fDBCR = "D"
    End With
    
    Set dbHI2(2) = New_DB_HI2()
    With dbHI2(2)
        .fDATE = "2020-02-02"
        .fTYPE = "10"
        .fOBJECT = "737994605"
        .fGLACC = "1578250"
        .fSUM = "0.00"
        .fCUR = "001"
        .fCURSUM = "650000.55"
        .fOP = "MSC"
        .fBASE = fISN
        .fDBCR = "D"
    End With
End Sub