'USEUNIT Library_Common
'USEUNIT Library_Colour
'USEUNIT Library_CheckDB
'USEUNIT Mortgage_Library
'USEUNIT Library_Contracts
'USEUNIT Card_Library
'USEUNIT Loan_Agreements_Library 
'USEUNIT Akreditiv_Library
'USEUNIT CashInput_Confirmphases_Library
'USEUNIT Main_Accountant_Filter_Library
'USEUNIT Deposit_Contract_Library
'USEUNIT Payment_Order_ConfirmPhases_Library

'USEUNIT Constants
Option Explicit

'Test Case Id - 174825

Dim DepositContract
Dim dbCONTRACTS,dbFOLDERS(2)

Sub Cash_Accounting_ByDeposit()
  
    Dim sDATE,eDATE
    Dim Acc,FolderName,CashIn,CashInIsn
    Dim VerificationDoc,CashAccountingFilter,verifyFilter1
    Dim fBASE,fBODY
    
    'Համակարգ մուտք գործել ARMSOFT օգտագործողով
    sDATE = "20030101"
    eDATE = "20260101"
    Call Initialize_AsBank("bank", sDATE, eDATE)
    Login("ARMSOFT")

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''-- Կարգավորումներում կատարել համապատասխան փոփոխությունները կանխիկ հաշվառման համար --''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "-- Կարգավորումներում կատարել համապատասխան փոփոխությունները կանխիկ հաշվառման համար --" ,,, DivideColor      
    
    'Մուտք գործել "Ենթահամակրգեր(ՀԾ)"
    Call ChangeWorkspace(c_Subsystems)
    Call wTreeView.DblClickItem("|ºÝÃ³Ñ³Ù³Ï³ñ·»ñ (§ÐÌ¦)|²¹ÙÇÝÇëïñ³ïÇí Ù³ë|Î³ñ·³íáñáõÙÝ»ñ ¨ ¹ñáõÛÃÝ»ñ|²ÝÏ³ÝËÇÏ ·áñÍ³ñùÝ»ñÇó Ï³ÝËÇÏÇ Ñ³ßí³éÙ³Ý ¹ñáõÛÃÝ»ñ|²í³Ý¹Ý»ñ (Ý»ñ·ñ³íí³Í)")
    BuiltIn.Delay(2000)
    With wMDIClient.VBObject("frmASDocForm").VBObject("TabFrame").VBObject("DocGrid")
      .Row = 0
      .Col = 0
      .Keys("0002")
    End With
    
    Call ClickCmdButton(1, "Î³ï³ñ»É")
    
    'SQL Ստուգում DOCSG աղուսյակում 
    Call CheckQueryRowCount("DOCSG","fISN","131889730",3)
    Call CheckDB_DOCSG("131889730","GRIDINST","0","AGRTYPE","0002",1)
    Call CheckDB_DOCSG("131889730","GRIDINST","0","ONLYCASHATTRPART","0",1)
    Call CheckDB_DOCSG("131889730","GRIDINST","0","ONLYPER","0",1)

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''-- Հաշիվներ թղթապանակից կատարել "Ավելացնել" գործողությունը --''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "-- Հաշիվներ թղթապանակից կատարել Ավելացնել գործողությունը --" ,,, DivideColor    
    
    'Մուտք Գլխավոր հաշվապահի ԱՇՏ
    Call ChangeWorkspace(c_ChiefAcc)
    
    Call wTreeView.DblClickItem("|¶ÉË³íáñ Ñ³ßí³å³ÑÇ ²Þî|Ð³ßÇíÝ»ñ") 
    BuiltIn.Delay(1000)
    'Կանխիկ հաշվառման և Բացման ամսաթիվ դաշտի լրացում
    Call Rekvizit_Fill("Dialog", 1, "CheckBox", "CASHAC", 1)
    Call Rekvizit_Fill("Dialog", 1, "General", "DATOTKN", "010120" &"[Tab]"& "010120")
    Call ClickCmdButton(2, "Î³ï³ñ»É")
    BuiltIn.Delay(2000)

    Set Acc = New_Account()
    With Acc         
      .BalanceAccount = "3022000"
      .AccountHolder = "00000678"
      .Name = ""
      .EnglishName = ""
      .RemainderType = ""
      .Curr = "000"
      .AccountType = "01"
      .OpenDate = "010120"
      .Account = ""
      .AccessType = "01"
      .CashAccounting = 1
    End With
    
    Call Create_Account(Acc)
    Log.Message "fISN = " & Acc.Isn ,,,SqlDivideColor

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''-- Հաշիվներ թղթապանակից կատարել "Կանխիկ մուտք" գործողությունը --'''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "-- Հաշիվներ թղթապանակից կատարել Կանխիկ մուտք գործողությունը --", "", pmNormal, DivideColor
    Log.Message Acc.Account
    
    Call SearchInPttel("frmPttel",0, Acc.Account)
    Call wMainForm.MainMenu.Click(c_AllActions)
    Call wMainForm.PopupMenu.Click(c_InnerOpers &"|"& c_Cashin)             
      
    Set CashIn = New_CashIn()  
    With CashIn
        .Date = "010120"
        .Amount = "100000"
        .CashLabel = "022"
        .Base = "Ð³Ù³Ó³ÛÝ å³ÛÙ³Ý³·ñÇ"
        .Aim = "Ð³Ù³Ó³ÛÝ Ã. Ñ³ßíÇ"
        .Depositor = "00000678"
        .FirstName = "master"
    End With 

    CashInIsn = Fill_CashIn(CashIn)
    
    'Եթե քաղվածքի պատուհանը հայտնվել է, ապա փակում է
    If wMDIClient.VBObject("FrmSpr").Exists Then
        wMDIClient.VBObject("FrmSpr").Close
    Else
        Log.Error "Statement window doesn't exist!",,,ErrorColor
    End If
    Call Close_Pttel("frmPttel")
    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''-- "Աշխատանքային փաստաթղթեր" թղթապանակից կատարել "Ուղարկել հաստատման" գործողությունը --'''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "-- Կատարել Ուղարկել հաստատման գործողությունը --", "", pmNormal, DivideColor     
    
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
        Call ClickCmdButton(2, "Î³ï³ñ»É")
        Call Close_Pttel("frmPttel")
    Else
        Log.Error "Can Not Open Աշխատանքային փաստաթղթեր pttel",,,ErrorColor      
    End If  

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''-- Գլխավոր հաշվապահ/Հաստատվող փաստաթղթեր(|) թղթապանակից կատարել "Վավերացնել" գործողությունը --''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "-- Կատարել Վավերացնել գործողությունը --", "", pmNormal, DivideColor

    Set VerificationDoc = New_VerificationDocument()
        VerificationDoc.DocType = "KasPrOrd"
    
    Call GoToVerificationDocument("|¶ÉË³íáñ Ñ³ßí³å³ÑÇ ²Þî|ÂÕÃ³å³Ý³ÏÝ»ñ|Ð³ëï³ïíáÕ ÷³ëï³ÃÕÃ»ñ (I)",VerificationDoc) 
    
    If WaitForPttel("frmPttel") Then
        If SearchInPttel("frmPttel",7, "100000") Then
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
     
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''-- "Աշխատանքային փաստաթղթեր" թղթապանակից կատարել "Վավերացնել" գործողությունը --'''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "-- Աշխատանքային փաստաթղթեր թղթապանակից կատարել Վավերացնել գործողությունը --",,,DivideColor       
    
    wTreeView.DblClickItem("|¶ÉË³íáñ Ñ³ßí³å³ÑÇ ²Þî|ÂÕÃ³å³Ý³ÏÝ»ñ|²ßË³ï³Ýù³ÛÇÝ ÷³ëï³ÃÕÃ»ñ") 
    'Լրացնել "Ամսաթիվ" դաշտերը
    Call Rekvizit_Fill("Dialog",1,"General","PERN", "010120")
    Call Rekvizit_Fill("Dialog",1,"General","PERK", "010120")
    Call ClickCmdButton(2, "Î³ï³ñ»É")
    
    If WaitForPttel("frmPttel") Then
        Call wMainForm.MainMenu.Click(c_AllActions)
        Call wMainForm.PopupMenu.Click(c_ToConfirm)
        BuiltIn.Delay(2000)
        Call ClickCmdButton(1, "Ð³ëï³ï»É")
        Call Close_Pttel("frmPttel")
    Else
        Log.Error "Can Not Open Աշխատանքային փաստաթղթեր pttel",,,ErrorColor
    End If   
    
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''-- Ստեղծել Ավանդային պայմանագիր --'''''''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "-- Ստեղծել Ավանդային պայմանագիր --", "", pmNormal, DivideColor
    
    'Մուտք ºÝÃ³Ñ³Ù³Ï³ñ·»ñ(ÐÌ) ԱՇՏ
    Call ChangeWorkspace(c_Subsystems)
    Call Initialize_Cash_Accounting_ByDeposit(Acc.Account)
    
    FolderName = "|ºÝÃ³Ñ³Ù³Ï³ñ·»ñ (§ÐÌ¦)|ä³ÛÙ³Ý³·ñ»ñ|Ü»ñ·ñ³íí³Í ÙÇçáóÝ»ñ|²í³Ý¹Ý»ñ (Ý»ñ·ñ³íí³Í)|"
    Call CreateNewDepositContract(FolderName, "¸³ï³ñÏ å³ÛÙ³Ý³·Çñ", "²í³Ý¹³ÛÇÝ å³ÛÙ³Ý³·Çñ", DepositContract)
    Log.Message DepositContract.Isn,,,SqlDivideColor
    
    Call PaySys_Send_To_Verify()
    BuiltIn.Delay(2000)
  	Call Close_Pttel("frmPttel")
  
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''-- Ð³ëï³ï»É Ավանդային å³ÛÙ³Ý³·ÇñÁ --''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "-- Հաստատել Ավանդային պայմանագիրը --", "", pmNormal, DivideColor

    Set verifyFilter1 = New_VerifyContract()
        verifyFilter1.AgreementN = DepositContract.general.agreementN
    
    Call Verify_Contract(FolderName & "Ð³ëï³ïíáÕ ÷³ëï³ÃÕÃ»ñ I", verifyFilter1) 
    Call DB_Initialize_ForDeposit(DepositContract.Isn,DepositContract.general.agreementN)
    
    'SQL Ստուգում DOCS աղուսյակում
    fBODY = "  CODE:"&DepositContract.general.agreementN&"  AGRTYPE:0002  CLICOD:00000678  NAME:KERAMIKA Ê³ã³ïãÛ³Ý ìÉ³¹»Ý ì³ÝÇÏÇ  CURRENCY:000  ACCACC:"&Acc.Account&"  ACCACCPR:"&Acc.Account&"  SUMMA:90000  CHRGFIRSTDAY:0  AUTOCAP:0  AUTODEBT:1  AUTOPROLONG:1  DATE:20211026  ACSBRANCH:01  ACSDEPART:1  ACSTYPE:D10  KINDSCALE:1  PCAGR:10/365  WITHSCALE:0  DONOTCALCPCBASE:0  PCNOCHOOSE:0/1  PCBREAK:0.5000/365  PAYPERGIVE:0  PCNDERAUTO:0  PCPENAGR:0.0000/1  PCPENPER:0.0000/1  DATEGIVE:20211027  DATEAGR:20220426  AUTODATE:0  SECTOR:U2  SCHEDULE:AtlanticAG/EXPIMP  LRDISTR:001  REPAYADVANCE:100  PPRCODE:221  CONSTPER:0  DLVSTMVIEW:3  PERIODICITY:1/4  DATEDIFF:3  NONWORKDAYS:1  "
    fBODY = Replace(fBODY, "  ", "%")
    Call CheckQueryRowCount("DOCS", "fISN", DepositContract.Isn, 1)
    Call CheckDB_DOCS(DepositContract.Isn, "D1AS21  ", "7", fBODY, 1)
  
    'SQL Ստուգում DOCP աղուսյակում
    Call CheckDB_DOCP(Acc.Isn, "Acc", DepositContract.Isn, 1)
  
    'SQL Ստուգում FOLDERS աղուսյակում
    Call CheckQueryRowCount("FOLDERS", "fISN", DepositContract.Isn, 2)
    Call CheckDB_FOLDERS(dbFOLDERS(1),1)
    Call CheckDB_FOLDERS(dbFOLDERS(2),1)
  
    'SQL Ստուգում RESNUMBERS աղուսյակում
    Call CheckQueryRowCount("RESNUMBERS", "fISN", DepositContract.Isn, 1)
    Call CheckDB_RESNUMBERS(DepositContract.Isn, "D", DepositContract.general.agreementN, 1)
    
    'SQL Ստուգում DAGRACCS աղուսյակում
    Call CheckQueryRowCount("DAGRACCS","fAGRISN",DepositContract.Isn,1)
    
    'SQL Ստուգում HIF աղուսյակում
    Call CheckQueryRowCount("HIF","fBASE",DepositContract.Isn,20)
    
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''''''''''-- Ավանդի ներգրավում --''''''''''''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "-- Ավանդի ներգրավում --", "", pmNormal, DivideColor    

    Call LetterOfCredit_Filter_Fill(FolderName, 1, DepositContract.general.agreementN)
    Call Deposit_Involvment(fBASE, DepositContract.general.agreementN, "27/10/21", DepositContract.general.amount, 2, DepositContract.general.settlementAccount)

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''''''''''-- Պարտքերի մարում --''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "-- Պարտքերի մարում --", "", pmNormal, DivideColor    

    Call Debt_Repayment(fBASE,"271021", "25000","","2",Acc.Account,"",2)
    Call Close_Pttel("frmPttel")

    Log.Message fBASE,,,SqlDivideColor
    
    'SQL Ստուգում DOCS աղուսյակում
    fBODY = "  CODE:"&DepositContract.general.agreementN&"  DATE:20211027  CORROFFPER:0  AMDSUMDBT:25000  SUMAGR:25000  NOTAXEDSUM:25000  SUMMA:25000  CASHORNO:2  ISPUSA:0  ACCCORR:"&Acc.Account&"  COMMENT:²í³Ý¹Ç å³ñïù»ñÇ í×³ñáõÙ  ACSBRANCH:00  ACSDEPART:1  ACSTYPE:D10  USERID:  77  "
    fBODY = Replace(fBODY, "  ", "%")
    Call CheckQueryRowCount("DOCS", "fISN", fBASE, 1)
    Call CheckDB_DOCS(fBASE, "D1DSDebt", "5", fBODY, 1)
    
    'SQL Ստուգում HIR աղուսյակում
    Call CheckQueryRowCount("HIR","fBASE",fBASE,1)
    Call Check_HIR("2021-10-27", "R1", DepositContract.Isn, "000", "25000.00", "DBT", "C")
          
    'SQL Ստուգում HIREST  աղուսյակում  
    Call CheckDB_HIREST("01", Acc.Isn,"-35000.00","000","-35000.00",1)

    'SQL Ստուգում HIRREST  աղուսյակում
    Call CheckQueryRowCount("HIRREST","fOBJECT",DepositContract.Isn,1)
    Call CheckDB_HIRREST("R1",DepositContract.Isn,"65000.00","2021-10-27",1)
    
    'SQL Ստուգում HIREST2 աղուսյակում 
    Call CheckDB_HIREST2("10","737994605","1559631","0.00","000","125000.00", 1)
    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''-- Կանխիկ միջոցների հաշվառում թղթապանակում ստուգել Մնացորդը --''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "-- Կանխիկ միջոցների հաշվառում թղթապանակում ստուգել Մնացորդը --" ,,, DivideColor 
    
    'Մուտք Գլխավոր հաշվապահի ԱՇՏ
    Call ChangeWorkspace(c_ChiefAcc)
    
    Set CashAccountingFilter = New_CashAccounting()
    With CashAccountingFilter
      .ClientCode = "00000678"
      .Curr = "000"
    End With
    Call GoTo_CashAccounting(CashAccountingFilter)     
    
    Call CompareFieldValue("frmPttel", "FKEY", "00000678")
    Call CompareFieldValue("frmPttel", "FCUR", "000")   
    Call CompareFieldValue("frmPttel", "SUM", "125,000.00")   
    Call CompareFieldValue("frmPttel", "FCOM", "KERAMIKA Ê³ã³ïãÛ³Ý ìÉ³¹»Ý ì³ÝÇÏÇ")
    Call Close_Pttel("frmPttel")
    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''-- Գործողությունների դիտում թղթապանակից հեռացնել Ավանդի մարում գործողությունը --''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "-- Գործողությունների դիտում թղթապանակից հեռացնել Ավանդի մարում գործողությունը --", "", pmNormal, DivideColor   

    Call ChangeWorkspace(c_Subsystems) 
    Call LetterOfCredit_Filter_Fill(FolderName, 1, DepositContract.general.agreementN)
    Call Delete_Actions("010920","010122",False,"",c_OpersView)
    
    'SQL Ստուգում HIREST2 աղուսյակում 
    Call CheckDB_HIREST2("10","737994605","1559631","0.00","000","100000.00", 1)
     
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''''''-- հեռացնել Ավանդային å³ÛÙ³Ý³·ÇñÁ --''''''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "-- հեռացնել Ավանդային å³ÛÙ³Ý³·ÇñÁ --", "", pmNormal, DivideColor      
    
    Call SearchAndDelete("frmPttel", 0, DepositContract.general.agreementN, "Ð³ëï³ï»ù ÷³ëï³ÃÕÃÇ çÝç»ÉÁ") 
    Call Close_Pttel("frmPttel")
    
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''''-- Հեռացնել Կարգավորումները --''''''''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "-- Հեռացնել Կարգավորումները --" ,,, DivideColor     
        
    Call wTreeView.DblClickItem("|ºÝÃ³Ñ³Ù³Ï³ñ·»ñ (§ÐÌ¦)|²¹ÙÇÝÇëïñ³ïÇí Ù³ë|Î³ñ·³íáñáõÙÝ»ñ ¨ ¹ñáõÛÃÝ»ñ|²ÝÏ³ÝËÇÏ ·áñÍ³ñùÝ»ñÇó Ï³ÝËÇÏÇ Ñ³ßí³éÙ³Ý ¹ñáõÛÃÝ»ñ|²í³Ý¹Ý»ñ (Ý»ñ·ñ³íí³Í)")
    BuiltIn.Delay(2000)
    With wMDIClient.VBObject("frmASDocForm").VBObject("TabFrame").VBObject("DocGrid")
      .Row = 0
      .Col = 0
      .Keys("^A[Del]")
    End With
    
    Call ClickCmdButton(1, "Î³ï³ñ»É")    
    
     'SQL Ստուգում DOCSG աղուսյակում 
    Call CheckQueryRowCount("DOCSG","fISN","131889730",0)
    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''-"Հաշվառված վճարային փաստաթղթերից" հեռացնել "Կանխիք մուտք" գործողությունները-'''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "--Հեռացնել Կանխիք մուտք գործողություննը --",,,DivideColor     
    
    Call ChangeWorkspace(c_ChiefAcc)
    wTreeView.DblClickItem("|¶ÉË³íáñ Ñ³ßí³å³ÑÇ ²Þî|ÂÕÃ³å³Ý³ÏÝ»ñ|Ð³ßí³éí³Í í×³ñ³ÛÇÝ ÷³ëï³ÃÕÃ»ñ")
    'Լրացնել "Ամսաթիվ" դաշտը
    Call Rekvizit_Fill("Dialog",1,"General","PERN", "010120")
    Call Rekvizit_Fill("Dialog",1,"General","PERK", "020220")
    Call ClickCmdButton(2, "Î³ï³ñ»É")
    
    If WaitForPttel("frmPttel") Then
        Call SearchAndDelete("frmPttel", 1, "Î³ÝËÇÏ Ùáõïù", "Ð³ëï³ï»ù ÷³ëï³ÃÕÃÇ çÝç»ÉÁ") 
        BuiltIn.Delay(2000)
        Call Close_Pttel("frmPttel")
     Else
        Log.Error "Can Not Open Հաշվառված վճարային փաստաթղթեր Window",,,ErrorColor      
     End If     
     
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''-- "Հաշիվներ" թղթապանակից հեռացնել ստաղծված հաշիվը --''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "-- Հաշիվներ թղթապանակից հեռացնել ստաղծված հաշիվը --",,,DivideColor     
    
    Call wTreeView.DblClickItem("|¶ÉË³íáñ Ñ³ßí³å³ÑÇ ²Þî|Ð³ßÇíÝ»ñ") 
    BuiltIn.Delay(1000)
    'Կանխիկ հաշվառման և Բացման ամսաթիվ դաշտի լրացում
    Call Rekvizit_Fill("Dialog", 1, "CheckBox", "CASHAC", 1)
    Call ClickCmdButton(2, "Î³ï³ñ»É")
    BuiltIn.Delay(2000)
    
    If WaitForPttel("frmPttel") Then
        Call SearchAndDelete("frmPttel", 1, Acc.Account, "Ð³ëï³ï»ù ÷³ëï³ÃÕÃÇ çÝç»ÉÁ") 
        BuiltIn.Delay(2000)
        Call Close_Pttel("frmPttel")
     Else
        Log.Error "Can Not Open Հաշիվներ Window",,,ErrorColor      
     End If   
    
    Call Close_AsBank()  
End Sub  

Sub Initialize_Cash_Accounting_ByDeposit(Account)
  
  Set DepositContract = New_OneTimeDeposit()
  With DepositContract
      .general.agreementN = ""
      .general.templateN = "0002"
      .general.client = "00000678"
      .general.thirdPerson = ""
      .general.expName = "KERAMIKA Ê³ã³ïãÛ³Ý ìÉ³¹»Ý ì³ÝÇÏÇ" 
      .general.name = "KERAMIKA Ê³ã³ïãÛ³Ý ìÉ³¹»Ý ì³ÝÇÏÇ"
      .general.curr = "000"
      .general.repaymentCurrency = ""
      .general.settlementAccount = Account
      .general.thirdPersonsAccount = ""
      .general.interestRepayAccount = Account
      .general.amount = "90000"
      .general.capitalized = 0
      .general.automaticallyPaym = 1
      .general.prologation = 1
      .general.signingDate = "26/10/21"
      .general.division = "01"
      .general.department = "1"
      .general.accessType = "D10"
      .interests.kindOfScale = "1"
      .interests.depositRate = "10.0000"
      .interests.depositeRateDiv = "365"
      .interests.recalculateRate = "0.5000"
      .interests.recalculateRate_div = "365"
      .interests.taxRate = "10"
      .dates.disbursemenDate = "27/10/21"
      .dates.maturityDate = "26/04/22"
      .dates.fixedInterests = 0
      .dates.dateFill = 1
      .dates.dateFill_win.paragraph_mounth = "1"
      .dates.dateFill_win.detourDirection = "2"
      .dates.fillInterestSum = 1
      .additional.sector = "U2"
      .additional.project_ = "AtlanticAG/EXPIMP"
      .additional.region = "001"
      .additional.thePerOfTheAToBeRBDD = "100.00"
      .additional.agreePaperN = "221"
      .statement.deliverStateMode = "3"
      .statement.sendStateAddress = ""
      .statement.deliverStateModeToTPerson = "3"
      .statement.sendStmAdrToTPerson = "2"
      .statement.startDate = "22/11/20"
      .statement.periodicity_months = "1"
      .statement.periodicity_days = "4"
      .statement.datePeriodDifference = "3"
      .statement.nonDaysAvoiding = "1"
  End With
End Sub

Sub DB_Initialize_ForDeposit(Isn,DocNum)
  
  Set dbCONTRACTS = New_DB_CONTRACTS()
  With dbCONTRACTS
      .fDGIsn = Isn
      .fDGPARENTIsn = Isn
      .fDGIsn1 = Isn
      .fDGIsn3 = Isn
      .fDGAGRKIND = 2
      .fDGSTATE = 7
      .fDGTYPENAME = "D1AS21  "
      .fDGCODE = DocNum
      .fDGPPRCODE = "221"
      .fDGCAPTION = "KERAMIKA Ê³ã³ïãÛ³Ý ìÉ³¹»Ý ì³ÝÇÏÇ"
      .fDGCLICODE = "00000678"
      .fDGCUR = "000"
      .fDGSUMMA = "90000.00"
      .fDGALLSUMMA = "0.00"
      .fDGRISKDEGREE = "0.00"
      .fDGRISKDEGNB = "0.00"
      .fDGSCHEDULE = "AtlanticAG/EXPIMP   "
      .fDGDISTRICT = "001"
      .fDGACSBRANCH = "01"
      .fDGACSDEPART = "1"
      .fDGACSTYPE = "D10"
  End With
  
  Set dbFOLDERS(1) = New_DB_FOLDERS()
  With dbFOLDERS(1)
      .fFOLDERID = "Agr." & Isn
      .fNAME = "D1AS21  "
      .fKEY = Isn
      .FISN = Isn
      .fSTATUS = "1"
      .fCOM = "²í³Ý¹³ÛÇÝ å³ÛÙ³Ý³·Çñ"
      .fSPEC = "1²í³Ý¹³ÛÇÝ å³ÛÙ³Ý³·Çñ- "&DocNum&" {KERAMIKA Ê³ã³ïãÛ³Ý ìÉ³¹»Ý ì³ÝÇÏÇ}"
  End With 

  Set dbFOLDERS(2) = New_DB_FOLDERS()
  With dbFOLDERS(2)
      .fFOLDERID = "C.737994605"
      .fNAME = "D1AS21  "
      .fKEY = Isn
      .FISN = Isn
      .fSTATUS = "1"
      .fCOM = " ²í³Ý¹³ÛÇÝ å³ÛÙ³Ý³·Çñ"
      .fSPEC = DocNum&" (KERAMIKA Ê³ã³ïãÛ³Ý ìÉ³¹»Ý ì³ÝÇÏÇ),     90000 - Ð³ÛÏ³Ï³Ý ¹ñ³Ù"
  End With  
  
End Sub  