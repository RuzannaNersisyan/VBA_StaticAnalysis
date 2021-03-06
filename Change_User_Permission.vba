'USEUNIT Loan_Agreements_Library
'USEUNIT Loan_Agreemnts_With_Schedule_Library
'USEUNIT Library_Common
'USEUNIT Constants

'Test Case ID 160530

Sub Change_User_Permission_DeleteAccess()
    Dim startDATE , fDATE, isExists, rolName , rowName(31)
    
    Utilities.ShortDateFormat = "yyyymmdd"
    startDATE = "20030101"
    fDATE = "20250101"
    isExists = False
    rolName = "All-Allowed"
    rowName(0) = "|¸»µÇïáñ³Ï³Ý å³ñïù|¸»µÇïáñ³Ï³Ý å³ñïù"
    rowName(1) = "|î»Õ³µ³ßËí³Í ÙÇçáóÝ»ñ|ì³ñÏ»ñ (ï»Õ³µ³ßËí³Í)"
    rowName(2) = "|î»Õ³µ³ßËí³Í ÙÇçáóÝ»ñ|úí»ñ¹ñ³ýï (ï»Õ³µ³ßËí³Í)"
    rowName(3) = "|î»Õ³µ³ßËí³Í ÙÇçáóÝ»ñ|üÇÝ³Ýë³Ï³Ý ÉÇ½ÇÝ· (ï»Õ³µ³ßËí³Í)"
    rowName(4) = "|î»Õ³µ³ßËí³Í ÙÇçáóÝ»ñ|²ñÅ»ÃÕÃ»ñ ØØÄä"
    rowName(5) = "|î»Õ³µ³ßËí³Í ÙÇçáóÝ»ñ|öáË³ïíáõÃÛáõÝÝ»ñ"
    rowName(6) = "|î»Õ³µ³ßËí³Í ÙÇçáóÝ»ñ|²ñÅ»ÃÕÃ»ñ í»ñ³í³×³éùÇ"
    rowName(7) = "|î»Õ³µ³ßËí³Í ÙÇçáóÝ»ñ|ê³ÑÙ³Ý³ã³÷"
    rowName(8) = "|î»Õ³µ³ßËí³Í ÙÇçáóÝ»ñ|²Ïñ»¹ÇïÇí"
    rowName(9) = "|î»Õ³µ³ßËí³Í ÙÇçáóÝ»ñ|¶»ñ³Í³Ëë"
    rowName(10) = "|î»Õ³µ³ßËí³Í ÙÇçáóÝ»ñ|êíáå (ï»Õ³µ³ßËí³Í)"
    rowName(11) = "|î»Õ³µ³ßËí³Í ÙÇçáóÝ»ñ|àã å»ï³Ï³Ý ³ñÅ»ÃÕÃ»ñ"
    rowName(12) = "|î»Õ³µ³ßËí³Í ÙÇçáóÝ»ñ|î»Õ³µ³ßËí³Í ³í³Ý¹Ý»ñ"
    rowName(13) = "|î»Õ³µ³ßËí³Í ÙÇçáóÝ»ñ|ü³ÏïáñÇÝ· ØØÄä"
    rowName(14) = "|î»Õ³µ³ßËí³Í ÙÇçáóÝ»ñ|è»åá"
    rowName(15) = "|î»Õ³µ³ßËí³Í ÙÇçáóÝ»ñ|êïáñ³¹³ë ÷áË³ïíáõÃÛáõÝ"
    rowName(16) = "|î»Õ³µ³ßËí³Í ÙÇçáóÝ»ñ|²ñÅ»ÃÕÃ»ñ í³×³éùÇ"
    rowName(17) = "|Ü»ñ·ñ³íí³Í ÙÇçáóÝ»ñ|Ü»ñ·ñ³íí³Í í³ñÏ»ñ"
    rowName(18) = "|Ü»ñ·ñ³íí³Í ÙÇçáóÝ»ñ|²í³Ý¹Ý»ñ (Ý»ñ·ñ³íí³Í)"
    rowName(19) = "|Ü»ñ·ñ³íí³Í ÙÇçáóÝ»ñ|Ü»ñ·ñ³íí³Í ûí»ñ¹ñ³ýï"
    rowName(20) = "|Ü»ñ·ñ³íí³Í ÙÇçáóÝ»ñ|Ü»ñ·ñ³íí³Í ýÇÝ³Ýë³Ï³Ý ÉÇ½ÇÝ·"
    rowName(21) = "|Ü»ñ·ñ³íí³Í ÙÇçáóÝ»ñ|Ð³Ï³¹³ñÓ é»åá"
    rowName(22) = "|Ü»ñ·ñ³íí³Í ÙÇçáóÝ»ñ|êïáñ³¹³ë ÷áË³éáõÃÛáõÝ"
    rowName(23) = "|Ü»ñ·ñ³íí³Í ÙÇçáóÝ»ñ|öáË³éáõÃÛáõÝÝ»ñ"
    rowName(24) = "|Ü»ñ·ñ³íí³Í ÙÇçáóÝ»ñ|ä³ñï³íáñáõÃÛáõÝ ²Ïñ»¹ÇïÇíÇ ·Íáí"
    rowName(25) = "|Ü»ñ·ñ³íí³Í ÙÇçáóÝ»ñ|êíáå (Ý»ñ·ñ³íí³Í)"
    rowName(26) = "|²å³Ñáíí³ÍáõÃÛáõÝ|îñ³Ù³¹ñí³Í ·ñ³í"
    rowName(27) = "|²å³Ñáíí³ÍáõÃÛáõÝ|îñ³Ù³¹ñí³Í »ñ³ßË³íáñáõÃÛáõÝ"
    rowName(28) = "|²å³Ñáíí³ÍáõÃÛáõÝ|îñ³Ù³¹ñí³Í ³í³Ý¹³ÛÇÝ ·ñ³í"
    rowName(29) = "|²å³Ñáíí³ÍáõÃÛáõÝ|¶ñ³í (ëï³óí³Í)"
    rowName(30) = "|²å³Ñáíí³ÍáõÃÛáõÝ|ºñ³ßË³íáñáõÃÛáõÝ (ëï³óí³Í)"
    rowName(31) = "|²å³Ñáíí³ÍáõÃÛáõÝ|²í³Ý¹³ÛÇÝ ·ñ³í(ëï³óí³Í)"
    
    'Test StartUp start
    Call Initialize_AsBank("bank", startDATE, fDATE)
    
    Login("ARMSOFT")  
    ChangeWorkspace("Ադմինիստրատորի ԱՇՏ 4.0")
    
    'TEst StartUp End
    Call wTreeView.DblClickItem("|²¹ÙÇÝÇëïñ³ïáñÇ ²Þî 4.0|ú·ï³·áñÍáÕÝ»ñ ¨ ²Þî|ú·ï³·áñÍáÕÝ»ñÇ ¹»ñ»ñ")
    Call ClickCmdButton(2, "Î³ï³ñ»É")
    Do Until wMDIClient.vbObject("frmPttel").vbObject("tdbgView").EOF
        If Trim(wMDIClient.vbObject("frmPttel").vbObject("tdbgView").Columns.Item(0).Text) = rolName Then
            isExists = True
            Exit Do
        Else
            Call wMDIClient.vbObject("frmPttel").vbObject("tdbgView").MoveNext
        End If
    Loop
    
    If isExists Then
        BuiltIn.Delay(2000)
        Call wMainForm.MainMenu.Click(c_AllActions)
        Call wMainForm.PopupMenu.Click(c_ToEdit)
        p1.vbObject("frmRolePropN").vbObject("TabStrip1").ClickTab("ºÝÃ³Ñ³Ù³Ï³ñ·»ñ")
        For Each rowN in rowName
            p1.vbObject("frmRolePropN").vbObject("RolePropCardDoc").vbObject("TabFrame").vbObject("SSTreeView").ClickItem(rowN)
            p1.vbObject("frmRolePropN").vbObject("RolePropCardDoc").vbObject("TabFrame").vbObject("SSGrid").Row = 1
            p1.vbObject("frmRolePropN").vbObject("RolePropCardDoc").vbObject("TabFrame").vbObject("SSGrid").Columns.Item(1).Value = -1
        Next
    Else
        Log.Error("Roll with name " & rolName & " does't exist")
    End If
    Call ClickCmdButton(10, "Î³ï³ñ»É")
    call Close_AsBank()
    
End Sub