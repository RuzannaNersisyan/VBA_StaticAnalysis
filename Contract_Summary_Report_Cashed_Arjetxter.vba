Option Explicit
'USEUNIT Contract_Summary_Report_Library
'USEUNIT Subsystems_SQL_Library
'USEUNIT Library_Common
'USEUNIT Constants

'Test Case Id 166002

Sub Contract_Summary_Report_Cashed_Arjetxter_Check_Rows_Test()

    Dim expectedsumma,expectedPercent,expectedarjetxter,expectedContractSum,expectedGivenDayCount,expectedRepaymentDayCount,_
        expectedRepDayCount,expectedExtStateDayCount, expectedTotalExtDayCount,expectedConstExtDayCount
    Dim actualdsumma,actualPercent,actualarjetxter,actualCollateral,actualContractSum, actualGivenDayCount,actualRepaymentDayCount,_
        actualRepDayCount,actualExtStateDayCount, actualTotalExtDayCount,actualConstExtDayCount
    Dim queryString, sql_Value, sql_isEqual, colNum
    Dim startDATE, fDATE, Date, fBASE, frmPttelProgress  
                                                   
    Utilities.ShortDateFormat = "yyyymmdd"
    startDATE = "20011016"
    fDATE = "20240101"
    Date = "120314"
    queryString = "Delete from CAgrProfile where fTypeName = 'C7Disp'  and  fRepDate = '2014-03-12'"
    'Test StartUp start
    Call Initialize_AsBankQA(startDATE, fDATE)
    'Test StartUp end
    
    Call Create_Connection()
    Call Execute_SLQ_Query(queryString)
 
    expectedsumma = "0.00"
    expectedPercent = "0.00"
    expectedarjetxter = "487,500,000.00"
    expectedContractSum = "7,499,911,049.39"
    expectedGivenDayCount = "150367"
    expectedRepaymentDayCount = "98202"
    expectedRepDayCount = "98202"
    expectedExtStateDayCount = "5392"
    expectedTotalExtDayCount = "0"
    expectedConstExtDayCount = "0"
    
    Call ChangeWorkspace(c_Subsystems)
    Call wTreeView.DblClickItem("Ð³ßí»ïíáõÃÛáõÝÝ»ñ,  Ù³ïÛ³ÝÝ»ñ")
    Call wTreeView.DblClickItem("î»Õ³µ³ßËí³Í ÙÇçáóÝ»ñ|²ñÅ»ÃÕÃ»ñ ØØÄä|ä³ÛÙ³Ý³·ñ»ñÇ ³Ù÷á÷áõÙ (ø»ß³íáñí³Í)")
    
    'Պայմանագրի ամփոփում(Քեշավերված) փաստաթղթի լրացում 
    Call  Contract_Sammary_Report_Fill_Cashed(Date,False,False,False,False,False,False,False)                                  
    'Waiting for frmPttel
    Set frmPttelProgress = AsBank.WaitVBObject("frmPttelProgress", 3000)
    While frmPttelProgress.Exists
      BuiltIn.Delay(delay_small) 
    Wend
    
        'Կատարում ենք SQL ստուգում
        queryString = "select COUNT(*) from CAgrProfile where fTypeName = 'C7Disp'  and  fRepDate = '2014-03-12'"
        sql_Value = 63
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
    
        queryString = "select SUM(fSumma) from CAgrProfile where fTypeName = 'C7Disp'  and  fRepDate = '2014-03-12'"
        sql_Value = 7499911049.39
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
       
        queryString = "select SUM(fCliSecNominal) from CAgrProfile where fTypeName = 'C7Disp'  and  fRepDate = '2014-03-12'"
        sql_Value = 487500000.00
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
       
        queryString = "select SUM(fN0LIM) from CAgrProfile where fTypeName = 'C7Disp'  and  fRepDate = '2014-03-12'"
        sql_Value = 7740747000.00
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
      
        queryString = "select SUM(fN0PIN) from CAgrProfile where fTypeName = 'C7Disp'  and  fRepDate = '2014-03-12'"
        sql_Value = 805.4491
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
       
        queryString = "select SUM(fBefLastDebtDays) from CAgrProfile where fTypeName = 'C7Disp'  and  fRepDate = '2014-03-12'"
        sql_Value = 98202
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
       
        queryString = "Select SUM(fR1) from CAgrProfile where fTypeName = 'C7Disp'  and  fRepDate = '2014-03-12'"
        sql_Value = 0 '8571000000.00
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
       
        queryString = "Select SUM(fR2) from CAgrProfile where fTypeName = 'C7Disp'  and  fRepDate = '2014-03-12'"
        sql_Value = 0 '191577186.90
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If

       
        queryString = "Select SUM(fR8) from CAgrProfile where fTypeName = 'C7Disp'  and  fRepDate = '2014-03-12'"
        sql_Value = 0 '277804087.70
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
       
        queryString = "Select SUM(fR8Chrg) from CAgrProfile where fTypeName = 'C7Disp'  and  fRepDate = '2014-03-12'"
        sql_Value = 0 '14081436.40
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
       
        queryString = "Select SUM(fRN) from CAgrProfile where fTypeName = 'C7Disp'  and  fRepDate = '2014-03-12'"
        sql_Value = 0 '8470780189.00
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
       
        queryString = "Select SUM(fRM) from CAgrProfile where fTypeName = 'C7Disp'  and  fRepDate = '2014-03-12'"
        sql_Value = 0 '360312361.90
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
    
    'Ֆիլտրել օրերի քանակը
    Call wMainForm.MainMenu.Click("Դիտում |arjetxteriDayCount")

    With wMDIClient.VBObject("frmPttel").VBObject("tdbgView")
      actualdsumma = Trim(.Columns.Item(5).FooterText)
      actualPercent = Trim(.Columns.Item(12).FooterText)
      actualarjetxter = Trim(.Columns.Item(15).FooterText)
      actualContractSum = Trim(.Columns.Item(25).FooterText)
      actualGivenDayCount = Trim(.Columns.Item(37).FooterText)
      actualRepaymentDayCount = Trim(.Columns.Item(38).FooterText)
      actualRepDayCount = Trim(.Columns.Item(39).FooterText)
      actualExtStateDayCount = Trim(.Columns.Item(40).FooterText)
      actualTotalExtDayCount = Trim(.Columns.Item(41).FooterText)
      actualConstExtDayCount = Trim(.Columns.Item(42).FooterText)
    End With
    
    'Գումար սյան ստուգում
    If expectedsumma <> actualdsumma Then
      Log.Error("Dont match")
    End If
    
    'Տոկոս սյան ստուգում
    If expectedPercent <> actualPercent Then
      Log.Error("Dont match")
    End If
     
    'Հաճախ. արժեթ. սյան ստուգում
    If expectedarjetxter <> actualarjetxter Then
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
     
    'Տկ.մ.մ.օ.ք. սյան ստուգում
    If expectedExtStateDayCount <> actualExtStateDayCount Then
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
     
    wMDIClient.VBObject("frmPttel").Close()
   
    Call Close_AsBank()  
     
End Sub 