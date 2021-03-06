'USEUNIT Library_Common 
'USEUNIT Library_Colour
'USEUNIT Constants

'-----------------------------------
' Լիազորագիրի(Authorization)-ի Class
'-----------------------------------
Class Authorization
    Public Isn
    Public ClientCode
    Public ProxyHolderCode
    Public Name
    Public EnglishName
    Public IdNumber
    Public Term
    Public AdditionalInformation
    Public ClosingDate
    Public AuthorizationType
    
    Public GridRowCount
    Public Row
    Public FillOrCheckGridRow(10)
    Public Account(10)
    Public Curr(10)
    Public Summ(10)
    Public Comment(10)
    
    Public AttachPhoto
    Public PhotoPath
    Public AttachSign
    Public SignPath
    Public AttachFile
    Public FilePath
    Public AttachLink
    Public LinkPath
    Public LinkDescription
    
    Private Sub Class_Initialize
        Isn = ""
        ClientCode = ""
        ProxyHolderCode = ""
        Name = ""
        EnglishName = ""
        IdNumber = ""
        Term = "/  /"
        AdditionalInformation = ""
        ClosingDate = "/  /"
        AuthorizationType = ""
        AttachPhoto = False
        PhotoPath = ""
        AttachSign = False
        SignPath = ""
        AttachFile = False
        FilePath = ""
        AttachLink = False
        LinkPath = ""
        LinkDescription = ""

        For Row = 1 To GridRowCount
            FillOrCheckGridRow(Row) = False
            Account(Row) = ""
            Curr(Row) = ""
            Summ(Row) = ""
            Comment(Row) = ""
        Next  
    End Sub  
End Class

Function New_Authorization()
    Set New_Authorization = NEW Authorization      
End Function

'-----------------------------------------------
' Լիազորագիրի(Authorization) պայմանագրի ստեղծում
'-----------------------------------------------
Function Create_Authorization(path,Authorization)

    Dim gridRow,wTabStrip
    Call wTreeView.DblClickItem(path)

    'ISN-ի վերագրում փոփոխականին
    Authorization.Isn = wMDIClient.vbObject("frmASDocForm").DocFormCommon.Doc.isn
  
    'Լրացնել "Հաճախորդի կոդ" դաշտը
    Call Rekvizit_Fill("Document",1,"General","CODE",Authorization.ClientCode)
    'Լրացնել "Լիազորված հաճախորդի կոդ" դաշտը
    Call Rekvizit_Fill("Document",1,"General","AUTHCLI",Authorization.ProxyHolderCode)
    'Լրացնել "Անվանում" դաշտը
    Call Rekvizit_Fill("Document",1,"General","ATNAME",Authorization.Name)
    'Լրացնել "Անգլերեն անվանում" դաշտը
    Call Rekvizit_Fill("Document",1,"General","ATENAME",Authorization.EnglishName)
    'Լրացնել "Անձը հաստատող փաստ." դաշտը
    Call Rekvizit_Fill("Document",1,"General","PASSPORT",Authorization.IdNumber)
    'Լրացնել "Ժամկետ" դաշտը
    Call Rekvizit_Fill("Document",1,"General","DATE",Authorization.Term)
    'Լրացնել "Լրացուցիչ ինֆորմացիա" դաշտը
    Call Rekvizit_Fill("Document",1,"General","ADDINFO",Authorization.AdditionalInformation)
    'Լրացնել "Փակման ամսաթիվ" դաշտը
    Call Rekvizit_Fill("Document",1,"General","DATECLOSE",Authorization.ClosingDate)
    'Լրացնել "Լիազորագրի տեսակ" դաշտը
    Call Rekvizit_Fill("Document",1,"General","AUTHTYPE",Authorization.AuthorizationType)
    
        
    For gridRow = 1 To Authorization.GridRowCount  
        If Authorization.FillOrCheckGridRow(gridRow) Then
          With wMDIClient.VBObject("frmASDocForm").VBObject("TabFrame").VBObject("DocGrid")
             'Լրացնում է Հաշիվ դաշտը
            .Row = gridRow - 1
            .Col = 0
            .Keys(Authorization.Account(gridRow) & "[Enter]")
      
            'Լրացնում է Արժույթ դաշտը
            .Row = gridRow - 1
            .Col = 1
            .Keys(Authorization.Curr(gridRow) & "[Enter]")
      
            'Լրացնում է Գումար դաշտը
            .Row = gridRow - 1
            .Col = 2
            .Keys(Authorization.Summ(gridRow) & "[Enter]")
       
             'Լրացնում է Մեկնաբանություն դաշտը
            .Row = gridRow - 1
            .Col = 3
            .Keys(Authorization.Comment(gridRow) & "[Enter]")
          End With 
        End If
    Next
    
    'Անցում Tab2 Գրաֆիկական տվյալներ
    Set wTabStrip = wMDIClient.VBObject("frmASDocForm").VBObject("TabStrip")    
        wTabStrip.SelectedItem = wTabStrip.Tabs(2)
        
    If Authorization.AttachPhoto Then
        'Սեղմել Ֆոտոնկար-ին
        wMDIClient.VBObject("frmASDocForm").VBObject("TabFrame_2").VBObject("ASImage").VBObject("ImageAs").DblClick
        'Լրացնել ֆայլի ճանապարհը
        p1.Window("#32770", "Open", 1).Window("ComboBoxEx32", "", 1).Window("ComboBox", "", 1).Window("Edit", "", 1).Keys(Authorization.PhotoPath)
        'Սեղնել "Open" կոճակը
        p1.Window("#32770", "Open", 1).Window("Button", "&Open", 1).Click
        BuiltIn.Delay(2000) 
        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    End If
    
    If Authorization.AttachSign Then
        'Սեղմել Ստորագրության նմուշ-ին
        wMDIClient.VBObject("frmASDocForm").VBObject("TabFrame_2").VBObject("ASImage_2").VBObject("ImageAs").DblClick
        'Լրացնել ֆայլի ճանապարհը
        p1.Window("#32770", "Open", 1).Window("ComboBoxEx32", "", 1).Window("ComboBox", "", 1).Window("Edit", "", 1).Keys(Authorization.SignPath)
        'Սեղնել "Open" կոճակը
        p1.Window("#32770", "Open", 1).Window("Button", "&Open", 1).Click    
        BuiltIn.Delay(2000) 
        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    End If

    'Անցում Tab3 Կցված էջ
    wTabStrip.SelectedItem = wTabStrip.Tabs(3)
    
    If Authorization.AttachFile Then
        'Սեղմել "Կցել ֆայլը" կոճակը
        wMDIClient.VBObject("frmASDocForm").VBObject("TabFrame_3").VBObject("AsAttachments1").VBObject("CmdAdd").Click
        'Լրացնել ֆայլի ճանապարհը
        p1.Window("#32770", "Open", 1).Window("ComboBoxEx32", "", 1).Window("ComboBox", "", 1).Window("Edit", "", 1).Keys(Authorization.FilePath)
        'Սեղնել "Open" կոճակը
        p1.Window("#32770", "Open", 1).Window("Button", "&Open", 1).Click
        BuiltIn.Delay(2000) 
        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    End If
    
    If Authorization.AttachLink Then
        'Սեղմել "Կցել հղում" կոճակը
        wMDIClient.VBObject("frmASDocForm").VBObject("TabFrame_3").VBObject("AsAttachments1").VBObject("CmdAddLink").Click
        'Լրացնել "Կցել հղում" պատուհանի "Հղում" դաշտը
        Call Rekvizit_Fill("Dialog",1,"General","LINK",Authorization.LinkPath)
        'Լրացնել "Կցել հղում" պատուհանի "Նկարագրություն" դաշտը
        Call Rekvizit_Fill("Dialog",1,"General","COMM",Authorization.LinkDescription)
        'Սեղմել "Կցել հղում" պատուհանի "Կատարել" կոճակը
        Call ClickCmdButton(2, "Î³ï³ñ»É")
        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    End If
    
    'Սեղմել "Կատարել"
    Call ClickCmdButton(1, "Î³ï³ñ»É")
End Function  

'-----------------------------------------------
' խմբագրել Լիազորագիրի(Authorization) պայմանագիրը
'-----------------------------------------------
Sub Edit_Authorization(Authorization)
  
    'Լրացնել "Հաճախորդի կոդ" դաշտը
    Call Rekvizit_Fill("Document",1,"General","CODE",Authorization.ClientCode)
    'Լրացնել "Լիազորված հաճախորդի կոդ" դաշտը
    Call Rekvizit_Fill("Document",1,"General","AUTHCLI",Authorization.ProxyHolderCode)
    'Լրացնել "Անվանում" դաշտը
    Call Rekvizit_Fill("Document",1,"General","ATNAME",Authorization.Name)
    'Լրացնել "Անգլերեն անվանում" դաշտը
    Call Rekvizit_Fill("Document",1,"General","ATENAME",Authorization.EnglishName)
    'Լրացնել "Անձը հաստատող փաստ." դաշտը
    Call Rekvizit_Fill("Document",1,"General","PASSPORT",Authorization.IdNumber)
    'Լրացնել "Ժամկետ" դաշտը
    Call Rekvizit_Fill("Document",1,"General","DATE",Authorization.Term)
    'Լրացնել "Լրացուցիչ ինֆորմացիա" դաշտը
    Call Rekvizit_Fill("Document",1,"General","ADDINFO",Authorization.AdditionalInformation)
    'Լրացնել "Փակման ամսաթիվ" դաշտը
    Call Rekvizit_Fill("Document",1,"General","DATECLOSE",Authorization.ClosingDate)
    'Լրացնել "Լիազորագրի տեսակ" դաշտը
    Call Rekvizit_Fill("Document",1,"General","AUTHTYPE",Authorization.AuthorizationType)
    
    For gridRow = 1 To Authorization.GridRowCount  
        If Authorization.FillOrCheckGridRow(gridRow) Then
          With wMDIClient.VBObject("frmASDocForm").VBObject("TabFrame").VBObject("DocGrid")
             'Լրացնում է Հաշիվ դաշտը
            .Row = gridRow - 1
            .Col = 0
            .Keys(Authorization.Account(gridRow) & "[Enter]")
      
            'Լրացնում է Արժույթ դաշտը
            .Row = gridRow - 1
            .Col = 1
            .Keys(Authorization.Curr(gridRow) & "[Enter]")
      
            'Լրացնում է Գումար դաշտը
            .Row = gridRow - 1
            .Col = 2
            .Keys(Authorization.Summ(gridRow) & "[Enter]")
       
             'Լրացնում է Մեկնաբանություն դաշտը
            .Row = gridRow - 1
            .Col = 3
            .Keys(Authorization.Comment(gridRow) & "[Enter]")
          End With 
        End If
    Next
    
    
    'Սեղմել "Կատարել"
    Call ClickCmdButton(1, "Î³ï³ñ»É")
End Sub  


'------------------------------------------------------------
' Ստուգել Լիազորագիրի(Authorization) պայմանագրի դաշտերի արժեքները
'------------------------------------------------------------
Function Check_Authorization(Authorization)
    Dim gridRow

    'Ստուգում է "Հաճախորդի կոդ" դաշտի արժեքը
    Call Compare_Two_Values("Հաճախորդի կոդ",Get_Rekvizit_Value("Document",1,"Mask","CODE"),Authorization.ClientCode)
    'Ստուգում է "Լիազորված հաճախորդի կոդ" դաշտի արժեքը
    Call Compare_Two_Values("Լիազորված հաճախորդի կոդ",Get_Rekvizit_Value("Document",1,"Mask","AUTHCLI"),Authorization.ProxyHolderCode)
    'Ստուգում է "Անվանում" դաշտի արժեքը
    Call Compare_Two_Values("Անվանում",Get_Rekvizit_Value("Document",1,"General","ATNAME"),Authorization.Name)
    'Ստուգում է "Անգլերեն անվանում" դաշտի արժեքը
    Call Compare_Two_Values("Անգլերեն անվանում",Get_Rekvizit_Value("Document",1,"General","ATENAME"),Authorization.EnglishName)
    'Ստուգում է "Անձը հաստատող փաստ." դաշտի արժեքը
    Call Compare_Two_Values("Անձը հաստատող փաստ.",Get_Rekvizit_Value("Document",1,"General","PASSPORT"),Authorization.IdNumber)  
    'Ստուգում է "Ժամկետ" դաշտի արժեքը
    Call Compare_Two_Values("Ժամկետ",Get_Rekvizit_Value("Document",1,"General","DATE"),Authorization.Term)
    'Ստուգում է "Լրացուցիչ ինֆորմացիա" դաշտի արժեքը
    Call Compare_Two_Values("Լրացուցիչ ինֆորմացիա",Get_Rekvizit_Value("Document",1,"Comment","ADDINFO"),Authorization.AdditionalInformation)
    'Ստուգում է "Փակման ամսաթիվ" դաշտի արժեքը
    Call Compare_Two_Values("Փակման ամսաթիվ",Get_Rekvizit_Value("Document",1,"General","DATECLOSE"),Authorization.ClosingDate)
    'Ստուգում է "Լիազորագրի տեսակ" դաշտի արժեքը
    Call Compare_Two_Values("Լիազորագրի տեսակ",Get_Rekvizit_Value("Document",1,"Mask","AUTHTYPE"),Authorization.AuthorizationType)
    
    For gridRow = 1 To Authorization.GridRowCount   
      If Authorization.FillOrCheckGridRow(gridRow) Then
           With wMDIClient.VBObject("frmASDocForm").VBObject("TabFrame").VBObject("DocGrid")
             'Ստուգում է գրիդի "Հաշիվ" դաշտի արժեքը
            .Row = gridRow - 1
            .Col = 0
            Call Compare_Two_Values("Գրիդի Հաշիվ",.text,Authorization.Account(gridRow))
      
            'Ստուգում է գրիդի "Արժույթ" դաշտի արժեքը
            .Row = gridRow - 1
            .Col = 1
            Call Compare_Two_Values("Գրիդի Արժույթ",.text,Authorization.Curr(gridRow))
      
            'Ստուգում է գրիդի "Գումար" դաշտի արժեքը
            .Row = gridRow - 1
            .Col = 2
            Call Compare_Two_Values("Գրիդի Գումար",.text,Authorization.Summ(gridRow))
       
             'Ստուգում է գրիդի "Մեկնաբանություն" դաշտի արժեքը
            .Row = gridRow - 1
            .Col = 3
            Call Compare_Two_Values("Գրիդի Մեկնաբանություն",.text,Authorization.Comment(gridRow))
          End With 
      End If
    Next
End Function  






















'---------------------------------------------
' Լիազորագիրի(Authorization)-ի Ֆիլտրի լրացման Class
'---------------------------------------------
Class FilterAuthorization
    Public Client
    Public Name
    Public ClientsName
    Public Note
    Public Date
    Public AuthorizationType
    Public ShowClosed
    Public Division
    Public Department
    Public AccessType

    Private Sub Class_Initialize
       Client = ""
       Name = ""
       ClientsName = ""
       Note = ""
       Date = ""
       AuthorizationType = ""
       ShowClosed = 0
       Division = ""
       Department = ""
       AccessType = ""
    End Sub  
End Class

Function New_FilterAuthorization()
    Set New_FilterAuthorization = NEW FilterAuthorization      
End Function

'--------------------------------------------------------------------------
'Մուտք է գործում Գլխավոր հաշվապահի ԱՇՏ ԱՇՏ/Տեղեկատուներ/Լիազորագրեր թղթապանակ
'--------------------------------------------------------------------------
'fillterAuthorization  - Լրացվող Ֆիլտրի տվյալների օբեկտ
Sub GoTo_Authorization(path,filterAuthorization)
    
    Dim FilterWin
    Call wTreeView.DblClickItem(path)
    Set FilterWin = p1.WaitVBObject("frmAsUstPar",delay_middle)
    BuiltIn.Delay(delay_middle) 
    
    If FilterWin.Exists Then
        Call Fill_Authorization_Filter(filterAuthorization)
        Call WaitForExecutionProgress()
    Else
        Log.Error "Can Not Open Authorization Filter",,,ErrorColor      
    End If 
End Sub 

'--------------------------------------------------
'Լրացնել "Լիազորագրեր" Authorization  Ֆիլտրի արժեքները
'--------------------------------------------------
Sub Fill_Authorization_Filter(Authorization)

    'Լրացնում է "Հաճախորդ" դաշտը
    Call Rekvizit_Fill("Dialog",1,"General","CLICODE",Authorization.Client)
    'Լրացնում է "Անվանում" դաշտը
    Call Rekvizit_Fill("Dialog",1,"General","NAME",Authorization.Name)
    'Լրացնում է "Հաճախորդի անվանում" դաշտը
    Call Rekvizit_Fill("Dialog",1,"General","CLINAME",Authorization.ClientsName)
    'Լրացնում է "Նշում" դաշտը
    Call Rekvizit_Fill("Dialog",1,"General","CLINOTE",Authorization.Note)
    'Լրացնում է "Ամսաթիվ" դաշտը
    Call Rekvizit_Fill("Dialog",1,"General","DATE",Authorization.Date)
    'Լրացնում է "Լիազորագրի տեսակ" դաշտը
    Call Rekvizit_Fill("Dialog",1,"General","AUTHTYPE",Authorization.AuthorizationType)
    'Լրացնում է "Ցույց տալ փակվածները" դաշտը
    Call Rekvizit_Fill("Dialog",1,"CheckBox","SHOWCLOSED",Authorization.ShowClosed)
    'Լրացնում է "Գրասենյակ" դաշտը
    Call Rekvizit_Fill("Dialog",1,"General","ACSBRANCH",Authorization.Division)
    'Լրացնում է "Բաժին" դաշտը
    Call Rekvizit_Fill("Dialog",1,"General","ACSDEPART",Authorization.Department)
    'Լրացնում է "Հասան-ն տիպ" դաշտը
    Call Rekvizit_Fill("Dialog",1,"General","ACSTYPE",Authorization.AccessType)

    Call ClickCmdButton(2, "Î³ï³ñ»É")
End Sub

'-------------------
'"Փակել" Գործողություն
'-------------------
Sub CloseAgreement(Date)
    Dim DocForm
    Call wMainForm.MainMenu.Click(c_AllActions)
    Call wMainForm.PopupMenu.Click(c_Close)
    wMDIClient.Refresh
    
    Set DocForm = AsBank.WaitVBObject("frmAsUstPar", delay_middle)
    
    If DocForm.Exists Then
        'Լրացնել "Ամսաթիվ" դաշտը
        Call Rekvizit_Fill("Dialog", 1, "General", "EDATE", Date)
        Call ClickCmdButton(2, "Î³ï³ñ»É")
    Else
        Log.Error "Can Not Open Rc(CloseContract) Window",,,ErrorColor         
    End If    
    BuiltIn.Delay(1500)
    If DocForm.Exists Then
        Log.Error "Can Not Close Rc(CloseContract) Window",,,ErrorColor
    End If
End Sub