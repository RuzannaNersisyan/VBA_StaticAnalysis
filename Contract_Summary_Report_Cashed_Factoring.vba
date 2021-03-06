Option Explicit
'USEUNIT Contract_Summary_Report_Library
'USEUNIT Subsystems_SQL_Library
'USEUNIT Library_Common
'USEUNIT Constants
'USEUNIT OLAP_Library

'Test Case Id 166774

Sub Contract_Summary_Report_Cashed_Factoring_Check_Rows_Test()

    Dim expectedsumma,expectedExpSum,expectedMoneyOut,expectedPercent,expectedexpPercent, expectedNotusePer,expectedunearnedPer,expectedPerSalePer,expectedPerOut,expectedexpSumPen,_
        expectedFinal,expectedComission,expectedpenSum,expectedpenPer,expectedCollateral,expectedOutPenPer, expectedSale,expectedexppenPercent,expectedExpPer,expectedLimit,expectedOutPen,_
        expectedBuySum,expectedContractSum,expectedGivenDayCount,expectedBTHDPer,expectedRepaymentDayCount, expectedRepDayCount,expectedExtStateDayCount,expectedExtendedDayCount,expectedPerRepDayCount,_
        expectedExtDayCount,expectedTotalExtDayCount,expectedConstExtDayCount,expectedExtPerDAyCount, expectedPresentSum
    Dim actualdsumma,actualExpSum,actualMoneyOut,actualPercent,actualOutPen, actualexpPercent,actualNotusePer,actualunearnedPer,actualPerSalePer,actualPerOut,actualexppenPercent,_
        actualBTHDPer,actualComission,actualpenSum,actualpenPer,actualSale,actualGuarantee, actualBuySum,actualExpPer,actualFinal,actualNotUse,actualContractSum,_
        actualGivenDayCount,actualRepaymentDayCount,actualRepDayCount,actualExtStateDayCount, actualExtendedDayCount,actualPerRepDayCount,actualExtDayCount,actualTotalExtDayCount,_
        actualConstExtDayCount,actualExtPerDAyCount,actualPresentSum,actualOutPenPer
    Dim queryString,sql_Value,colNum,sql_isEqual,isExists,actualexpSumPen
    Dim startDATE, fDATE,Date,fBASE,EPath1, EPath2, arrIgnore, frmPttelProgress
        
            
    'Կատարում է ստուգում,եթե նման անունով ֆայլ կա տրված թղթապանակում ,ջնջում է
    isExists = aqFile.Exists(Project.Path & "Stores\Excel Files\factoring1.xlsx")
    If isExists Then
      aqFileSystem.DeleteFile(Project.Path & "Stores\Excel Files\factoring1.xlsx")
    End If
                                      
    Utilities.ShortDateFormat = "yyyymmdd"
    startDATE = "20111016"
    fDATE = "20250101"
    Date = "120314"
    queryString = "Delete from CAgrProfile where  fRepDate = '2014-03-12' and (fTypeName = 'C5Univer'  or fTypeName = 'C5Disp' or fTypeName = 'C5Simpl' )"
    'Test StartUp start
    Call Initialize_AsBank("bank",startDATE, fDATE)
    'Test StartUp end
    Call Create_Connection()
    Call Execute_SLQ_Query(queryString)
    
    expectedBuySum ="79,747,781.40" 
    expectedsumma = "79,777,000.00"
    expectedExpSum = "79,652,001.10"
    expectedMoneyOut = "480,000.00"
    expectedSale = "0.00"
    expectedPerSalePer = "0.00"
    expectedFinal = "28,718.60"
    expectedComission = "500.00"
    expectedPercent = "51,109.40"
    expectedexpPercent = "0.00"    
    expectedExpPer = "51,109.40"   
    expectedPerOut = "2,000.00"
    expectedBTHDPer = "35,715,976.85"
    expectedexpSumPen = "888,233,076.23"
    expectedContractSum = "113,868,000.00"   
    expectedGivenDayCount = "47796"
    expectedRepaymentDayCount = "-54018"
    expectedRepDayCount = "-54018"
    expectedExtStateDayCount = "0"
    expectedExtendedDayCount = "0"
    expectedPerRepDayCount = "-1397"
    expectedExtDayCount = "72973"   
    expectedTotalExtDayCount = "73042"
    expectedConstExtDayCount = "680"   
    expectedExtPerDAyCount = "1869"
    expectedPresentSum = "1,003,748,443.88"  
    
    
    Call ChangeWorkspace(c_Factoring)
'    Call wTreeView.DblClickItem("Ð³ßí»ïíáõÃÛáõÝÝ»ñ,  Ù³ïÛ³ÝÝ»ñ")
    Call wTreeView.DblClickItem("|ü³ÏïáñÇÝ·|ä³ÛÙ³Ý³·ñ»ñÇ ³Ù÷á÷áõÙ (ø»ß³íáñí³Í)")
    
    'Պայմանագրի ամփոփում(Քեշավերված) փաստաթղթի լրացում 
    Call  Contract_Sammary_Report_Fill_Cashed(Date,False,False,False,False,False,False,False)                                  
    'Waiting for frmPttel
    Set frmPttelProgress = AsBank.WaitVBObject("frmPttelProgress", 3000)
    While frmPttelProgress.Exists
      BuiltIn.Delay(delay_small) 
    Wend 
    
       'Կատարում ենք SQL ստուգում:
        queryString = "select COUNT(*) from CAgrProfile where  fRepDate = '2014-03-12' and (fTypeName = 'C5Univer'  or fTypeName = 'C5Disp' or fTypeName = 'C5Simpl')"
        sql_Value = 133
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
      
        queryString = "select SUM(fSumma) from CAgrProfile where  fRepDate = '2014-03-12' and (fTypeName = 'C5Univer'  or fTypeName = 'C5Disp' or fTypeName = 'C5Simpl')"
        sql_Value = 113868000.00
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
       
        queryString = "select SUM(fR2) from CAgrProfile where  fRepDate = '2014-03-12' and (fTypeName = 'C5Univer'  or fTypeName = 'C5Disp' or fTypeName = 'C5Simpl')"
        sql_Value = 51109.40
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
       
        queryString = "select SUM(fN0LIM) from CAgrProfile where  fRepDate = '2014-03-12' and (fTypeName = 'C5Univer'  or fTypeName = 'C5Disp' or fTypeName = 'C5Simpl')"
        sql_Value = 114347000.00
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
      
        queryString = "select SUM(fR1) from CAgrProfile where fRepDate = '2014-03-12' and (fTypeName = 'C5Univer'  or fTypeName = 'C5Disp' or fTypeName = 'C5Simpl')"
        sql_Value = 79777000.00
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
     
        queryString = "select SUM(fN0PN1) from CAgrProfile where  fRepDate = '2014-03-12' and (fTypeName = 'C5Univer'  or fTypeName = 'C5Disp' or fTypeName = 'C5Simpl')"
        sql_Value = 0.00
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
       
        queryString = "select SUM(fN0PN2) from CAgrProfile where  fRepDate = '2014-03-12' and (fTypeName = 'C5Univer'  or fTypeName = 'C5Disp' or fTypeName = 'C5Simpl')"
        sql_Value = 0.00
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
       
        queryString = "select SUM(fPresentValue) from CAgrProfile where  fRepDate = '2014-03-12' and (fTypeName = 'C5Univer'  or fTypeName = 'C5Disp' or fTypeName = 'C5Simpl')"
        sql_Value = 1003748443.88
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
       
        queryString = "select SUM(fPresentValuePure) from CAgrProfile where  fRepDate = '2014-03-12' and (fTypeName = 'C5Univer'  or fTypeName = 'C5Disp' or fTypeName = 'C5Simpl')"
        sql_Value = 79799390.80
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
    
      'Ֆիլտրել օրերի քանակը
    Call wMainForm.MainMenu.Click("Դիտում |facDayCount")
   
    With wMDIClient.VBObject("frmPttel").VBObject("tdbgView")
      actualBuySum = Trim(.Columns.Item(3).FooterText)
      actualdsumma = Trim(.Columns.Item(4).FooterText)
      actualExpSum = Trim(.Columns.Item(5).FooterText)
      actualMoneyOut = Trim(.Columns.Item(6).FooterText)
      actualSale = Trim(.Columns.Item(7).FooterText)
      actualPerSalePer = Trim(.Columns.Item(8).FooterText)
      actualFinal = Trim(.Columns.Item(9).FooterText)
      actualComission = Trim(.Columns.Item(10).FooterText) 
      actualPercent = Trim(.Columns.Item(11).FooterText)
      actualexpPercent = Trim(.Columns.Item(12).FooterText)
      actualExpPer = Trim(.Columns.Item(13).FooterText)
      actualPerOut = Trim(.Columns.Item(14).FooterText)
      actualBTHDPer = Trim(.Columns.Item(16).FooterText)
      actualexpSumPen = Trim(.Columns.Item(18).FooterText)
      actualContractSum = Trim(.Columns.Item(48).FooterText)
      actualGivenDayCount = Trim(.Columns.Item(64).FooterText)
      actualRepaymentDayCount = Trim(.Columns.Item(65).FooterText)
      actualRepDayCount = Trim(.Columns.Item(66).FooterText)
      actualExtStateDayCount = Trim(.Columns.Item(67).FooterText)
      actualExtendedDayCount = Trim(.Columns.Item(68).FooterText)
      actualPerRepDayCount = Trim(.Columns.Item(69).FooterText)
      actualExtDayCount = Trim(.Columns.Item(70).FooterText)
      actualTotalExtDayCount = Trim(.Columns.Item(71).FooterText)
      actualConstExtDayCount = Trim(.Columns.Item(72).FooterText)
      actualExtPerDAyCount = Trim(.Columns.Item(74).FooterText)
      actualPresentSum = Trim(.Columns.Item(100).FooterText)
    End With
    
     'Գումար սյան ստուգում
     If expectedsumma <> actualdsumma Then
        Log.Error("Dont match")
     End If

     'Ժամկետանց Գումար սյան ստուգում
     If expectedExpSum <> actualExpSum Then
        Log.Error("Dont match")
     End If
     
     'Վճարված Գումար սյան ստուգում
     If expectedBuySum <> actualBuySum Then
         Log.Error("Dont match")
     End If
     
     'Ժամկետանց տոկոս սյան ստուգում
     If expectedExpPer <> actualExpPer Then
         Log.Error("Dont match")
     End If
      
     'ԲՏՀԴ տոկոս սյան ստուգում
     If expectedBTHDPer <> actualBTHDPer Then
         Log.Error("Dont match")
     End If
     
     'Ժամկետանց գումարի տույժ դաշտի ստուգում
     If expectedexpSumPen <> actualexpSumPen Then
         Log.Error("Dont match")
     End If
     
     'Դուրս գրվաց գումար սյան ստուգում
     If expectedMoneyOut <> actualMoneyOut Then
         Log.Error("Dont match")
     End If
     
     'Դուրս գրված զեղչատոկոս սյան ստուգում
     If expectedPerSalePer <> actualPerSalePer Then
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
     
     'Դուրս գրված տոկոս սյան ստուգում
     If expectedPerOut <> actualPerOut Then
         Log.Error("Dont match")
     End If
     
     'Զեղչ./Հավ. սյան ստուգում
     If expectedSale <> actualSale Then
         Log.Error("Dont match")
     End If
     
     'Վերջնահաշվարկ սյան ստուգում
     If expectedFinal <> actualFinal Then
         Log.Error("Dont match")
     End If
     
     'Կոմիսիոն գումարի տույժ սյան ստուգում
     If expectedComission <> actualComission Then
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
     
     'Ֆիլտրել սյուները
     Call wMainForm.MainMenu.Click("Դիտում |RemoveColumns")
     Delay(2000)
     Call Sys.Process("Asbank").VBObject("MainForm").VBObject("tbToolBar").Window("ToolbarWindow32", "", 1).ClickItem(27)
     
     'Save as EXCEL ֆայլը "Excel Files" թղթապանակում
     Dim strObjName,p,wnd
     strObjName = "Window(""XLMAIN"", ""* - Excel"")"
     Set p = Sys.Process("EXCEL")
     Sys.Process("EXCEL").Window("XLMAIN", "* - Excel", 1).Window("XLDESK", "", 1).Window("EXCEL7", "*", 1).Keys("[F12]")

     Builtin.Delay(2000)
     Sys.Process("EXCEL").Window("#32770", "Save As", 1).Window("DUIViewWndClassName", "", 1).Window("DirectUIHWND", "", 1).Window("FloatNotifySink", "", 1).Window("ComboBox", "", 1).Window("Edit", "", 1).Keys(Project.Path & "Stores\Excel Files\factoring1.xlsx")
     Sys.Process("EXCEL").Window("#32770", "Save As", 1).Window("Button", "&Save", 1).Click()
     
     EPath1 = Project.Path & "Stores\Excel Files\factoring1.xlsx"
     EPath2 = Project.Path & "Stores\Excel Files\factoring.xlsx"
     arrIgnore = Array("$A$1")
     Call ComparisonTwoExcelFilesWithCheck(EPath1, EPath2, arrIgnore)
     p.Close()
     wMDIClient.VBObject("frmPttel").Close()     
     Call Close_AsBank()  
     
End Sub 