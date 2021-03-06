Option Explicit

'USEUNIT Library_Common
'USEUNIT OLAP_Library

'Test Case ID 166367

Sub Accountanty_soushi_liab_Test() 

    Dim exists, SPath, userName, Passord, StartDate, EndDate, AccNumber, TreeLevel, CBranch, Language 
    Dim EPath1, EPath2, resultWorksheet, Thousand, RequesQuery, i, j, DB1, param, CurrDate, windExists, Cont
  
    SPath = Project.Path & "Stores\Actual_OLAP"
    EPath1 = Project.Path & "Stores\Actual_OLAP\soushi_liab_xml.xlsx"
    EPath2 = Project.Path & "Stores\Expected_OLAP\soushi_liab_xml_28.02.14.xlsx"
    resultWorksheet = Project.Path & "Stores\Result_Olap\Result_soushi_liab_xml.xlsx"
     'Î³ï³ñáõÙ ¿ ëïáõ·áõÙ,»Ã» ÝÙ³Ý ³ÝáõÝáí ý³ÛÉ Ï³ ïñí³Í ÃÕÃ³å³Ý³ÏáõÙ ,çÝçáõÙ ¿   
    exists = aqFile.Exists(EPath1)
    If exists Then
        aqFileSystem.DeleteFile(EPath1)
    End If
    
    'Test StartUp start
    Call Initialize_Excel ()
    'Test StartUp end
    
    Call Sys.Process("EXCEL").Window("XLMAIN", "Excel", 1).Window("FullpageUIHost").Window("NetUIHWND").Click(505, 236)
    
    Call AddOLAPAddIn ()
 
     userName = "ADMIN"
     Passord= ""
     DB1 = "bankTesting_QA"
   
    'Î³ï³ñ»É ³ßË³ï³ÝùÇ ëÏÇ½µ
    Call Start_Work(userName ,Passord,DB1 )
     i = 0
     j = 42
    
    '´³ó»É Ñ³ßí»ïíáõÃÛ³Ü Ó¨³ÝÙáõß ïíÛ³ÉÝ»ñÇ å³ÑáóÇó
    Call Open_Accountanty(i,j)

    windExists = False
    CurrDate = "28022014"
    StartDate = Null
    EndDate = Null
    AccNumber = "1"
    TreeLevel = NULL
    CBranch = "99997"
    Language  = "Հայերեն"
    Thousand = True
    RequesQuery = "60"
    param = "soushi_liab_xml.xlsx"
    Cont = False
    
    'Ð³ßí³ñÏ»É Ñ³ßí»ïíáõÃÛáõÝÁ 
    Call Calculate_Report_Range_LCR_NSFR(windExists,CurrDate,StartDate,EndDate,AccNumber,TreeLevel,CBranch,Language ,Thousand,RequesQuery,param)

    BuiltIn.Delay(1000)
   
    'ä³Ñ»É ý³ÛÉÁ ACTUAL_OLAP ÃÕÃ³å³Ý³ÏáõÙ
    Call Save_To_Folder_LCR(SPath,param)
   
   'Ð³Ù»Ù³ï»É »ñÏáõ EXCEL ý³ÛÉ»ñ
    Call CompareTwoExcelFiles(EPath1, EPath2, resultWorksheet)
    
    'Î³ï³ñ»É ²ßË³ï³ÝùÇ ³í³ñï
    Sys.Process("EXCEL").Window("XLMAIN", "" & param& " - Excel", 1).Window("EXCEL2", "", 2).ToolBar("Ribbon").Window("MsoWorkPane", "Ribbon", 1).Window("NUIPane", "", 1).Window("NetUIHWND", "", 1).Keys("~X")
    Sys.Process("EXCEL").Window("XLMAIN", "" & param& " - Excel", 1).Window("EXCEL2", "", 2).ToolBar("Ribbon").Window("MsoWorkPane", "Ribbon", 1).Window("NUIPane", "", 1).Window("NetUIHWND", "", 1).Keys("Y7")
  
    'ö³Ï»É EXCEL- Á
    'TestedApps.Items("EXCEL").Close
    Call CloseAllExcelFiles()
    TestedApps.killproc.Run()
End Sub