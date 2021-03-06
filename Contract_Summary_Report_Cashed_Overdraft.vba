Option Explicit
'USEUNIT Contract_Summary_Report_Library
'USEUNIT Subsystems_SQL_Library
'USEUNIT Library_Common
'USEUNIT Constants
'USEUNIT OLAP_Library

'Test Case Id 166006

Sub Contract_Summary_Report_Cashed_Overdraft_Check_Rows_Test()

    Dim expectedsumma,expectedexpSumma,expectedMoneyOut,expectedPercent,expectedexpPercent,expectedAJOOld, expectedNotusePer,expectedunearnedPer,expectedexppenPercent,expectedPerOut,expectedAJOTime,_
        expectedBTHD, expectedDgBthd,expectedpenSum,expectedpenPer,expectedCollateral,expectedOutPenPer, expectedGuarantee, expectedReservedSum,expectedNotUsedReserve,expectedLimit,expectedOutPen,expectedSumPen,_
        expectedNotUse, expectedContractSum,expectedGivenDayCount,expectedRepaymentDayCount,expectedAJONew, expectedRepDayCount,expectedExtStateDayCount,expectedExtendedDayCount,expectedPerRepDayCount,_
        expectedExtDayCount , expectedTotalExtDayCount,expectedConstExtDayCount,expectedExtPerDAyCount, expectedPresentSum
    Dim actualdsumma, actualexpSumma,actualMoneyOut,actualPercent,actualOutPenexpectedSumPen, actualexpPercent,actualNotusePer,actualunearnedPer,actualexppenPercent,actualPerOut,actualAJOTime,_
        actualBTHD,actualDgBthd,actualpenSum,actualpenPer,actualCollateral,actualGuarantee,actualAJOOld, actualReservedSum,actualNotUsedReserve ,actualLimit, actualNotUse,actualContractSum,actualAJONew,actualOutPen,_  
        actualGivenDayCount,actualRepaymentDayCount,actualRepDayCount,actualExtStateDayCount,actualSumPen, actualExtendedDayCount,actualPerRepDayCount,actualExtDayCount,actualTotalExtDayCount,_
        actualConstExtDayCount,actualExtPerDAyCount,actualPresentSum,actualOutPenPer
    Dim queryString,sql_Value,colNum,sql_isEqual,isExists
    Dim p, Date, fBASE, EPath1, EPath2, arrIgnore
    Dim startDATE, fDATE, frmPttelProgress
                 
    'Կատարում է ստուգում,եթե նման անունով ֆայլ կա տրված թղթապանակում ,ջնջում է
    isExists = aqFile.Exists(Project.Path & "Stores\Excel Files\overdraft1.xlsx")
    If isExists Then
    aqFileSystem.DeleteFile(Project.Path & "Stores\Excel Files\overdraft1.xlsx")
    End If
                                          
    Utilities.ShortDateFormat = "yyyymmdd"
    startDATE = "20111016"
    fDATE = "20240101"
    Date = "120314"
    queryString = "Delete from CAgrProfile where  fRepDate = '2014-03-12' and (fTypeName = 'C3AS21'  or fTypeName = 'C3Univer'  or fTypeName = 'C3ASOv')"
    'Test StartUp start
    Call Initialize_AsBankQA(startDATE, fDATE)
    'Test StartUp endchi kapum?
    
    Call Create_Connection()
    Call Execute_SLQ_Query(queryString)
 
    expectedsumma = "382,732,861.68"
    expectedAJOTime = "114,495,431.42"
    expectedAJONew = "28,723,363.99"
    expectedAJOOld = "56,235,206.53"
    expectedexpSumma = "23,883,338.70"
    expectedMoneyOut = "19,850,799.50"
    expectedPercent = "9,494,518.42"
    expectedNotusePer = "0.00"
    expectedunearnedPer = "17,547,955.22"
    expectedexppenPercent = "1,979,366.30"
    expectedPerOut = "617,302.10"
    expectedBTHD = "0.00"
    expectedDgBthd = "0.00"
    expectedpenSum = "640,895.61"
    expectedpenPer = "219,230.23"
    expectedOutPen = "612,405.21"
    expectedOutPenPer = "82,424.03"
    expectedSumPen = "0.00"
    expectedCollateral = "55,352,704.18"
    expectedGuarantee = "0.00"
    expectedReservedSum = "9,550,569.80"
    expectedNotUsedReserve = "4,456,642.11"
    expectedLimit = "569,047,394.00"
    expectedNotUse = "231,957,784.62"
    expectedContractSum = "589,496,844.00"
    expectedGivenDayCount = "398070"    
    expectedRepaymentDayCount = "187436"  
    expectedRepDayCount = "187436"      
    expectedExtStateDayCount = "0"
    expectedExtendedDayCount = "0"
    expectedPerRepDayCount = "107135"
    expectedExtDayCount = "4731"
    expectedTotalExtDayCount = "10177"
    expectedConstExtDayCount = "560"
    expectedExtPerDAyCount = "1251"
    expectedPresentSum = "393,087,505.94"
    
    
    Call ChangeWorkspace(c_Subsystems)
    Call wTreeView.DblClickItem("Ð³ßí»ïíáõÃÛáõÝÝ»ñ,  Ù³ïÛ³ÝÝ»ñ")
    Call wTreeView.DblClickItem("î»Õ³µ³ßËí³Í ÙÇçáóÝ»ñ|úí»ñ¹ñ³ýï (ï»Õ³µ³ßËí³Í)|ä³ÛÙ³Ý³·ñ»ñÇ ³Ù÷á÷áõÙ (ø»ß³íáñí³Í)")
    
    'Պայմանագրի ամփոփում(Քեշավերված) փաստաթղթի լրացում 
    Call  Contract_Sammary_Report_Fill_Cashed(Date,False,False,False,False,False,False,False)                                                         
    'Waiting for frmPttel
    Set frmPttelProgress = AsBank.WaitVBObject("frmPttelProgress", 3000)
    While frmPttelProgress.Exists
      BuiltIn.Delay(delay_small) 
    Wend 
    
       'Կատարում ենք SQL ստուգում
       queryString = "select COUNT(*) from CAgrProfile where  fRepDate = '2014-03-12' and (fTypeName = 'C3AS21'  or fTypeName = 'C3Univer'  or fTypeName = 'C3ASOv')"
       sql_Value = 548
       colNum = 0
       sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
       If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
       End If
      
       queryString = "select SUM(fSumma) from CAgrProfile where  fRepDate = '2014-03-12' and (fTypeName = 'C3AS21'  or fTypeName = 'C3Univer'  or fTypeName = 'C3ASOv')"
       sql_Value = 589496844.00
       colNum = 0
       sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
       If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
       End If
       
       queryString = "select SUM(fR2) from CAgrProfile where  fRepDate = '2014-03-12' and (fTypeName = 'C3AS21'  or fTypeName = 'C3Univer'  or fTypeName = 'C3ASOv')"
       sql_Value = 9494518.42
       colNum = 0
       sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
       If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
       End If
       
       queryString = "select SUM(fN0LIM) from CAgrProfile where  fRepDate = '2014-03-12' and (fTypeName = 'C3AS21'  or fTypeName = 'C3Univer'  or fTypeName = 'C3ASOv')"
       sql_Value = 569047394.00
       colNum = 0
       sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
       If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
       End If
      
       queryString = "select SUM(fR1) from CAgrProfile where  fRepDate = '2014-03-12' and (fTypeName = 'C3AS21'  or fTypeName = 'C3Univer'  or fTypeName = 'C3ASOv')"
       sql_Value = 212002223.73
       colNum = 0
       sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
       If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
       End If
       
       queryString = "select SUM(fRO) from CAgrProfile where  fRepDate = '2014-03-12' and (fTypeName = 'C3AS21'  or fTypeName = 'C3Univer'  or fTypeName = 'C3ASOv')"
       sql_Value = 4456642.11
       colNum = 0
       sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
       If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
       End If
       
       queryString = "select SUM(fRA) from CAgrProfile where  fRepDate = '2014-03-12' and (fTypeName = 'C3AS21'  or fTypeName = 'C3Univer'  or fTypeName = 'C3ASOv')"
       sql_Value = 56235206.53
       colNum = 0
       sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
       If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
       End If
       
       queryString = "select SUM(fN0PN1) from CAgrProfile where  fRepDate = '2014-03-12' and (fTypeName = 'C3AS21'  or fTypeName = 'C3Univer'  or fTypeName = 'C3ASOv')"
       sql_Value = 10089.1221
       colNum = 0
       sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
       If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
       End If
       
       queryString = "select SUM(fN0PN2) from CAgrProfile where  fRepDate = '2014-03-12' and (fTypeName = 'C3AS21'  or fTypeName = 'C3Univer'  or fTypeName = 'C3ASOv')"
       sql_Value = 10089.1221
       colNum = 0
       sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
       If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
       End If
       
       queryString = "select SUM(fR4) from CAgrProfile where  fRepDate = '2014-03-12' and (fTypeName = 'C3AS21'  or fTypeName = 'C3Univer'  or fTypeName = 'C3ASOv')"
       sql_Value = 9550569.80
       colNum = 0
       sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
       If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
       End If
       
       queryString = "select SUM(fR0) from CAgrProfile where  fRepDate = '2014-03-12' and (fTypeName = 'C3AS21'  or fTypeName = 'C3Univer'  or fTypeName = 'C3ASOv')"
       sql_Value = 114495431.42
       colNum = 0
       sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
       If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
       End If
       
       queryString = "select SUM(fUnusedSum) from CAgrProfile where  fRepDate = '2014-03-12' and (fTypeName = 'C3AS21'  or fTypeName = 'C3Univer'  or fTypeName = 'C3ASOv')"
       sql_Value = 231957784.62
       colNum = 0
       sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
       If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
       End If
       
       queryString = "select SUM(fPresentValue) from CAgrProfile where  fRepDate = '2014-03-12' and (fTypeName = 'C3AS21'  or fTypeName = 'C3Univer'  or fTypeName = 'C3ASOv')"
       sql_Value = 393087505.94
       colNum = 0
       sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
       If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
       End If
       
       queryString = "select SUM(fPresentValuePure) from CAgrProfile where  fRepDate = '2014-03-12' and (fTypeName = 'C3AS21'  or fTypeName = 'C3Univer'  or fTypeName = 'C3ASOv')"
       sql_Value = 392227380.10
       colNum = 0
       sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
       If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
       End If
       
       queryString = "select SUM(fPerSumFuture) from CAgrProfile where  fRepDate = '2014-03-12' and (fTypeName = 'C3AS21'  or fTypeName = 'C3Univer'  or fTypeName = 'C3ASOv')"
       sql_Value = 17547955.22
       colNum = 0
       sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
       If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
       End If
       
       queryString = "select SUM(fMortgageSum) from CAgrProfile where  fRepDate = '2014-03-12' and (fTypeName = 'C3AS21'  or fTypeName = 'C3Univer'  or fTypeName = 'C3ASOv')"
       sql_Value = 55352704.1789
       colNum = 0
       sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
       If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
       End If
    
    'Ֆիլտրել օրերի քանակը
    Call wMainForm.MainMenu.Click("Դիտում |overDayCount")
   
    With wMDIClient.VBObject("frmPttel").VBObject("tdbgView")
      actualdsumma = Trim(.Columns.Item(3).FooterText)
      actualAJOTime = Trim(.Columns.Item(4).FooterText)
      actualAJONew = Trim(.Columns.Item(5).FooterText)
      actualAJOOld = Trim(.Columns.Item(6).FooterText)
      actualexpSumma = Trim(.Columns.Item(7).FooterText)
      actualMoneyOut = Trim(.Columns.Item(8).FooterText)
      actualPercent = Trim(.Columns.Item(9).FooterText)
      actualNotusePer = Trim(.Columns.Item(10).FooterText)
      actualunearnedPer = Trim(.Columns.Item(11).FooterText)
      actualexppenPercent = Trim(.Columns.Item(12).FooterText)
      actualPerOut = Trim(.Columns.Item(14).FooterText)
      actualBTHD = Trim(.Columns.Item(16).FooterText)
      actualDgBthd = Trim(.Columns.Item(17).FooterText)
      actualpenSum = Trim(.Columns.Item(18).FooterText)
      actualpenPer = Trim(.Columns.Item(19).FooterText)
      actualOutPen = Trim(.Columns.Item(20).FooterText)
      actualOutPenPer = Trim(.Columns.Item(21).FooterText)
      actualSumPen = Trim(.Columns.Item(22).FooterText)
      actualCollateral = Trim(.Columns.Item(25).FooterText)
      actualGuarantee = Trim(.Columns.Item(26).FooterText)
      actualReservedSum = Trim(.Columns.Item(33).FooterText)
      actualNotUsedReserve = Trim(.Columns.Item(34).FooterText)
      actualLimit = Trim(.Columns.Item(47).FooterText)
      actualNotUse = Trim(.Columns.Item(48).FooterText)
      actualContractSum = Trim(.Columns.Item(49).FooterText)
      actualGivenDayCount = Trim(.Columns.Item(65).FooterText)
      actualRepaymentDayCount = Trim(.Columns.Item(66).FooterText)
      actualRepDayCount = Trim(.Columns.Item(67).FooterText)
      actualExtStateDayCount = Trim(.Columns.Item(68).FooterText)
      actualExtendedDayCount = Trim(.Columns.Item(69).FooterText)
      actualPerRepDayCount = Trim(.Columns.Item(70).FooterText)
      actualExtDayCount = Trim(.Columns.Item(71).FooterText)
      actualTotalExtDayCount = Trim(.Columns.Item(72).FooterText)
      actualConstExtDayCount = Trim(.Columns.Item(73).FooterText)
      actualExtPerDAyCount = Trim(.Columns.Item(75).FooterText)
      actualPresentSum = Trim(.Columns.Item(106).FooterText)
    End With
    
    'Գումար սյան ստուգում
    If expectedsumma <> actualdsumma Then
      Log.Error("Dont match")
    End If
     
    'ԱԺՕ.ժամ-յին գ. սյան ստուգում
    If expectedAJOTime  <> actualAJOTime  Then
      Log.Error("Dont match")
    End If
     
    'ԱԺՕ.նոր.ժ-ց գ. սյան ստուգում
    If expectedAJONew <> actualAJONew Then
      Log.Error("Dont match")
    End If
     
    'ԱՅՕ.հին.ժ-ց.գ. սյան ստուգում
    If expectedAJOOld <> actualAJOOld Then
      Log.Error("Dont match")
    End If
    
    'Ժանկետանց գումար սյան ստուգում
    If expectedexpSumma <> actualexpSumma Then
       Log.Error("Dont match")
    End If
     
    'Դուրս գրված գումար սյան ստուգում
    If expectedMoneyOut <> actualMoneyOut Then
       Log.Error("Dont match")
    End If
     
    'Տոկոս սյան ստուգում
    If expectedPercent <> actualPercent Then
       Log.Error("Dont match")
    End If
    
    'Չօգտ. մաս տոկոս սյան ստուգում
    If expectedNotusePer <> actualNotusePer Then
       Log.Error("Dont match")
    End If
     
    'ժամկետանց չօգտ. մասի տոկոս սյան ստուգում
    If expectedexppenPercent <> actualexppenPercent Then
       Log.Error("Dont match")
    End If
     
    'Չվաստակած տոկոս սյան ստուգում
    If expectedunearnedPer <> actualunearnedPer Then
       Log.Error("Dont match")
    End If
     
    'Չվաստակած տոկոս սյան ստուգում
    If expectedexppenPercent <> actualexppenPercent Then
       Log.Error("Dont match")
    End If
     
    'Դուրս գրված տոկոս սյան ստուգում
    If expectedPerOut <> actualPerOut Then
       Log.Error("Dont match")
    End If
     
    'ԲՏՀԴ տոկ. սյան ստուգում
    If expectedBTHD <> actualBTHD Then
       Log.Error("Dont match")
    End If
     
    'Դ.գ. ԲՏՀԴ  սյան ստուգում
    If expectedDgBthd <> actualDgBthd Then
       Log.Error("Dont match")
    End If
     
    'Ժամկետանց գումարի տույժ սյան ստուգում
    If expectedpenSum <> actualpenSum Then
       Log.Error("Dont match")
    End If
     
    'Ժամկետանց տոկոսի տույժ սյան ստուգում
    If expectedpenPer <> actualpenPer Then
       Log.Error("Dont match")
    End If
     
    'Դուրս գրված տույժ սյան ստուգում
    If expectedOutPen <> actualOutPen Then
       Log.Error("Dont match")
    End If
     
    'Դուրս գրված տույժ սյան ստուգում
    If expectedOutPenPer <> actualOutPenPer Then
       Log.Error("Dont match")
    End If
     
    'Ժամկետանց գումարի տոկոս սյան ստուգում
    If expectedSumPen <> actualSumPen Then
       Log.Error("Dont match")
    End If
   
    'Գրավի արժեք սյան ստուգում
    If expectedCollateral <> actualCollateral Then
       Log.Error("Dont match")
    End If
     
    'Երաշխավորության արժեք սյան ստուգում
    If expectedGuarantee <> actualGuarantee Then
       Log.Error("Dont match")
    End If
     
    'Պահուստավորված գումար սյան ստուգում
    If expectedReservedSum <> actualReservedSum Then
       Log.Error("Dont match")
    End If
     
    'Չօգտ.մասի պահ. սյան ստուգում
    If expectedNotUsedReserve <> actualNotUsedReserve Then
       Log.Error("Dont match")
    End If
     
    'Չօգտ.մաս սյան ստուգում
    If expectedNotUse <> actualNotUse Then
       Log.Error("Dont match")
    End If
     
    'Պայմանագրի գումար սյան ստուգում
    If expectedContractSum <> actualContractSum Then
       Log.Error("Dont match")
    End If
     
    'Տ.օ.ք. սյան ստուգում
    If expectedGivenDayCount <> actualGivenDayCount Then
       Log.Error("Dont match")
    End If
     
    'Մ.օ.ք. սյան ստուգում
    If expectedRepaymentDayCount <> actualRepaymentDayCount Then
      Log.Error("Dont match")
    End If
     
    'Մ.օ.ք.ա.մ.ժ. սյան ստուգում
    If expectedRepDayCount <> actualRepDayCount Then
      Log.Error("Dont match")
    End If
     
    'Երկ/վիճ. գ.օ.ք. սյան ստուգում
    If expectedExtStateDayCount <> actualExtStateDayCount Then
       Log.Error("Dont match")
    End If
      
    'Երկ.օ.ք. սյան ստուգում
    If expectedExtendedDayCount <> actualExtendedDayCount Then
       Log.Error("Dont match")
    End If
     
    'Տկ.մ.մ.օ.ք. սյան ստուգում
    If expectedPerRepDayCount <> actualPerRepDayCount Then
       Log.Error("Dont match")
    End If
     
    'Ժամկ.օ.ք. սյան ստուգում
    If expectedExtDayCount <> actualExtDayCount Then
       Log.Error("Dont match")
    End If
     
    'Ընդ.ժամկ.օ.ք. սյան ստուգում
    If expectedTotalExtDayCount <> actualTotalExtDayCount Then
       Log.Error("Dont match")
    End If
     
    'Անընդ.յամկ.օ.ք. սյան ստուգում
    If expectedConstExtDayCount <> actualConstExtDayCount Then
       Log.Error("Dont match")
    End If
     
    'Տկ.ժ.օ.ք. սյան ստուգում
    If expectedExtPerDAyCount <> actualExtPerDAyCount Then
       Log.Error("Dont match")
    End If
    Log.Message(expectedPresentSum)
    log.Message(actualPresentSum)
     
    'Ներկա արժեք սյան ստուգում
    If expectedPresentSum <> actualPresentSum Then
       Log.Error("Dont match")
    End If
     
    'Ֆիլտրել սյուները
    Call wMainForm.MainMenu.Click("Դիտում |RemoveColumn")
    Call Sys.Process("Asbank").VBObject("MainForm").VBObject("tbToolBar").Window("ToolbarWindow32", "", 1).ClickItem(27)
    
    'Save as EXCEL ֆայլը "Excel Files" թղթապանակում
    Set p = Sys.Process("EXCEL")
    Sys.Process("EXCEL").Window("XLMAIN", "* - Excel", 1).Window("XLDESK", "", 1).Window("EXCEL7", "*", 1).Keys("[F12]")
    Builtin.Delay(2000)
    Sys.Process("EXCEL").Window("#32770", "Save As", 1).Window("DUIViewWndClassName", "", 1).Window("DirectUIHWND", "", 1).Window("FloatNotifySink", "", 1).Window("ComboBox", "", 1).Window("Edit", "", 1).Keys(Project.Path & "Stores\Excel Files\overdraft1.xlsx")
    Sys.Process("EXCEL").Window("#32770", "Save As", 1).Window("Button", "&Save", 1).Click()
     
    EPath1 = Project.Path & "Stores\Excel Files\overdraft1.xlsx"
    EPath2 = Project.Path & "Stores\Excel Files\overdraft.xlsx"
    arrIgnore = Array("$A$1")
    Call ComparisonTwoExcelFilesWithCheck(EPath1, EPath2, arrIgnore)
    p.Close()
    wMDIClient.VBObject("frmPttel").Close()
    Call Close_AsBank()
    
End Sub 