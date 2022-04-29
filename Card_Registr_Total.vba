Option Explicit
'USEUNIT Subsystems_SQL_Library
'USEUNIT Library_Common
'USEUNIT Card_Library
'USEUNIT Mortgage_Library
'USEUNIT OLAP_Library
'USEUNIT Constants
'USEUNIT Library_Colour

'Test Case Id 165997

'Պլաստիկ Քարտեր ԱՇՏ/Ստացված հանրագումարներ
Sub Cards_Registr_Total_Test()
    
    Dim DateStart,DateEnd
    Dim RecClearingTrans,Path1,Path2,resultWorksheet,SortArr(2)
    Dim queryString,sql_Value, colNum,sql_isEqual
  
    DateStart = "20010101"
    DateEnd = "20240101"
    
    Set RecClearingTrans = New_ReceivedClearingTransactions()
    With RecClearingTrans
        .FileDate_1 = "121017"
        .FileDate_2 = "121017"
        .ShowMadeTransactions = 1
        .ShowArchivedOpers = 0
        .View = "VRcClear\2"
        .FillInto = "0"
    End With
    
    queryString = "update statistics HI DELETE FROM HI WHERE fDATE = '2018-05-21'"
  
    'Test StartUp start
    Call Initialize_AsBankQA(DateStart, DateEnd) 

    Call Create_Connection()
   ' Call Execute_SLQ_Query(queryString)
    Call ChangeWorkspace(c_CardsSV) 
    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''--- Թղթապանակի ստուգում ֆայլերի ընդունելուց հետո ---''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''' ''''''''''''''
    Log.Message "--- Check Rec Clearing Transaction After Add Files ---" ,,, DivideColor 

    Call GoToRecClearingTrans_PlasticCarts(RecClearingTrans) 
    Call CheckPttel_RowCount("frmPttel", 913)

    Path1 = Project.Path & "Stores\ExpectedReports\PlasticCards\FilesRegistr\Actual\Actual_RecClearingTrans.xlsx"
    Path2 = Project.Path & "Stores\ExpectedReports\PlasticCards\FilesRegistr\Expected\Expected_RecClearingTrans.xlsx"
    resultWorksheet = Project.Path & "Stores\ExpectedReports\PlasticCards\FilesRegistr\Result\Result_RecClearingTrans.xlsx"
    
    'Արտահանել և Ð³Ù»Ù³ï»É »ñÏáõ EXCEL ý³ÛÉ»ñ
    Call ExportToExcel("frmPttel",Path1)
    Call CompareTwoExcelFiles(Path1, Path2, resultWorksheet)  
    Call CloseAllExcelFiles()    
    
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''''''--- Հաշվառել փաստաթղթերը ---''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''' 
    Log.Message "--- Registr Cards Files ---" ,,, DivideColor 

    Call Registr_Cards_Total("210518")
    Call Close_Pttel("frmPttel")   
    
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''--- Թղթապանակի ստուգում ֆայլերի Հաշվառելուց հետո ---'''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''' ''''''''''''''
    Log.Message "--- Check Rec Clearing Transaction After Registr Cards ---" ,,, DivideColor 

    RecClearingTrans.FileDate_2 = "210518"
    Call GoToRecClearingTrans_PlasticCarts(RecClearingTrans) 
    Call CheckPttel_RowCount("frmPttel", 913)

    Path1 = Project.Path & "Stores\ExpectedReports\PlasticCards\FilesRegistr\Actual\Actual_RecClearingTransAfterRegistr.xlsx"
    Path2 = Project.Path & "Stores\ExpectedReports\PlasticCards\FilesRegistr\Expected\Expected_RecClearingTransAfterRegistr.xlsx"
    resultWorksheet = Project.Path & "Stores\ExpectedReports\PlasticCards\FilesRegistr\Result\Result_RecClearingTransAfterRegistr.xlsx"
    
    'Արտահանել և Ð³Ù»Ù³ï»É »ñÏáõ EXCEL ý³ÛÉ»ñ
    Call ExportToExcel("frmPttel",Path1)
    Call CompareTwoExcelFiles(Path1, Path2, resultWorksheet)  
    Call CloseAllExcelFiles()    
        
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''''''--- Կատարում է SQL ստուգում ---''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''' 
    Log.Message "SQL Check For Rec Clearing Transation",,,SqlDivideColor
  
      queryString = "select Count(*) from HI where fDATE = '2018-05-21' "
      sql_Value = 12
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
       
      queryString = "select Sum(fSUM) from HI where fDATE = '2018-05-21' and fTYPE = '01' and fDBCR = 'C' "
      sql_Value = 102.95
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
  
      queryString = "select Sum(fCURSUM) from HI where fDATE = '2018-05-21' and fTYPE = '01' and fDBCR = 'C'"
      sql_Value = 102.95
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
       
      queryString = "select Sum(fSUM) from HI where fDATE = '2018-05-21' and fTYPE = '01' and fDBCR = 'D'"
      sql_Value = 102.95
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If 
       
      queryString = "select Sum(fCURSUM) from HI where fDATE = '2018-05-21' and fTYPE = '01' and fDBCR = 'D'"
      sql_Value = 102.95
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If      
      
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''--- Ջնջում է բոլոր ներմուծած ֆայլերը ---''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "--- Delete All Contracts Total ---" ,,, DivideColor       

    'Ջնջում է բոլոր ներմուծած ֆայլերը
    Call Delete_All_Contracts_Total()
    Call Close_Pttel("frmPttel")
    
      'Կատարում է SQL ստուգում
      queryString = "select Count(*) from HI where fDATE = '2018-05-21' "
      sql_Value = 0
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
      If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
      End If
       
    'Փակել ASBANK-ը
    Call Close_AsBank()
End Sub