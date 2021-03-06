Option Explicit

'USEUNIT Library_Common
'USEUNIT OLAP_Library
'USEUNIT Constants

'Test Case ID 166341


Sub Accountanty_16_Test() 

    Dim exists, SPath, userName, Passord, StartDate, EndDate, AccNumber, TreeLevel, CBranch, Language 
    Dim EPath1, EPath2, resultWorksheet, Thousand, RequesQuery, i, j, DB1, param, CurrDate, windExists, Cont
    Dim DateStart, DateEnd, aDate
       
    SPath = Project.Path & "Stores\Actual_OLAP"
    EPath1 = Project.Path & "Stores\Actual_OLAP\16600_16.xls"
    EPath2 = Project.Path & "Stores\Expected_OLAP\16600_16_28.02.14_nersic.xls"
    resultWorksheet = Project.Path & "Stores\Result_Olap\Result_16600_16.xls"
     'Î³ï³ñáõÙ ¿ ëïáõ·áõÙ,»Ã» ÝÙ³Ý ³ÝáõÝáí ý³ÛÉ Ï³ ïñí³Í ÃÕÃ³å³Ý³ÏáõÙ ,çÝçáõÙ ¿   
    exists = aqFile.Exists(EPath1)
    If exists Then
        aqFileSystem.DeleteFile(EPath1)
    End If

    DateStart = "20120101"
    DateEnd = "20240101"
    param = "16600_16.xls"
    
    'Test StartUp start
    Call Initialize_AsBankQA(DateStart, DateEnd) 
    'Test StartUp end
 
    Call ChangeWorkspace(c_ChiefAcc)
    Call wTreeView.DblClickItem("|¶ÉË³íáñ Ñ³ßí³å³ÑÇ ²Þî|Ð³ßí»ïíáõÃÛáõÝÝ»ñ,  Ù³ïÛ³ÝÝ»ñ|Î´ Ñ³ßí»ïíáõÃÛáõÝÝ»ñ|16 ØÇçµ³ÝÏ³ÛÇÝ å³Ñ³ÝçÝ»ñ ¨ å³ñï³íáñáõÃÛáõÝÝ»ñ")
    aDate = "280214"
    Cont = True
    BuiltIn.Delay(3000)
    Sys.Process("Asbank").VBObject("frmAsUstPar").VBObject("TabFrame").VBObject("TDBDate").Keys(aDate)
    Sys.Process("Asbank").VBObject("frmAsUstPar").VBObject("TabFrame").VBObject("Checkbox").wState = 1
    Sys.Process("Asbank").VBObject("frmAsUstPar").VBObject("CmdOK").Click()
   
    BuiltIn.Delay(10000)
    'ä³Ñ»É ý³ÛÉÁ ACTUAL_OLAP ÃÕÃ³å³Ý³ÏáõÙ
    Call Save_To_Folder(SPath,param,Cont)
     
  'Ð³Ù»Ù³ï»É »ñÏáõ EXCEL ý³ÛÉ»ñ
    Call CompareTwoExcelFiles(EPath1, EPath2, resultWorksheet)

    'Î³ï³ñ»É ²ßË³ï³ÝùÇ ³í³ñï
    Sys.Process("EXCEL").Window("XLMAIN", "" & param & "  [Compatibility Mode] - Excel", 1).Window("EXCEL2", "", 2).ToolBar("Ribbon").Window("MsoWorkPane", "Ribbon", 1).Window("NUIPane", "", 1).Window("NetUIHWND", "", 1).Keys("~X")
    Sys.Process("EXCEL").Window("XLMAIN", "" & param & "  [Compatibility Mode] - Excel", 1).Window("EXCEL2", "", 2).ToolBar("Ribbon").Window("MsoWorkPane", "Ribbon", 1).Window("NUIPane", "", 1).Window("NetUIHWND", "", 1).Keys("Y7")
 
    'ö³Ï»É EXCEL- Á
    Call CloseAllExcelFiles()
    Call Close_AsBank()
    
End Sub