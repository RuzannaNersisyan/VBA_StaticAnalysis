Option Explicit
'USEUNIT Library_Common  
'USEUNIT Subsystems_SQL_Library 
'USEUNIT Constants
'USEUNIT Overdraft_NewCases_Library
'USEUNIT Akreditiv_Library
'USEUNIT Group_Operations_Library
'USEUNIT CashInput_Confirmphases_Library
'USEUNIT Library_Contracts
'USEUNIT Library_CheckDB

'Test case Id 165849

Sub Complicicated_Overdraft_UseOtherAccounts_Test()
  Dim fDATE, sDATE, my_vbObj
  Dim queryString, sql_Value, sql_isEqual, colNum, name, name_len, Pttel
  Dim MemOrd_ISN, GroupeGive_ISN, GroupCalc_ISN, GroupRepay_ISN, InputDoc_ISN,_
      GroupCalcSubAgr_ISN
  Dim DocNum, fBASE, CreditCard, ClientCode, Curr, CalcAccAMD, CalcAccUSD, Summa, Renewable, opDate, Term, _
      OverdraftPercent, NonUsedPercent, Baj, PastSum, PastPerSum, NonUsedPerSum, _
      DateFill, Paragraph, CheckPayDates, PayDates, Direction, AutoDebt, _
      UseOtherAccounts, Scheme, AutoDateChild, TypeAutoDate, AgrPeriod, DefineSchedule, _
      PerSumPayDate, StartDate, Sector, UsageField, Aim, Schedule, _
      Guarantee, Country, District, RegionLR, PaperCode, InputDocNumber
  Dim CreditAcc, OrderSum, Count, Operation, DocType, FolderName,IfExists,_
      CalcDate, FormDate, FirstDate, LastDate, ExpectedSum, SumAccUSD, Date,_
      opType, Summ, Workspace, Action
  Dim arrayCalcAcc, arrayDocNum, arrayDate, arrayActionType, arrCheckbox
  Dim attr,dbFOLDERS(2)
  
''1, Համակարգ մուտք գործել ARMSOFT օգտագործողով
  fDATE = "20260101"
  sDATE = "20140101"
  Call Initialize_AsBank("bank", sDATE, fDATE)
  Login("ARMSOFT")
  Call Create_Connection()
 
'--------------------------------------
  Set attr = Log.CreateNewAttributes
  attr.BackColor = RGB(0, 255, 255)
  attr.Bold = True
  attr.Italic = True
'--------------------------------------  
  
  ClientCode = "00001005"
  CreditCard = 1
  CalcAccAMD = "33120090800"      ''Դրամային հաշիվ
  CalcAccUSD = "33120090601"      ''Դոլարային հաշիվ
  Summa = "100000"
  Renewable = 1
  opDate = "140618"
  Term = "140619"
  OverdraftPercent = 12
  NonUsedPercent = 12
  Baj = "365"
  PastSum = ""
  PastPerSum = ""
  NonUsedPerSum = ""
  DateFill = 1
  Paragraph = 1
  CheckPayDates = 0
  AutoDebt = 1
  UseOtherAccounts = 3
  Scheme = "001"
  AutoDateChild = 1
  TypeAutoDate = 2
  AgrPeriod = 12
  DefineSchedule = 1
  PerSumPayDate = 1
  PayDates = 15
  Direction = 2
  Sector = "U2"
  UsageField = "01.001"
  Aim = "00"
  Schedule = "9"
  Guarantee = "9"
  Country = "AM"
  District = "001"
  RegionLR = "010000008"
  PaperCode = "111"
  
'-------------------------------------------------------------------------------------  
  ''Ջնջել բոլոր փաստաթղթերը
  Call ChangeWorkspace(c_Overdraft)
  FolderName = "|úí»ñ¹ñ³ýï (ï»Õ³µ³ßËí³Í)|"
  Call wTreeView.DblClickItem(FolderName & "úí»ñ¹ñ³ýï áõÝ»óáÕ Ñ³ßÇíÝ»ñ")
  Call Rekvizit_Fill("Dialog", 1, "General", "ACCMASK", CalcAccAMD)
  Call ClickCmdButton(2, "Î³ï³ñ»É")
  
  IfExists = wMDIClient.VBObject("frmPttel").VBObject("tdbgView").ApproxCount
  
  If IfExists <> 0 Then
    Call wMainForm.MainMenu.Click(c_AllActions)
    Call wMainForm.PopupMenu.Click(c_View)
    DocNum = wMDIClient.VBObject("frmASDocForm").VBObject("TabFrame").VBObject("TextC").Text
    BuiltIn.Delay(3000)
    wMDIClient.VBObject("frmASDocForm").Close
    wMDIClient.VBObject("frmPttel").Close
  
    'Ջնջել բոլոր գործողությունները
    Workspace = "|úí»ñ¹ñ³ýï (ï»Õ³µ³ßËí³Í)|"
    DocType = 2
    FirstDate = "^A[Del]"
    LastDate = "^A[Del]"
    Action = "^A[Del]" 
    Call GroupDelete(Workspace, DocType, DocNum, FirstDate, LastDate, Action)
  Else
    BuiltIn.Delay(3000)
    wMDIClient.VBObject("frmPttel").Close  
  End If
  
  'Ջնջել "Հիշարար օրդերը"
  Call ChangeWorkspace(c_CustomerService) 
  Date = "140618"
  opType = "MemOrd"
  Call DeletePayDoc(Date, MemOrd_ISN, opType, ClientCode)
  
  'Ջնջել "Կանխիկ մուտքը"
  opType = "KasPrOrd"
  Call DeletePayDoc(Date, InputDoc_ISN, opType, ClientCode)
  
  If IfExists <> 0 Then
    'Ջնջել Բարդ օվերդրաֆտ պայմանագիրը
    Call ChangeWorkspace(c_Overdraft)
  
    docType = "2"
    FolderName = "|úí»ñ¹ñ³ýï (ï»Õ³µ³ßËí³Í)|"
    IfExists = LetterOfCredit_Filter_Fill(FolderName, docType, DocNum)
  
    Call wMainForm.MainMenu.Click(c_Opers & "|" & c_Delete)
  
    Call ClickCmdButton(3, "²Ûá")
    BuiltIn.Delay(3000)
    wMDIClient.VBObject("frmPttel").Close
  End If  
  
'-------------------------------------------------------------------------------------

  Call Log.Message("2. Կատարել Կանխիկ մուտք հաճախորդի դոլարայի հաշվի վրա",,,attr)
  Call ChangeWorkspace(c_CustomerService)   
  opDate = "140618"
  opType = "CashInput"
  Summ = 1000 
  Name = "Պետրոսյան Պետրոս"
  Call CashInputOutput(opDate, opType, CalcAccUSD, Summ, InputDocNumber, Name, InputDoc_ISN)
  wMDIClient.VBObject("FrmSpr").Close
  
  ''3.Կանխիկ մուտք փաստաթուղթը ուղարկել հաստատման:
  Call wMainForm.MainMenu.Click(c_AllActions)
  Call wMainForm.PopupMenu.Click(c_SendToVer)
  Call ClickCmdButton(2, "Î³ï³ñ»É")
  BuiltIn.Delay(3000)
  wMDIClient.VBObject("frmPttel").Close

   ''4.Մուտք գործել "Հաստատող 1 ԱՇՏ/Հաստատվող վճարային փաստաթղթեր " թղթապանակ - "Կանխիկ մուտք" փաստաթուղթը պետք է առկա լինեն:
  Call ChangeWorkspace(c_Verifier1)
  
  Dim VerificationDoc
  Set VerificationDoc = New_VerificationDocument()
      VerificationDoc.User = "77"
        
  Call GoToVerificationDocument("|Ð³ëï³ïáÕ I ²Þî|Ð³ëï³ïíáÕ í×³ñ³ÛÇÝ ÷³ëï³ÃÕÃ»ñ",VerificationDoc)
  Builtin.Delay(2000)

  ''5.Վավերացնել "Կանխիկ մուտք" փաստաթուղթը:
  ColNum = 3
  name_len = 6
  Pttel = ""
  Call Find_Doc_By(InputDocNumber, name_len, ColNum, Pttel)
  Call wMainForm.MainMenu.Click(c_AllActions)
  Call wMainForm.PopupMenu.Click(c_ToConfirm)
  Call ClickCmdButton(1, "Ð³ëï³ï»É")
  BuiltIn.Delay(3000)
  wMDIClient.VBObject("frmPttel").Close
  
  ''6.Մուտք գործել "Հաճախորդի սպասարկում և դրամարկղ/Աշխատանքային փաստաթղթեր" - "Կանխիկ մուտք" փաստաթուղթը պետք է առկա լինի:
  Call ChangeWorkspace(c_CustomerService)  
  Call wTreeView.DblClickItem("|Ð³×³Ëáñ¹Ç ëå³ë³ñÏáõÙ ¨ ¹ñ³Ù³ñÏÕ |²ßË³ï³Ýù³ÛÇÝ ÷³ëï³ÃÕÃ»ñ")
  Call Rekvizit_Fill("Dialog", 1, "General", "PERN", opDate) 
  Call Rekvizit_Fill("Dialog", 1, "General", "PERK", opDate) 
  Call Rekvizit_Fill("Dialog", 1, "General", "DOCTYPE", "KasPrOrd")
  Call ClickCmdButton(2, "Î³ï³ñ»É")
  
  ''7.Վավերացնել "Կանխիկ մուտք" փաստաթուղթը:
  Call wMainForm.MainMenu.Click(c_AllActions)
  Call wMainForm.PopupMenu.Click(c_ToConfirm)
  Call ClickCmdButton(1, "Ð³ëï³ï»É")
  BuiltIn.Delay(3000)
  wMDIClient.VBObject("frmPttel").Close
  
  ''8, Անցում կատարել "Օվերդրաֆտ (տեղաբաշխված)" ԱՇՏ
  Call ChangeWorkspace(c_Overdraft)
  
  Call Log.Message("3.Բարդ օվերդրաֆտ(գծային) պայմանագրի ստեղծում",,,attr)
  Call Letter_Of_Complicicated_Overdraft_Doc_Fill(DocNum, fBASE, CreditCard, ClientCode, _
                           Curr, CalcAccAMD, Summa, Renewable, opDate, Term, _
                           OverdraftPercent, NonUsedPercent, Baj, PastSum, PastPerSum, _
                           NonUsedPerSum, DateFill, Paragraph, CheckPayDates, _
                           PayDates, Direction, AutoDebt, UseOtherAccounts, Scheme, AutoDateChild, _
                           TypeAutoDate, AgrPeriod, DefineSchedule, _
                           PerSumPayDate, StartDate, Sector, UsageField, Aim, _
                           Schedule, Guarantee, Country, District, RegionLR, PaperCode)
                           
      ''SQL ստուգում պայամանգիր ստեղցելուց հետո: 
      ''CONTRACTS
      queryString = "select count(*) from CONTRACTS where fDGISN = " & fBASE &_
                      "and fDGAGRTYPE = 'C' and fDGMODTYPE = 3 and fDGAGRKIND = 'XL'" &_
                      "and fDGSTATE = 1 and fDGSUMMA = 100000.00 and fDGALLSUMMA = 0.00"
      sql_Value = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If  
                                
      ''FOLDERS
      queryString = "select count(*) from FOLDERS where fISN = " & fBASE 
      sql_Value = 3
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If                       
                                          
  ''4.Պայմանագիրը ուղարկել հաստատման
  Call wMainForm.MainMenu.Click(c_AllActions)
  Call wMainForm.PopupMenu.Click(c_SendToVer)
  Call ClickCmdButton(5, "²Ûá") 
  BuiltIn.Delay(3000)
  wMDIClient.VBObject("frmPttel").Close
  
  ''5.Մուտք գործել "Հաստատվող փաստաթղթեր 1" թղթապանակ 
  Call wTreeView.DblClickItem("|úí»ñ¹ñ³ýï (ï»Õ³µ³ßËí³Í)|Ð³ëï³ïíáÕ ÷³ëï³ÃÕÃ»ñ I")
  Call Rekvizit_Fill("Dialog", 1, "General", "NUM", DocNum) 
  Call ClickCmdButton(2, "Î³ï³ñ»É")
  Builtin.Delay(2000)
  If wMDIClient.VBObject("frmPttel").VBObject("tdbgView").ApproxCount <> 1 Then
    Call Log.Error("Պայմանագիրը առկա չէ Հաստատվող փաստաթղթեր 1 թղթապանակում:")
    Exit Sub
  End If
  
  ''6.Վավերացնել պայմանագիրը
  Call wMainForm.MainMenu.Click(c_AllActions)
  Call wMainForm.PopupMenu.Click(c_ToConfirm)
  Call ClickCmdButton(1, "Ð³ëï³ï»É") 
  BuiltIn.Delay(3000)
  wMDIClient.VBObject("frmPttel").Close

  ''7.Մուտք գործել "Հաճախորդի սպասարկում և դրամարկղ"
  Call ChangeWorkspace(c_CustomerService)
 
  Call Log.Message("8.Ստեղծել Հիշարար օրդեր (Հաշիվ դեբետ = 33120090800)",,,attr)
  CreditAcc = "000292600"
  OrderSum = "50000"
  MemOrd_ISN = Mem_Order_Create_Order(opDate, CalcAccAMD, CreditAcc, OrderSum)
  
  wMDIClient.VBObject("FrmSpr").Close
  
  ''9.Հաշվառել "Հիշարար օրդեր" փաստաթուղթը
  Call wMainForm.MainMenu.Click(c_AllActions)
  Call wMainForm.PopupMenu.Click(c_DoTrans)
  Call ClickCmdButton(5, "²Ûá")
  BuiltIn.Delay(3000)
  wMDIClient.VBObject("frmPttel").Close

  ''10.Մուտք գործել "Օվերդրաֆտ(տեղաբաշխված)" 
  Call ChangeWorkspace(c_Overdraft)

  Call Log.Message("12.Օվերդրաֆտի խմբային տրամադրում",,,attr)  
  ReDim arrayCalcAcc(0)
  arrayCalcAcc(0) = CalcAccAMD
  Count = 1
  Operation = "Give"
  GroupeGive_ISN = OverdraftGroupOperation(arrayCalcAcc, Count, opDate, Operation)
    
    ''SQL հարցում օվերդրաֆտի խմբային տրամադրումից հետո
     ''CONTRACTS
      queryString = "select fDGSTATE from CONTRACTS where fDGISN = " & fBASE
      sql_Value = 7
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
      
      ''HI
      queryString = "select count(*) from HI where fBASE = " & GroupeGive_ISN &_
                     "and fSUM = 50000.00 and fCURSUM = 50000.00"
      sql_Value = 3
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
      
      ''HIF
      queryString = "select count(*) from HIF where fBASE = " & fBASE 
      sql_Value = 28
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
      
      ''HIR
      queryString = "select count(*) from HIR where fBASE = " & GroupeGive_ISN &_
                     "and fCURSUM = 50000.00" 
      sql_Value = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
      
  Call Log.Message("14.Խմբային տոկոսների հաշվարկ Մայր պայմանագրերի համար",,,attr)
  ReDim arrayDocNum(0)
  arrayDocNum(0) = DocNum
  DocType = "2"
  CalcDate = "150718"
  FormDate = "150718" 
  GroupCalc_ISN = OverdraftGroupCalculation(arrayDocNum, Count, DocType, CalcDate, FormDate)
      
    ''SQL ստուգում խմբային տոկոսների հաշվարկից հետո:
      ''FOLDERS
      queryString = "select count(*) from FOLDERS where fISN = " & fBASE 
      sql_Value = 5
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
      
      Set dbFOLDERS(1) = New_DB_FOLDERS()
          dbFOLDERS(1).fFOLDERID = "LOANREGISTER"
          dbFOLDERS(1).fNAME = "C3Compl"
          dbFOLDERS(1).fKEY = fBASE 
          dbFOLDERS(1).fISN = fBASE 
          dbFOLDERS(1).fSTATUS = 1
          dbFOLDERS(1).fCOM = """Overdraft"" ûå»ñ³ïáñ 6"
          dbFOLDERS(1).fSPEC = "C3X"& Trim(DocNum) &"          111                               0                                                                                                                                                             0.00                                                                                                                                                                                                                                                                                               "

      Set dbFOLDERS(2) = New_DB_FOLDERS()
          dbFOLDERS(2).fFOLDERID = "LOANREGISTER2"
          dbFOLDERS(2).fNAME = "C3Compl"
          dbFOLDERS(2).fKEY = fBASE 
          dbFOLDERS(2).fISN = fBASE 
          dbFOLDERS(2).fSTATUS = "1"
          dbFOLDERS(2).fCOM = """Overdraft"" ûå»ñ³ïáñ 6"
          dbFOLDERS(2).fSPEC = "0"
        
      Call CheckDB_FOLDERS(dbFOLDERS(1), 1)
      Call CheckDB_FOLDERS(dbFOLDERS(2), 1)
      
      ''HI
      queryString = "select count(*) from HI where fBASE = " & GroupCalc_ISN &_
                     "and fSUM = 526.00 and fCURSUM = 526.00"
      sql_Value = 2
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
      
      ''HIF
      queryString = "select count(*) from HIF where fBASE = " & GroupCalc_ISN 
      sql_Value = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
      
      ''HIR
      queryString = "select count(*) from HIR where fBASE = " & GroupCalc_ISN &_
                     "and fCURSUM = 526.00" 
      sql_Value = 2
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
      
      ''HIRREST
      queryString = "select count(*) from HIRREST where fOBJECT = " & fBASE &_
                     "and fLASTREM = 526.00 and fPENULTREM = 0.00"
      sql_Value = 2
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
      
      ''HIT
      queryString = "select count(*) from HIT where fOBJECT = " & fBASE &_
                     "and fCURSUM = 526.00"  
      sql_Value = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
      
  Call Log.Message("15.Խմբային տոկոսների հաշվարկ ենթապայմանագրերի համար",,,attr)
  DocType = "1" 
  Call wTreeView.DblClickItem("|úí»ñ¹ñ³ýï (ï»Õ³µ³ßËí³Í)|ä³ÛÙ³Ý³·ñ»ñ")
  Call Rekvizit_Fill("Dialog", 1, "General", "LEVEL", DocType) 
  Call Rekvizit_Fill("Dialog", 1, "General", "NUM", DocNum) 
  Call ClickCmdButton(2, "Î³ï³ñ»É")
  
  Date = "150718"
  ReDim arrCheckbox(2)          
  arrCheckbox = Array("CHG", "OPX")
  Call Group_Calculation(Date, arrCheckbox)
  
  'Վերցնել Խմբային հաշվարկի ISN-ը
  Builtin.Delay(2000)
  Call wMainForm.MainMenu.Click(c_AllActions)
  Call wMainForm.PopupMenu.Click(c_OpersView)
  Call Rekvizit_Fill("Dialog", 1, "General", "START", "^A[Del]" & Date) 
  Call Rekvizit_Fill("Dialog", 1, "General", "END", "^A[Del]" & Date) 
  Call ClickCmdButton(2, "Î³ï³ñ»É")
  Builtin.Delay(2000)
  wMDIClient.VBObject("frmPttel_2").VBObject("tdbgView").ClickR

  Call wMainForm.PopupMenu.Click(c_View)
  GroupCalcSubAgr_ISN = wMDIClient.VBObject("frmASDocForm").DocFormCommon.Doc.isn
  BuiltIn.Delay(3000)
  wMDIClient.VBObject("frmASDocForm").Close
  Builtin.Delay(2000)
  wMDIClient.VBObject("frmPttel_2").Close
  Builtin.Delay(2000)
  wMDIClient.VBObject("frmPttel").Close
  
    ''SQL ստուգում Խմբային տոկոսների հաշվարկից հետո
      ''HI
      queryString = "select count(*) from HI where fBASE = " & GroupCalcSubAgr_ISN
      sql_Value = 12
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If

      ''HIF
      queryString = "select count(*) from HIF where fBASE = " & GroupCalcSubAgr_ISN &_
                     "and fSUM = 0.00 and fCURSUM = 0.00" 
      sql_Value = 4
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
      
      ''HIR
      queryString = "select count(*) from HIR where fBASE = " & GroupCalcSubAgr_ISN &_
                     "and (fCURSUM = 16.40 or fCURSUM = 493.20 or fCURSUM = 509.60)" 
      sql_Value = 5
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
      
      ''HIT
      queryString = "select count(*) from HIT where fBASE = " & GroupCalcSubAgr_ISN &_
                     "and (fCURSUM = 16.40 or fCURSUM = 493.20)"
      sql_Value = 3
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
      
  Call Log.Message("16.Խմբային մարում",,,attr)
  opDate = "160718"
  Operation = "Repayment"
  GroupRepay_ISN = OverdraftGroupOperation(arrayCalcAcc, Count, opDate, Operation)
  
    ''SQL ստուգում Խմբային մարումից հետո
      ''HI
      queryString = "select count(*) from HI where fBASE = " & GroupRepay_ISN
      sql_Value = 17
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
       
      ''HIR
      queryString = "select count(*) from HIR where fBASE = " & GroupRepay_ISN &_
                     "and (fCURSUM = 50000.00 or fCURSUM = 526.00)" 
      sql_Value = 5
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
      
      ''HIRREST
      queryString = "select count(*) from HIRREST where fOBJECT = " & fBASE &_
                     "and fLASTREM = 0.00 and (fPENULTREM = 526.00 or fPENULTREM = 0.00)"
      sql_Value = 2
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
    
  Call Log.Message("17.Ստուգել, որ հաճախորդի դոլարային հաշիվը (33120090601) պակասած լինի մարված գումարի չափով",,,attr)
  ''18.Մուտք գործել "Պայմանագրեր" թղթապանակ
  docType = "2"
  FolderName = "|úí»ñ¹ñ³ýï (ï»Õ³µ³ßËí³Í)|"
  IfExists = LetterOfCredit_Filter_Fill(FolderName, docType, DocNum)
  
  'Հաշվել մարված գումարի չափը
  ReDim arrayDate(3)
  ReDim arrayActionType(3)
  
  arrayDate = Array("160718", "160718", "160718")
  arrayActionType = Array(22, 53, 63)
  Count = 3
  ExpectedSum = Sum(arrayDate, arrayActionType, Count)
  BuiltIn.Delay(3000)
  wMDIClient.VBObject("frmPttel").Close

  '19.Մուտք գործել "Հաճախորդի սպասարկում և դրամարկղ"
  Call ChangeWorkspace(c_CustomerService)
  
  Call Log.Message("20.'Ընդհանուր դիտում' թղթապանակում հաշվել հարճախորդի դոլլարային հաշվից մարված գումարը",,,attr)
  Call wTreeView.DblClickItem("|Ð³×³Ëáñ¹Ç ëå³ë³ñÏáõÙ ¨ ¹ñ³Ù³ñÏÕ |ÀÝ¹Ñ³Ýáõñ ¹ÇïáõÙ")
  Date = "160718" 
  opType = "CEX"
  Call Rekvizit_Fill("Dialog", 1, "General", "PERN", Date) 
  Call Rekvizit_Fill("Dialog", 1, "General", "PERK", Date) 
  Call Rekvizit_Fill("Dialog", 1, "General", "ACCMASK", CalcAccUSD) 
  Call Rekvizit_Fill("Dialog", 1, "General", "OPERTYPE", opType) 
  Call ClickCmdButton(2, "Î³ï³ñ»É")
  Builtin.Delay(2000)
  
  SumAccUSD = 0
'  Set my_vbObj = Sys.Process("Asbank").VBObject("MainForm").Window("MDIClient", "", 1).VBObject("frmPttel").VBObject("tdbgView")
'  my_vbObj.MoveFirst
  While Not wMDIClient.VBObject("frmPttel").VBObject("tdbgView").EOF
    SumAccUSD = SumAccUSD + wMDIClient.VBObject("frmPttel").VBObject("tdbgView").Columns.Item(7)
    wMDIClient.VBObject("frmPttel").VBObject("tdbgView").MoveNext   
  Wend
  
  BuiltIn.Delay(3000)
  wMDIClient.VBObject("frmPttel").Close
  
  If SumAccUSD <> ExpectedSum Then
    Log.Error("Փաղկապակցված հաշվից վճարված գումարը հավասար չէ օվերդրաֆտի մարման գումարին:")
  End If

'-------------------------------------------------------------------------------------  
  Call Log.Message("Ջնջել բոլոր փաստաթղթերը",,,attr)
  Call ChangeWorkspace(c_Overdraft)
  
  'Ջնջել բոլոր գործողությունները
  Workspace = "|úí»ñ¹ñ³ýï (ï»Õ³µ³ßËí³Í)|"
  DocType = 2
  FirstDate = "^A[Del]"
  LastDate = "^A[Del]"
  Action = "^A[Del]"  
  Call GroupDelete(Workspace, DocType, DocNum, FirstDate, LastDate, Action)
  
  'Ջնջել "Հիշարար օրդերը"
  Call ChangeWorkspace(c_CustomerService) 
  Date = "140618"
  opType = ""
  Call DeletePayDoc(Date, MemOrd_ISN, opType, ClientCode)
  
  'Ջնջել "Կանխիկ մուտքը"
  opType = ""
  Call DeletePayDoc(Date, InputDoc_ISN, opType, ClientCode)
  
  'Ջնջել Բարդ օվերդրաֆտ պայմանագիրը
  Call ChangeWorkspace(c_Overdraft)
  
  docType = "2"
  FolderName = "|úí»ñ¹ñ³ýï (ï»Õ³µ³ßËí³Í)|"
  IfExists = LetterOfCredit_Filter_Fill(FolderName, docType, DocNum)
  
  Call wMainForm.MainMenu.Click(c_Opers & "|" & c_Delete)
  
  Call ClickCmdButton(3, "²Ûá")
  BuiltIn.Delay(3000)
  wMDIClient.VBObject("frmPttel").Close
'-------------------------------------------------------------------------------------

  Call Close_AsBank()  
End Sub