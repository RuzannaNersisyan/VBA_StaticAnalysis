'USEUNIT Library_Common 
'USEUNIT Library_Colour
'USEUNIT Constants
'USEUNIT Library_Contracts
'USEUNIT Library_CheckDB
'USEUNIT Deposit_Library
'USEUNIT Authorization_Library

Option Explicit
'Test Case Id - 179266

Dim objectAuthorization,filterAuthorization
Dim editAuthorization,checkAfterEditAuthorization
Dim dbCONTRACT,dbFOLDERS(5)

'Լիազորագիր փաստաթղթի ստուգում
Sub Check_Add_Authorization_Test()
    
    Dim sDATE,fDATE
    Dim path,fBODY
     
    'Համակարգ մուտք գործել ARMSOFT օգտագործողով
    sDATE = "20020101"
    fDATE = "20260101"
    Call Initialize_AsBank("bank", sDATE, fDATE)
    Login("ARMSOFT")

    'Մուտք "Գլխավոր հաշվապահի ԱՇՏ"   
    Call ChangeWorkspace(c_ChiefAcc)

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''''''--- Ստեղծել Լիազորագիր փաստաթուղթ ---'''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "--- Ստեղծել Լիազորագիր փաստաթուղթ ---",,,DivideColor
    
    Call Test_Initialize_For_Authorization()

    path = "|¶ÉË³íáñ Ñ³ßí³å³ÑÇ ²Þî|Üáñ ÷³ëï³ÃÕÃ»ñ|ø³ñï ÷³ëï³ÃÕÃ»ñ|ÈÇ³½áñ³·Çñ"
    Call Create_Authorization(path,objectAuthorization)
    
    Log.Message "SQL Check After Create Authorization",,,SqlDivideColor
    Log.Message "fISN = " & objectAuthorization.isn,,,SqlDivideColor
    
    Call SQL_Initialize_For_Authorization(objectAuthorization.isn)
    
    'SQL Ստուգում DOCS աղուսյակում
    fBODY = "  CODE:00000017  AUTHCLI:00000008  ATNAME:§Ð³Ûáó ´³ÝÏ¦  ATENAME:Client 00000008  PASSPORT:AB123456  DATE:20240101  "&_
    "ADDINFO:AdditionalInformation_AdditionalInformation_AdditionalInformation_AdditionalInformation_Additi_1  BLREP:0  AUTHTYPE:1  "
    fBODY = Replace(fBODY, "  ", "%")
    Call CheckQueryRowCount("DOCS","fISN",objectAuthorization.isn,1)
    Call CheckDB_DOCS(objectAuthorization.isn,"AUTHORIZ","1",fBODY,1)

    'SQL Ստուգում DOCP աղուսյակում  
    Call CheckQueryRowCount("DOCP","fISN",objectAuthorization.isn,1)
    Call CheckDB_DOCP(objectAuthorization.isn,"AUTHORIZ","1628332",1)
    
    'SQL Ստուգում DOCLOG աղուսյակում 
    Call CheckQueryRowCount("DOCLOG","fISN",objectAuthorization.isn,1)
    Call CheckDB_DOCLOG(objectAuthorization.isn,"77","N","1","",1)

    'SQL Ստուգում DOCSG աղուսյակում 
    Call CheckQueryRowCount("DOCSG","fISN",objectAuthorization.isn,4)
    Call CheckDB_DOCSG(objectAuthorization.isn,"ACCS","0","ACC","30220040100",1)
    Call CheckDB_DOCSG(objectAuthorization.isn,"ACCS","0","COMMENT","Comment_Comment_Comment",1)
    Call CheckDB_DOCSG(objectAuthorization.isn,"ACCS","0","CUR","000",1)
    Call CheckDB_DOCSG(objectAuthorization.isn,"ACCS","0","SUMMA","15000",1)
    
    'SQL Ստուգում FOLDERS աղուսյակում 
    Call CheckQueryRowCount("FOLDERS","fISN",objectAuthorization.isn,4)
    Call CheckDB_FOLDERS(dbFOLDERS(1),1)
    Call CheckDB_FOLDERS(dbFOLDERS(2),1)
    Call CheckDB_FOLDERS(dbFOLDERS(3),1)
    Call CheckDB_FOLDERS(dbFOLDERS(4),1)
    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''--- Դիտել գործողությամբ ստուգել Ստեղծված Լիազորագիր փաստաթուղթի արժեքները ---''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "--- Դիտել գործողությամբ ստուգել Ստեղծված Լիազորագիր փաստաթուղթի արժեքները ---",,,DivideColor

    objectAuthorization.Name = "§Ð³Ûáó ´³ÝÏ¦"
    objectAuthorization.EnglishName = "Client 00000008"
    path = "|¶ÉË³íáñ Ñ³ßí³å³ÑÇ ²Þî|î»Õ»Ï³ïáõÝ»ñ|ÈÇ³½áñ³·ñ»ñ"
    
    Call GoTo_Authorization(path,filterAuthorization)
    
    If SearchInPttel("frmPttel",0, "00000017") Then
        Call wMainForm.MainMenu.Click(c_AllActions)
        Call wMainForm.PopupMenu.Click(c_View)
        BuiltIn.Delay(2000)
        
        Call Check_Authorization(objectAuthorization)
        'Սեղմել "Կատարել"
        Call ClickCmdButton(1, "OK")
        BuiltIn.Delay(1000) 
    Else
        Log.Error "Can Not find this row!",,,ErrorColor
    End If
    
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''--- Կատարել Աջ կլիկ(Լիազորագրի հաճախորդի թղթապանակ) գործողությունը ---''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "--- Կատարել Աջ կլիկ(Լիազորված հաճախորդի թղթապանակ) գործողությունը ---",,,DivideColor

    If SearchInPttel("frmPttel",0, "00000017") Then
        Call wMainForm.MainMenu.Click(c_AllActions)
        Call wMainForm.PopupMenu.Click(c_AuthClFolder)
        BuiltIn.Delay(2000)
        Call Close_Window(wMDIClient, "frmPttel_2")
    Else
        Log.Error "Can Not find this row!",,,ErrorColor
    End If
    
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''--- Կատարել Աջ կլիկ(խմբագրել) գործողությունը ---'''''''''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "--- Կատարել Աջ կլիկ(խմբագրել) գործողությունը ---",,,DivideColor

    If SearchInPttel("frmPttel",0, "00000017") Then
        Call wMainForm.MainMenu.Click(c_AllActions)
        Call wMainForm.PopupMenu.Click(c_ToEdit)
        BuiltIn.Delay(2000)
        
        Call Edit_Authorization(editAuthorization)
    Else
        Log.Error "Can Not find this row!",,,ErrorColor
    End If
    
    'SQL Ստուգում DOCS աղուսյակում
    fBODY = "  CODE:00000017  AUTHCLI:00000008  ATNAME:§Ð³Ûáó ´³ÝÏ¦  ATENAME:Client 00000008  PASSPORT:AB123456  DATE:20250101  "&_
    "ADDINFO:AdditionalInformation_AdditionalInformation_AdditionalInformation_AdditionalInformation_Additi_1  BLREP:0  AUTHTYPE:1  "
    fBODY = Replace(fBODY, "  ", "%")
    Call CheckQueryRowCount("DOCS","fISN",objectAuthorization.isn,1)
    Call CheckDB_DOCS(objectAuthorization.isn,"AUTHORIZ","1",fBODY,1)
    
    'SQL Ստուգում DOCLOG աղուսյակում 
    Call CheckQueryRowCount("DOCLOG","fISN",objectAuthorization.isn,2)
    Call CheckDB_DOCLOG(objectAuthorization.isn,"77","N","1","",1)
    Call CheckDB_DOCLOG(objectAuthorization.isn,"77","E","1","",1)

    'SQL Ստուգում DOCSG աղուսյակում 
    Call CheckQueryRowCount("DOCSG","fISN",objectAuthorization.isn,8)
    Call CheckDB_DOCSG(objectAuthorization.isn,"ACCS","0","ACC","30220040100",1)
    Call CheckDB_DOCSG(objectAuthorization.isn,"ACCS","1","ACC","000311400  ",1)
    Call CheckDB_DOCSG(objectAuthorization.isn,"ACCS","0","COMMENT","Comment_Comment_Comment",1)
    Call CheckDB_DOCSG(objectAuthorization.isn,"ACCS","1","COMMENT","For_Edit",1)
    Call CheckDB_DOCSG(objectAuthorization.isn,"ACCS","0","CUR","000",1)
    Call CheckDB_DOCSG(objectAuthorization.isn,"ACCS","1","CUR","000",1)
    Call CheckDB_DOCSG(objectAuthorization.isn,"ACCS","0","SUMMA","15000",1)
    Call CheckDB_DOCSG(objectAuthorization.isn,"ACCS","1","SUMMA","19999",1)
    
    'SQL Ստուգում FOLDERS աղուսյակում 
    dbFOLDERS(2).fSPEC = "AB123456                        20250101§Ð²Úàò ´²ÜÎ¦                                      "&_
    "AdditionalInformation_AdditionalInformation_AdditionalInformation_AdditionalInformation_Additi_1                                            00000000000000081"
    dbFOLDERS(3).fSPEC = "§Ð³Ûáó ´³ÝÏ¦   Ä³ÙÏ»ï` 01/01/25"
    dbFOLDERS(4).fSPEC = "§Ð³Ûáó ´³ÝÏ¦   Ä³ÙÏ»ï` 01/01/25"
    
    Call CheckQueryRowCount("FOLDERS","fISN",objectAuthorization.isn,5)
    Call CheckDB_FOLDERS(dbFOLDERS(1),1)
    Call CheckDB_FOLDERS(dbFOLDERS(2),1)
    Call CheckDB_FOLDERS(dbFOLDERS(3),1)
    Call CheckDB_FOLDERS(dbFOLDERS(4),1)
    Call CheckDB_FOLDERS(dbFOLDERS(5),1)
    
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''--- Ստուգել խմբագրված Լիազորագիր փաստաթուղթի արժեքները ---''''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "--- Ստուգել խմբագրված Լիազորագիր փաստաթուղթի արժեքները ---",,,DivideColor
    
    If SearchInPttel("frmPttel",0, "00000017") Then
        Call wMainForm.MainMenu.Click(c_AllActions)
        Call wMainForm.PopupMenu.Click(c_View)
        BuiltIn.Delay(2000)
        
        Call Check_Authorization(checkAfterEditAuthorization)
        'Սեղմել "Կատարել"
        Call ClickCmdButton(1, "OK")
        BuiltIn.Delay(1000) 
    Else
        Log.Error "Can Not find this row!",,,ErrorColor
    End If
    
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''--- Կատարել Աջ կլիկ(Դիտել փոփոխման հայտերը) գործողությունը ---''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "--- Կատարել Աջ կլիկ(Դիտել փոփոխման հայտերը) գործողությունը ---",,,DivideColor

    If SearchInPttel("frmPttel",0, "00000017") Then
        Call wMainForm.MainMenu.Click(c_AllActions)
        Call wMainForm.PopupMenu.Click(c_ViewChangeRequests)
        BuiltIn.Delay(2000)
        Call Close_Window(wMDIClient, "frmPttel_2")
    Else
        Log.Error "Can Not find this row!",,,ErrorColor
    End If
    
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''--- Կատարել Աջ կլիկ(Փակել) գործողությունը ---''''''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "--- Կատարել Աջ կլիկ(Փակել) գործողությունը ---",,,DivideColor

    If SearchInPttel("frmPttel",0, "00000017") Then
        Call CloseAgreement("121223")
    Else
        Log.Error "Can Not find this row!",,,ErrorColor
    End If   
    
    'SQL Ստուգում DOCS աղուսյակում
    fBODY = "  CODE:00000017  AUTHCLI:00000008  ATNAME:§Ð³Ûáó ´³ÝÏ¦  ATENAME:Client 00000008  PASSPORT:AB123456  DATE:20250101  "&_
    "ADDINFO:AdditionalInformation_AdditionalInformation_AdditionalInformation_AdditionalInformation_Additi_1  DATECLOSE:20231212  BLREP:0  AUTHTYPE:1  "
    fBODY = Replace(fBODY, "  ", "%")
    Call CheckQueryRowCount("DOCS","fISN",objectAuthorization.isn,1)
    Call CheckDB_DOCS(objectAuthorization.isn,"AUTHORIZ","1",fBODY,1)
    
    'SQL Ստուգում DOCLOG աղուսյակում 
    Call CheckQueryRowCount("DOCLOG","fISN",objectAuthorization.isn,3)
    Call CheckDB_DOCLOG(objectAuthorization.isn,"77","E","1","",2)
    
    'SQL Ստուգում FOLDERS աղուսյակում 
    dbFOLDERS(2).fSPEC = "AB123456                        20250101§Ð²Úàò ´²ÜÎ¦                                      AdditionalInformation_Additional"&_
    "Information_AdditionalInformation_AdditionalInformation_Additi_1                                            20231212000000081"
    dbFOLDERS(3).fSPEC = "§Ð³Ûáó ´³ÝÏ¦   Ä³ÙÏ»ï` 01/01/25  [ö³Ïí³Í]"
    dbFOLDERS(4).fSPEC = "§Ð³Ûáó ´³ÝÏ¦   Ä³ÙÏ»ï` 01/01/25  [ö³Ïí³Í]"
    
    Call CheckQueryRowCount("FOLDERS","fISN",objectAuthorization.isn,5)
    Call CheckDB_FOLDERS(dbFOLDERS(2),1)
    Call CheckDB_FOLDERS(dbFOLDERS(3),1)
    Call CheckDB_FOLDERS(dbFOLDERS(4),1)

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''--- Դիտել գործողությամբ ստուգել Փակված Լիազորագիր փաստաթուղթի արժեքները ---''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "--- Դիտել գործողությամբ ստուգել Փակված Լիազորագիր փաստաթուղթի արժեքները ---",,,DivideColor

    checkAfterEditAuthorization.ClosingDate = "12/12/23"
    
    If SearchInPttel("frmPttel",0, "00000017") Then
        Call wMainForm.MainMenu.Click(c_AllActions)
        Call wMainForm.PopupMenu.Click(c_View)
        BuiltIn.Delay(2000)
        
        Call Check_Authorization(checkAfterEditAuthorization)
        'Սեղմել "Կատարել"
        Call ClickCmdButton(1, "OK")

        BuiltIn.Delay(1000) 
    Else
        Log.Error "Can Not find this row!",,,ErrorColor
    End If
    
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''--- Կատարել Աջ կլիկ(Բացել) գործողությունը ---''''''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "--- Կատարել Աջ կլիկ(Բացել) գործողությունը ---",,,DivideColor

    If SearchInPttel("frmPttel",0, "00000017") Then
        BuiltIn.Delay(1000) 
        Call wMainForm.MainMenu.Click(c_AllActions)
        Call wMainForm.PopupMenu.Click(c_Open)
    Else
        Log.Error "Can Not find this row!",,,ErrorColor
    End If   

    'SQL Ստուգում DOCS աղուսյակում
    fBODY = "  CODE:00000017  AUTHCLI:00000008  ATNAME:§Ð³Ûáó ´³ÝÏ¦  ATENAME:Client 00000008  PASSPORT:AB123456  DATE:20250101  "&_
    "ADDINFO:AdditionalInformation_AdditionalInformation_AdditionalInformation_AdditionalInformation_Additi_1  BLREP:0  AUTHTYPE:1  "
    fBODY = Replace(fBODY, "  ", "%")
    Call CheckQueryRowCount("DOCS","fISN",objectAuthorization.isn,1)
    Call CheckDB_DOCS(objectAuthorization.isn,"AUTHORIZ","1",fBODY,1)
    
    'SQL Ստուգում DOCLOG աղուսյակում 
    Call CheckQueryRowCount("DOCLOG","fISN",objectAuthorization.isn,4)
    Call CheckDB_DOCLOG(objectAuthorization.isn,"77","E","1","",3)
    
    'SQL Ստուգում FOLDERS աղուսյակում 
    dbFOLDERS(2).fSPEC = "AB123456                        20250101§Ð²Úàò ´²ÜÎ¦                                      AdditionalInformation_Additional"&_
    "Information_AdditionalInformation_AdditionalInformation_Additi_1                                            00000000000000081"
    dbFOLDERS(3).fSPEC = "§Ð³Ûáó ´³ÝÏ¦   Ä³ÙÏ»ï` 01/01/25"
    dbFOLDERS(4).fSPEC = "§Ð³Ûáó ´³ÝÏ¦   Ä³ÙÏ»ï` 01/01/25"
    
    Call CheckQueryRowCount("FOLDERS","fISN",objectAuthorization.isn,5)
    Call CheckDB_FOLDERS(dbFOLDERS(2),1)
    Call CheckDB_FOLDERS(dbFOLDERS(3),1)
    Call CheckDB_FOLDERS(dbFOLDERS(4),1)    
    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''''''--- Հեռացնել  Լիազորագիր պայմանագիրը ---'''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''      
    Log.Message "-- Հեռացնել  Լիազորագիր պայմանագիրը --",,,DivideColor 
    
    Call SearchAndDelete("frmPttel", 0, "00000017", "Ð³ëï³ï»ù ÷³ëï³ÃÕÃÇ çÝç»ÉÁ") 
    Call Close_Window(wMDIClient, "frmPttel")

    Call Close_AsBank()
End Sub

Sub Test_Initialize_For_Authorization()
    Set filterAuthorization = New_FilterAuthorization()
        filterAuthorization.ShowClosed = 1

   Set objectAuthorization = New_Authorization()
   With objectAuthorization
        .ClientCode = "00000017"
        .ProxyHolderCode = "00000008"
        .Name = ""
        .EnglishName = ""
        .IdNumber = "AB123456"
        .Term = "01/01/24"
        .AdditionalInformation = "AdditionalInformation_AdditionalInformation_AdditionalInformation_AdditionalInformation_Additi_1"
        .ClosingDate = "/  /"
        .AuthorizationType = "1"
        
        .GridRowCount = 1
        .FillOrCheckGridRow(1) = True
        .Account(1) = "30220040100"
        .Curr(1) = "000"
        .Summ(1) = "15,000.00"
        .Comment(1) = "Comment_Comment_Comment"
        
        .AttachPhoto = True
        .PhotoPath = Project.Path & "Stores\Attach file\Photo.jpg"
        .AttachSign = True
        .SignPath = Project.Path & "Stores\Attach file\Photo.jpg"
        .AttachFile = True
        .FilePath = Project.Path & "Stores\Attach file\Photo.jpg"
        .AttachLink = True
        .LinkPath = Project.Path & "Stores\Attach file\Photo.jpg"
        .LinkDescription = "ÜÏ³ñ³·ñáõÃÛáõÝ_ÜÏ³ñ³·ñáõÃÛáõÝ_ÜÏ³ñ³·ñáõÃÛáõÝ_____1"
   End With
   
   Set editAuthorization = New_Authorization()
   With editAuthorization
        .Term = "^A[Del]"&"01/01/25"
        .GridRowCount = 2
        .FillOrCheckGridRow(2) = True
        .Account(2) = "000311400"
        .Curr(2) = "000"
        .Summ(2) = "19,999.00"
        .Comment(2) = "For_Edit"
   End With
   
   Set checkAfterEditAuthorization = New_Authorization()
   With checkAfterEditAuthorization
        .ClientCode = "00000017"
        .ProxyHolderCode = "00000008"
        .Name = "§Ð³Ûáó ´³ÝÏ¦"
        .EnglishName = "Client 00000008"
        .IdNumber = "AB123456"
        .Term = "01/01/25"
        .AdditionalInformation = "AdditionalInformation_AdditionalInformation_AdditionalInformation_AdditionalInformation_Additi_1"
        .ClosingDate = "/  /"
        .AuthorizationType = "1"
        
        .GridRowCount = 2
        .FillOrCheckGridRow(1) = True
        .Account(1) = "30220040100"
        .Curr(1) = "000"
        .Summ(1) = "15,000.00"
        .Comment(1) = "Comment_Comment_Comment"
        
        .FillOrCheckGridRow(2) = True
        .Account(2) = "000311400"
        .Curr(2) = "000"
        .Summ(2) = "19,999.00"
        .Comment(2) = "For_Edit"
   End With
  
End Sub

Sub SQL_Initialize_For_Authorization(fISN)  
     
     Set dbFOLDERS(1) = New_DB_FOLDERS()
     With dbFOLDERS(1)
        .fFOLDERID = "AuthorAcc."&fISN
        .fNAME = "AUTHORIZ"
        .fKEY = "30220040100"
        .fISN = fISN
        .fSTATUS = "1"
        .fCOM = "§Ð³Ûáó ´³ÝÏ¦"
        .fSPEC = "000"
        .fECOM = "Client 00000008"
     End With   
     
     Set dbFOLDERS(2) = New_DB_FOLDERS()
     With dbFOLDERS(2)
        .fFOLDERID = "Authoriz.00000017"
        .fNAME = "AUTHORIZ"
        .fKEY = fISN
        .fISN = fISN
        .fSTATUS = "1"
        .fCOM = "§Ð³Ûáó ´³ÝÏ¦"
        .fSPEC = "AB123456                        20240101§Ð²Úàò ´²ÜÎ¦                                      AdditionalInformation_AdditionalInformation_"&_
        "AdditionalInformation_AdditionalInformation_Additi_1                                            00000000000000081"
        .fECOM = "Client 00000008"
     End With 
     
     Set dbFOLDERS(3) = New_DB_FOLDERS()
     With dbFOLDERS(3)
        .fFOLDERID = "C.1628323"
        .fNAME = "AUTHORIZ"
        .fKEY = fISN
        .fISN = fISN
        .fSTATUS = "1"
        .fCOM = "    ÈÇ³½áñí³Í ³ÝÓ -"
        .fSPEC = "§Ð³Ûáó ´³ÝÏ¦   Ä³ÙÏ»ï` 01/01/24"
        .fECOM = "    Authorized person -"
     End With
     
     Set dbFOLDERS(4) = New_DB_FOLDERS()
     With dbFOLDERS(4)
        .fFOLDERID = "C.1628332"
        .fNAME = "AUTHORIZ"
        .fKEY = fISN
        .fISN = fISN
        .fSTATUS = "1"
        .fCOM = "    ÈÇ³½áñ³·Çñ-"
        .fSPEC = "§Ð³Ûáó ´³ÝÏ¦   Ä³ÙÏ»ï` 01/01/24"
        .fECOM = "    Authorization-"
     End With 
     
     Set dbFOLDERS(5) = New_DB_FOLDERS()
     With dbFOLDERS(5)
        .fFOLDERID = "AuthorAcc."&fISN
        .fNAME = "AUTHORIZ"
        .fKEY = "000311400  "
        .fISN = fISN
        .fSTATUS = "1"
        .fCOM = "§Ð³Ûáó ´³ÝÏ¦"
        .fSPEC = "000"
        .fECOM = "Client 00000008"
     End With  
End Sub