Option Explicit
'USEUNIT Library_Common
'USEUNIT Contract_Summary_Report_Library

Sub Contract_Summary_Report_Check_Rows_Test()
    Dim startDATE, fDATE
    Dim Date, cont_date, contrView
    Date = "201211"
    cont_date = "111111"
    
    Utilities.ShortDateFormat = "yyyymmdd"
    startDATE = "20101016"
    fDATE = "20111221"
    'Test StartUp start
    Call Initialize_AsBank("bank", startDATE, fDATE)
    Login ("CREDITOPERATOR")
    'Test StartUp end
    Call wTreeView.DblClickItem("|ì³ñÏ»ñ (ï»Õ³µ³ßËí³Í)|ä³ÛÙ³Ý³·ñ»ñÇ ³Ù÷á÷áõÙ")
    
    Call Contract_Sammary_Report_Fill(Date, Null, Null, Null, Null, Null, Null, Null, _
                                      Null, Null, Null, Null, Null, Null, Null, _
                                      Null, Null, Null, Null, Null, Null, Null, False, False, _
                                      Null, False, False, False, _
                                      True, True, True, True, True, _
                                      True, True, True, True, True, True, _
                                      True, True, True, True, True, True, True)
    
    Set contrView = wMDIClient.WaitVBObject("tdbgView", 150000)
    
    If contrView.Exists Then
        
        '¶áõÙ³ñ ëÛ³Ý ëïáõ·áõÙ
        If Trim(Sys.Process("Asbank").vbObject("MainForm").Window("MDIClient", "", 1).vbObject("frmPttel").vbObject("tdbgView").Columns.Item(3).FooterText) <> "2,487,329,401.01" Then
            Log.Error("Wrong summa")
        End If
        'Ä³ÙÏ»ï³Ýó ·áõÙ³ñ ëÛ³Ý ëïáõ·áõÙ
        If Trim(Sys.Process("Asbank").vbObject("MainForm").Window("MDIClient", "", 1).vbObject("frmPttel").vbObject("tdbgView").Columns.Item(4).FooterText) <> "2,475,601,162.70" Then
            Log.Error("Wrong Expired Summa")
        End If
        '¸áõñë ·ñí³Í ·áõÙ³ñ ëÛ³Ý ëïáõ·áõÙ
        If Trim(Sys.Process("Asbank").vbObject("MainForm").Window("MDIClient", "", 1).vbObject("frmPttel").vbObject("tdbgView").Columns.Item(5).FooterText) <> "2,249,990.00" Then
            Log.Error("Wrong Logout Summa")
        End If
        'îáÏáë ëÛ³Ý ëïáõ·áõÙ
        If Trim(Sys.Process("Asbank").vbObject("MainForm").Window("MDIClient", "", 1).vbObject("frmPttel").vbObject("tdbgView").Columns.Item(6).FooterText) <> "312,324,587.06" Then
            Log.Error("Wrong Percent")
        End If
        'âû·ï. Ù³ëÇ ïáÏáë ëÛ³Ý ëïáõ·áõÙ
        If Trim(Sys.Process("Asbank").vbObject("MainForm").Window("MDIClient", "", 1).vbObject("frmPttel").vbObject("tdbgView").Columns.Item(7).FooterText) <> "1,779,614.00" Then
            Log.Error("Wrong Unused Part of Percent")
        End If
        'Ä³ÙÏ»ï³Ýó ãû·ï. Ù³ëÇ ïáÏáë ëÛ³Ý ëïáõ·áõÙ
        If Trim(Sys.Process("Asbank").vbObject("MainForm").Window("MDIClient", "", 1).vbObject("frmPttel").vbObject("tdbgView").Columns.Item(8).FooterText) <> "1,777,014.00" Then
            Log.Error("Wrong Expired Unused Part of Percent")
        End If
        'Öí³ëï³Ï³Í ïáÏáë ëÛ³Ý ëïáõ·áõÙ
        If Trim(Sys.Process("Asbank").vbObject("MainForm").Window("MDIClient", "", 1).vbObject("frmPttel").vbObject("tdbgView").Columns.Item(9).FooterText) <> "36,790.16" Then
            Log.Error("Wrong Unearned Percent")
        End If
        'Ä³ÙÏ»Ý³ó ïáÏáë ëÛ³Ý ëïáõ·áõÙ
        If Trim(Sys.Process("Asbank").vbObject("MainForm").Window("MDIClient", "", 1).vbObject("frmPttel").vbObject("tdbgView").Columns.Item(10).FooterText) <> "312,324,436.06" Then
            Log.Error("Wrong Expired Percent")
        End If
        ''¸áõñë ·ñí³Í ïáÏáë ëÛ³Ý ëïáõ·áõÙ
        If Trim(Sys.Process("Asbank").vbObject("MainForm").Window("MDIClient", "", 1).vbObject("frmPttel").vbObject("tdbgView").Columns.Item(11).FooterText) <> "281,089.04" Then
            Log.Error("Wrong Written-Off Percent")
        End If
        '´îÐ¸ ïáÏ. ëÛ³Ý ëïáõ·áõÙ
        If Trim(Sys.Process("Asbank").vbObject("MainForm").Window("MDIClient", "", 1).vbObject("frmPttel").vbObject("tdbgView").Columns.Item(12).FooterText) <> "704,348,186.24" Then
            Log.Error("Wrong BTHD")
        End If
        '¸.·. ´îÐ¸ ëÛ³Ý ëïáõ·áõÙ
        If Trim(Sys.Process("Asbank").vbObject("MainForm").Window("MDIClient", "", 1).vbObject("frmPttel").vbObject("tdbgView").Columns.Item(13).FooterText) <> "611,835.90" Then
            Log.Error("Wrong D.G. BTHD")
        End If
        'Ä³ÙÏ»ï³Ýó ·áõÙ³ñ ïáõÛÅ ëÛ³Ý ëïáõ·áõÙ
        If Trim(Sys.Process("Asbank").vbObject("MainForm").Window("MDIClient", "", 1).vbObject("frmPttel").vbObject("tdbgView").Columns.Item(14).FooterText) <> "3,872,172,387.69" Then
            Log.Error("Wrong Expired Penalty of Summa ")
        End If
        'Ä³ÙÏ»ï³Ýó ïáÏáëÇ ïáõÛÅ ëÛ³Ý ëïáõ·áõÙ
        If Trim(Sys.Process("Asbank").vbObject("MainForm").Window("MDIClient", "", 1).vbObject("frmPttel").vbObject("tdbgView").Columns.Item(15).FooterText) <> "460,463,318.16" Then
            Log.Error("Wrong Expired Penalty of Percent")
        End If
        
        '¸áõñë ·ñí³Í ïáõÛÅ ëÛ³Ý ëïáõ·áõÙ
        If Trim(Sys.Process("Asbank").vbObject("MainForm").Window("MDIClient", "", 1).vbObject("frmPttel").vbObject("tdbgView").Columns.Item(16).FooterText) <> "2,751,925.00" Then
            Log.Error("Wrong Written-Off Penalty ")
        End If
        '¸áõñë ·ñí³Í ïáÏ. ïáõÛÅ ëÛ³Ý ëïáõ·áõÙ
        If Trim(Sys.Process("Asbank").vbObject("MainForm").Window("MDIClient", "", 1).vbObject("frmPttel").vbObject("tdbgView").Columns.Item(17).FooterText) <> "440,991.80" Then
            Log.Error("Wrong Written-Off Penalty of Percent")
        End If
        'Ä³ÙÏ»ï³Ýó ·áõÙ³ñÇ ïáÏáë ëÛ³Ý ëïáõ·áõÙ
        If Trim(Sys.Process("Asbank").vbObject("MainForm").Window("MDIClient", "", 1).vbObject("frmPttel").vbObject("tdbgView").Columns.Item(18).FooterText) <> "5,990.38" Then
            Log.Error("Wrong Percent of Expired Summa")
        End If
        '¸.·. Å³ÙÏ. ·.ïÏ. ëÛ³Ý ëïáõ·áõÙ
        If Trim(Sys.Process("Asbank").vbObject("MainForm").Window("MDIClient", "", 1).vbObject("frmPttel").vbObject("tdbgView").Columns.Item(19).FooterText) <> "5,990.38" Then
            Log.Error("Wrong D.G. Percent of Expired Summa")
        End If
        '¶ñ³íÇ ³ñÅ»ùÁ ëÛ³Ý ëïáõ·áõÙ
        If Trim(Sys.Process("Asbank").vbObject("MainForm").Window("MDIClient", "", 1).vbObject("frmPttel").vbObject("tdbgView").Columns.Item(20).FooterText) <> "44,588,125.00" Then
            Log.Error("Wrong Value of Collateral")
        End If
        'ºñ³ßË³íáñáõÃÛ³Ý ³ñÅ»ù ëÛ³Ý ëïáõ·áõÙ
        If Trim(Sys.Process("Asbank").vbObject("MainForm").Window("MDIClient", "", 1).vbObject("frmPttel").vbObject("tdbgView").Columns.Item(21).FooterText) <> "2,000,100,000.00" Then
            Log.Error("Wrong Value of Garantee")
        End If
        'ä³Ñáõëï³íáñí³Í ·áõÙ³ñ ëÛ³Ý ëïáõ·áõÙ
        If Trim(Sys.Process("Asbank").vbObject("MainForm").Window("MDIClient", "", 1).vbObject("frmPttel").vbObject("tdbgView").Columns.Item(30).FooterText) <> "4,630,304,089.10" Then
            Log.Error("Wrong Rezerves Summa")
        End If
        ' âû·ï. Ù³ëÇ å³Ñ. ëÛ³Ý ëïáõ·áõÙ
        If Trim(Sys.Process("Asbank").vbObject("MainForm").Window("MDIClient", "", 1).vbObject("frmPttel").vbObject("tdbgView").Columns.Item(31).FooterText) <> "92,100.00" Then
            Log.Error("Wrong Rezerv of Unused Part")
        End If
        'ê³Ñ³Ù³Ý³ã³÷ ëÛ³Ý ëïáõ·áõÙ
        If Trim(Sys.Process("Asbank").vbObject("MainForm").Window("MDIClient", "", 1).vbObject("frmPttel").vbObject("tdbgView").Columns.Item(42).FooterText) <> "2,386,492,372.00" Then
            Log.Error("Wrong Limit")
        End If
        'âû·ï. Ù³ë ëÛ³Ý ëïáõ·áõÙ
        If Trim(Sys.Process("Asbank").vbObject("MainForm").Window("MDIClient", "", 1).vbObject("frmPttel").vbObject("tdbgView").Columns.Item(43).FooterText) <> "129,500,000.00" Then
            Log.Error("Wrong Value of Unused Part")
        End If
        'ä³ÛÙ³Ý³·ñÇ ·áõÙ³ñ ëÛ³Ý ëïáõ·áõÙ
        If Trim(Sys.Process("Asbank").vbObject("MainForm").Window("MDIClient", "", 1).vbObject("frmPttel").vbObject("tdbgView").Columns.Item(44).FooterText) <> "2,984,706,872.00" Then
            Log.Error("Wrong Summa of Contract")
        End If
        'Ü»ñÏ³ ³ñÅ»ù ëÛ³Ý ëïáõ·áõÙ
        If Trim(Sys.Process("Asbank").vbObject("MainForm").Window("MDIClient", "", 1).vbObject("frmPttel").vbObject("tdbgView").Columns.Item(127).FooterText) <> "2,804,612,247.78" Then
            Log.Error("Wrong Actual Value")
        End If
    Else
        Log.Error("Contract view doesn't exist")
    End If
    'Test CleanUp start
    Call Close_AsBank()
    'Test CleanUp end
    
End Sub