'USEUNIT Library_Common
'USEUNIT Library_Colour
'USEUNIT Mortgage_Library
'USEUNIT Constants
'USEUNIT Deposit_Contract_Library
Option Explicit

'Test Case Id - 162681

Sub Check_Document_Action()
  
    Dim sDATE,fDATE
    Dim Deposit_Attract

    'Համակարգ մուտք գործել ARMSOFT օգտագործողով
    sDATE = "20030101"
    fDATE = "20260101"
    Call Initialize_AsBank("bank_Report", sDATE, fDATE)
    Login("ARMSOFT")

    Call ChangeWorkspace(c_Deposits)
    Set Deposit_Attract = New_Deposit_Attracted()

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''--- Ստուգել Ենթափաստաթղթեր գործողությունը ---''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''             
    Log.Message "-- Ստուգել Ենթափաստաթղթեր գործողությունը --" ,,, DivideColor  
    
    Call GoToDeposit_Attracted(Deposit_Attract)
    
    BuiltIn.Delay(1000)
    Call wMainForm.MainMenu.Click(c_Opers)
    Call wMainForm.PopupMenu.Click(c_Documents & "|" & c_Subdocuments)
    
    Call CheckPttel_RowCount("frmPttel_2", 0)
    Call Close_Pttel("frmPttel_2")
    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''--- Ստուգել Ծնող փաստաթղթեր գործողությունը ---'''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''             
    Log.Message "-- Ստուգել Ծնող փաստաթղթեր գործողությունը --" ,,, DivideColor
    
    BuiltIn.Delay(1000)
    Call wMainForm.MainMenu.Click(c_Opers)
    Call wMainForm.PopupMenu.Click(c_Documents & "|" & c_ParentDoc)
    
    Call CheckPttel_RowCount("frmPttel_2", 1)
    Call Close_Pttel("frmPttel_2")
    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''--- Ստուգել Թղթապանակների նկարագրություն գործողությունը ---'''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''             
    Log.Message "-- Ստուգել Թղթապանակների նկարագրություն գործողությունը --" ,,, DivideColor
    
    BuiltIn.Delay(1000)
    Call wMainForm.MainMenu.Click(c_Opers)
    Call wMainForm.PopupMenu.Click(c_Documents & "|" & c_DescriptionFolders)
    
    Call CheckPttel_RowCount("frmPttel_2", 0)
    Call Close_Pttel("frmPttel_2")   

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''--- Ստուգել Փնտրել ընդլայնված պատուհանը ---'''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''            
    Log.Message "-- Ստուգել Փնտրել ընդլայնված պատուհանը --" ,,, DivideColor
    
    BuiltIn.Delay(1000)
    Call wMainForm.MainMenu.Click(c_Opers)
    Call wMainForm.PopupMenu.Click(c_Folder & "|" & c_SearchAdvanced)
    BuiltIn.Delay(1000)
    
    If p1.WaitVBObject("frmPttelFindNew",500).Exists Then
        p1.VBObject("frmPttelFindNew").VBObject("CommandCancel").ClickButton  
    Else
        Log.Error "Փնտրել ընդլայնված պատուհանը չի բացվել!",,,ErrorColor  
    End If
    
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''--- Ստուգել Դիտել պարամետրերը գործողությունը ---''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''           
    Log.Message "-- Ստուգել Դիտել պարամետրերը գործողությունը --" ,,, DivideColor
    
    BuiltIn.Delay(1000)
    Call wMainForm.MainMenu.Click(c_Opers)
    Call wMainForm.PopupMenu.Click(c_Folder & "|" & c_ViewParameters)
    BuiltIn.Delay(1000)
    
    If wMDIClient.WaitVBObject("FrmSpr",500).Exists Then
        wMDIClient.VBObject("FrmSpr").Close
    Else
        Log.Error "Դիտել պարամետրերը չի բացվել!",,,ErrorColor  
    End If 
        
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''--- Ստուգել Խմբավորել գործողությունը ---''''''''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''            
    Log.Message "-- Ստուգել Խմբավորել գործողությունը --" ,,, DivideColor
    
    BuiltIn.Delay(1000)
    Call wMainForm.MainMenu.Click(c_Opers)
    Call wMainForm.PopupMenu.Click(c_Folder & "|" & c_Generator)
    BuiltIn.Delay(1000)
    
    If p1.WaitVBObject("frmGrpSpr",500).Exists Then
        p1.VBObject("frmGrpSpr").VBObject("Command2").Click
    Else
        Log.Error "Խմբավորել պատուհանը չի բացվել!",,,ErrorColor  
    End If
    
    Call Close_Pttel("frmPttel")   
    Call Close_AsBank()   
End Sub    