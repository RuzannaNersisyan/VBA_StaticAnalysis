'USEUNIT Library_Common

'--------------------------------------------------------------------------------------
'  ä³ÛÙ³Ý³·ñÇ ³Ù÷á÷áõÙ ýÇÉïñÇ Éñ³óáõÙ
'--------------------------------------------------------------------------------------
'Date - ²Ùë³ÃÇí
'contrLevel - ä³ÛÙ³Ý³·ñÇ Ù³Ï³ñ¹³Ï
'curr - ²ñÅáõÛÃ
'ctype - î»ë³Ï
'Number - ä³ÛÙ³Ý³·ñÇ Ñ³Ù³ñ
'paperNumber - ä³ÛÙ³Ý³·ñÇ ÃÕÃ³ÛÇÝ Ñ³Ù³ñ
'client - Ð³×³Ëáñ¹
'Name - ²Ýí³ÝáõÙ
'shablType -Ò¨³ÝÙáõßÇ ï»ë³Ï
'shablNode - æ¨³ÝÙáõßÇ Ñ³Ý·.
'note - ÜßáõÙÝ»ñ
'note2 - ÜßáõÙÝ»ñ-2
'note3- ÜßáõÙÝ»ñ-3
'acsBranch - ¶ñ³ëºÝÛ³Ï
'acsDepart - ´³ÅÇÝ
'acsType -  îÇå
'risk - èÇëÏÇ ¹³ëÇã
'efficiency - ²ßË³ïáõÝ³ÏáõÃÛáõÝ
'sDate - ÎÝùí³Í ¿ ëÏ½µÇ ³Ùë³ÃÇí
'eDate - ÎÝùí³Í ¿ í»ñçÇ ³Ùë³ÃÇí
'fstartDate - Ø³ñÙ³Ý Å³ÙÏ»ï ëÏÇ½µ
'fendDate - Ø³ñÙ³Ý Å³ÙÏ»ï í»ñç
'showClosed -òáõÛó ï³É ÷³Ïí³ÍÝ»ñÁ
'showpartClosed - àã ÉñÇí ÷³Ï
'defCurrency - Ü³ËÁÝïñ»ÉÇ ³ñÅáõÛÃ
'circulInformation - Þñç³Ý³éáõ ÇÝýáñÙ³óÇ³
'summWithoutExpiredPart- ¶áõÙ³ñÝ»ñÁ ³é³Ýó Å³ÙÏ»ï³Ýó Ù³ëÇ
'summawithoutLogout - ¶áõÙ³ñÝ»ñÁ ³é³Ýó ¹áõñë·ñáõÙÝ»ñÇ
'mainclientData- Ð³×³Ëáñ¹Ç ÑÇÙÝ³Ï³Ý ïíÛ³ÉÝ»ñÁ
'otherclientData - Ð³×³Ëáñ¹Ç ³ÛÉ ïíÛ³ÉÝ»ñ
'contrmainData - ä³ÛÙ³Ý³·ñÇ ÑÇÙÝ³Ï³Ý ïíÛ³ÉÝ»ñ
'othercontrData - ä³ÛÙ³Ý³·ñÇ ³ÛÉ ïíÛ³ÉÝ»ñ
'pldata - ¶ñ³íÇ ïíÛ³ÉÝ»ñ
'mainSumma - ÐÇÙÝ³Ï³Ý ·áõÙ³ñÝ»ñ
'otherSumma- ²ÛÉ ·áõÙ³ñÝ»ñ
'addSumma - Èñ³óáõóÇã ·áõÙ³ñÝ»ñ
'mainDate - ÐÇÙÝ³Ï³Ý ³Ùë³Ãí»ñ
'otherDate - ²ÛÉ ³Ùë³Ãí»ñ
'addDate - Èñ³óáõóÇã ³Ùë³Ãí»ñ
'mainAccData - Ð³ßí³å³Ñ³Ï³Ý ÑÇÙÝ³Ï³Ý ïíÛ³ÉÝ»ñ
'addAccData - Ð³ßí³å³Ñ³Ï³Ý Éñ³óáõóÇã ïíÛ³ÉÝ»ñ
'expitedSumma - Ä³ÙÏ»ï³Ýó ·áõÙ³ñÝ»ñ
'woffSumma- ¸áõñë ·ñí³Í ·áõÙ³ñÝ»ñ
'note4 - ÜßáõÙÝ»ñ
'riskInf - èÇëÏ³ÛÇÝ ÇÝýáñÙ³óÇ³
'benData - ÜßáõÙÝ»ñÇ ïíÛ³ÉÝ»ñ
'pType - ÀÝ¹áõÝáõÙ ¿ 1,2,3,4 ³ñÅ»ùÝ»ñÁ , 1 ³ñÅ»ùÇ ÷áË³ÝóíáõÙ ¿ í³ñÏ»ñÇ Ñ³Ù³ñ, 2-Á` ý³ÏïáñÇÝ·Ç
'3-Á ` ³í³Ý¹Ý»ñÇ , ÇëÏ 4-Á ûí»ñ¹ñ³ýïÇ å³ÛÙ³Ý³·ñÇ ³Ù÷á÷áõÙÝ»ñÇ Ñ³Ù³ñ 
Sub Contract_Sammary_Report_Fill(Date, contrLevel, curr, ctype, Number, paperNumber, client, Name, _
                                 shablType, shablNode, note, note2, note3, acsBranch, acsDepart, _
                                 acsType, risk, efficiency, sDate, eDate, fstartDate, fendDate, showClosed, showpartClosed, _
                                 defCurrency, circulInformation, summWithoutExpiredPart, summawithoutLogout, _
                                 mainclientData, otherclientData, contrmainData, othercontrData, pldata, _
                                 mainSumma, otherSumma, addSumma, mainDate, otherDate, addDate, _
                                 mainAccData, addAccData, expitedSumma, woffSumma, note4, riskInf, benData, pType)
   
  If p1.WaitVBObject("frmAsUstPar", 3000).Exists Then
    '²Ùë³ÃÇí ¹³ßïÇ Éñ³óáõÙ
    Call Rekvizit_Fill("Dialog", 1, "General", "RDATE", "!" & "[End]" & "[Del]" & Date)
    'ä³ÛÙ³Ý³·ñÇ Ù³Ï³ñ¹³Ï ¹³ßïÇ Éñ³óáõÙ
    Call Rekvizit_Fill("Dialog", 1, "General", "LEVEL", contrLevel)
    '²ñÅáõÛÃ ¹³ßïÇ Éñ³óáõÙ
    Call Rekvizit_Fill("Dialog", 1, "General", "CUR", curr)
    'î»ë³Ï ¹³ßïÇ Éñ³óáõÙ
    Call Rekvizit_Fill("Dialog", 1, "General", "AGRKIND", ctype)
    'ä³ÛÙ³Ý³·ñÇ N ¹³ßïÇ Éñ³óáõÙ
    Call Rekvizit_Fill("Dialog", 1, "General", "NUM", Number)
    'ÂÕÃ³ÛÇÝ N ¹³ßïÇ ÉñáóáõÙ
    Call Rekvizit_Fill("Dialog", 1, "General", "PPRCODE", paperNumber)
    'Ð³×³Ëáñ¹ ¹³ßïÇ Éñ³óáõÙ
    Call Rekvizit_Fill("Dialog", 1, "General", "CLIENT", client)
    '²Ýí³ÝáõÙ ¹³ßïÇ Éñ³óáõÙ
    Call Rekvizit_Fill("Dialog", 1, "General", "CLIENTNAME", Name)
    'Ò¨³ÝÙ. ï»ë³Ï ¹³ßïÇ Éñ³óáõÙ
    Call Rekvizit_Fill("Dialog", 1, "General", "SHABLON", shablType)
    'Ò¨³ÝÙ. Ñ³Ý·. ¹³ßïÇ Éñ³óáõÙ
    Call Rekvizit_Fill("Dialog", 1, "General", "SHABLNODE", shablNode)
    '¶ñ³ë»ÝÛ³É ¹³ßïÇ Éñ³óáõÙ
    Call Rekvizit_Fill("Dialog", 1, "General", "ACSBRANCH", acsBranch)
    
    BuiltIn.Delay(2000)
    'Ð³×³Ëáñ¹Ç ÑÇÙÝ³Ï³Ý ïíÛ³ÉÝ»ñÁ ¹³ßïÇ Éñ³óáõÙ
    If mainclientData Then
      Call Rekvizit_Fill("Dialog", 2, "CheckBox", "CL1", 1)
    End If
    '²ÛÉ ïíÛ³ÉÝ»ñ ¹³ßïÇ Éñ³óáõÙ
    If otherclientData Then
      Call Rekvizit_Fill("Dialog", 2, "CheckBox", "CL2", 1)
    End If
    'ä³ÛÙ³Ý³·ñÇ ÑÇÙÝ³Ï³Ý ïíÛ³É»ñ ¹³ßïÇ Éñ³óáõÙ
    If contrmainData Then
      Call Rekvizit_Fill("Dialog", 2, "CheckBox", "AGR1", 1)
    End If 
    '²ÛÉ ïíÛ³ÉÝ»ñ ¹³ßïÇ Éñ³óáõÙ
    If othercontrData Then
      Call Rekvizit_Fill("Dialog", 2, "CheckBox", "AGR2", 1)
    End If
    '¶ñ³íÇ ïíÛ³ÉÝ»ñ ¹³ßïÇ Éñ³óáõÙ
    If pldata Then
      Call Rekvizit_Fill("Dialog", 2, "CheckBox", "AGR3", 1)
    End If
    'ÐÇÙÝ³Ï³Ý ·áõÙ³ñ ¹³ßïÇ Éñ³óáõÙ
    If mainSumma Then
      Call Rekvizit_Fill("Dialog", 2, "CheckBox", "SUM1", 1)
    End If
    '²ÛÉ ·áõÙ³ñÝ»ñ ¹³ßïÇ Éñ³óáõÙ
    If otherSumma Then
      Call Rekvizit_Fill("Dialog", 2, "CheckBox", "SUM2", 1)
    End If
    'Èñ³óáõáóÇã ·áõÙ³ñÝ»ñ ¹³ßïÇ Éñ³óáõÙ
    If addSumma Then
      Call Rekvizit_Fill("Dialog", 2, "CheckBox", "SUM3", 1)
    End If
    'ÐÇÙÝ³Ï³Ý ³Ùë³Ãí»ñ ¹³ßïÇ Éñ³óáõÙ
    If mainDate Then
      Call Rekvizit_Fill("Dialog", 2, "CheckBox", "DAT1", 1)
    End If
    '²ÛÉ ³Ùë³Ãí»ñ ¹³ßïÇ Éñ³óáõÙ
    If otherDate Then
      Call Rekvizit_Fill("Dialog", 2, "CheckBox", "DAT2", 1)
    End If
    'Èñ³óáõóÇã ³Ùë³Ãí»ñ ¹³ßïÇ Éñ³óáõÙ
    If addDate Then
      Call Rekvizit_Fill("Dialog", 2, "CheckBox", "DAT3", 1)
    End If
    'Ð³ßí³å³Ñ³Ï³Ý ÑÇÙÝ³Ï³Ý ïíÛ³ÉÝ»ñ ¹³ßïÇ Éñ³óáõÙ
    If mainAccData Then
      Call Rekvizit_Fill("Dialog", 2, "CheckBox", "ACC1", 1)
    End If
    'Èñ³óáõóÇã ïíÛ³ÉÝ»ñ ¹³ßïÇ Éñ³óáõÙ
    If addAccData Then
      Call Rekvizit_Fill("Dialog", 2, "CheckBox", "ACC2", 1)
    End If
    'Ä³ÙÏ»ï³Ýó ·áõÙ³ñÝ»ñ ¹³ßïÇ Éñ³óáõÙ
    If expitedSumma Then
      Call Rekvizit_Fill("Dialog", 2, "CheckBox", "SUMJS", 1)
    End If
    'ÜßáõÙÝ»ñ ¹³ßïÇ Éñ³óáõÙ
    If note4 Then
      Call Rekvizit_Fill("Dialog", 2, "CheckBox", "NOTES", 1)
    End If
    'Շահառուների տվյալներ դաշտի լրացում
    If benData Then
      Call Rekvizit_Fill("Dialog", 2, "CheckBox", "SHOWRESPS", 1)
    End If
				
    'ì³ñÏ»ñÇ Ï³Ù úí»ñ¹ñ³ýïÇ Ñ³Ù³ñ 
    If pType = 1 or pType = 4 Then
      '¸áõñë·ñí³Í ·áõÙ³ñÝ»ñ ¹³ßïÇ Éñ³óáõÙ
      If woffSumma Then
        Call Rekvizit_Fill("Dialog", 2, "CheckBox", "SUMOS", 1)
      End If
      'èÇëÏ³ÛÇÝ ÇÝýáñÙ³óÇ³ ¹³ßïÇ Éñ³óáõÙ
      If riskInf Then
        Call Rekvizit_Fill("Dialog", 2, "CheckBox", "RSK", 1)
      End If   
    End If   
				                 
    'ü³ÏïáñÇÝ·Ç Ñ³Ù³ñ 
    If pType = 2 Then
      'ä³Ñ³Ýç³ïÇñáç ÑÇÙÝ³Ï³Ý ïíÛ³ÉÝ»ñ ¹³ßïÇ Éñ³óáõÙ 
      Call Rekvizit_Fill("Dialog", 2, "CheckBox", "CC1", 1)
      '²ÛÉ ïíÛ³ÉÝ»ñ ¹³ßïÇ Éñ³óáõÙ 
      Call Rekvizit_Fill("Dialog", 2, "CheckBox", "CC2", 1)
      '¸áõñë·ñí³Í ·áõÙ³ñÝ»ñ ¹³ßïÇ Éñ³óáõÙ
      If woffSumma Then
        Call Rekvizit_Fill("Dialog", 2, "CheckBox", "SUMOS", 1)
      End If
      'èÇëÏ³ÛÇÝ ÇÝýáñÙ³óÇ³ ¹³ßïÇ Éñ³óáõÙ
      If riskInf Then
        Call Rekvizit_Fill("Dialog", 2, "CheckBox", "RSK", 1)
      End If
    End If   
				                
    BuiltIn.Delay(1000)  
    Call ClickCmdButton(2, "Î³ï³ñ»É")
  Else
    Log.Error "Can't open frmAsUstPar window", "", pmNormal, ErrorColor
  End If
End Sub

'________________________________________________________________________________________________________________________
' ä³ÛÙ³Ý³·ñÇ ³Ù÷á÷áõÙ(ø»ß³íáñí³Í) ÷³ëï³ÃÕÃÇ Éñ³óáõÙ 
'________________________________________________________________________________________________________________________
'Date - ²Ùë³ÃÇí
'AccInfo - Ð³ßí³å³Ñ³Ï³Ý ïíÛ³ÉÝ»ñ
'Inform - Þñç³Ý³éáõ ÇÝýáñÙ³óÇ³
'ClientInfo - Ð³×³Ëáñ¹Ç ïíÛ³ÉÝ»ñ
'Notes - ÜßáõÙÝ»ñ
'SumWithoutPen - ¶áõÙ. ³é³Ýó Å³ÙÏ»ï³Ýó Ù³ëÇ
'ShowInfo - òáõÛó ï³É ³ñï³Ñ³Ýí³Í ïíÛ³ÉÝ»ñÁ
'SumWithot_ - òáõÛó ï³É ³ñï³Ñ³Ýí³Í ïíÛ³ÉÝ»ñÁ
Sub Contract_Sammary_Report_Fill_Cashed(Date,AccInfo,Inform,ClientInfo,Notes,SumWithoutPen,ShowInfo,SumWithot_)
    'Èñ³óÝ»Ù ²Ùë³ÃÇí ¹³ßïÁ
    Call Rekvizit_Fill("Dialog",1,"General","RDATE",Date)
     'Ð³ßí³å³Ñ³Ï³Ý ïíÛ³ÉÝ»ñ ¹³ßïÇ Éñ³óáõÙ
    If AccInfo Then
       Call Rekvizit_Fill("Dialog",1,"CheckBox","ACC",1)
    End If
    
    'Ð³×³Ëáñ¹Ç ïíÛ³ÉÝ»ñ ¹³ßïÇ Éñ³óáõÙ
    If ClientInfo Then 
       Call Rekvizit_Fill("Dialog",1,"CheckBox","CL",1)
    End If
    
    'Þñç³Ý³éáõ ÇÝýáñÙ³óÇ³ ¹³ßïÇ Éñ³óáõÙ
    If Inform Then
       Call Rekvizit_Fill("Dialog",1,"CheckBox","CHKTURN",1) 
    End If
    
    'ÜßáõÙÝ»ñ ¹³ßïÇ Éñ³óáõÙ
    If Notes Then 
      Call Rekvizit_Fill("Dialog",1,"CheckBox","NOTES",1)  
    End If
    
    '²í³Ý¹
    If deposit Then
      'òáõÛó ï³É ³ñï³Ñ³Ýí³Í ïíÛ³ÉÝ»ñÁ ¹³ßïÇ Éñ³óáõÙ
      If ShowInfo Then 
         Call Rekvizit_Fill("Dialog",1,"CheckBox","SHOWIMPDATA",1)
      End If
      '¶áõÙ. ³é³Ýó Å³ÙÏ»ï³Ýó Ù³ëÇ ¹³ßïÇ Éñ³óáõÙ 
      If SumWithoutPen Then 
         Call Rekvizit_Fill("Dialog",1,"CheckBox","SHWITHOUTSUMJ",1)
      End If
    End If
    
    'úí»ñ¹ñ³ýï ¨ í³ñÏ
   If overdraft_credit Then
      '¶áõÙ. ³é³Ýó Å³ÙÏ»ï³Ýó Ù³ëÇ ¹³ßïÇ Éñ³óáõÙ 
      If SumWithoutPen Then 
         Call Rekvizit_Fill("Dialog",1,"CheckBox","SHWITHOUTSUMJ",1)
      End If
      'òáõÛó ï³É ³ñï³Ñ³Ýí³Í ïíÛ³ÉÝ»ñÁ ¹³ßïÇ Éñ³óáõÙ
      If ShowInfo Then 
         Call Rekvizit_Fill("Dialog",1,"CheckBox","SHOWIMPDATA",1)
      End If
      '¶áõÙ. ³é³Ýó ¹áõñë·ñáõÙÝ»ñÇ
      If SumWithot_ Then
         Call Rekvizit_Fill("Dialog",1,"CheckBox","SHWITHOUTOUTSUM",1)
      End If
   End If
   
   '²ñÅ»ÃÕÃ»ñ
   If Arjetxter Then 
      'òáõÛó ï³É ³ñï³Ñ³Ýí³Í ïíÛ³ÉÝ»ñÁ ¹³ßïÇ Éñ³óáõÙ
      If ShowInfo Then 
         Call Rekvizit_Fill("Dialog",1,"CheckBox","SHOWIMPDATA",1)
      End If
   End If
   
   'ê»ÕÙ»É Î³ï³ñ»É Ïáñ×³ÏÁ
   Sys.Process("Asbank").VBObject("frmAsUstPar").VBObject("CmdOK").Click()
End Sub 