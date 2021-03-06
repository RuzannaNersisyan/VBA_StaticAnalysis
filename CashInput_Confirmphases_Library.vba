Option Explicit
'USEUNIT Library_Common
'USEUNIT Library_Colour
'USEUNIT Library_Contracts
'USEUNIT Online_PaySys_Library
'USEUNIT Constants

Dim f_Count, l_Count, d_Count, rowCount, rowCountNum, cassaDirCount, accRowCoun

'----------------------------------------------
'Կանխիկ մուտք փաստաթղթի լրացում
'----------------------------------------------
'docNumber - Փաստաթղթի համարը
'summa - Գումար դաշտի արժեք
'accTemp - Հաշիվներ ֆիլտրի հաշվի շաբլոն դաշտի լրացում
'fISN - Փաստատթղթի ISN-ը
'draft - true արժեքի դեպքում սեղմվում է Սրագիր կոճակը, false-ի դեպքում` Կատարել
Sub CashInput_Doc_Fill(docNumber, accTemp, summa, fISN, draft)
    
    BuiltIn.Delay(2000)
    Call wTreeView.DblClickItem("|¶ÉË³íáñ Ñ³ßí³å³ÑÇ ²Þî|Ð³ßÇíÝ»ñ")
    If p1.WaitvbObject("frmAsUstPar", 2000).Exists Then 
      'Հաշվի շաբլոն դաշտի լրացում
      Call Rekvizit_Fill("Dialog", 1, "General", "AccMask", accTemp)
      Call ClickCmdButton(2, "Î³ï³ñ»É")
    Else 
      Log.Error "Can't find frmAsUstPar window", "", pmNormal, ErrorColor
    End If
    
    BuiltIn.Delay(3000)
    Call wMainForm.MainMenu.Click(c_AllActions)
    Call wMainForm.PopupMenu.Click(c_InnerOpers & "|" & c_CashIn)
    If wMDIClient.WaitvbObject("frmASDocForm", 3000).Exists Then 
      'Ստեղծվող ISN - ի փաստատթղթի  վերագրում փոփոխականին
      fISN = wMDIClient.vbObject("frmASDocForm").DocFormCommon.Doc.isn
    
      'Փաստաթղթի N դաշտի արժեքի վերագրում փոփոխականին
      docNumber = Get_Rekvizit_Value("Document", 1, "General", "DOCNUM")
      'Գումար դաշտի լրացում
      Call Rekvizit_Fill("Document", 1, "General", "SUMMA", summa)
      'Նպատակ դաշտի լրացում
      Call Rekvizit_Fill("Document", 1, "General", "AIM", "²ÝÝå³ï³Ï") 
      'Անուն դաշտի լրացում
      Call Rekvizit_Fill("Document", 1, "General", "PAYER", "ä»ïñáë ä»ïñáëÛ³Ý") 
    
      'Կատարել կամ Սևագիր կոճակի սեղմում
      If draft Then
          Call ClickCmdButton(1, "ê¨³·Çñ")
      Else
          Call ClickCmdButton(1, "Î³ï³ñ»É")
      End If
    Else 
      Log.Error "Can't find frmASDocForm window", "", pmNormal, ErrorColor
    End If
    
End Sub

'-----------------------------------------------------
'Î³ÝËÇÏ Ùáõïù ÷³ëï³ÃÕÃÇ ì³í»ñ³óáõÙ ê¨³·ñ»ñ ÃÕÃ³å³Ý³ÏÇó
'-----------------------------------------------------

Sub CashInput_Verify_Doc_From_Drafts()
    
    Call wMainForm.MainMenu.Click(c_AllActions)
    BuiltIn.Delay(delay_middle)
    Call wMainForm.PopupMenu.Click(c_ToEdit)
    BuiltIn.Delay(delay_middle)
    Sys.Process("Asbank").vbObject("MainForm").Window("MDIClient", "", 1).vbObject("frmASDocForm").vbObject("CmdOk_2").Click()
'    Sys.Process("Asbank").VBObject("frmAsMsgBox").VBObject("cmdButton").click()
End Sub

'-----------------------------------------------------
'Î³ÝËÇÏ Ùáõïù ÷³ëï³ÃÕÃÇ áõÕ³ñÏáõÙ í»ñëïáõ·Ù³Ý
'-----------------------------------------------------

Sub CashInput_Send_To_CheckUp()
    
    Call wMainForm.MainMenu.Click(c_AllActions)
    BuiltIn.Delay(delay_middle)
    Call wMainForm.PopupMenu.Click(c_SendToDoubleInput)
    BuiltIn.Delay(delay_middle)
    Sys.Process("Asbank").vbObject("frmAsUstPar").vbObject("CmdOK").Click()
    
End Sub

'-----------------------------------------------------
' Կանխիկ մուտք/ելք փաստաթղթի ստեղծում
' opDate - Ամսաթիվ
' opType - Փաստաքղքի տեսակ (Կանխիկ մուտք/ելք)
' CalcAcc - Հաշիվ կրեդիտ/դեբետ
' Summa - Գումար
' docNumber - Փաստաթղոի N
' Doc_ISN - Փաստաթղոի ISN 
'-----------------------------------------------------
Sub CashInputOutput(opDate, opType, CalcAcc, Summa, docNumber, Name, Doc_ISN)
  'Բացել "Աշխատնքային փաստաթղթեր" թղթապանակը:
  Call wTreeView.DblClickItem("|Ð³×³Ëáñ¹Ç ëå³ë³ñÏáõÙ ¨ ¹ñ³Ù³ñÏÕ |²ßË³ï³Ýù³ÛÇÝ ÷³ëï³ÃÕÃ»ñ")
  Sys.Process("Asbank").VBObject("frmAsUstPar").VBObject("TabFrame").VBObject("TDBDate").Keys(opDate & "[Tab]")
  Sys.Process("Asbank").VBObject("frmAsUstPar").VBObject("TabFrame").VBObject("TDBDate_2").Keys(opDate & "[Tab]")
  Sys.Process("Asbank").VBObject("frmAsUstPar").VBObject("CmdOK").ClickButton
  BuiltIn.Delay(2000)
  'Կատարել "Գործողություններ/Բոլոր գործողությունները . . .
  Call wMainForm.MainMenu.Click(c_AllActions)
  Select Case opType
      '"Կանխիկ գործարքներ/Կանխիկ մուտք": - Պետք է բացվի "Կանխիկ մուտք" փաստաթուղթը:
      Case "CashInput"
        Call wMainForm.PopupMenu.Click(c_CashOpers & "|" & c_CashIn)
        'Լրացնել "Հաշիվ կրեդիտ" դաշտը CalcAcc արժեքով:
        Call Rekvizit_Fill("Document", 1, "General", "ACCCR", CalcAcc)
        'Լրացնել "Անուն" դաշտը name արժեքով:
        Call Rekvizit_Fill("Document", 1, "General", "PAYER", Name)
      Case "CashOutput"
        '"Կանխիկ գործարքներ/Կանխիկ ելք": - Պետք է բացվի "Կանխիկ ելք" փաստաթուղթը:
        Call wMainForm.PopupMenu.Click(c_CashOpers & "|" & c_CashOut)
        'Լրացնել "Հաշիվ դեբետ" դաշտը CalcAcc արժեքով:
        Call Rekvizit_Fill("Document", 1, "General", "ACCDB", CalcAcc)
  End Select
  
  docNumber = wMDIClient.VBObject("frmASDocForm").VBObject("TabFrame").VBObject("TextC").Text
  'Լրացնել "Գումար" դաշտը Summa արժեքով:
  Call Rekvizit_Fill("Document", 1, "General", "SUMMA", Summa)
  'Լրացնել "Ամսաթիվ" դաշտը opDate արժեքով:
  Call Rekvizit_Fill("Document", 1, "General", "DATE", opDate)
  'Նպատակ դաշտի լրացում
  Call Rekvizit_Fill("Document", 1, "General", "AIM", "111")
  
  Doc_ISN = wMDIClient.VBObject("frmASDocForm").DocFormCommon.Doc.isn
  
  Call ClickCmdButton(1, "Î³ï³ñ»É")
End Sub

'----------------------------------------------------
' Հաշվառվաշ վճարային փաստաթղթի ջնջում
' opDate - Ամսաթիվ
' opType - Փաստաքղքի տեսակ
' Client - Հաճախորդի կոդ
' Summa - Գումար
' docNumber - Փաստաթղոի N
' Doc_ISN - Փաստաթղոի ISN 
'-----------------------------------------------------
Sub DeletePayingDoc(opDate, opType, Doc_ISN)
  Call wTreeView.DblClickItem("|Ð³×³Ëáñ¹Ç ëå³ë³ñÏáõÙ ¨ ¹ñ³Ù³ñÏÕ |Ð³ßí³éí³Í í×³ñ³ÛÇÝ ÷³ëï³ÃÕÃ»ñ")
  
  Sys.Process("Asbank").VBObject("frmAsUstPar").VBObject("TabFrame").VBObject("TDBDate").Keys(opDate & "[Tab]")
  Sys.Process("Asbank").VBObject("frmAsUstPar").VBObject("TabFrame").VBObject("TDBDate_2").Keys(opDate & "[Tab]")
  Sys.Process("Asbank").VBObject("frmAsUstPar").VBObject("TabFrame").VBObject("ASTypeTree_2").VBObject("TDBMask").Keys(opType & "[Tab]")
  Sys.Process("Asbank").VBObject("frmAsUstPar").VBObject("TabFrame").VBObject("TDBNumber").Keys(Doc_ISN & "[Tab]")
  
  Sys.Process("Asbank").VBObject("frmAsUstPar").VBObject("CmdOK").ClickButton
   Do Until Sys.Process("Asbank").VBObject("MainForm").Window("MDIClient", "", 1).VBObject("frmPttel").VBObject("tdbgView").EOF
      If Sys.Process("Asbank").VBObject("MainForm").Window("MDIClient", "", 1).VBObject("frmPttel").VBObject("tdbgView").ApproxCount <> 0 Then
        Call wMainForm.MainMenu.Click(c_Opers & "|" & c_Delete)
        Sys.Process("Asbank").VBObject("frmDeleteDoc").VBObject("YesButton").ClickButton
      Else 
        Exit Do
      End If 
   Loop
  Sys.Process("Asbank").VBObject("MainForm").Window("MDIClient", "", 1).VBObject("frmPttel").Close
End Sub

'-----------------------------
'"Կանխիկ Մուտք"  CashIn - Class
'-----------------------------
Class CashIn
    Public fIsn
    Public Office
    Public Department
    Public DocNum 
    Public Date
    Public CashDesk
    Public CashDeskAccount
    Public CreditAccount
    Public Amount
    Public CashLabel
    Public Base
    Public Aim
    Public Depositor
    Public FirstName
    Public LastName
    Public IdNumber
    Public IdTipe
    Public Issued
    Public IssuedDate
    Public DateOfExpire
    Public DateOfBirth
    Public Citizenship
    Public Country
    Public Community
    Public City 
    Public Flat
    Public Street
    Public House
    Public Email
    Public ChargesAccount
    Public Curr
    Public ChargeType
    Public ChargesAmount
    Public Interest
    Public IncomeAccount
    Public NonResident
    Public Comment
    Public CliAgrDetails
    Public SubAmount
    Public SubAmountToBePaid 
    Public AmountInPrimaryCurr
    Public CBExchangeRate
    Public CheckDateOfBirth
    Public BuySell
    Public ExchangeRate
    Public LegalStatus
    Public OperArea
    Public CBExchangeRate_Sub
    Public CheckAmount
    Public OperType
    Public OperPlace
    Public Time
    Public CoinPayCurr
    Public CoinPayAcc
    Public EarnExternalExchg
    Public DamageExternalExchg 
    Public RoundedAmount
				
    Private Sub Class_Initialize
        fIsn = ""
        Office = ""
        Department = ""
        DocNum = ""
        Date = ""
        CashDesk = ""
        CashDeskAccount = ""
        CreditAccount = ""
        Amount = ""
        CashLabel = ""
        Base = ""
        Aim = ""
        Depositor = ""
        FirstName = ""
        LastName = ""
        IdNumber = ""
        IdTipe = ""
        Issued = ""
        IssuedDate = ""
        DateOfExpire = ""
        DateOfBirth = ""
        Citizenship = ""
        Country = ""
        Community = ""
        City = ""
        Flat = ""
        Street = ""
        House = ""
        Email = ""
        ChargesAccount = ""
        Curr = ""
        ChargeType = ""
        ChargesAmount = "0.00"
        Interest = "0.0000"
        IncomeAccount = ""
        NonResident = 0
        Comment = ""
        CliAgrDetails = ""
        SubAmount = "0.00"
        SubAmountToBePaid = "0.00" 
        AmountInPrimaryCurr = "0.00"
        CBExchangeRate = "0.0000/0"
        CheckDateOfBirth = ""
        BuySell = ""
        ExchangeRate = "0/0"
        CBExchangeRate_Sub = "0/0"
        LegalStatus = ""
        OperArea = ""
        CheckAmount = ""
        OperType = ""
        OperPlace = ""
        Time = ""
        CoinPayCurr = ""
        CoinPayAcc = ""
        EarnExternalExchg = ""
        DamageExternalExchg = ""
        RoundedAmount = "0.00"
    End Sub  
End Class

Function New_CashIn()
    Set New_CashIn = New CashIn  
End Function

Function Fill_CashIn(CashIn)
    
    'ISN-ի վերագրում փոփոխականին
    Fill_CashIn = wMDIClient.vbObject("frmASDocForm").DocFormCommon.Doc.isn
    
    'Փաստաթղթի N դաշտի արժեքի վերագրում փոփոխականին
    CashIn.DocNum = Get_Rekvizit_Value("Document",1,"General","DOCNUM")
    
    'Ամսաթիվ դաշտի լրացում
    Call Rekvizit_Fill("Document", 1, "General", "DATE", "^A[Del]" & CashIn.Date)
    'Դրամարկղ դաշտի լրացում
    Call Rekvizit_Fill("Document", 1, "General", "KASSA", CashIn.CashDesk)
    'Դրամարկղի հաշիվ դաշտի լրացում
    Call Rekvizit_Fill("Document", 1, "General", "ACCDB", CashIn.CashDeskAccount)
    'Հաշիվ կրեդիտ դաշտի լրացում
    Call Rekvizit_Fill("Document", 1, "General", "ACCCR", CashIn.CreditAccount)
    'Գումար դաշտի լրացում
    Call Rekvizit_Fill("Document", 1, "General", "SUMMA", CashIn.Amount)
    'Դրամարկղի նիշ դաշտի լրացում
    Call Rekvizit_Fill("Document", 1, "General", "KASSIMV", CashIn.CashLabel)
    'Հիմք դաշտի լրացում
    Call Rekvizit_Fill("Document", 1, "General", "BASE", CashIn.Base)
    'Նպատակ դաշտի լրացում
    Call Rekvizit_Fill("Document", 1, "General", "AIM", CashIn.Aim)
    'Մուծող դաշտի լրացում
    Call Rekvizit_Fill("Document", 1, "General", "CLICODE", CashIn.Depositor)
    'Անուն դաշտի լրացում
    Call Rekvizit_Fill("Document", 1, "General", "PAYER", CashIn.FirstName)
    'Ազգանուն դաշտի լրացում
    Call Rekvizit_Fill("Document", 1, "General", "PAYERLASTNAME", CashIn.LastName)
    'Անձը հաստ. փաստ դաշտի լրացում
    Call Rekvizit_Fill("Document", 1, "General", "PASSNUM", CashIn.IdNumber)
    'Տիպ դաշտի լրացում
    Call Rekvizit_Fill("Document", 1, "General", "PASTYPE", CashIn.IdTipe)
    'Տրված դաշտի լրացում
    Call Rekvizit_Fill("Document", 1, "General", "PASBY", CashIn.Issued)
    'Տրված ամսաթիվ դաշտի լրացում
    Call Rekvizit_Fill("Document", 1, "General", "DATEPASS", CashIn.IssuedDate)
    'Վավեր է մինչև դաշտի լրացում
    Call Rekvizit_Fill("Document", 1, "General", "DATEEXPIRE", CashIn.DateOfExpire)
    'Ծննդյան ամսաթիվ դաշտի լրացում
    Call Rekvizit_Fill("Document", 1, "General", "DATEBIRTH", CashIn.DateOfBirth)
    'Քաղաքացիություն դաշտի լրացում
    Call Rekvizit_Fill("Document", 1, "General", "CITIZENSHIP", CashIn.Citizenship)
    'Երկիր դաշտի լրացում
    Call Rekvizit_Fill("Document", 1, "General", "COUNTRY", CashIn.Country)
    'Բնակավայր դաշտի լրացում
    Call Rekvizit_Fill("Document", 1, "General", "COMMUNITY", CashIn.Community)
    'Քաղաք դաշտի լրացում
    Call Rekvizit_Fill("Document", 1, "General", "CITY", CashIn.City)   
    'Բնակարան դաշտի լրացում
    Call Rekvizit_Fill("Document", 1, "General", "APARTMENT", CashIn.Flat) 
    'Փողոց դաշտի լրացում
    Call Rekvizit_Fill("Document", 1, "General", "ADDRESS", CashIn.Street)
    'Տուն/Շենք դաշտի լրացում
    Call Rekvizit_Fill("Document", 1, "General", "BUILDNUM", CashIn.House)
    'Էլ հասցե դաշտի լրացում
    Call Rekvizit_Fill("Document", 1, "General", "EMAIL", CashIn.Email)
    
    'Գանձման հաշիվ դաշտի լրացում
    Call Rekvizit_Fill("Document", 2, "General", "CHRGACC", CashIn.ChargesAccount)
    'Արժույթ դաշտի լրացում
    Call Rekvizit_Fill("Document", 2, "General", "CHRGCUR", CashIn.Curr)
    'Գանձման տեսակ դաշտի լրացում
    Call Rekvizit_Fill("Document", 2, "General", "PAYSCALE", CashIn.ChargeType)
    'Ստուգում է "Գումար" դաշտի արժեքը
    Call Compare_Two_Values("Գումար",Get_Rekvizit_Value("Document",2,"General","CHRGSUM"),CashIn.ChargesAmount) 
    'Ստուգում է "Տոկոս" դաշտի արժեքը
    Call Compare_Two_Values("Տոկոս",Get_Rekvizit_Value("Document",2,"General","PRSNT"),CashIn.Interest) 
    'Ստուգում է "Եկամտի հաշիվ" դաշտի արժեքը
    Call Compare_Two_Values("Եկամտի հաշիվ",Get_Rekvizit_Value("Document",2,"Mask","CHRGINC"),CashIn.IncomeAccount) 


    'Ոչ ռեզիդենտ դաշտի լրացում
    Call Rekvizit_Fill("Document", 2, "CheckBox", "NONREZ", CashIn.NonResident)
    'Մեկնաբանություն դաշտի լրացում
    Call Rekvizit_Fill("Document", 2, "General", "COMM", CashIn.Comment)
    'Հաճ.պայմանագ.տվյալներ դաշտի լրացում
    Call Rekvizit_Fill("Document", 2, "General", "AGRDETAILS", CashIn.CliAgrDetails)

    'Մանրադրամ դաշտի լրացում
    Call Rekvizit_Fill("Document", 3, "General", "XSUM", CashIn.SubAmount)
    'Ստուգում է "Մանրադրամի վճարման գումար" դաշտի արժեքը
    Call Compare_Two_Values("Մանրադրամի վճարման գումար",Get_Rekvizit_Value("Document",3,"General","XCURSUM"),CashIn.SubAmountToBePaid) 
    'Ստուգում է "Գումար հիմնական արժույթով" դաշտի արժեքը
    Call Compare_Two_Values("Գումար հիմնական արժույթով",Get_Rekvizit_Value("Document",3,"General","XSUMMAIN"),CashIn.AmountInPrimaryCurr) 

    Call ClickCmdButton(1, "Î³ï³ñ»É")
End Function

'-----------------------------
'"Ստեղծել հաշիվ" Account - Class
'-----------------------------
Class Account
    Public Isn
    Public BalanceAccount
    Public AccountHolder
    Public Name
    Public EnglishName
    Public RemainderType
    Public Curr
    Public AccountType
    Public OpenDate
    Public Account
    Public Division
    Public Department
    Public AccessType
    Public CashAccounting
    
    Private Sub Class_Initialize
        Isn = ""
        BalanceAccount = ""
        AccountHolder = ""
        Name = ""
        EnglishName = ""
        RemainderType = ""
        Curr = ""
        AccountType = ""
        OpenDate = ""
        Account = ""
        Division = ""
        Department = ""
        AccessType = ""
        CashAccounting = 0
    End Sub  
End Class

Function New_Account()
    Set New_Account = NEW Account      
End Function

Sub Create_Account(Account)

      'Ստեղծել հաշիվ գործողության կատարում
      Call wMainForm.MainMenu.Click(c_AllActions)
      Call wMainForm.PopupMenu.Click(c_Add)
      BuiltIn.Delay(1000) 
      
      'Հաճախորդի փաստաթղթի ISN - ի ստացում
      Account.Isn = wMDIClient.VBObject("frmASDocForm").DocFormCommon.Doc.ISN  
      
      'Հ/Պ հաշվեկշռային հաշվի տիպ դաշտի լրացում
      Call Rekvizit_Fill("Document", 1, "General", "BALACC", Account.BalanceAccount)
      'Հաշվետեր դաշտի լրացում
      Call Rekvizit_Fill("Document", 1, "General", "CLICOD", Account.AccountHolder )
      ' Անվանում դաշտի լրացում
      Call Rekvizit_Fill("Document", 1, "General", "NAME", Account.Name )
      'Անգլերեն Անվանում դաշտի լրացում
      Call Rekvizit_Fill("Document", 1, "General", "ENAME", Account.EnglishName )
      'Հաշվի մնացորդի տիպ դաշտի լրացում
      Call Rekvizit_Fill("Document", 1, "General", "DK", Account.RemainderType)
      'Արժույթ դաշտի լրացում
      Call Rekvizit_Fill("Document", 1, "General", "CODVAL", Account.Curr)
      'Հաշվի տիպ դաշտի լրացում
      Call Rekvizit_Fill("Document", 1, "General", "ACCTYPE", Account.AccountType)
      'Բացման ամսաթիվ դաշտի լրացում
      Call Rekvizit_Fill("Document", 1, "General", "DATOTK", Account.OpenDate)
      'Վերցնում է Հաշիվ դաշտի արժեքը
      Account.Account = Get_Rekvizit_Value("Document",1,"General","CODE")
      'Գրասենյակ տիպ դաշտի լրացում
      Call Rekvizit_Fill("Document", 1, "General", "ACSBRANCH", Account.Division)
      'Բաժին տիպ դաշտի լրացում
      Call Rekvizit_Fill("Document", 1, "General", "ACSDEPART", Account.Department)
      'Հասան-ն տիպ դաշտի լրացում
      Call Rekvizit_Fill("Document", 1, "General", "ACSTYPE", Account.AccessType)
      
      'Կանխիկի հաշվառում նշիչի լրացում
      Call Rekvizit_Fill("Document", 2, "CheckBox", "CASHAC", Account.CashAccounting)

      'Կատարել կոճակի սեղմում
      Call ClickCmdButton(1, "Î³ï³ñ»É")
      BuiltIn.Delay(2000) 
End Sub 

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''''''''''CashIn_Common''''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Կնախիկ մուտք փաստաթղթի Ընդհանուր բաժնի կլաս
' payerLegalStatus - ատանում է հաճախորդի իրավաբանական կարգավիճակը
'                     Օրինակ՝ "ֆիզԱնձ"
Class CashIn_Common 
    Public tabN
    Public office
    Public department
    Public docNum 
    Public date
    Public dateForCheck
    Public cashRegister
    Public cashRegisterAcc 
    Public curr
    Public accCredit
    Public amount
    Public amountForCheck
    Public cashierChar
    Public base
    Public aim 
    Public payer
    Public payerLegalStatus
    Public name
    Public surname
    Public id
    Public idForCheck
    Public idType
    Public idTypeForCheck
    Public idGivenBy
    Public idGivenByForCheck
    Public idGiveDate
    Public idGiveDateForCheck
    Public idValidUntil
    Public idValidUntilForCheck
    Public birthDate
    Public birthDateForCheck
    Public citizenship
    Public country
    Public residence
    Public city 
    Public street
    Public apartment
    Public house
    Public email
    Public emailForCheck
    Private Sub Class_Initialize()
        tabN = 1
        office = ""
        department = ""
        docNum = ""
        date = ""
        dateForCheck = "/  /"
        cashRegister = ""
        cashRegisterAcc = ""
        curr = ""
        accCredit = ""
        amount = "0.00"
        amountForCheck = "0.00"
        cashierChar = ""
        base = ""
        aim = ""
        payer = ""
        payerLegalStatus = ""
        name = ""
        surname = ""
        id = ""
        idForCheck = ""
        idType = ""
        idTypeForCheck = ""
        idGivenBy = ""
        idGivenByForCheck = ""
        idGiveDate = ""
        idGiveDateForCheck = "/  /"
        idValidUntil = ""
        idValidUntilForCheck = "/  /"
        birthDate = ""
        birthDateForCheck = "/  /"
        citizenship = ""
        country = ""
        residence = ""
        city = ""
        street = ""
        apartment = ""
        house = ""
        email = ""
        emailForCheck = ""
    End Sub
End Class

Function New_CashIn_Common()
    Set New_CashIn_Common = New CashIn_Common
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''''''Fill_CashIn_Common'''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Կանխիկ մուտք փաստաթղթի Ընդհանուր բաժնի լրացման ֆունկցիա
' Common - Կնախիկ մուտք փաստաթղթի Ընդհանուր բաժնի կլաս
Sub Fill_CashIn_Common(Common)
    'Գրասենյակ դաշտի լրացում
    Call Rekvizit_Fill("Document", Common.tabN, "General", "KASSA", Common.office)
    'Բաժին դաշտի լրացում
    Call Rekvizit_Fill("Document", Common.tabN, "General", "ACCDB", Common.department)
    'Փաստաթղթի N դաշտի արժեքի վերագրում փոփոխականին
    Common.docNum = Get_Rekvizit_Value("Document", Common.tabN, "General", "DOCNUM")
    'Ամսաթիվ դաշտի լրացում
    Call Rekvizit_Fill("Document", Common.tabN, "General", "DATE", "^A[Del]" & Common.date)
    'Դրամարկղ դաշտի լրացում
    Call Rekvizit_Fill("Document", Common.tabN, "General", "KASSA", "^A[Del]" & Common.cashRegister)
    'Դրամարկղի հաշիվ դաշտի լրացում
    Call Rekvizit_Fill("Document", Common.tabN, "General", "ACCDB", "[Home]" & Common.cashRegisterAcc)
    'Հաշիվ կրեդիտ դաշտի լրացում
    Call Rekvizit_Fill("Document", Common.tabN, "General", "ACCCR", "[Home]" & Common.accCredit)
    ' Ստուգել, որ Արժույթ դաշտը չխմբագրվող է
    Call Check_ReadOnly("Document", Common.tabN, "Mask", "CUR", True)
    ' Ստուգել Արժույթ դաշտի արժեքը
    Call Compare_Two_Values("Արժույթ", Get_Rekvizit_Value("Document", Common.tabN, "Mask", "CUR"), Common.curr)
    'Գումար դաշտի լրացում
    Call Rekvizit_Fill("Document", Common.tabN, "General", "SUMMA", Common.amount)
    'Դրամարկղի նիշ դաշտի լրացում
    Call Rekvizit_Fill("Document", Common.tabN, "General", "KASSIMV", Common.cashierChar)
    'Հիմք դաշտի լրացում
    Call Rekvizit_Fill("Document", Common.tabN, "General", "BASE", "[Home]!" & "[End]" & "[Del]" & Common.base)
    'Նպատակ դաշտի լրացում
    Call Rekvizit_Fill("Document", Common.tabN, "General", "AIM", "[Home]!" & "[End]" & "[Del]" & Common.aim)
    'Մուծող դաշտի լրացում
    Call Rekvizit_Fill("Document", Common.tabN, "General", "CLICODE", Common.payer)
    If Common.payerLegalStatus = "ֆիզԱնձ" Then
        ' Ստուգել, որ Անուն դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Common.tabN, "Comment", "PAYER", True)
        ' Ստուգել Անուն դաշտի արժեքը
        Call Compare_Two_Values("Անուն", Get_Rekvizit_Value("Document", Common.tabN, "Comment", "PAYER"), Common.name)
        ' Ստուգել, որ Ազգանուն դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Common.tabN, "General", "PAYERLASTNAME", True)
        ' Ստուգել Ազգանուն դաշտի արժեքը
        Call Compare_Two_Values("Ազգանուն", Get_Rekvizit_Value("Document", Common.tabN, "General", "PAYERLASTNAME"), Common.surname)
        ' Ստուգել Անձը հաստ. փաստթ. կոդ դաշտի արժեքը
        Call Compare_Two_Values("Անձը հաստ. փաստթ. կոդ", Get_Rekvizit_Value("Document", Common.tabN, "Comment", "PASSNUM"), Common.idForCheck)
        ' Ստուգել Տիպ դաշտի արժեքը
        Call Compare_Two_Values("Տիպ", Get_Rekvizit_Value("Document", Common.tabN, "Mask", "PASTYPE"), Common.idTypeForCheck)
        ' Ստուգել Տրված դաշտի արժեքը
        Call Compare_Two_Values("Տրված", Get_Rekvizit_Value("Document", Common.tabN, "General", "PASBY"), Common.idGivenByForCheck)
        ' Ստուգել Տրված ամսաթիվ դաշտի արժեքը
        Call Compare_Two_Values("Տրված ամսաթիվ", Get_Rekvizit_Value("Document", Common.tabN, "General", "DATEPASS"), Common.idGiveDateForCheck)
        ' Ստուգել Վավեր է մինչև դաշտի արժեքը
        Call Compare_Two_Values("Վավեր է մինչև", Get_Rekvizit_Value("Document", Common.tabN, "General", "DATEEXPIRE"), Common.idValidUntilForCheck)
        ' Ստուգել, որ Ծննդյան ամսաթիվ դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Common.tabN, "General", "DATEBIRTH", True)
        ' Ստուգել Ծննդյան ամսաթիվ դաշտի արժեքը
        Call Compare_Two_Values("Ծննդյան ամսաթիվ", Get_Rekvizit_Value("Document", Common.tabN, "General", "DATEBIRTH"), Common.birthDateForCheck)
        ' Ստուգել, որ Քաղաքացիություն դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Common.tabN, "Mask", "CITIZENSHIP", True)
        ' Ստուգել Քաղաքացիություն դաշտի արժեքը
        Call Compare_Two_Values("Քաղաքացիություն", Get_Rekvizit_Value("Document", Common.tabN, "Mask", "CITIZENSHIP"), Common.citizenship)
        ' Ստուգել, որ Երկիր դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Common.tabN, "Mask", "COUNTRY", True)
        ' Ստուգել Երկիր դաշտի արժեքը
        Call Compare_Two_Values("Երկիր", Get_Rekvizit_Value("Document", Common.tabN, "Mask", "COUNTRY"), Common.country)
        ' Ստուգել, որ Բնակավայր դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Common.tabN, "Mask", "COMMUNITY", True)
        ' Ստուգել Բնակավայր դաշտի արժեքը
        Call Compare_Two_Values("Բնակավայր", Get_Rekvizit_Value("Document", Common.tabN, "Mask", "COMMUNITY"), Common.residence)
        ' Ստուգել, որ Քաղաք դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Common.tabN, "General", "CITY", True)
        ' Ստուգել Քաղաք դաշտի արժեքը
        Call Compare_Two_Values("Քաղաք", Get_Rekvizit_Value("Document", Common.tabN, "General", "CITY"), Common.city)
        ' Ստուգել, որ Բնակարան դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Common.tabN, "General", "APARTMENT", True)
        ' Ստուգել Բնակարան դաշտի արժեքը
        Call Compare_Two_Values("Բնակարան", Get_Rekvizit_Value("Document", Common.tabN, "General", "APARTMENT"), Common.apartment)
        ' Ստուգել, որ Փողոց դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Common.tabN, "General", "ADDRESS", True)
        ' Ստուգել Փողոց դաշտի արժեքը
        Call Compare_Two_Values("Փողոց", Get_Rekvizit_Value("Document", Common.tabN, "General", "ADDRESS"), Common.street)
        ' Ստուգել, որ Տուն/Շենք դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Common.tabN, "General", "BUILDNUM", True)
        ' Ստուգել Տուն/Շենք դաշտի արժեքը
        Call Compare_Two_Values("Տուն/Շենք", Get_Rekvizit_Value("Document", Common.tabN, "General", "BUILDNUM"), Common.house)
        ' Ստուգել Էլ հասցե դաշտի արժեքը
        Call Compare_Two_Values("Էլ հասցե", Get_Rekvizit_Value("Document", Common.tabN, "General", "EMAIL"), Common.emailForCheck)
    Else
        'Անուն դաշտի լրացում
        Call Rekvizit_Fill("Document", Common.tabN, "General", "PAYER", "![End][Del]" & Common.name)
        'Ազգանուն դաշտի լրացում
        Call Rekvizit_Fill("Document", Common.tabN, "General", "PAYERLASTNAME", "![End][Del]" & Common.surname)
        'Ծննդյան ամսաթիվ դաշտի լրացում
        Call Rekvizit_Fill("Document", Common.tabN, "General", "DATEBIRTH", Common.birthDate)
        'Քաղաքացիություն դաշտի լրացում
        Call Rekvizit_Fill("Document", Common.tabN, "General", "CITIZENSHIP", Common.citizenship)
        'Երկիր դաշտի լրացում
        Call Rekvizit_Fill("Document", Common.tabN, "General", "COUNTRY", Common.country)
        'Բնակավայր դաշտի լրացում
        Call Rekvizit_Fill("Document", Common.tabN, "General", "COMMUNITY", Common.residence)
        'Քաղաք դաշտի լրացում
        Call Rekvizit_Fill("Document", Common.tabN, "General", "CITY", Common.city)   
        'Բնակարան դաշտի լրացում
        Call Rekvizit_Fill("Document", Common.tabN, "General", "APARTMENT", Common.apartment) 
        'Փողոց դաշտի լրացում
        Call Rekvizit_Fill("Document", Common.tabN, "General", "ADDRESS", Common.street)
        'Տուն/Շենք դաշտի լրացում
        Call Rekvizit_Fill("Document", Common.tabN, "General", "BUILDNUM", Common.house)
    End If
    
    'Անձը հաստ. փաստ դաշտի լրացում
    Call Rekvizit_Fill("Document", Common.tabN, "General", "PASSNUM", "[Home]!" & "[End]" & "[Del]" & Common.id)
    'Տիպ դաշտի լրացում
    Call Rekvizit_Fill("Document", Common.tabN, "General", "PASTYPE", Common.idType)
    'Տրված դաշտի լրացում
    Call Rekvizit_Fill("Document", Common.tabN, "General", "PASBY", Common.idGivenBy)
    'Տրված ամսաթիվ դաշտի լրացում
    Call Rekvizit_Fill("Document", Common.tabN, "General", "DATEPASS", Common.idGiveDate)
    'Վավեր է մինչև դաշտի լրացում
    Call Rekvizit_Fill("Document", Common.tabN, "General", "DATEEXPIRE", Common.idValidUntil) 
    'Էլ հասցե դաշտի լրացում
    Call Rekvizit_Fill("Document", Common.tabN, "General", "EMAIL", "[Home]!" & "[End]" & "[Del]" & Common.email)
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''''''''''CashIn_Charge''''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Կնախիկ մուտք փաստաթղթի Գանձում բաժնի կլաս
' notGrCash - փոփոխականը ստուգում է Կանխիկ մուտք գործողությունը խմբային է(True) թե ոչ(False)
Class CashIn_Charge
    Public tabN
    Public office
    Public department
    Public chargeAcc
    Public chargeAccForCheck
    Public chargeCurr
    Public chargeCurrForCheck
    Public cbExchangeRate
    Public chargeType
    Public chargeAmount
    Public chargeAmoForCheck
    Public chargePercent
    Public chargePerForCheck
    Public incomeAcc
    Public incomeAccCurr
    Public buyAndSell
    Public buyAndSellForCheck
    Public operType
    Public operPlace
    Public time
    Public timeForCheck
    Public operArea
    Public operAreaForCheck
    Public nonResident
    Public nonResidentForCheck
    Public legalStatus
    Public legalStatusForCheck
    Public comment
    Public commentForCheck
    Public clientAgreeData
    Public notGrCash
    Private Sub Class_Initialize()
        tabN = 2
        office = ""
        department = ""
        chargeAcc = ""
        chargeAccForCheck = ""
        chargeCurr = ""
        chargeCurrForCheck = ""
        cbExchangeRate = ""
        chargeType = ""
        chargeAmount = "0.00"
        chargeAmoForCheck = "0.00"
        chargePercent = "0.0000"
        chargePerForCheck = "0.0000"
        incomeAcc = ""
        incomeAccCurr = ""
        buyAndSell = ""
        buyAndSellForCheck = ""
        operType = ""
        operPlace = ""
        time = ""
        timeForCheck = ""
        operArea = ""
        operAreaForCheck = ""
        nonResident = 0
        nonResidentForCheck = 0
        legalStatus = ""
        legalStatusForCheck = ""
        comment = ""
        commentForCheck = ""
        clientAgreeData = ""
        notGrCash = True
    End Sub
End Class

Function New_CashIn_Charge()
    Set New_CashIn_Charge = New CashIn_Charge
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''''''Fill_CashIn_Charge'''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Կանխիկ մուտք փաստաթղթի Գանձում բաժնի լրացման ֆունկցիա
' Charge - Կնախիկ մուտք փաստաթղթի Ընդհանուր բաժնի կլաս
Sub Fill_CashIn_Charge(Charge, payerLegalStatus)
    ' Ստուգել, որ Գրասենյակ դաշտը չխմբագրվող է
    Call Check_ReadOnly("Document", Charge.tabN, "Mask", "ACSBRANCHINC", True)
    ' Ստուգել Գրասենյակ դաշտի արժեքը
    Call Compare_Two_Values("Գրասենյակ", Get_Rekvizit_Value("Document", Charge.tabN, "Mask", "ACSBRANCHINC"), Charge.office)
    ' Ստուգել, որ Բաժին դաշտը չխմբագրվող է
    Call Check_ReadOnly("Document", Charge.tabN, "Mask", "ACSDEPARTINC", True)
    ' Ստուգել Բաժին դաշտի արժեքը
    Call Compare_Two_Values("Բաժին", Get_Rekvizit_Value("Document", Charge.tabN, "Mask", "ACSDEPARTINC"), Charge.department)
    ' Ստուգել, որ Գանձման հաշիվ դաշտը խմբագրվող է
    Call Check_ReadOnly("Document", Charge.tabN, "Mask", "CHRGACC", False)
    ' Ստուգել Գանձման հաշիվ դաշտի արժեքը
    Call Compare_Two_Values("Գանձման հաշիվ", Get_Rekvizit_Value("Document", Charge.tabN, "Mask", "CHRGACC"), Charge.chargeAccForCheck)
    ' Գանձման հաշիվ դաշտի լրացում
    Call Rekvizit_Fill("Document", Charge.tabN, "General", "CHRGACC", "[Home]" & Charge.ChargeAcc)
    ' Ստուգել, որ Արժույթ դաշտը խմբագրվող է
    Call Check_ReadOnly("Document", Charge.tabN, "Mask", "CHRGCUR", False)
    ' Ստուգել Արժույթ դաշտի արժեքը
    Call Compare_Two_Values("Արժույթ", Get_Rekvizit_Value("Document", Charge.tabN, "Mask", "CHRGCUR"), Charge.chargeCurrForCheck)
    ' Արժույթ դաշտի լրացում
    Call Rekvizit_Fill("Document", Charge.tabN, "General", "CHRGCUR", Charge.chargeCurr)
    ' Ստուգել, որ ԿԲ փոխարժեք դաշտը չխմբագրվող է
    Call Check_ReadOnly("Document", Charge.tabN, "Course1", "CHRGCBCRS", True)
    ' Ստուգել ԿԲ փոխարժեք դաշտի արժեքը
    Call Compare_Two_Values("ԿԲ փոխարժեք", Get_Rekvizit_Value("Document", Charge.tabN, "Course", "CHRGCBCRS"), Charge.cbExchangeRate)
    ' Գանձման տեսակ դաշտի լրացում
    Call Rekvizit_Fill("Document", Charge.tabN, "General", "PAYSCALE", Charge.chargeType)
    ' Գումար դաշտի լրացում
    Call Rekvizit_Fill("Document", Charge.tabN, "General", "CHRGSUM", Charge.chargeAmount)
    ' Տոկոս դաշտի լրացում
    Call Rekvizit_Fill("Document", Charge.tabN, "General", "PRSNT", Charge.chargePercent)
    ' Եկամտի հաշիվ դաշտի լրացում
    Call Rekvizit_Fill("Document", Charge.tabN, "General", "CHRGINC", Charge.incomeAcc)
    ' Ստուգել, որ Գործողության տեսակ դաշտը չխմբագրվող է
    Call Check_ReadOnly("Document", Charge.tabN, "Mask", "CURTES", True)
    ' Ստուգել, որ Գործողության վայր դաշտը չխմբագրվող է
    Call Check_ReadOnly("Document", Charge.tabN, "Mask", "CURVAIR", True)
    
    If Charge.incomeAccCurr <> Charge.chargeCurr and Charge.chargeAmount <> "0.00" Then
        ' Ստուգել, որ Առք/Վաճառք դաշտը խմբագրվող է
        Call Check_ReadOnly("Document", Charge.tabN, "Mask", "CUPUSA", False)
        ' Ստուգել Առք/Վաճառք դաշտի արժեքը
        Call Compare_Two_Values("Առք/Վաճառք", Get_Rekvizit_Value("Document", Charge.tabN, "Mask", "CUPUSA"), Charge.buyAndSellForCheck) 
        ' Առք/Վաճառք դաշտի լրացում
        Call Rekvizit_Fill("Document", Charge.tabN, "General", "CUPUSA", Charge.buyAndSell)
        ' Ստուգել Գործողության տեսակ դաշտի արժեքը
        Call Compare_Two_Values("Գործողության տեսակ", Get_Rekvizit_Value("Document", Charge.tabN, "Mask", "CURTES"), Charge.operType)
        ' Ստուգել Գործողության վայր դաշտի արժեքը
        Call Compare_Two_Values("Գործողության վայր", Get_Rekvizit_Value("Document", Charge.tabN, "Mask", "CURVAIR"), Charge.operPlace)
        ' Ստուգել, որ Ժամանակ դաշտը խմբագրվող է
        Call Check_ReadOnly("Document", Charge.tabN, "Mask", "TIME", False)
        If aqDateTime.Compare(aqConvert.DateTimeToFormatStr(aqDateTime.Time, "%H:%M"), "16:00") < 0 Then
            Charge.timeForCheck = "1"
        Else
            Charge.timeForCheck = "2"
        End If
        ' Ստուգել Ժամանակ դաշտի արժեքը
        Call Compare_Two_Values("Ժամանակ", Get_Rekvizit_Value("Document", Charge.tabN, "Mask", "TIME"), Charge.timeForCheck)
        ' Ժամանակ դաշտի լրացում
        Call Rekvizit_Fill("Document", Charge.tabN, "General", "TIME", Charge.time)
    Else 
        ' Ստուգել, որ Առք/Վաճառք դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Charge.tabN, "Mask", "CUPUSA", True)
        ' Ստուգել Առք/Վաճառք դաշտի արժեքը
        Call Compare_Two_Values("Առք/Վաճառք", Get_Rekvizit_Value("Document", Charge.tabN, "Mask", "CUPUSA"), "") 
        ' Ստուգել Գործողության տեսակ դաշտի արժեքը
        Call Compare_Two_Values("Գործողության տեսակ", Get_Rekvizit_Value("Document", Charge.tabN, "Mask", "CURTES"), "")
        ' Ստուգել Գործողության վայր դաշտի արժեքը
        Call Compare_Two_Values("Գործողության վայր", Get_Rekvizit_Value("Document", Charge.tabN, "Mask", "CURVAIR"), "")
        ' Ստուգել, որ Ժամանակ դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Charge.tabN, "Mask", "TIME", True)
        ' Ստուգել Ժամանակ դաշտի արժեքը
        Call Compare_Two_Values("Ժամանակ", Get_Rekvizit_Value("Document", Charge.tabN, "Mask", "TIME"), "")
    End If
    
    If Charge.incomeAcc = "" or Charge.chargeAmount = "0.00" or Charge.ChargeAcc = "" Then
        ' Ստուգել, որ Մեկնաբանություն դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Charge.tabN, "General", "COMM", True)
        ' Ստուգել Մեկնաբանություն դաշտի արժեքը
        Call Compare_Two_Values("Մեկնաբանություն", Get_Rekvizit_Value("Document", Charge.tabN, "General", "COMM"), "")
    Else 
        ' Ստուգել, որ Մեկնաբանություն դաշտը խմբագրվող է
        Call Check_ReadOnly("Document", Charge.tabN, "General", "COMM", False)
        ' Ստուգել Մեկնաբանություն դաշտի արժեքը
        Call Compare_Two_Values("Մեկնաբանություն", Get_Rekvizit_Value("Document", Charge.tabN, "General", "COMM"), Charge.commentForCheck)
        ' Մեկնաբանություն դաշտի լրացում
        Call Rekvizit_Fill("Document", Charge.tabN, "General", "COMM", "[Home]!" & "[End]" & "[Del]" & Charge.comment)
    End If
    
    If Charge.notGrCash Then
        If payerLegalStatus = "ֆիզԱնձ" Then
        ' Ստուգել, որ  Հաճ.պայմանագ.տվյալներ դաշտը չխմբագրվող է
            Call Check_ReadOnly("Document", Charge.tabN, "General", "AGRDETAILS", True)
            ' Ստուգել Հաճ.պայմանագ.տվյալներ դաշտի արժեքը
            Call Compare_Two_Values("Հաճ.պայմանագ.տվյալներ", Get_Rekvizit_Value("Document", Charge.tabN, "General", "AGRDETAILS"), Charge.clientAgreeData)
        Else
            ' Ստուգել, որ  Հաճ.պայմանագ.տվյալներ դաշտը խմբագրվող է
            Call Check_ReadOnly("Document", Charge.tabN, "General", "AGRDETAILS", False)
            ' Հաճ.պայմանագ.տվյալներ դաշտի լրացում
            Call Rekvizit_Fill("Document", Charge.tabN, "General", "AGRDETAILS", Charge.clientAgreeData)
        End If
    End If
    
    ' Ստուգել Գործողության ոլորտ դաշտի արժեքը
    Call Compare_Two_Values("Գործողության ոլորտ", Get_Rekvizit_Value("Document", Charge.tabN, "Mask", "VOLORT"), Charge.operAreaForCheck)
    ' Գործողության ոլորտ դաշտի լրացում
    Call Rekvizit_Fill("Document", Charge.tabN, "General", "VOLORT", Charge.operArea)
    ' Ստուգել Ոչ ռեզիդենտ նշիչի արժեքը
    Call Compare_Two_Values("Ոչ ռեզիդենտ", Get_Rekvizit_Value("Document", Charge.tabN, "CheckBox", "NONREZ"), Charge.nonResidentForCheck)
    ' Ոչ ռեզիդենտ նշիչի լրացում
    Call Rekvizit_Fill("Document", Charge.tabN, "CheckBox", "NONREZ", Charge.nonResident)
    ' Ստուգել Իրավաբանական կարգավիճակ դաշտի արժեքը
    Call Compare_Two_Values("Իրավաբանական կարգավիճակ", Get_Rekvizit_Value("Document", Charge.tabN, "Mask", "JURSTAT"), Charge.legalStatusForCheck)
    ' Իրավաբանական կարգավիճակ դաշտի լրացում
    Call Rekvizit_Fill("Document", Charge.tabN, "General", "JURSTAT", Charge.legalStatus)
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''''''''''CashIn_Coin''''''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Կնախիկ մուտք փաստաթղթի Մանրադրամ բաժնի կլաս
Class CashIn_Coin
    Public tabN
    Public coin
    Public coinForCheck
    Public coinPayCurr
    Public coinPayAcc
    Public coinExchangeRate
    Public coinCBExchangeRate
    Public coinBuyAndSell
    Public coinPayAmount
    Public coinPayAmountForCheck
    Public amountWithMainCurr
    Public amountCurrForCheck
    Public incomeOutChange
    Public damagesOutChange
    Public roundedAmount
    Public roundedAmountForCheck
    Private Sub Class_Initialize()
        tabN = 3
        coin = "0.00"
        coinForCheck = "0.00"
        coinPayCurr = ""
        coinPayAcc = ""
        coinExchangeRate = "0/0"
        coinCBExchangeRate = "0/0"
        coinBuyAndSell = ""
        coinPayAmount = "0.00"
        coinPayAmountForCheck = "0.00"
        amountWithMainCurr = "0.00"
        amountCurrForCheck = "0.00"
        incomeOutChange = ""
        damagesOutChange = ""
        roundedAmount = "0.00"
        roundedAmountForCheck = "0.00"
    End Sub
End Class

Function New_CashIn_Coin()
    Set New_CashIn_Coin = New CashIn_Coin
End Function

Sub Fill_CashIn_Coin(Coin, curr)
    If curr = "000" Then
        ' Ստուգել, որ Մանրադրամ դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Coin.tabN, "General", "XSUM", True)
        ' Ստուգել Մանրադրամ դաշտի արժեքը
        Call Compare_Two_Values("Մանրադրամ", Get_Rekvizit_Value("Document", Coin.tabN, "General", "XSUM"), "0.00")
        ' Ստուգել, որ Մանրադրամի վճարման արժույթ դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Coin.tabN, "Mask", "XCUR", True)
        ' Ստուգել Մանրադրամի վճարման արժույթ դաշտի արժեքը
        Call Compare_Two_Values("Մանրադրամի վճարման արժույթ", Get_Rekvizit_Value("Document", Coin.tabN, "Mask", "XCUR"), "") 
        ' Ստուգել, որ Մանրադրամի վճարման հաշիվ դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Coin.tabN, "Mask", "XACC", True)
        ' Ստուգել Մանրադրամի վճարման հաշիվ դաշտի արժեքը
        Call Compare_Two_Values("Մանրադրամի վճարման հաշիվ", Get_Rekvizit_Value("Document", Coin.tabN, "Mask", "XACC"), "") 
        ' Ստուգել, որ Փոխարժեք դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Coin.tabN, "Course1", "XDLCRS", True)
        ' Ստուգել Փոխարժեք դաշտի արժեքը
        Call Compare_Two_Values("Փոխարժեք", Get_Rekvizit_Value("Document", Coin.tabN, "Course", "XDLCRS"), "0/0")
        ' Ստուգել, որ ԿԲ փոխարժեք դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Coin.tabN, "Course1", "XCBCRS", True)
        ' Ստուգել ԿԲ փոխարժեք դաշտի արժեքը
        Call Compare_Two_Values("ԿԲ փոխարժեք", Get_Rekvizit_Value("Document", Coin.tabN, "Course", "XCBCRS"), "0/0")
        ' Ստուգել Առք/Վաճառք դաշտի արժեքը
        Call Compare_Two_Values("Առք/Վաճառք", Get_Rekvizit_Value("Document", Coin.tabN, "Mask", "XCUPUSA"), "") 
        ' Ստուգել, որ Մանրադրամի վճարման գումար դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Coin.tabN, "General", "XCURSUM", True)
        ' Ստուգել Մանրադրամի վճարման գումար դաշտի արժեքը
        Call Compare_Two_Values("Մանրադրամի վճարման գումար", Get_Rekvizit_Value("Document", Coin.tabN, "General", "XCURSUM"), "0.00") 
        ' Ստուգել, որ Գումար հիմնական արժույթով դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Coin.tabN, "General", "XSUMMAIN", True)
        ' Ստուգել Գումար հիմնական արժույթով դաշտի արժեքը
        Call Compare_Two_Values("Գումար հիմնական արժույթով", Get_Rekvizit_Value("Document", Coin.tabN, "General", "XSUMMAIN"), "0.00")
        ' Ստուգել, որ Եկամուտներ արտ. փոխանակումից դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Coin.tabN, "Mask", "XINC", True)
        ' Ստուգել Եկամուտներ արտ. փոխանակումից դաշտի արժեքը
        Call Compare_Two_Values("Եկամուտներ արտ. փոխանակումից", Get_Rekvizit_Value("Document", Coin.tabN, "Mask", "XINC"), "") 
        ' Ստուգել, որ Վնասներ արտ. փոխանակումից դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Coin.tabN, "Mask", "XEXP", True)
        ' Ստուգել Վնասներ արտ. փոխանակումից դաշտի արժեքը
        Call Compare_Two_Values("Վնասներ արտ. փոխանակումից", Get_Rekvizit_Value("Document", Coin.tabN, "Mask", "XEXP"), "")
        ' Ստուգել, որ  Կլորացված գումար դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Coin.tabN, "General", "ROUNDSUM", True)
        ' Ստուգել Կլորացված գումար դաշտի արժեքը
        Call Compare_Two_Values("Կլորացված գումար", Get_Rekvizit_Value("Document", Coin.tabN, "General", "ROUNDSUM"), "0.00")
    Else
        ' Մանրադրամ դաշտի լրացում
        Call Rekvizit_Fill("Document", Coin.tabN, "General", "XSUM", Coin.coin)
        If Coin.coin <> "0.00" Then
            ' Մանրադրամի վճարման արժույթ դաշտի լրացում
            Call Rekvizit_Fill("Document", Coin.tabN, "General", "XCUR", Coin.coinPayCurr)
            ' Մանրադրամի վճարման հաշիվ դաշտի լրացում
            Call Rekvizit_Fill("Document", Coin.tabN, "General", "XACC", Coin.coinPayAcc)
            ' Ստուգել Մանրադրամի վճարման գումար դաշտի արժեքը
            Call Compare_Two_Values("Մանրադրամի վճարման գումար", Get_Rekvizit_Value("Document", Coin.tabN, "General", "XCURSUM"), Coin.coinPayAmountForCheck) 
            ' Մանրադրամի վճարման գումար դաշտի լրացում
            Call Rekvizit_Fill("Document", Coin.tabN, "General", "XCURSUM", Coin.coinPayAmount)
        End If
        ' Ստուգել, որ Փոխարժեք դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Coin.tabN, "Course1", "XDLCRS", True)
        ' Ստուգել Փոխարժեք դաշտի արժեքը
        Call Compare_Two_Values("Փոխարժեք", Get_Rekvizit_Value("Document", Coin.tabN, "Course", "XDLCRS"), Coin.coinExchangeRate)
        ' Ստուգել, որ ԿԲ փոխարժեք դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Coin.tabN, "Course1", "XCBCRS", True)
        ' Ստուգել ԿԲ փոխարժեք դաշտի արժեքը
        Call Compare_Two_Values("ԿԲ փոխարժեք", Get_Rekvizit_Value("Document", Coin.tabN, "Course", "XCBCRS"), Coin.coinCBExchangeRate)
        ' Ստուգել, որ Գումար հիմնական արժույթով դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Coin.tabN, "General", "XSUMMAIN", True)
        ' Ստուգել Գումար հիմնական արժույթով դաշտի արժեքը
        Call Compare_Two_Values("Գումար հիմնական արժույթով", Get_Rekvizit_Value("Document", Coin.tabN, "General", "XSUMMAIN"), Coin.amountWithMainCurr)
        ' Ստուգել, որ Եկամուտներ արտ. փոխանակումից դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Coin.tabN, "Mask", "XINC", True)
        ' Ստուգել Եկամուտներ արտ. փոխանակումից դաշտի արժեքը
        Call Compare_Two_Values("Եկամուտներ արտ. փոխանակումից", Get_Rekvizit_Value("Document", Coin.tabN, "Mask", "XINC"), Coin.incomeOutChange) 
        ' Ստուգել, որ Վնասներ արտ. փոխանակումից դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Coin.tabN, "Mask", "XEXP", True)
        ' Ստուգել Վնասներ արտ. փոխանակումից դաշտի արժեքը
        Call Compare_Two_Values("Վնասներ արտ. փոխանակումից", Get_Rekvizit_Value("Document", Coin.tabN, "Mask", "XEXP"), Coin.damagesOutChange)
        ' Ստուգել, որ  Կլորացված գումար դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", Coin.tabN, "General", "ROUNDSUM", True)
        ' Ստուգել Կլորացված գումար դաշտի արժեքը
        Call Compare_Two_Values("Կլորացված գումար", Get_Rekvizit_Value("Document", Coin.tabN, "General", "ROUNDSUM"), Coin.roundedAmount)
    End If
    ' Ստուգել, որ Առք/Վաճառք դաշտը չխմբագրվող է
    Call Check_ReadOnly("Document", Coin.tabN, "Mask", "XCUPUSA", True)
    ' Ստուգել Առք/Վաճառք դաշտի արժեքը
    Call Compare_Two_Values("Առք/Վաճառք", Get_Rekvizit_Value("Document", Coin.tabN, "Mask", "XCUPUSA"), Coin.coinBuyAndSell)
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''''''''''''CashInput''''''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Կանխիկ մուտք փաստաթղթի կլաս
Class CashInput
    Public fIsn 
    Public commonTab 
    Public chargeTab
    Public coinTab
    Public attachedTab
    Private Sub Class_Initialize()
        fIsn = ""
        Set commonTab = New_CashIn_Common()
        Set chargeTab = New_CashIn_Charge()
        Set coinTab = New_CashIn_Coin()
        Set attachedTab = New_Attached_Tab(f_Count, l_Count, d_Count)
    End Sub
End Class

Function New_CashInput(attachedFiles, attachedLinks, deleteFiles)
    f_Count = attachedFiles
    l_Count = attachedLinks
    d_Count = deleteFiles
    Set New_CashInput = New CashInput
End Function

Sub Fill_CashInput(CashInput, button)
    Call Fill_CashIn_Common(CashInput.commonTab)
    Call Fill_CashIn_Charge(CashInput.chargeTab, CashInput.commonTab.payerLegalStatus)
    Call Fill_CashIn_Coin(CashInput.coinTab, CashInput.commonTab.curr)
    Call Fill_Attached_Tab(CashInput.attachedTab)
    Call ClickCmdButton(1, button)
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''Create_Cash_Input'''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Կանխիկի մուտք փաստաթղթի ստեղծում
' CashIn - Կանխիկի մուտք փաստաթղթի լրացման կլաս
Sub Create_Cash_Input(CashInput, button)
    BuiltIn.Delay(3000)
    Call wMainForm.MainMenu.Click(c_AllActions)
    Call wMainForm.PopupMenu.Click(c_InnerOpers &"|"& c_CashIn)
    If wMDIClient.WaitvbObject("frmASDocForm", 3000).Exists Then 
        'ISN-ի վերագրում փոփոխականին
        CashInput.fIsn = wMDIClient.vbObject("frmASDocForm").DocFormCommon.Doc.isn
        Call Fill_CashInput(CashInput, button)
    Else 
        Log.Error "Can't open frmASDocForm window.", "", pmNormal, ErrorColor 
    End If
End Sub

' Կանխիկ մուտք փաստաթղթի արժեքների ստուգում
' CashIn - Կանխիկ մուտք փաստաթղթի լրացման կլաս
Sub Check_Cash_Input(CashIn)
    Dim i
    ' Ստուգել Գրասենյակ դաշտի արժեքը
    Call Compare_Two_Values("Գրասենյակ", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "Mask", "ACSBRANCH"), CashIn.commonTab.office)
    ' Ստուգել Բաժին դաշտի արժեքը
    Call Compare_Two_Values("Բաժին", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "Mask", "ACSDEPART"), CashIn.commonTab.department)
    ' Ստուգել Փաստաթղթի N դաշտի արժեքը
    Call Compare_Two_Values("Փաստաթղթի N", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "General", "DOCNUM"), CashIn.commonTab.docNum)
    ' Ստուգել Ամսաթիվ դաշտի արժեքը
    Call Compare_Two_Values("Ամսաթիվ", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "General", "DATE"), CashIn.commonTab.dateForCheck)
    ' Ստուգել Դրամարկղ դաշտի արժեքը
    Call Compare_Two_Values("Դրամարկղ", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "Mask", "KASSA"), CashIn.commonTab.cashRegister)
    ' Ստուգել Դրամարկղի հաշիվ դաշտի արժեքը
    Call Compare_Two_Values("Դրամարկղի հաշիվ", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "Mask", "ACCDB"), CashIn.commonTab.cashRegisterAcc)
    ' Ստուգել Արժույթ դաշտի արժեքը
    Call Compare_Two_Values("Արժույթ", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "Mask", "CUR"), CashIn.commonTab.curr)
    ' Ստուգել Հաշիվ կրեդիտ դաշտի արժեքը
    Call Compare_Two_Values("Հաշիվ կրեդիտ", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "Mask", "ACCCR"), CashIn.commonTab.accCredit)
    ' Ստուգել Գումար դաշտի արժեքը
    Call Compare_Two_Values("Գումար", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "General", "SUMMA"), CashIn.commonTab.amountForCheck)
    ' Ստուգել Դրամարկղի նիշ դաշտի արժեքը
    Call Compare_Two_Values("Դրամարկղի նիշ", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "Mask", "KASSIMV"), CashIn.commonTab.cashierChar)
    ' Ստուգել Հիմք դաշտի արժեքը
    Call Compare_Two_Values("Հիմք", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "Comment", "BASE"), CashIn.commonTab.base)
    ' Ստուգել Նպատակ դաշտի արժեքը
    Call Compare_Two_Values("Նպատակ", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "Comment", "AIM"), CashIn.commonTab.aim)
    ' Ստուգել Մուծող դաշտի արժեքը
    Call Compare_Two_Values("Մուծող", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "Mask", "CLICODE"), CashIn.commonTab.payer)
    ' Ստուգել Անուն դաշտի արժեքը
    Call Compare_Two_Values("Անուն", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "Comment", "PAYER"), CashIn.commonTab.name)
    ' Ստուգել Ազգանուն դաշտի արժեքը
    Call Compare_Two_Values("Ազգանուն", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "General", "PAYERLASTNAME"), CashIn.commonTab.surname)
    ' Ստուգել Անձը հաստ. փաստթ. կոդ դաշտի արժեքը
    Call Compare_Two_Values("Անձը հաստ. փաստթ. կոդ", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "Comment", "PASSNUM"), CashIn.commonTab.idForCheck)
    ' Ստուգել Տիպ դաշտի արժեքը
    Call Compare_Two_Values("Տիպ", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "Mask", "PASTYPE"), CashIn.commonTab.idTypeForCheck)
    ' Ստուգել Տրված դաշտի արժեքը
    Call Compare_Two_Values("Տրված", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "General", "PASBY"), CashIn.commonTab.idGivenByForCheck)
    ' Ստուգել Տրված ամսաթիվ դաշտի արժեքը
    Call Compare_Two_Values("Տրված ամսաթիվ", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "General", "DATEPASS"), CashIn.commonTab.idGiveDateForCheck)
    ' Ստուգել Վավեր է մինչև դաշտի արժեքը
    Call Compare_Two_Values("Վավեր է մինչև", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "General", "DATEEXPIRE"), CashIn.commonTab.idValidUntilForCheck)
    ' Ստուգել Ծննդյան ամսաթիվ դաշտի արժեքը
    Call Compare_Two_Values("Ծննդյան ամսաթիվ", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "General", "DATEBIRTH"), CashIn.commonTab.birthDateForCheck)
    ' Ստուգել Քաղաքացիություն դաշտի արժեքը
    Call Compare_Two_Values("Քաղաքացիություն", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "Mask", "CITIZENSHIP"), CashIn.commonTab.citizenship)
    ' Ստուգել Երկիր դաշտի արժեքը
    Call Compare_Two_Values("Երկիր", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "Mask", "COUNTRY"), CashIn.commonTab.country)
    ' Ստուգել Բնակավայր դաշտի արժեքը
    Call Compare_Two_Values("Բնակավայր", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "Mask", "COMMUNITY"), CashIn.commonTab.residence)
    ' Ստուգել Քաղաք դաշտի արժեքը
    Call Compare_Two_Values("Քաղաք", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "General", "CITY"), CashIn.commonTab.city)
    ' Ստուգել Բնակարան դաշտի արժեքը
    Call Compare_Two_Values("Բնակարան", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "General", "APARTMENT"), CashIn.commonTab.apartment)
    ' Ստուգել Փողոց դաշտի արժեքը
    Call Compare_Two_Values("Փողոց", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "General", "ADDRESS"), CashIn.commonTab.street)
    ' Ստուգել Տուն/Շենք դաշտի արժեքը
    Call Compare_Two_Values("Տուն/Շենք", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "General", "BUILDNUM"), CashIn.commonTab.house)
    ' Ստուգել Էլ հասցե դաշտի արժեքը
    Call Compare_Two_Values("Էլ հասցե", Get_Rekvizit_Value("Document", CashIn.commonTab.tabN, "General", "EMAIL"), CashIn.commonTab.emailForCheck)
    
    ' Ստուգել Գրասենյակ դաշտի արժեքը
    Call Compare_Two_Values("Գրասենյակ", Get_Rekvizit_Value("Document", CashIn.chargeTab.tabN, "Mask", "ACSBRANCHINC"), CashIn.chargeTab.office)
    ' Ստուգել Բաժին դաշտի արժեքը
    Call Compare_Two_Values("Բաժին", Get_Rekvizit_Value("Document", CashIn.chargeTab.tabN, "Mask", "ACSDEPARTINC"), CashIn.chargeTab.department)
    ' Ստուգել Գանձման հաշիվ դաշտի արժեքը
    Call Compare_Two_Values("Գանձման հաշիվ", Get_Rekvizit_Value("Document", CashIn.chargeTab.tabN, "Mask", "CHRGACC"), CashIn.chargeTab.chargeAcc)
    ' Ստուգել Արժույթ դաշտի արժեքը
    Call Compare_Two_Values("Արժույթ", Get_Rekvizit_Value("Document", CashIn.chargeTab.tabN, "Mask", "CHRGCUR"), CashIn.chargeTab.chargeCurrForCheck)
    ' Ստուգել ԿԲ փոխարժեք դաշտի արժեքը
    Call Compare_Two_Values("ԿԲ փոխարժեք", Get_Rekvizit_Value("Document", CashIn.chargeTab.tabN, "Course", "CHRGCBCRS"), CashIn.chargeTab.cbExchangeRate)
    ' Ստուգել Գանձման տեսակ դաշտի արժեքը
    Call Compare_Two_Values("Գանձման տեսակ", Get_Rekvizit_Value("Document", CashIn.chargeTab.tabN, "Mask", "PAYSCALE"), CashIn.chargeTab.chargeType)
    ' Ստուգել Գումար դաշտի արժեքը
    Call Compare_Two_Values("Գումար_2", Get_Rekvizit_Value("Document", CashIn.chargeTab.tabN, "General", "CHRGSUM"), CashIn.chargeTab.chargeAmoForCheck) 
    ' Ստուգել Տոկոս դաշտի արժեքը
    Call Compare_Two_Values("Տոկոս", Get_Rekvizit_Value("Document", CashIn.chargeTab.tabN, "General", "PRSNT"), CashIn.chargeTab.chargePerForCheck) 
    ' Ստուգել Եկամտի հաշիվ դաշտի արժեքը
    Call Compare_Two_Values("Եկամտի հաշիվ", Get_Rekvizit_Value("Document", CashIn.chargeTab.tabN, "Mask", "CHRGINC"), CashIn.chargeTab.incomeAcc) 
    ' Ստուգել Առք/Վաճառք դաշտի արժեքը
    Call Compare_Two_Values("Առք/Վաճառք", Get_Rekvizit_Value("Document", CashIn.chargeTab.tabN, "Mask", "CUPUSA"), CashIn.chargeTab.buyAndSellForCheck) 
    ' Ստուգել Գործողության տեսակ դաշտի արժեքը
    Call Compare_Two_Values("Գործողության տեսակ", Get_Rekvizit_Value("Document", CashIn.chargeTab.tabN, "Mask", "CURTES"), CashIn.chargeTab.operType)
    ' Ստուգել Գործողության վայր դաշտի արժեքը
    Call Compare_Two_Values("Գործողության վայր", Get_Rekvizit_Value("Document", CashIn.chargeTab.tabN, "Mask", "CURVAIR"), CashIn.chargeTab.operPlace)
    ' Ստուգել Ժամանակ դաշտի արժեքը
    Call Compare_Two_Values("Ժամանակ", Get_Rekvizit_Value("Document", CashIn.chargeTab.tabN, "Mask", "TIME"), CashIn.chargeTab.timeForCheck)
    ' Ստուգել Գործողության ոլորտ դաշտի արժեքը
    Call Compare_Two_Values("Գործողության ոլորտ", Get_Rekvizit_Value("Document", CashIn.chargeTab.tabN, "Mask", "VOLORT"), CashIn.chargeTab.operAreaForCheck)
    ' Ստուգել Ոչ ռեզիդենտ դաշտի արժեքը
    Call Compare_Two_Values("Ոչ ռեզիդենտ", Get_Rekvizit_Value("Document", CashIn.chargeTab.tabN, "CheckBox", "NONREZ"), CashIn.chargeTab.nonResidentForCheck)
    ' Ստուգել Իրավաբանական կարգավիճակ դաշտի արժեքը
    Call Compare_Two_Values("Իրավաբանական կարգավիճակ", Get_Rekvizit_Value("Document", CashIn.chargeTab.tabN, "Mask", "JURSTAT"), CashIn.chargeTab.legalStatusForCheck)
    ' Ստուգել Մեկնաբանություն դաշտի արժեքը
    Call Compare_Two_Values("Մեկնաբանություն", Get_Rekvizit_Value("Document", CashIn.chargeTab.tabN, "General", "COMM"), CashIn.chargeTab.commentForCheck)
    ' Ստուգել Հաճ.պայմանագ.տվյալներ դաշտի արժեքը
    Call Compare_Two_Values("Հաճ.պայմանագ.տվյալներ", Get_Rekvizit_Value("Document", CashIn.chargeTab.tabN, "General", "AGRDETAILS"), CashIn.chargeTab.clientAgreeData)

    ' Ստուգել Մանրադրամ դաշտի արժեքը
    Call Compare_Two_Values("Մանրադրամ", Get_Rekvizit_Value("Document", CashIn.coinTab.tabN, "General", "XSUM"), CashIn.coinTab.coinForCheck)
    ' Ստուգել Մանրադրամի վճարման արժույթ դաշտի արժեքը
    Call Compare_Two_Values("Մանրադրամի վճարման արժույթ", Get_Rekvizit_Value("Document", CashIn.coinTab.tabN, "Mask", "XCUR"), CashIn.coinTab.coinPayCurr) 
    ' Ստուգել Մանրադրամի վճարման հաշիվ դաշտի արժեքը
    Call Compare_Two_Values("Մանրադրամի վճարման հաշիվ", Get_Rekvizit_Value("Document", CashIn.coinTab.tabN, "Mask", "XACC"), CashIn.coinTab.coinPayAcc) 
    ' Ստուգել Փոխարժեք դաշտի արժեքը
    Call Compare_Two_Values("Փոխարժեք", Get_Rekvizit_Value("Document", CashIn.coinTab.tabN, "Course", "XDLCRS"), CashIn.coinTab.coinExchangeRate)
    ' Ստուգել ԿԲ փոխարժեք դաշտի արժեքը
    Call Compare_Two_Values("ԿԲ փոխարժեք", Get_Rekvizit_Value("Document", CashIn.coinTab.tabN, "Course", "XCBCRS"), CashIn.coinTab.coinCBExchangeRate) 
    ' Ստուգել Առք/Վաճառք դաշտի արժեքը
    Call Compare_Two_Values("Առք/Վաճառք", Get_Rekvizit_Value("Document", CashIn.coinTab.tabN, "Mask", "XCUPUSA"), CashIn.coinTab.coinBuyAndSell) 
    ' Ստուգել Մանրադրամի վճարման գումար դաշտի արժեքը
    Call Compare_Two_Values("Մանրադրամի վճարման գումար", Get_Rekvizit_Value("Document", CashIn.coinTab.tabN, "General", "XCURSUM"), CashIn.coinTab.coinPayAmountForCheck) 
    ' Ստուգել Գումար հիմնական արժույթով դաշտի արժեքը
    Call Compare_Two_Values("Գումար հիմնական արժույթով", Get_Rekvizit_Value("Document", CashIn.coinTab.tabN, "General", "XSUMMAIN"), CashIn.coinTab.amountCurrForCheck)
    ' Ստուգել Եկամուտներ արտ. փոխանակումից դաշտի արժեքը
    Call Compare_Two_Values("Եկամուտներ արտ. փոխանակումից", Get_Rekvizit_Value("Document", CashIn.coinTab.tabN, "Mask", "XINC"), CashIn.coinTab.incomeOutChange) 
    ' Ստուգել Վնասներ արտ. փոխանակումից դաշտի արժեքը
    Call Compare_Two_Values("Վնասներ արտ. փոխանակումից", Get_Rekvizit_Value("Document", CashIn.coinTab.tabN, "Mask", "XEXP"), CashIn.coinTab.damagesOutChange)
    ' Ստուգել Կլորացված գումար դաշտի արժեքը
    Call Compare_Two_Values("Կլորացված գումար", Get_Rekvizit_Value("Document", CashIn.coinTab.tabN, "General", "ROUNDSUM"), CashIn.coinTab.roundedAmountForCheck) 
    
    Call GoTo_ChoosedTab(CashIn.attachedTab.tabN)
    ' Ստուգել, որ ֆայլերը առկա են
    For i = 0 To CashIn.attachedTab.filesCount - 1
        If Not SearchInAttachList (CashIn.attachedTab.fileName(i), CashIn.attachedTab.tabN) Then
           Log.Error "Can't find searched " & CashIn.attachedTab.addFiles(i) & " row.", "", pmNormal, ErrorColor
        End If
    Next
    For i = 0 To CashIn.attachedTab.linksCount - 1
        If Not SearchInAttachList (CashIn.attachedTab.addLinks(i), CashIn.attachedTab.tabN) Then
           Log.Error "Can't find searched " & CashIn.attachedTab.addLinks(i) & " row.", "", pmNormal, ErrorColor
        End If
    Next
End Sub

' Կանխիկ մուտք փաստաթղթի խմբագրում
' OldCashIn - հին Կանխիկ մուտք փաստաթղթի լրացման կլաս
' EditCashIN - նոր Կանխիկ մուտք փաստաթղթի լրացման կլաս
Sub Edit_Cash_Input(OldCashIn, EditCashIN, button)
    BuiltIn.Delay(3000)
    Call wMainForm.MainMenu.Click(c_AllActions)
    Call wMainForm.PopupMenu.Click(c_ToEdit)
    If wMDIClient.WaitvbObject("frmASDocForm", 3000).Exists Then 
        Call Check_Cash_Input(OldCashIn)
        EditCashIN.fIsn = OldCashIn.fIsn
        EditCashIN.commonTab.DocNum = OldCashIn.commonTab.DocNum
        Call GoTo_ChoosedTab(OldCashIn.commonTab.tabN)
        Call Fill_CashInput(EditCashIN, button)
    Else 
        Log.Error "Can't open frmASDocForm window.", "", pmNormal, ErrorColor 
    End If
End Sub


' Խմբային կանխիկ մուտք փաստաթղթի  Ընդհանուր բաժնի լրացման կլասս
' payerLegalStatus - ատանում է հաճախորդի իրավաբանական կարգավիճակը
Class  Group_CashIn_Common

     Public tabN    
     Public docNum  
     Public wOffice
     Public wDepartment
     Public wDate
     Public cashRegister
     Public cashRegisterAcc
     Public wCurr
     Public cashierChar
     Public wBase
     Public gridRowCount
     Public wAcc()
     Public wSum()
     Public wAim()
     Public wPayer
     Public wName
     Public surName
     Public wId
     Public wIdCheck
     Public wEmailCheck
     Public idType
     Public idGivenBy
     Public idGiveDateForCheck
     Public idValidUntilForCheck
     Public birthDateForCheck
     Public wCitizenship
     Public wCountry
     Public wResidence
     Public wCity
     Public wApartment
     Public wStreet
     Public wHouse
     Public wEmail
     Public wBirthDate
     Public idGiveDate
     Public idTypeCheck
     Public idGivenByCheck
     Public idValidUntil
     Public payerLegalStatus
     
     Private Sub Class_Initialize
          tabN = 1
          docNum = ""
          wOffice = ""
          wDepartment = ""
          wDate = ""
          cashRegister = ""
          cashRegisterAcc = ""
          wCurr = ""
          cashierChar = ""
          wBase = ""
          gridRowCount = rowCount
          ReDim wAcc(gridRowCount)
          ReDim wSum(gridRowCount)
          ReDim wAim(gridRowCount)
          wPayer = ""
          wName = ""
          surName = ""
          wIdCheck = ""
          wEmailCheck = ""
          wId = ""
          idType = ""
          idTypeCheck = ""
          idGivenBy = ""
          idGiveDateForCheck = "/ /"
          idValidUntilForCheck = "/ /"
          birthDateForCheck = "/ /"
          wCitizenship = ""
          wCountry = ""
          wResidence = ""
          wCity = ""
          wApartment = ""
          wStreet = ""
          wHouse = ""
          wEmail = ""
          wBirthDate = ""
          idGiveDate = ""
          idGivenByCheck = ""
          idValidUntil = ""
          payerLegalStatus = ""
     End Sub

End Class

Function New_Group_CashIn_Common()
         Set New_Group_CashIn_Common = New Group_CashIn_Common
End Function

' Խմբային կանխիկ մուտք փաստաթղթի  Ընդհանուր բաժնի լրացման պրոցեդուրա
Sub Fill_Group_CashIn_Common(General)
     Dim i 
    'Գրասենյակ դաշտի լրացում
    Call Rekvizit_Fill("Document", General.tabN, "General", "ACSBRANCH", General.wOffice)
    'Բաժին դաշտի լրացում
    Call Rekvizit_Fill("Document", General.tabN, "General", "ACSDEPART", General.wDepartment)
    'Փաստաթղթի N դաշտի արժեքի վերագրում փոփոխականին
    General.docNum = Get_Rekvizit_Value("Document", General.tabN, "General", "DOCNUM")
    'Ամսաթիվ դաշտի լրացում
    Call Rekvizit_Fill("Document", General.tabN, "General", "DATE", "^A[Del]" & General.wDate)
    'Դրամարկղ դաշտի լրացում
    Call Rekvizit_Fill("Document", General.tabN, "General", "KASSA", "^A[Del]" & General.cashRegister)
    'Դրամարկղի հաշիվ դաշտի լրացում
    Call Rekvizit_Fill("Document", General.tabN, "General", "ACCDB", General.cashRegisterAcc)
    ' Ստուգել, որ Արժույթ դաշտը չխմբագրվող է
    Call Check_ReadOnly("Document", General.tabN, "Mask", "CUR", True)
    ' Ստուգել Արժույթ դաշտի արժեքը
    Call Compare_Two_Values("Արժույթ", Get_Rekvizit_Value("Document", General.tabN, "Mask", "CUR"), General.wCurr)
    'Դրամարկղի նիշ դաշտի լրացում
    Call Rekvizit_Fill("Document", General.tabN, "General", "KASSIMV", General.cashierChar)
    'Հիմք դաշտի լրացում
    Call Rekvizit_Fill("Document", General.tabN, "General", "BASE", "[Home]!" & "[End]" & "[Del]" & General.wBase)
    
    ' Լրացնել Գրիդը
    For  i = 0 To General.gridRowCount - 1 
           With wMDIClient.VBObject("frmASDocForm").VBObject("TabFrame").VBObject("DocGrid")
               ' Հաշիվ դաշտի լրացում
              .Row = i
              .Col = 0
              .Keys(General.wAcc(i) & "[Enter]")
              ' Գումար դաշտի լրացում
              .Col = 1
              .Keys(General.wSum(i) & "[Enter]")
              ' Նպատակ դաշտի լրացում
              .Col = 2
              .Keys(General.wAim(i) & "[Enter]" ) 
              
              If i = General.gridRowCount - 1  Then

              .MoveLast
              If Trim(.Columns.Item(General.gridRowCount - 1).Value) = "" Then
                 .Keys("^[D]")
              End If  
           End If
           
           
           End With 
    Next
    'Մուծող դաշտի լրացում
    Call Rekvizit_Fill("Document", General.tabN, "General", "CLICODE", General.wPayer)
    If General.payerLegalStatus = "ֆիզԱնձ" Then
        ' Ստուգել, որ Անուն դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", General.tabN, "Comment", "PAYER", True)
        ' Ստուգել Անուն դաշտի արժեքը
        Call Compare_Two_Values("Անուն", Get_Rekvizit_Value("Document", General.tabN, "Comment", "PAYER"), General.wName)
        ' Ստուգել, որ Ազգանուն դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", General.tabN, "General", "PAYERLASTNAME", True)
        ' Ստուգել Ազգանուն դաշտի արժեքը
        Call Compare_Two_Values("Ազգանուն", Get_Rekvizit_Value("Document", General.tabN, "General", "PAYERLASTNAME"), General.surName)
        ' Ստուգել Անձը հաստ. փաստթ. կոդ դաշտի արժեքը
        Call Compare_Two_Values("Անձը հաստ. փաստթ. կոդ", Get_Rekvizit_Value("Document", General.tabN, "Comment", "PASSNUM"), General.wIdCheck)
        ' Ստուգել Տիպ դաշտի արժեքը
        Call Compare_Two_Values("Տիպ", Get_Rekvizit_Value("Document", General.tabN, "Mask", "PASTYPE"), General.idTypeCheck)
        ' Ստուգել Տրված դաշտի արժեքը
        Call Compare_Two_Values("Տրված", Get_Rekvizit_Value("Document", General.tabN, "General", "PASBY"), General.idGivenByCheck)
        ' Ստուգել Տրված ամսաթիվ դաշտի արժեքը
        Call Compare_Two_Values("Տրված ամսաթիվ", Get_Rekvizit_Value("Document", General.tabN, "General", "DATEPASS"), General.idGiveDateForCheck)
        ' Ստուգել Վավեր է մինչև դաշտի արժեքը
        Call Compare_Two_Values("Վավեր է մինչև", Get_Rekvizit_Value("Document", General.tabN, "General", "DATEEXPIRE"), General.idValidUntilForCheck)
        ' Ստուգել, որ Ծննդյան ամսաթիվ դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", General.tabN, "General", "DATEBIRTH", True)
        ' Ստուգել Ծննդյան ամսաթիվ դաշտի արժեքը
        Call Compare_Two_Values("Ծննդյան ամսաթիվ", Get_Rekvizit_Value("Document", General.tabN, "General", "DATEBIRTH"), General.birthDateForCheck)
        ' Ստուգել, որ Քաղաքացիություն դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", General.tabN, "Mask", "CITIZENSHIP", True)
        ' Ստուգել Քաղաքացիություն դաշտի արժեքը
        Call Compare_Two_Values("Քաղաքացիություն", Get_Rekvizit_Value("Document", General.tabN, "Mask", "CITIZENSHIP"), General.wCitizenship)
        ' Ստուգել, որ Երկիր դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", General.tabN, "Mask", "COUNTRY", True)
        ' Ստուգել Երկիր դաշտի արժեքը
        Call Compare_Two_Values("Երկիր", Get_Rekvizit_Value("Document", General.tabN, "Mask", "COUNTRY"), General.wCountry)
        ' Ստուգել, որ Բնակավայր դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", General.tabN, "Mask", "COMMUNITY", True)
        ' Ստուգել Բնակավայր դաշտի արժեքը
        Call Compare_Two_Values("Բնակավայր", Get_Rekvizit_Value("Document", General.tabN, "Mask", "COMMUNITY"), General.wResidence)
        ' Ստուգել, որ Քաղաք դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", General.tabN, "General", "CITY", True)
        ' Ստուգել Քաղաք դաշտի արժեքը
        Call Compare_Two_Values("Քաղաք", Get_Rekvizit_Value("Document", General.tabN, "General", "CITY"), General.wCity)
        ' Ստուգել, որ Բնակարան դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", General.tabN, "General", "APARTMENT", True)
        ' Ստուգել Բնակարան դաշտի արժեքը
        Call Compare_Two_Values("Բնակարան", Get_Rekvizit_Value("Document", General.tabN, "General", "APARTMENT"), General.wApartment)
        ' Ստուգել, որ Փողոց դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", General.tabN, "General", "ADDRESS", True)
        ' Ստուգել Փողոց դաշտի արժեքը
        Call Compare_Two_Values("Փողոց", Get_Rekvizit_Value("Document", General.tabN, "General", "ADDRESS"), General.wStreet)
        ' Ստուգել, որ Տուն/Շենք դաշտը չխմբագրվող է
        Call Check_ReadOnly("Document", General.tabN, "General", "BUILDNUM", True)
        ' Ստուգել Տուն/Շենք դաշտի արժեքը
        Call Compare_Two_Values("Տուն/Շենք", Get_Rekvizit_Value("Document", General.tabN, "General", "BUILDNUM"), General.wHouse)
        ' Ստուգել Էլ հասցե դաշտի արժեքը
        Call Compare_Two_Values("Էլ հասցե", Get_Rekvizit_Value("Document", General.tabN, "General", "EMAIL"), General.wEmailCheck)
    Else
        'Անուն դաշտի լրացում
        Call Rekvizit_Fill("Document", General.tabN, "General", "PAYER", "![End][Del]" & General.wName)
        'Ազգանուն դաշտի լրացում
        Call Rekvizit_Fill("Document", General.tabN, "General", "PAYERLASTNAME", "![End][Del]" & General.surName)
        'Ծննդյան ամսաթիվ դաշտի լրացում
        Call Rekvizit_Fill("Document", General.tabN, "General", "DATEBIRTH", General.wBirthDate)
        'Քաղաքացիություն դաշտի լրացում
        Call Rekvizit_Fill("Document", General.tabN, "General", "CITIZENSHIP", General.wCitizenship)
        'Երկիր դաշտի լրացում
        Call Rekvizit_Fill("Document", General.tabN, "General", "COUNTRY", General.wCountry)
        'Բնակավայր դաշտի լրացում
        Call Rekvizit_Fill("Document", General.tabN, "General", "COMMUNITY", "[Home]!" & "[End]" & "[Del]" & General.wResidence)
        'Քաղաք դաշտի լրացում
        Call Rekvizit_Fill("Document", General.tabN, "General", "CITY", "[Home]!" & "[End]" & "[Del]" & General.wCity)   
        'Բնակարան դաշտի լրացում
        Call Rekvizit_Fill("Document", General.tabN, "General", "APARTMENT", "[Home]!" & "[End]" & "[Del]" & General.wApartment) 
        'Փողոց դաշտի լրացում
        Call Rekvizit_Fill("Document", General.tabN, "General", "ADDRESS", "[Home]!" & "[End]" & "[Del]" & General.wStreet)
        'Տուն/Շենք դաշտի լրացում
        Call Rekvizit_Fill("Document", General.tabN, "General", "BUILDNUM", General.wHouse)
    End If
    
    'Անձը հաստ. փաստ դաշտի լրացում
    Call Rekvizit_Fill("Document", General.tabN, "General", "PASSNUM", "[Home]!" & "[End]" & "[Del]" & General.wId)
    'Տիպ դաշտի լրացում
    Call Rekvizit_Fill("Document", General.tabN, "General", "PASTYPE", General.idType)
    'Տրված դաշտի լրացում
    Call Rekvizit_Fill("Document", General.tabN, "General", "PASBY", General.idGivenBy)
    'Տրված ամսաթիվ դաշտի լրացում
    Call Rekvizit_Fill("Document", General.tabN, "General", "DATEPASS", General.idGiveDate)
    'Վավեր է մինչև դաշտի լրացում
    Call Rekvizit_Fill("Document", General.tabN, "General", "DATEEXPIRE", General.idValidUntil) 
    'Էլ հասցե դաշտի լրացում
    Call Rekvizit_Fill("Document", General.tabN, "General", "EMAIL", "[Home]!" & "[End]" & "[Del]" & General.wEmail)
       
End Sub



' Խմբային Կանխիկ մուտք փաստաթղթի կլաս
Class GroupCashInput
    Public fIsn 
    Public generalTab 
    Public chargeTab
    Public coinTab
    Public attachedTab
    Private Sub Class_Initialize()
        fIsn = ""
        Set generalTab = New_Group_CashIn_Common()
        Set chargeTab = New_CashIn_Charge()
        Set coinTab = New_CashIn_Coin()
        Set attachedTab = New_Attached_Tab(f_Count, l_Count, d_Count)
    End Sub
End Class

Function New_GroupCashInput(rowCountGrid, attachedFiles, attachedLinks, deleteFiles)
         rowCount = rowCountGrid
         f_Count = attachedFiles
         l_Count = attachedLinks
         d_Count = deleteFiles
         Set New_GroupCashInput = New GroupCashInput
End Function

Sub Fill_GroupCashInput(grCashInput, button)

    Call Fill_Group_CashIn_Common(GrCashInput.generalTab)
    Call Fill_CashIn_Charge(GrCashInput.chargeTab, grCashInput.generalTab.payerLegalStatus)
    Call Fill_CashIn_Coin(GrCashInput.coinTab, GrCashInput.generalTab.wCurr)
    Call Fill_Attached_Tab(GrCashInput.attachedTab)
    Call ClickCmdButton(1, button)
End Sub


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''Create_GroupCash_Input'''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Խմբային Կանխիկի մուտք փաստաթղթի ստեղծում
' GroupCashInput - Խմբային Կանխիկի մուտք փաստաթղթի լրացման կլաս
Sub Create_Group_Cash_Input(GrCashInput, button)
    BuiltIn.Delay(3000)
    Call wMainForm.MainMenu.Click(c_AllActions)
    Call wMainForm.PopupMenu.Click(c_InnerOpers &"|"& c_PkCashOrd)
    If wMDIClient.WaitvbObject("frmASDocForm", 3000).Exists Then 
        'ISN-ի վերագրում փոփոխականին
        GrCashInput.fIsn = wMDIClient.vbObject("frmASDocForm").DocFormCommon.Doc.isn
        Call Fill_GroupCashInput(GrCashInput, button)
    Else 
        Log.Error "Can't open frmASDocForm window.", "", pmNormal, ErrorColor 
    End If
End Sub


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''Create_GroupCash_Input_Next'''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Խմբային Կանխիկի մուտք փաստաթղթի ստեղծում (Հաջորդը)
' GroupCashInput - Խմբային Կանխիկի մուտք փաստաթղթի լրացման կլաս
Sub Create_Group_Cash_Input_Next(folderDirect, GrCashInput, button)
    BuiltIn.Delay(3000)
    Call wTreeView.DblClickItem(folderDirect)   
    If wMDIClient.WaitvbObject("frmASDocForm", 3000).Exists Then 
        'ISN-ի վերագրում փոփոխականին
        GrCashInput.fIsn = wMDIClient.vbObject("frmASDocForm").DocFormCommon.Doc.isn
        Call Fill_GroupCashInput(GrCashInput, button)
    Else 
        Log.Error "Can't open frmASDocForm window.", "", pmNormal, ErrorColor 
    End If
End Sub


' Հաշվի ավելացում Դրամարկղում
Class Add_Acc_Into_Cassa

        Public folderDirect
        Public folderName
        Public cassaIsn
        Public addedRowCount
        Public wCur()
        Public accDbt()
        Public wPreferred()
        Public arr()
        Public count
        Public wCode
        Public wName
        Public eName
        Public wParent
        Public wATM
        Public wPOS
        Sub  Class_Initialize()
              folderDirect = ""
              folderName = "|¸ñ³Ù³ñÏÕ»ñ|00  00                                      |000 ´áÉáñ ¹ñ³Ù³ñÏÕ»ñ|001 ÀÝÑ³Ýáõñ ¹ñ³Ù³ñÏÕ"
              cassaIsn = ""
              addedRowCount = rowCountNum
              ReDim wCur(addedRowCount)
              ReDim accDbt(addedRowCount)
              ReDim wPreferred(addedRowCount)
              count = cassaDirCount
              ReDim arr(count)
              wCode = ""
              wName = ""
              eName = ""
              wParent = ""
              wATM = False
              wPOS = ""
        End Sub
      
End Class


Function New_Add_Acc_Into_Cassa(cassaDirect, countNum)
         rowCountNum = countNum
         cassaDirCount = cassaDirect
         Set New_Add_Acc_Into_Cassa = New Add_Acc_Into_Cassa
End Function

' Հաշվի ավելացում Դրամարկղում
Sub Fill_Add_Acc_Into_Cassa(AddIntoCassa)

        Dim rowCount, control, i
        Call wTreeView.DblClickItem(AddIntoCassa.folderDirect)   

        If Not  Find_Tree_Element(AddIntoCassa.count, AddIntoCassa.arr) Then
           Log.Error(arr(i) & " Row dosn't found")
           Exit Sub
        End If
        
        If wMDIClient.WaitVBObject("frmASDocForm",4000).Exists Then
           AddIntoCassa.cassaIsn = wMDIClient.vbObject("frmASDocForm").DocFormCommon.Doc.isn
           ' Կոդ դաշտի լրացում
           Call Rekvizit_Fill("Document", 1, "General", "CODE", AddIntoCassa.wCode) 
           ' Անվանում դաշտի լրացում
           Call Rekvizit_Fill("Document", 1, "General", "NAME", AddIntoCassa.wName) 
           ' Անգլերեն անվանում դաշտի լրացում
           Call Rekvizit_Fill("Document", 1, "General", "ENAME", AddIntoCassa.eName) 
           ' Կուտակիչ դաշտի լրացում
           Call Rekvizit_Fill("Document", 1, "General", "PARENT", AddIntoCassa.wParent) 
           ' Բանկոմատ  դաշտի լրացում
           Call Rekvizit_Fill("Document", 1, "CheckBox", "ATM", AddIntoCassa.wATM) 
           ' ԱՄԿ(POS) դաշտի լրացում
           Call Rekvizit_Fill("Document", 1, "General", "POS", AddIntoCassa.wPOS) 
           
           
           rowCount = wMDIClient.VBObject("frmASDocForm").VBObject("TabFrame").VBObject("DocGrid").ApproxCount

           For  i = 0 To AddIntoCassa.addedRowCount-1
                   With wMDIClient.VBObject("frmASDocForm").VBObject("TabFrame").VBObject("DocGrid")
                       ' Արժույթ դաշտի լրացում
                      .Row = rowCount + 1
                      .Col = 0
                      .Keys(AddIntoCassa.wCur(i) & "[Enter]")
                      ' Հաշիվ  դաշտի լրացում
                      .Col = 1
                      .Keys(AddIntoCassa.accDbt(i) & "[Enter]")
                      ' Նախընտրելի դաշտի լրացում
                      .Col = 2
                      .Keys(AddIntoCassa.wPreferred(i) & "[Enter]")
                       rowCount = rowCount + 1
                   End With 
            Next
        Else
           Log.Error("Դրամարկղ թաստաթուղթը չի բացվել")
        End If
        Call ClickCmdButton(1, "Î³ï³ñ»É")
End Sub


' Խմբային Կանխիկ մուտք փաստաթղթի արժեքների ստուգում
' CashIn - Խմբային Կանխիկ մուտք փաստաթղթի լրացման կլաս
Sub Check_Group_Cash_Input(grCashIn)
    Dim i
    ' Ստուգել Գրասենյակ դաշտի արժեքը
    Call Compare_Two_Values("Գրասենյակ", Get_Rekvizit_Value("Document", grCashIn.generalTab.tabN, "Mask", "ACSBRANCH"), grCashIn.generalTab.wOffice)
    ' Ստուգել Բաժին դաշտի արժեքը
    Call Compare_Two_Values("Բաժին", Get_Rekvizit_Value("Document", grCashIn.generalTab.tabN, "Mask", "ACSDEPART"), grCashIn.generalTab.wDepartment)
    ' Ստուգել Փաստաթղթի N դաշտի արժեքը
    Call Compare_Two_Values("Փաստաթղթի N", Get_Rekvizit_Value("Document", grCashIn.generalTab.tabN, "General", "DOCNUM"), grCashIn.generalTab.docNum)
    ' Ստուգել Ամսաթիվ դաշտի արժեքը
    Call Compare_Two_Values("Ամսաթիվ", Get_Rekvizit_Value("Document", grCashIn.generalTab.tabN, "General", "DATE"), grCashIn.generalTab.wDate)
    ' Ստուգել Դրամարկղ դաշտի արժեքը
    Call Compare_Two_Values("Դրամարկղ", Get_Rekvizit_Value("Document", grCashIn.generalTab.tabN, "Mask", "KASSA"), grCashIn.generalTab.cashRegister)
    ' Ստուգել Դրամարկղի հաշիվ դաշտի արժեքը
    Call Compare_Two_Values("Դրամարկղի հաշիվ", Get_Rekvizit_Value("Document", grCashIn.generalTab.tabN, "Mask", "ACCDB"), grCashIn.generalTab.cashRegisterAcc)
    ' Ստուգել Արժույթ դաշտի արժեքը
    Call Compare_Two_Values("Արժույթ", Get_Rekvizit_Value("Document", grCashIn.generalTab.tabN, "Mask", "CUR"), grCashIn.generalTab.wCurr)
    
    ' Ստուգել Դրամարկղի նիշ դաշտի արժեքը
    Call Compare_Two_Values("Դրամարկղի նիշ", Get_Rekvizit_Value("Document", grCashIn.generalTab.tabN, "Mask", "KASSIMV"), grCashIn.generalTab.cashierChar)
    ' Ստուգել Հիմք դաշտի արժեքը
    Call Compare_Two_Values("Հիմք", Get_Rekvizit_Value("Document", grCashIn.generalTab.tabN, "Comment", "BASE"), grCashIn.generalTab.wBase)
    
    
    For i = 0 to grCashIn.generalTab.gridRowCount - 1
        ' Հաշիվ  դաշտերի ստուգում
        If Not Check_Value_Grid(0 , i, "Document", grCashIn.generalTab.tabN, grCashIn.generalTab.wAcc(i)) Then
               Log.Error "Գրիդի " & i & " տողի հաշվ դաշտի արժեքը սխալ է " ,,,ErrorColor
        End If
        ' Գումար դաշտի ստուգում
        If Not Check_Value_Grid(1 , i, "Document", grCashIn.generalTab.tabN, grCashIn.generalTab.wSum(i)) Then 
               Log.Error "Գրիդի " & i & " տողի գումար դաշտի արժեքը սխալ է ",,,ErrorColor
        End If
        ' Նպատակ դաշտի ստուգում
        If Not Check_Value_Grid(2 , i, "Document", grCashIn.generalTab.tabN, grCashIn.generalTab.wAim(i)) Then 
               Log.Error "Գրիդի " & i & " տողի նպատակ դաշտի արժեքը սխալ է ",,,ErrorColor
        End If
    Next      
    
    ' Ստուգել Մուծող դաշտի արժեքը
    Call Compare_Two_Values("Մուծող", Get_Rekvizit_Value("Document", grCashIn.generalTab.tabN, "Mask", "CLICODE"), grCashIn.generalTab.wPayer)
    ' Ստուգել Անուն դաշտի արժեքը
    Call Compare_Two_Values("Անուն", Get_Rekvizit_Value("Document", grCashIn.generalTab.tabN, "Comment", "PAYER"), grCashIn.generalTab.wName)
    ' Ստուգել Ազգանուն դաշտի արժեքը
    Call Compare_Two_Values("Ազգանուն", Get_Rekvizit_Value("Document", grCashIn.generalTab.tabN, "General", "PAYERLASTNAME"), grCashIn.generalTab.surName)
    ' Ստուգել Անձը հաստ. փաստթ. կոդ դաշտի արժեքը
    Call Compare_Two_Values("Անձը հաստ. փաստթ. կոդ", Get_Rekvizit_Value("Document", grCashIn.generalTab.tabN, "Comment", "PASSNUM"), grCashIn.generalTab.wId)
    ' Ստուգել Տիպ դաշտի արժեքը
    Call Compare_Two_Values("Տիպ", Get_Rekvizit_Value("Document", grCashIn.generalTab.tabN, "Mask", "PASTYPE"), grCashIn.generalTab.idType)
    ' Ստուգել Տրված դաշտի արժեքը
    Call Compare_Two_Values("Տրված", Get_Rekvizit_Value("Document", grCashIn.generalTab.tabN, "General", "PASBY"), grCashIn.generalTab.idGivenBy)
    ' Ստուգել Տրված ամսաթիվ դաշտի արժեքը
    Call Compare_Two_Values("Տրված ամսաթիվ", Get_Rekvizit_Value("Document", grCashIn.generalTab.tabN, "General", "DATEPASS"), grCashIn.generalTab.idGiveDate)
    ' Ստուգել Վավեր է մինչև դաշտի արժեքը
    Call Compare_Two_Values("Վավեր է մինչև", Get_Rekvizit_Value("Document", grCashIn.generalTab.tabN, "General", "DATEEXPIRE"), grCashIn.generalTab.idValidUntil)
    ' Ստուգել Ծննդյան ամսաթիվ դաշտի արժեքը
    Call Compare_Two_Values("Ծննդյան ամսաթիվ", Get_Rekvizit_Value("Document", grCashIn.generalTab.tabN, "General", "DATEBIRTH"), grCashIn.generalTab.wBirthDate)
    ' Ստուգել Քաղաքացիություն դաշտի արժեքը
    Call Compare_Two_Values("Քաղաքացիություն", Get_Rekvizit_Value("Document", grCashIn.generalTab.tabN, "Mask", "CITIZENSHIP"), grCashIn.generalTab.wCitizenship)
    ' Ստուգել Երկիր դաշտի արժեքը
    Call Compare_Two_Values("Երկիր", Get_Rekvizit_Value("Document", grCashIn.generalTab.tabN, "Mask", "COUNTRY"), grCashIn.generalTab.wCountry)
    ' Ստուգել Բնակավայր դաշտի արժեքը
    Call Compare_Two_Values("Բնակավայր", Get_Rekvizit_Value("Document", grCashIn.generalTab.tabN, "Mask", "COMMUNITY"), grCashIn.generalTab.wResidence)
    ' Ստուգել Քաղաք դաշտի արժեքը
    Call Compare_Two_Values("Քաղաք", Get_Rekvizit_Value("Document", grCashIn.generalTab.tabN, "General", "CITY"), grCashIn.generalTab.wCity)
    ' Ստուգել Բնակարան դաշտի արժեքը
    Call Compare_Two_Values("Բնակարան", Get_Rekvizit_Value("Document", grCashIn.generalTab.tabN, "General", "APARTMENT"), grCashIn.generalTab.wApartment)
    ' Ստուգել Փողոց դաշտի արժեքը
    Call Compare_Two_Values("Փողոց", Get_Rekvizit_Value("Document", grCashIn.generalTab.tabN, "General", "ADDRESS"), grCashIn.generalTab.wStreet)
    ' Ստուգել Տուն/Շենք դաշտի արժեքը
    Call Compare_Two_Values("Տուն/Շենք", Get_Rekvizit_Value("Document", grCashIn.generalTab.tabN, "General", "BUILDNUM"), grCashIn.generalTab.wHouse)
    ' Ստուգել Էլ հասցե դաշտի արժեքը
    Call Compare_Two_Values("Էլ հասցե", Get_Rekvizit_Value("Document", grCashIn.generalTab.tabN, "General", "EMAIL"), grCashIn.generalTab.wEmail)
    
    ' Ստուգել Գրասենյակ դաշտի արժեքը
    Call Compare_Two_Values("Գրասենյակ", Get_Rekvizit_Value("Document", grCashIn.chargeTab.tabN, "Mask", "ACSBRANCHINC"), grCashIn.chargeTab.office)
    ' Ստուգել Բաժին դաշտի արժեքը
    Call Compare_Two_Values("Բաժին", Get_Rekvizit_Value("Document", grCashIn.chargeTab.tabN, "Mask", "ACSDEPARTINC"), grCashIn.chargeTab.department)
    ' Ստուգել Գանձման հաշիվ դաշտի արժեքը
    Call Compare_Two_Values("Գանձման հաշիվ", Get_Rekvizit_Value("Document", grCashIn.chargeTab.tabN, "Mask", "CHRGACC"), grCashIn.chargeTab.chargeAcc)
    ' Ստուգել Արժույթ դաշտի արժեքը
    Call Compare_Two_Values("Արժույթ", Get_Rekvizit_Value("Document", grCashIn.chargeTab.tabN, "Mask", "CHRGCUR"), grCashIn.chargeTab.chargeCurrForCheck)
    ' Ստուգել ԿԲ փոխարժեք դաշտի արժեքը
    Call Compare_Two_Values("ԿԲ փոխարժեք", Get_Rekvizit_Value("Document", grCashIn.chargeTab.tabN, "Course", "CHRGCBCRS"), grCashIn.chargeTab.cbExchangeRate)
    ' Ստուգել Գանձման տեսակ դաշտի արժեքը
    Call Compare_Two_Values("Գանձման տեսակ", Get_Rekvizit_Value("Document", grCashIn.chargeTab.tabN, "Mask", "PAYSCALE"), grCashIn.chargeTab.chargeType)
    ' Ստուգել Գումար դաշտի արժեքը
    Call Compare_Two_Values("Գումար_2", Get_Rekvizit_Value("Document", grCashIn.chargeTab.tabN, "General", "CHRGSUM"), grCashIn.chargeTab.chargeAmoForCheck) 
    ' Ստուգել Տոկոս դաշտի արժեքը
    Call Compare_Two_Values("Տոկոս", Get_Rekvizit_Value("Document", grCashIn.chargeTab.tabN, "General", "PRSNT"), grCashIn.chargeTab.chargePerForCheck) 
    ' Ստուգել Եկամտի հաշիվ դաշտի արժեքը
    Call Compare_Two_Values("Եկամտի հաշիվ", Get_Rekvizit_Value("Document", grCashIn.chargeTab.tabN, "Mask", "CHRGINC"), grCashIn.chargeTab.incomeAcc) 
    ' Ստուգել Առք/Վաճառք դաշտի արժեքը
    Call Compare_Two_Values("Առք/Վաճառք", Get_Rekvizit_Value("Document", grCashIn.chargeTab.tabN, "Mask", "CUPUSA"), grCashIn.chargeTab.buyAndSellForCheck) 
    ' Ստուգել Գործողության տեսակ դաշտի արժեքը
    Call Compare_Two_Values("Գործողության տեսակ", Get_Rekvizit_Value("Document", grCashIn.chargeTab.tabN, "Mask", "CURTES"), grCashIn.chargeTab.operType)
    ' Ստուգել Գործողության վայր դաշտի արժեքը
    Call Compare_Two_Values("Գործողության վայր", Get_Rekvizit_Value("Document", grCashIn.chargeTab.tabN, "Mask", "CURVAIR"), grCashIn.chargeTab.operPlace)
    ' Ստուգել Ժամանակ դաշտի արժեքը
    Call Compare_Two_Values("Ժամանակ", Get_Rekvizit_Value("Document", grCashIn.chargeTab.tabN, "Mask", "TIME"), grCashIn.chargeTab.timeForCheck)
    ' Ստուգել Գործողության ոլորտ դաշտի արժեքը
    Call Compare_Two_Values("Գործողության ոլորտ", Get_Rekvizit_Value("Document", grCashIn.chargeTab.tabN, "Mask", "VOLORT"), grCashIn.chargeTab.operAreaForCheck)
    ' Ստուգել Ոչ ռեզիդենտ դաշտի արժեքը
    Call Compare_Two_Values("Ոչ ռեզիդենտ", Get_Rekvizit_Value("Document", grCashIn.chargeTab.tabN, "CheckBox", "NONREZ"), grCashIn.chargeTab.nonResident)
    ' Ստուգել Իրավաբանական կարգավիճակ դաշտի արժեքը
    Call Compare_Two_Values("Իրավաբանական կարգավիճակ", Get_Rekvizit_Value("Document", grCashIn.chargeTab.tabN, "Mask", "JURSTAT"), grCashIn.chargeTab.legalStatusForCheck)
    ' Ստուգել Մեկնաբանություն դաշտի արժեքը
    Call Compare_Two_Values("Մեկնաբանություն", Get_Rekvizit_Value("Document", grCashIn.chargeTab.tabN, "General", "COMM"), grCashIn.chargeTab.comment)
    
    ' Ստուգել Մանրադրամ դաշտի արժեքը
    Call Compare_Two_Values("Մանրադրամ", Get_Rekvizit_Value("Document", grCashIn.coinTab.tabN, "General", "XSUM"), grCashIn.coinTab.coinForCheck)
    ' Ստուգել Մանրադրամի վճարման արժույթ դաշտի արժեքը
    Call Compare_Two_Values("Մանրադրամի վճարման արժույթ", Get_Rekvizit_Value("Document", grCashIn.coinTab.tabN, "Mask", "XCUR"), grCashIn.coinTab.coinPayCurr) 
    ' Ստուգել Մանրադրամի վճարման հաշիվ դաշտի արժեքը
    Call Compare_Two_Values("Մանրադրամի վճարման հաշիվ", Get_Rekvizit_Value("Document", grCashIn.coinTab.tabN, "Mask", "XACC"), grCashIn.coinTab.coinPayAcc) 
    ' Ստուգել Փոխարժեք դաշտի արժեքը
    Call Compare_Two_Values("Փոխարժեք", Get_Rekvizit_Value("Document", grCashIn.coinTab.tabN, "Course", "XDLCRS"), grCashIn.coinTab.coinExchangeRate)
    ' Ստուգել ԿԲ փոխարժեք դաշտի արժեքը
    Call Compare_Two_Values("ԿԲ փոխարժեք", Get_Rekvizit_Value("Document", grCashIn.coinTab.tabN, "Course", "XCBCRS"), grCashIn.coinTab.coinCBExchangeRate) 
    ' Ստուգել Առք/Վաճառք դաշտի արժեքը
    Call Compare_Two_Values("Առք/Վաճառք", Get_Rekvizit_Value("Document", grCashIn.coinTab.tabN, "Mask", "XCUPUSA"), grCashIn.coinTab.coinBuyAndSell) 
    ' Ստուգել Մանրադրամի վճարման գումար դաշտի արժեքը
    Call Compare_Two_Values("Մանրադրամի վճարման գումար", Get_Rekvizit_Value("Document", grCashIn.coinTab.tabN, "General", "XCURSUM"), grCashIn.coinTab.coinPayAmountForCheck) 
    ' Ստուգել Գումար հիմնական արժույթով դաշտի արժեքը
    Call Compare_Two_Values("Գումար հիմնական արժույթով", Get_Rekvizit_Value("Document", grCashIn.coinTab.tabN, "General", "XSUMMAIN"), grCashIn.coinTab.amountCurrForCheck)
    ' Ստուգել Եկամուտներ արտ. փոխանակումից դաշտի արժեքը
    Call Compare_Two_Values("Եկամուտներ արտ. փոխանակումից", Get_Rekvizit_Value("Document", grCashIn.coinTab.tabN, "Mask", "XINC"), grCashIn.coinTab.incomeOutChange) 
    ' Ստուգել Վնասներ արտ. փոխանակումից դաշտի արժեքը
    Call Compare_Two_Values("Վնասներ արտ. փոխանակումից", Get_Rekvizit_Value("Document", grCashIn.coinTab.tabN, "Mask", "XEXP"), grCashIn.coinTab.damagesOutChange)
    ' Ստուգել Կլորացված գումար դաշտի արժեքը
    Call Compare_Two_Values("Կլորացված գումար", Get_Rekvizit_Value("Document", grCashIn.coinTab.tabN, "General", "ROUNDSUM"), grCashIn.coinTab.roundedAmountForCheck) 
    
    Call GoTo_ChoosedTab(grCashIn.attachedTab.tabN) 
    ' Ստուգել, որ ֆայլերը առկա են
    For i = 0 To grCashIn.attachedTab.filesCount - 1
        If Not SearchInAttachList (grCashIn.attachedTab.fileName(i), grCashIn.attachedTab.tabN) Then
           Log.Error "Can't find searched " & grCashIn.attachedTab.fileName(i) & " row.", "", pmNormal, ErrorColor
        End If
    Next
    For i = 0 To grCashIn.attachedTab.linksCount - 1
        If Not SearchInAttachList (grCashIn.attachedTab.addLinks(i), grCashIn.attachedTab.tabN) Then
           Log.Error "Can't find searched " & grCashIn.attachedTab.addLinks(i) & " row.", "", pmNormal, ErrorColor
        End If
    Next
End Sub


' Խմբային Կանխիկ մուտք փաստաթղթի խմբագրում
' OldCashIn - հին Կանխիկ մուտք փաստաթղթի լրացման կլաս
' EditCashIN - նոր Կանխիկ մուտք փաստաթղթի լրացման կլաս
Sub Edit_Group_Cash_Input(grCashIn, GrCashInput, button)
    BuiltIn.Delay(3000)
    Call wMainForm.MainMenu.Click(c_AllActions)
    Call wMainForm.PopupMenu.Click(c_ToEdit)
    If wMDIClient.WaitvbObject("frmASDocForm", 3000).Exists Then 
        Call Check_Group_Cash_Input(grCashIn)
        GrCashInput.fIsn = grCashIn.fIsn
        Call GoTo_ChoosedTab(grCashIn.generalTab.tabN)
        Call Fill_GroupCashInput(GrCashInput, button)
    Else 
        Log.Error "Can't open frmASDocForm window.", "", pmNormal, ErrorColor 
    End If
End Sub


' Խմբային գործողությունների ջնջում
Function DeleteGroupAction(ExpMess1, ExpMess2)
          
            Dim state
            state = False
            BuiltIn.Delay(2000)
            Call wMainForm.MainMenu.Click(c_AllActions)
            ' Գործողության տիպը պայամանագրի նկատմամբ
            Call wMainForm.PopupMenu.Click(c_Delete)
            
            If MessageExists(2, ExpMess1) Then
                ' Կատարել կոճակի սեղմում
                Call ClickCmdButton(5, "Î³ï³ñ»É")
               
                    If  MessageExists(1, ExpMess2) Then
                            ' Սեղմել "Այո" կոճակը
                            Call ClickCmdButton(3, "²Ûá")  
                            state = True
                    End If
            End If
            DeleteGroupAction = state
End Function