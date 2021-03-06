Option Explicit
'USEUNIT Contract_Summary_Report_Library
'USEUNIT Subsystems_SQL_Library
'USEUNIT Library_Common
'USEUNIT Constants
'USEUNIT OLAP_Library

'Test Case Id 166005

Sub Contract_Summary_Report_Cashed_Deposit_Check_Rows_Test()

    Dim expectedsumma,expectedexpSumma,expectedMoneyOut,expectedPercent,expectedexpPercent, expectedNotusePer,expectedunearnedPer,expectedexppenPercent,expectedPerOut,_
        expectedBTHD, expectedDgBthd,expectedpenSum,expectedpenPer,expectedCollateral,expectedOutPenPer, expectedGuarantee, expectedReservedSum,expectedNotUsedReserve,expectedLimit,expectedOutPen,_
        expectedNotUse, expectedContractSum,expectedGivenDayCount,expectedRepaymentDayCount, expectedRepDayCount,expectedExtStateDayCount,expectedExtendedDayCount,expectedPerRepDayCount,_
        expectedExtDayCount, expectedTotalExtDayCount,expectedConstExtDayCount,expectedExtPerDAyCount, expectedPresentSum
    Dim actualdsumma, actualexpSumma,actualMoneyOut,actualPercent,actualOutPen, actualexpPercent,actualNotusePer,actualunearnedPer,actualexppenPercent,actualPerOut,_
        actualBTHD,actualDgBthd,actualpenSum,actualpenPer,actualCollateral,actualGuarantee, actualReservedSum,actualNotUsedReserve ,actualLimit, actualNotUse,actualContractSum,_
        actualGivenDayCount,actualRepaymentDayCount,actualRepDayCount,actualExtStateDayCount, actualExtendedDayCount,actualPerRepDayCount,actualExtDayCount,actualTotalExtDayCount,_
        actualConstExtDayCount,actualExtPerDAyCount,actualPresentSum,actualOutPenPer
    Dim queryString,sql_Value,colNum,sql_isEqual,isExists,EPath1, EPath2, arrIgnore
    Dim startDATE, fDATE, Date, frmPttelProgress
    
            
    'Կատարում է ստուգում,եթե նման անունով ֆայլ կա տրված թղթապանակում ,ջնջում է
    isExists = aqFile.Exists(Project.Path & "Stores\Excel Files\deposit1.xlsx")
    If isExists Then
    aqFileSystem.DeleteFile(Project.Path & "Stores\Excel Files\deposit1.xlsx")
    End If
                                           
    Utilities.ShortDateFormat = "yyyymmdd"
    startDATE = "20111016"
    fDATE = "20240101"
    Date = "120314"
    queryString = "Delete from DAgrProfile where  fRepDate = '2014-03-12' and fTypeName = 'D1AS21'"
    'Test StartUp start
    Call Initialize_AsBankQA(startDATE, fDATE)
    'Test StartUp end
    
    Call Create_Connection()
    Call Execute_SLQ_Query(queryString)
    
    expectedsumma = "1,063,536,689.60"
    expectedexpSumma = "0.00"
    expectedPercent = "23,926,160.77"
    expectedexpPercent = "0.00"
    expectedunearnedPer = "0.00"
    expectedexppenPercent = "0.00"
    expectedpenSum = "0.00"
    expectedpenPer = "0.00"
    expectedCollateral = "0.00"
    expectedGuarantee = "0.00"
    expectedContractSum = "928,798,139.43"
    expectedGivenDayCount = "1013800"
    expectedRepaymentDayCount = "563234"
    expectedRepDayCount = "558846"
    expectedExtStateDayCount = "3407"
    expectedExtendedDayCount = "4388"
    expectedPerRepDayCount = "175995"
    expectedExtDayCount = "0"
    expectedTotalExtDayCount = "3"
    expectedConstExtDayCount = "2"
    expectedExtPerDAyCount = "0"
    expectedPresentSum = "1,087,462,850.37"
    
    
    Call ChangeWorkspace(c_Subsystems)
    Call wTreeView.DblClickItem("Ð³ßí»ïíáõÃÛáõÝÝ»ñ,  Ù³ïÛ³ÝÝ»ñ")
    Call wTreeView.DblClickItem("Ü»ñ·ñ³íí³Í ÙÇçáóÝ»ñ|²í³Ý¹Ý»ñ (Ý»ñ·ñ³íí³Í)|ä³ÛÙ³Ý³·ñ»ñÇ ³Ù÷á÷áõÙ (ø»ß³íáñí³Í)")
    
    'Պայմանագրի ամփոփում(Քեշավերված) փաստաթղթի լրացում 
    Call  Contract_Sammary_Report_Fill_Cashed(Date,False,False,False,False,False,False,False)                                                                      
    'Waiting for frmPttel
    Set frmPttelProgress = AsBank.WaitVBObject("frmPttelProgress", 3000)
    While frmPttelProgress.Exists
      BuiltIn.Delay(delay_small) 
    Wend 
    
        'Կատարում ենք SQL ստուգում: 
        queryString = "select COUNT(*) from DAgrProfile where  fRepDate = '2014-03-12' and fTypeName = 'D1AS21'"
        sql_Value = 2091
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
      
        queryString = "select SUM(fSumma) from DAgrProfile where  fRepDate = '2014-03-12' and fTypeName = 'D1AS21'"
        sql_Value = 928798139.43
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
       
        queryString = "select SUM(fR2) from DAgrProfile where  fRepDate = '2014-03-12' and fTypeName = 'D1AS21'"
        sql_Value = 23926160.77
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If

        queryString = "select SUM(fR1) from DAgrProfile where fRepDate = '2014-03-12' and fTypeName = 'D1AS21'"
        sql_Value = 1063536689.60 
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
     
        queryString = "select SUM(fN0PN1) from DAgrProfile where  fRepDate = '2014-03-12' and fTypeName = 'D1AS21'"
        sql_Value = 19300.9044
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
       
        queryString = "select SUM(fN0PN2) from DAgrProfile where  fRepDate = '2014-03-12' and fTypeName = 'D1AS21'"
        sql_Value = 19300.9044
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
       
        queryString = "select SUM(fPresentValue) from DAgrProfile where  fRepDate = '2014-03-12' and fTypeName = 'D1AS21'"
        sql_Value = 1087462850.37
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
       
        queryString = "select SUM(fPresentValuePure) from DAgrProfile where  fRepDate = '2014-03-12' and fTypeName = 'D1AS21'"
        sql_Value = 1087462850.37
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
   
    'Ֆիլտրել օրերի քանակը
    Call wMainForm.MainMenu.Click("Դիտում |depositDayCoun")
   
    With wMDIClient.VBObject("frmPttel").VBObject("tdbgView")
      actualdsumma = Trim(.Columns.Item(3).FooterText)
      actualexpSumma = Trim(.Columns.Item(4).FooterText)
      actualPercent = Trim(.Columns.Item(5).FooterText)
      actualexpPercent = Trim(.Columns.Item(6).FooterText)
      actualunearnedPer = Trim(.Columns.Item(7).FooterText)
      actualexppenPercent = Trim(.Columns.Item(8).FooterText)
      actualpenSum = Trim(.Columns.Item(9).FooterText)
      actualpenPer = Trim(.Columns.Item(10).FooterText)
      actualCollateral = Trim(.Columns.Item(11).FooterText)
      actualGuarantee = Trim(.Columns.Item(12).FooterText)
      actualContractSum = Trim(.Columns.Item(24).FooterText)
      actualGivenDayCount = Trim(.Columns.Item(39).FooterText)
      actualRepaymentDayCount = Trim(.Columns.Item(40).FooterText)
      actualRepDayCount = Trim(.Columns.Item(41).FooterText)
      actualExtStateDayCount = Trim(.Columns.Item(42).FooterText)
      actualExtendedDayCount = Trim(.Columns.Item(43).FooterText)
      actualPerRepDayCount = Trim(.Columns.Item(44).FooterText)
      actualExtDayCount = Trim(.Columns.Item(45).FooterText)
      actualTotalExtDayCount = Trim(.Columns.Item(46).FooterText)
      actualConstExtDayCount = Trim(.Columns.Item(47).FooterText)
      actualExtPerDAyCount = Trim(.Columns.Item(49).FooterText)
      actualPresentSum = Trim(.Columns.Item(63).FooterText)
    End With 
    
    'Գումար սյան ստուգում
    If expectedsumma <> actualdsumma Then
      Log.Error("Dont match")
    End If
     
    'Ժանկետանց գումար դաշտի ստուգում
    If expectedexpSumma <> actualexpSumma Then
       Log.Error("Dont match")
    End If
     
    'Տոկոս սյան ստուգում
    If expectedPercent <> actualPercent Then
       Log.Error("Dont match")
    End If
     
    'Արդյունավետ տոկոս սյան ստուգում
    If expectedexpPercent <> actualexpPercent Then
       Log.Error("Dont match")
    End If
     
    'Չվաստակած տոկոս սյան ստուգում
    If expectedunearnedPer <> actualunearnedPer Then
       Log.Error("Dont match")
    End If
     
    'ժամկետանց  տոկոս սյան ստուգում
    If expectedexppenPercent <> actualexppenPercent Then
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
     
    'Գրավի արժեք սյան ստուգում
    If expectedCollateral <> actualCollateral Then
       Log.Error("Dont match")
    End If
     
    'Երաշխավորության արժեք սյան ստուգում
    If expectedGuarantee <> actualGuarantee Then
       Log.Error("Dont match")
    End If
     
    'Պայմանագրի գումար սյան ստուգում
    If expectedContractSum  <> actualContractSum  Then
       Log.Error("Dont match")
    End If
     
    'Տ.օ.ք սյան ստուգում
    If expectedGivenDayCount <> actualGivenDayCount Then
       Log.Error("Dont match")
    End If
     
    'Մ.մ.օ.ք. սյան ստուգում
    If expectedRepaymentDayCount <> actualRepaymentDayCount Then
       Log.Error("Dont match")
    End If
     
    'Մ.մ.օ.ք.ա.մ.ժ. սյան ստուգում
    If expectedRepDayCount <> actualRepDayCount Then
       Log.Error("Dont match")
    End If
     
    'Երկ/վիճ. գ.օ.ք. սյան ստուգում
    If expectedExtStateDayCount <> actualExtStateDayCount Then
       Log.Error("Dont match")
    End If
     
    'Երկ. օ.ք. սյան ստուգում
    If expectedExtendedDayCount <> actualExtendedDayCount Then
       Log.Error("Dont match")
    End If
     
    'Տկ. մ.մ.օ.ք. սյան ստուգում
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
     
    'Անընդ. ժամկ.լ.ք. սյան ստուգում
    If expectedConstExtDayCount <> actualConstExtDayCount Then
       Log.Error("Dont match")
    End If
     
    'Տկ.ժ.օ.ք. սյան ստուգում
    If expectedExtPerDAyCount <> actualExtPerDAyCount Then
       Log.Error("Dont match")
    End If
     
    'Ներկա արժեք սյան ստուգում
    If expectedPresentSum <> actualPresentSum Then
       Log.Error("Dont match")
    End If
     
    wMainForm.Refresh
    BuiltIn.Delay(2000)
    'Ֆիլտրել սյուները
    Call wMainForm.MainMenu.Click("Դիտում |RemoveColumn")
    Call Sys.Process("Asbank").VBObject("MainForm").VBObject("tbToolBar").Window("ToolbarWindow32", "", 1).ClickItem(27)
    
    'Save as EXCEL ֆայլը "Excel Files" թղթապանակում
    Dim strObjName,p,wnd
    strObjName = "Window(""XLMAIN"", ""* - Excel"")"
    Set p = Sys.Process("EXCEL")
    Sys.Process("EXCEL").Window("XLMAIN", "* - Excel", 1).Window("XLDESK", "", 1).Window("EXCEL7", "*", 1).Keys("[F12]")
    Builtin.Delay(2000)
    Sys.Process("EXCEL").Window("#32770", "Save As", 1).Window("DUIViewWndClassName", "", 1).Window("DirectUIHWND", "", 1).Window("FloatNotifySink", "", 1).Window("ComboBox", "", 1).Window("Edit", "", 1).Keys(Project.Path & "Stores\Excel Files\deposit1.xlsx")
    Sys.Process("EXCEL").Window("#32770", "Save As", 1).Window("Button", "&Save", 1).Click()
     
    'Համեմատել EXCEL ֆայլերը
    EPath1 = Project.Path & "Stores\Excel Files\deposit1.xlsx"
    EPath2 = Project.Path & "Stores\Excel Files\deposit.xlsx"
    arrIgnore = Array("$A$1")
    Call ComparisonTwoExcelFilesWithCheck(EPath1, EPath2, arrIgnore)
    p.Close()
    wMDIClient.VBObject("frmPttel").Close()     
    Call Close_AsBank() 
    
End Sub 