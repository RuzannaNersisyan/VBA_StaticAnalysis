Option Explicit
'USEUNIT Subsystems_SQL_Library
'USEUNIT Online_PaySys_Library
'USEUNIT Akreditiv_Library
'USEUNIT Library_Common
'USEUNIT Constants
'USEUNIT Payment_Order_ConfirmPhases_Library
'USEUNIT Mortgage_Library

'Test Case N 63572

Sub Akreditiv_Renewable_Test()
  Utilities.ShortDateFormat = "yyyymmdd"
  Dim sDATE, fDATE
  Dim fBASE, docNumber, clientCode, curr, accacc, summ, restore, dategive, date_arg, agrIntRate
  Dim agrIntRatePart, sector, schedule, guarante, district, paperCode
  Dim verify, docType, Exists, Data, Lim, AccptDocNum
  Dim S_Date, F_Date, TF, ColVal,country
  Dim my_vbObj, CalcDate, Date, Money, Count, AMDCount,FolderName 
  Dim TerRes, Date_tr, Val, Bank,aim,region
  Dim queryString, sql_Value, colNum, sql_isEqual
  Dim ReqFDate, OblFDate, OblPer, Baj, Acc
  
  fDATE = "20220101"
  sDATE = "20140101"      

  ''1, Համակարգ մուտք գործել ARMSOFT օգտագործողով
  Call Initialize_AsBank("bank", sDATE, fDATE)
  Login("ARMSOFT")
  Call Create_Connection()

  ''2, Անցում "Ակրեդիտիվ" ԱՇՏ
  Call ChangeWorkspace(c_LetterOfCredit)
  ''3, Ակրեդիտիվի գլխավոր պայմանագրի ստեղծում
  Call wTreeView.DblClickItem( "|²Ïñ»¹ÇïÇí|Üáñ å³ÛÙ³Ý³·ñÇ ëï»ÕÍáõÙ")

  clientCode = "00034851"
  curr = "000"
  accacc = "30220042300"
  summ = "1000000"
  restore = True
  dategive = "110515"
  date_arg = "110516"
  agrIntRate = "18"
  agrIntRatePart = "365"
  sector = "U2"
  aim = "00"
  schedule = "9"
  guarante = "9"
  district = "001"
  paperCode = "123"
  country = "AM"
  region = "010000008"
  
  Call Letter_Of_Credit_Doc_Fill(fBASE, docNumber, clientCode, curr, accacc, summ,_
                                restore, dategive, date_arg, agrIntRate, agrIntRatePart, _
                                sector,aim, schedule,country, guarante, district,region, paperCode) 
  ''4. Այլ վճարումների գրաֆիկի նշանակում
  call ContractAction (c_OtherPaySchedule)
  Call ClickCmdButton(1, "Î³ï³ñ»É")

  ''5. Պայմանագիրը ուղարկել հաստատման
  
    'SQL ստուգում: Պայամանգիր ստեղցելուց հետո պետք է fDGSTATE = 1
    queryString = "select * from CONTRACTS where fDGISN= '" & fBASE & "'"
    sql_Value = 1
    colNum = 13
    sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
    If Not sql_isEqual Then
      Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
    End If
    
    Data = Find_Data ("²Ïñ»¹ÇïÇíÇ ·ÉË³íáñ å³ÛÙ³Ý³·Çñ- "& Trim(docNumber) &" {öáË³ÝóÙ³Ý ëïáõ·Ù³Ý Ñ³×³Ëáñ¹ 1}",0)
    If Not Data then
      call Log.Error("Փաստաթուղթը չի գտնվել") 
      exit Sub
    End If
  
    
    Call wMainForm.MainMenu.Click(c_AllActions)
    Call wMainForm.PopupMenu.Click(c_SendToVer)
    BuiltIn.Delay(2000)
    Call MessageExists(2,"àõÕ³ñÏ»É Ñ³ëï³ïÙ³Ý")
    Call ClickCmdButton(5, "²Ûá")
  
    'փակել պատուհանը
    BuiltIn.Delay(2000)
    Call Close_Pttel("frmPttel")

      'SQL ստուգում: Պայամանգիր հաստատման ուղարկելուց  հետո պետք է fDGSTATE = 101
      queryString = "select * from CONTRACTS where fDGISN= '" & fBASE & "'"
      sql_Value = 101
      colNum = 13
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
  
  '' 6. Մուտք գործել հաստատվող փաստաթղթեր 1 թղթապանակ - Պայմանագիրը առկա լինի
  Call wTreeView.DblClickItem("|²Ïñ»¹ÇïÇí|Ð³ëï³ïíáÕ ÷³ëï³ÃÕÃ»ñ I")
  Call ClickCmdButton(2, "Î³ï³ñ»É")
  
  Exists = Find_Data(Trim(docNumber), 2)
  If (Not Exists) then
    call Log.Error("Պայմանագիրը առկա չէ")
    Exit Sub
  End If 

  '' 7. Հաստատել պայմանագիրը
  verify = true
  call  PaySys_Verify(verify)
  ' փակել պատուհանը
  BuiltIn.Delay(2000)
  Call Close_Pttel("frmPttel")
     
      'SQL ստուգում: Պայամանգիր "Հաստատվող փաստաթղթեր I" վավերացնելուց  հետո պետք է fDGSTATE = 7
      queryString = "select * from CONTRACTS where fDGISN= '" & fBASE & "'"
      sql_Value = 7
      colNum = 13
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If 
     
  '' 8. Մուտք գործել "Պայմանագրեր՛՛ թղթապանակ 
  docType = "2"
  FolderName = "|²Ïñ»¹ÇïÇí|"
  Exists = LetterOfCredit_Filter_Fill(FolderName, docType, docNumber)
  If (Not Exists) Then
    Call Log.Error("Պայմանագիրը առկա չէ")
    Exit sub
  End If

'"9. Կատարել "Գործողություններ/Բոլոր գործողություններ/Դիտում և խմբագրում/Այլ/Սահմանաչափեր" գործողությունը - Սահմանաչափի արժեքը պետք է հավասար լինի 0:
  ' Սահմանաչափի արժեքը պետք է հավասար լինի 0
  S_Date = "100515"
  F_Date = "100515"
  TF = 0
  ColVal = "0.00"
  Lim =  Check_Limit(S_Date,F_Date, TF, ColVal)
  If (Not Lim) Then
    call Log.Error("Սահմանաչափի արժեքը 0 չէ")
  End if

  ''10. Մայր պայմանագրի համար կատարել "Գծայնության վերականգնում գործողությունտը 
  ''11. Վարկային գծի դադարեցում/ վերականգնում փաստաթղթի լրացում
  'Կանգնենք մեր պայմանագրի վրա
  TerRes = "|" & c_LineRestoration
  Date_tr = "110515"
  Val = "2" 
  Call Credit_Termination_Restoration(TerRes, Date_tr, Val)
  
  ''12. Ակցեպտավորում փաստաթղթի ստեղծում
   Date = "110515"
   Money = "500000"
   ReqFDate = "110516"
   OblFDate = "110516"
   OblPer = "18"
   Baj = "365"
   Bank = "00000001"
   Acc = ""
  Call Create_Acceptance(Date,  Money, ReqFDate, OblFDate, OblPer, Baj, Bank, Acc)

  ''''14-ի expected-ի համար վերցնենք ակցեպտավորում պայմանագրի համարը վերցնենք 
  AccptDocNum = FindVal(0)

  ''13. Անցում կատարել "Պարտավորություններ ակրեդիտիվի գծով" ԱՇՏ
  Call ChangeWorkspace(c_LiabilitiesInLC)

  ''14.Անցում կատարել "Պայմանագրեր " թղթապանակ 
  '- Ակցեպտավորում փաստաթղթին համապատասխան պետք է ստեղծված լինի "Պարտավորություններ ակրեդիտիվի գծով " տեսակի պայմանագիր :
  docType = "2"
  FolderName = "|ä³ñï³íáñáõÃÛáõÝÝ»ñ ²Ïñ»¹ÇïÇíÇ ·Íáí|"
  Exists = LetterOfCredit_Filter_Fill(FolderName, docType, Trim(AccptDocNum))
  If (Not Exists) Then
    call Log.Error("Պարտավորություններ ակրեդիտիվի գծով տեսակի Պայմանագիրը առկա չէ")
    exit sub
  End If
    
  ''15.Ստուգել "Պարտավորություններ ակրեդիտիվի գծով " պայմանագրի ավտոմատ լրացված արժեքների ճշտությունը
  Set my_vbObj = wMDIClient.VBObject("frmPttel").VBObject("tdbgView")
  If Not Trim(my_vbObj.Columns.Item(1)) = Trim("§26 ÎáÙÇë³ñÝ»ñÇ ´³ÝÏ¦") Then
    Call Log.Error("Պարտավորություններ ակրեդիտիվի գծով պայմանագրի Անվանում դաշտը սխալ լրացված")
      Exit Sub
  End If    
  If Not Trim(my_vbObj.Columns.Item(2)) = Trim("000") Then
    Call Log.Error("Պարտավորություններ ակրեդիտիվի գծով պայմանագրի Արժ. դաշտը սխալ է լրացված")
      Exit Sub
  End If  
  If Not Trim(my_vbObj.Columns.Item(3)) = Trim("500,000.00") Then
    Call Log.Error("Պարտավորություններ ակրեդիտիվի գծով պայմանագրի Մնացորդ դաշտը սխալ է լրացված")
      Exit Sub
  End If  
  If Not Trim(my_vbObj.Columns.Item(5)) = Trim("11/05/15") Then
    Call Log.Error("Պարտավորություններ ակրեդիտիվի գծով պայմանագրի Ամսաթիվ դաշտը սխալ է լրացված")
      Exit Sub
  End If  
  If Not Trim(my_vbObj.Columns.Item(6)) = Trim("11/05/16") Then
    Call Log.Error("Պարտավորություններ ակրեդիտիվի գծով պայմանագրի Մարման ժամկետ դաշտը սխալ է լրացված")
      Exit Sub
  End If  
  If Not Trim(my_vbObj.Columns.Item(8)) = Trim("00000001") Then
    Call Log.Error("Պարտավորություններ ակրեդիտիվի գծով պայմանագրի Հաճախորդ դաշտը սխալ է լրացված")
      Exit Sub
  End If  
  If Not Trim(my_vbObj.Columns.Item(12)) = Trim("00") Then
    Call Log.Error("Պարտավորություններ ակրեդիտիվի գծով պայմանագրի Գրասենյակ դաշտը սխալ է լրացված")
      Exit Sub
  End If  
  If Not Trim(my_vbObj.Columns.Item(13)) = Trim("1") Then
      Call Log.Error("Պարտավորություններ ակրեդիտիվի գծով պայմանագրի Բաժին դաշտը սխալ է լրացված")
      Exit Sub
  End if    
  ' փակել պատուհանը
  BuiltIn.Delay(2000)
  Call Close_Pttel("frmPttel")

  ''16.Անցում կատարել "Ակրեդիտիվ" ԱՇՏ
  Call ChangeWorkspace(c_LetterOfCredit)

  ''17. Մուտք գործել "Պայմանագրեր" թղթապանակ - Ակրեդիտիվի մայր պայմանագիրը պետք է առկա լինի :
  'Ակրեդիտիվի մայր պայմանագիրը պետք է առկա լինի 
  docType = "2"
  FolderName = "|²Ïñ»¹ÇïÇí|"
  Exists = LetterOfCredit_Filter_Fill(FolderName, docType, docNumber)
  If (Not Exists) Then
    call Log.Error("Պայմանագիրը առկա չէ")
    exit sub
  End If

  ''18,Մայր պայմանագրի համար կատարել "Գծայնության դադարեցում" գործողությունը
  ''19.Վարկային գծի դադարեցում/ վերականգնում փաստաթղթի լրացում
  TerRes = "|" & c_LineTermination
  Date_tr = "110615"
  Val=  "1"
  Call Credit_Termination_Restoration(TerRes, Date_tr, Val)

  ''20.Կատարել "Գործողություններ/ Բոլոր գործողություններ/ Թղթապանակներ/Ակցեպտավորումներ " գործողությունը   - Ակցեպտավորման պայմանագիրը պետք է առկա լինի :
  Call wMainForm.MainMenu.Click(c_AllActions)
  Call wMainForm.PopupMenu.Click(c_Folders & "|" & c_Acceptances)

  'Ակցեպտավորման պայմանագիրը պետք է առկա լինի
  Exists = false
  wMDIClient.Refresh
  Set my_vbObj = wMDIClient.WaitVBObject("frmPttel_2", 5000)
  wMDIClient.Refresh
  If my_vbObj.Exists Then 
  my_vbObj.vbObject("tdbgView").MoveFirst
     Do While (Not my_vbObj.vbObject("tdbgView").EOF)  
        If Left(Trim(my_vbObj.vbObject("tdbgView").Columns.Item(0).Text), Len(Trim(docNumber))) = Trim(docNumber)  then 
           Exists = True 
           Exit Do   
        Else
            Call my_vbObj.vbObject("tdbgView").MoveNext
        End If
      Loop 
  Else
    Log.Error("Թղթապանակը հնարավոր չեղավ բացել")
  End If
  If (Not Exists) Then
    call Log.Error("Ակցեպտավորման պայմանագիրը առկա չէ")
  End If

  ''21.Տոկոսների հաշվարկում փաստաթղթի ստեղծում
  CalcDate = "120615"
  Date = "120615"
  Call Calculate_Percent(fBase, CalcDate, Date)
  
      'SQL ստուգում: Տոկոսների հաշվարկում փաստաթուղթ ստեղծելուց հետո 
      queryString = "select Sum(fCURSUM), Sum(fSUM) from HI where fDATE = '2015-06-12' and fBASE = " & fBASE & " and fDBCR = 'C'"
      sql_Value = 15673.80
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
      sql_Value = 15673.80
      colNum = 1
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
      
      queryString = "select Sum(fCURSUM), Sum(fSUM) from HI where fDATE = '2015-06-12' and fBASE = " & fBASE & " and fDBCR = 'D'"
      sql_Value = 15673.80
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
      sql_Value = 15673.80
      colNum = 1
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If

  ''22.Ակրեդիտիվ պայմանագրի պարտքերի մարման հայտի ստեղծում
  Date = "130615" 
  Money = "10000"
  Count = ""
  AMDCount = ""
  Call AkrPayment(fBase ,Date, Money, Count, AMDCount)
  Call Close_Pttel("frmPttel_2")
      
      'SQL ստուգում: Ակրեդիտիվ պայմանագրի պարտքերի մարման հայտ ստեղծելուց հետո պետք է fSUM = 10000.00
      queryString = "select * from HI where fDATE = '2015-06-13' and fBASE = " & fBASE & " and fDBCR = 'C'"
      sql_Value = 10000.00
      colNum = 3
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
      
      queryString = "select * from HI where fDATE = '2015-06-13' and fBASE = " & fBASE & " and fDBCR = 'D'"
      sql_Value = 10000.00
      colNum = 3
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
    
  ''23.Մայր պայմանագրի համար կատարել "Գործողություններ/Բոլոր գործողություններ/Դիտում և խմբագրում/Այլ/Սահմանաչափեր" գործողությունը - Սահմանաչափը պետք է լինի 0ացված :
  wMDIClient.Refresh
  'Սահմանաչափը պետք է լինի 0ացված : 
  S_Date = "110615"
  F_Date = "110615"
  TF = 0
  ColVal = "0.00"
  Lim =  Check_Limit(S_Date,F_Date, TF, ColVal)
  If (Not Lim) Then
    call Log.Error("Սահմանաչափի արժեքը 0 չէ")
  End if

  ''24.Վարկային գծի դադարեցում/ վերականգնում փաստաթղթի լրացում
  ''''' վերականգնում
  TerRes = "|" & c_LineRestoration
  Date_tr = "140615"
  Val = "2"
  Call Credit_Termination_Restoration(TerRes, Date_tr, Val)

  ''25.Մայր պայմանագրի համար կատարել "Գործողություններ/Բոլոր գործողություններ/Դիտում և խմբագրումԱյլ/Սահմանաչափեր" գործողությունը - Սահմանաչափը պետք է լինի մայր պայմանագրի գումարին հավասար (100000):
  wMDIClient.Refresh

  'Սահմանաչափը պետք է լինի մայր պայմանագրի գումարին հավասար (1000000):
  S_Date = "140615"
  F_Date = "140615"
  TF = 0
  ColVal = "1,000,000.00"
  Lim =  Check_Limit(S_Date,F_Date, TF, ColVal)
  If (Not Lim) Then
    call Log.Error("Սահմանաչափի արժեքը 1.000.000) չէ")
  End if

  ''26.Տոկոսների հաշվարկում փաստաթղթի ստեղծում
  CalcDate = "100116"
  Date = "100116"
  Call Calculate_Percent(fBase, CalcDate, Date)

  ''27.Կատարել "Գործողություններ/ Բոլոր գործողություններ/ Թղթապանակներ/Ակցեպտավորումներ " գործողությունը 
  Call wMainForm.MainMenu.Click(c_AllActions)
  Call wMainForm.PopupMenu.Click(c_Folders & "|" & c_Acceptances)

  ''28.Տոկոսների հաշվարկում փաստաթղթի ստեղծում
  CalcDate  = "100116"
  Date = "100116"
  Call Calculate_Percent(fBase, CalcDate ,Date)
  
    'SQL ստուգում: Տոկոսների հաշվարկում փաստաթուղթ ստեղծելուց հետո 
      queryString = "select Sum(fCURSUM), Sum(fSUM) from HI where fDATE = '2016-01-10' and fBASE = " & fBASE & " and fDBCR = 'C'"
      sql_Value = 101410.30
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
      sql_Value = 101410.30
      colNum = 1
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
      
      queryString = "select Sum(fCURSUM), Sum(fSUM) from HI where fDATE = '2016-01-10' and fBASE = " & fBASE & " and fDBCR = 'D'"
      sql_Value = 101410.30
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
      sql_Value = 101410.30
      colNum = 1
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If

  ''29.Ակրեդիտիվ պայմանագրի պարտքերի մարման հայտի ստեղծում 
  Date = "110116" 
  Money = "10000"
  Count = ""
  AMDCount = ""
  Call AkrPayment(fBase, Date, Money, Count, AMDCount)
  Call Close_Pttel("frmPttel_2")
  
    'SQL ստուգում: Ակրեդիտիվ պայմանագրի պարտքերի մարման հայտ ստեղծելուց հետո պետք է fSUM = 10000.00
      queryString = "select * from HI where fDATE = '2016-01-11' and fBASE = " & fBASE & " and fDBCR = 'C'"
      sql_Value = 10000.00
      colNum = 3
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
      
      queryString = "select * from HI where fDATE = '2016-01-11' and fBASE = " & fBASE & " and fDBCR = 'D' and fTYPE = '01'"
      sql_Value = 10000.00
      colNum = 3
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
      
      queryString = "select * from HI where fDATE = '2016-01-11' and fBASE = " & fBASE & " and fDBCR = 'D' and fTYPE = '02'"
      sql_Value = 10000.00
      colNum = 3
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If

  ''30.Մայր պայմանագրի համար կատարել "Գործողություններ/Բոլոր գործողություններ/Դիտում և խմբագրումԱյլ/Սահմանաչափեր" գործողությունը - Սահմանաչափը պետք է լինի մայր պայմանագրի գումարին հավասար (100000):
  wMDIClient.Refresh

  'Սահմանաչափը պետք է լինի մայր պայմանագրի գումարին հավասար (100000):

  S_Date = "110515"
  F_Date = "110515"
  TF = 0
  ColVal = "1,000,000.00"
  Lim =  Check_Limit(S_Date, F_Date, TF, ColVal)
  If (Not Lim) Then
    call Log.Error("Սահմանաչափի արժեքը 1.000.000) չէ")
  End if
  
  Log.Message "Բոլոր փաստաթղթերի ջնջում"
  ''31.Ջնջել բոլոր փաստաթղթերը : 
  Call Delete_ByCount(1)
  Call Delete_ByCount(0)
  
  Call Delete_Doc()
  Call Close_AsBank()

End Sub

