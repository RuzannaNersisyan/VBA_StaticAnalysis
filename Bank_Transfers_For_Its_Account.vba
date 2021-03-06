Option Explicit
'USEUNIT Subsystems_SQL_Library
'USEUNIT  Library_Common
'USEUNIT Constants
'USEUNIT External_Transfers_Library
'USEUNIT Subsystems_SQL_Library
'USEUNIT Percentage_Calculation_Filter_Library
'USEUNIT BankMail_Library
'USEUNIT Akreditiv_Library

'Test Case 159077

' "Միջթղթակցային փոխանցում" փաստաթղթի ստեղծում և գործողությունների կատարում
Sub Bank_Transfers_For_Its_Account_Test()

      Dim fDATE, sDATE
      Dim TransfersForItsAcc, SendingTransfersForIts, PartiallyEditableAssign, AccForTransfers
      Dim todayDMY, frmPttel, colNum, status, grRemOrdISN, grRemOrdNum, state
      Dim folderDirect, wCur, wUser, docType, paySysin, paySysOut, payNotes, acsBranch, acsDepart, selectView, exportExcel
      Dim queryString, sqlValue, sql_isEqual, todayTime
      
      fDATE = "20250101"
      sDATE = "20120101"
      Call Initialize_AsBank("bank", sDATE, fDATE)
      
      ' Մուտք գործել համակարգ ARMSOFT օգտագործողով 
      Call Create_Connection()
      Login("ARMSOFT")
      
      ' Մուտք Արտաքին փոխանցումների ԱՇՏ
      Call ChangeWorkspace(c_ExternalTransfers)

      todayDMY = aqConvert.DateTimeToFormatStr(aqDateTime.Today,"%d/%m/%y")
      
      ' Ստեղծել միջթղթակցային փոխանցում փաստաթուղթ
      Set TransfersForItsAcc = New_TransfersForItsAcc()
      With TransfersForItsAcc
      
            .folderDirect = "|²ñï³ùÇÝ ÷áË³ÝóáõÙÝ»ñÇ ²Þî|Üáñ ÷³ëï³ÃÕÃ»ñ|ØÇçÃÕÃ³Ïó³ÛÇÝ ÷áË³ÝóáõÙ"
            .wDate = todayDMY
            .accDB = "000010201"
            .accCR = "10330030101"
            .wSumma = "10,000.00"
            .addInfo = "Ð³Ù³Ó³ÛÝ Ã. Ñ³ßíÇ"
            .wPack = "123"
            .tcorrAcc = "000548101"
            .wMedop = "A"
            .medBank = "0445RU99305"
            .medID = "00052641523"
            
      End With
      
      Call Fill_TransfersForItsAcc(TransfersForItsAcc) 
      BuiltIn.Delay(2000)     
       
      Log.Message(TransfersForItsAcc.fISN)
      Log.Message(TransfersForItsAcc.cliCode)
      todayTime = aqConvert.DateTimeToFormatStr(aqDateTime.Today,"20%y%m%d")
      
                  'DOCS
                  queryString = " SELECT COUNT(*) FROM DOCS WHERE fISN = " & TransfersForItsAcc.fISN & _
                                            " and fNAME = 'FinTrans' and fSTATE = '1' and fBODY = '"& vbCRLF _
                                          & "USERID:  77"& vbCRLF _
                                          & "ACSBRANCH:00"& vbCRLF _
                                          & "ACSDEPART:1"& vbCRLF _
                                          & "DOCNUM:"& TransfersForItsAcc.cliCode & vbCRLF _
                                          & "DATE:"& todayTime & vbCRLF _
                                          & "ACCDB:000010201"& vbCRLF _
                                          & "ACCCR:10330030101"& vbCRLF _
                                          & "SUMMA:10000"& vbCRLF _
                                          & "CUR:001"& vbCRLF _
                                          & "ADDINFO:Ð³Ù³Ó³ÛÝ Ã. Ñ³ßíÇ"& vbCRLF _
                                          & "PACK:123"& vbCRLF _
                                          & "TCORRACC:000548101"& vbCRLF _
                                          & "PAYSYSIN:Ð"& vbCRLF _
                                          & "MEDOP:A"& vbCRLF _
                                          & "MEDBANK:0445RU99305"& vbCRLF _
                                          & "MEDID:00052641523"& vbCRLF _
                                          & "TYPECODE1:+80 85 86"& vbCRLF _
                                          & "TYPECODE2:-10 20 21 22 23 24 30 31 32 25 26 92 93 11 27 33 28"& vbCRLF _
                                          & "'"
                  sqlValue = 1
                  colNum = 0
                  sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
                  If Not sql_isEqual Then
                    Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
                  End If
                  
                  'FOLDERS
                  queryString = " SELECT COUNT(*) FROM FOLDERS WHERE fISN = " & TransfersForItsAcc.fISN & _
                                            " and fNAME = 'FinTrans' and fCOM = 'öáË³ÝóáõÙ Çñ Ñ³ßÇíÝ»ñáí' and fECOM = 'Fin. Institution Own Transfer'" & _
                                            " and fDCBRANCH = '00' and fDCDEPART = '1' and fSPEC ='"& TransfersForItsAcc.cliCode &"77700000010201  7770010330030101        10000.00001Üáñ                                                   77                                                                                       Ð        Ð³Ù³Ó³ÛÝ Ã. Ñ³ßíÇ'" 
                  sqlValue = 1        
                  colNum = 0
                  sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
                  If Not sql_isEqual Then
                    Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
                  End If
                  
                  'HI
                  queryString = " SELECT COUNT(*) FROM HI WHERE fBASE = " & TransfersForItsAcc.fISN & _
                                            " and fTYPE = '11' and fSUM = '4000000.00' and fCUR = '001' and fOP = 'TRF' and fCURSUM = '10000.00' " & _
                                            " and (( fSPEC = '"& TransfersForItsAcc.cliCode &"                   Ð³Ù³Ó³ÛÝ Ã. Ñ³ßíÇ                 0   400.0000    1' and fDBCR = 'D') " & _
                                            " or (fSPEC = '"& TransfersForItsAcc.cliCode &"                   Ð³Ù³Ó³ÛÝ Ã. Ñ³ßíÇ                 1   400.0000    1' and fDBCR = 'C'))"
                  sqlValue = 2
                  colNum = 0
                  sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
                  If Not sql_isEqual Then
                    Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
                  End If
                  
                  'DOCLOG
                  queryString = " SELECT COUNT(*) FROM DOCLOG WHERE fISN = " & TransfersForItsAcc.fISN & _
                                            " and fSTATE = '1' and (fOP = 'N' or fOP = 'T'  " & _
                                            " or (fOP = 'M' and fCOM = '¶ñ³Ýóí»É »Ý Ó¨³Ï»ñåáõÙÝ»ñÁ')) " 
                  sqlValue = 3
                  colNum = 0
                  sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
                  If Not sql_isEqual Then
                    Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
                  End If
                  
      ' Մուտք աշխատանքային փաստաթղթեր դիալոգ և արժեքների լրացում
      folderDirect = "|²ñï³ùÇÝ ÷áË³ÝóáõÙÝ»ñÇ ²Þî|²ßË³ï³Ýù³ÛÇÝ ÷³ëï³ÃÕÃ»ñ"
      wCur = "001"
      docType = "FinTrans"
      paySysin = "Ð"
      acsBranch = "00"
      acsDepart = "1" 
      selectView = "Oper"
      exportExcel = "0"
      Call WorkingDocsFilter(folderDirect, todayDMY, todayDMY, wCur, wUser, docType, paySysin, paySysOut, payNotes, acsBranch, acsDepart, selectView, exportExcel)
      
      ' Փաստաթուղթն ուղարկել արտաքին բաժին
      state =  ConfirmContractDoc(2, TransfersForItsAcc.cliCode, c_SendToExternalSec, 5, "²Ûá")
      If Not state Then
            Log.Error("Փաստաթուղթը չի ուղարկվել արտաքին բաժին")
      End If
      
      Set frmPttel = Sys.Process("Asbank").VBObject("MainForm").Window("MDIClient", "", 1).VBObject("frmPttel")
      frmPttel.Close
      
                  'DOCS
                  queryString = " SELECT COUNT(*) FROM DOCS WHERE fISN = " & TransfersForItsAcc.fISN & _
                                            " and fNAME = 'FinTrans' and fSTATE = '2'"
                  sqlValue = 1
                  colNum = 0
                  sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
                  If Not sql_isEqual Then
                    Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
                  End If
                  
                  'FOLDERS
                  queryString = " SELECT COUNT(*) FROM FOLDERS WHERE fISN = " & TransfersForItsAcc.fISN & _
                                            " and fNAME = 'FinTrans' and fCOM = 'öáË³ÝóáõÙ Çñ Ñ³ßÇíÝ»ñáí' and fECOM = 'Fin. Institution Own Transfer'" & _
                                            " and fDCBRANCH = '' and fDCDEPART = '' and fSPEC ='"& TransfersForItsAcc.cliCode &"77700000010201  7770010330030101        10000.00001Ð³ëï³ïí³Í             77Ð³Ù³Ó³ÛÝ Ã. Ñ³ßíÇ               123Ð '" 
                  sqlValue = 1
                  colNum = 0
                  sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
                  If Not sql_isEqual Then
                    Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
                  End If
                  
                  'HI
                  queryString = " SELECT COUNT(*) FROM HI WHERE fBASE = " & TransfersForItsAcc.fISN & _
                                            " and fTYPE = '01' and fSUM = '4000000.00' and fCUR = '001' and fOP = 'TRF' and fCURSUM = '10000.00'" & _
                                            " and ((fDBCR = 'D' and fSPEC = '"& TransfersForItsAcc.cliCode &"                   Ð³Ù³Ó³ÛÝ Ã. Ñ³ßíÇ                 0   400.0000    1' )" & _
                                            " or (fSPEC = '"& TransfersForItsAcc.cliCode &"                   Ð³Ù³Ó³ÛÝ Ã. Ñ³ßíÇ                 1   400.0000    1'  and fDBCR = 'C'))"
                  sqlValue = 2
                  colNum = 0
                  sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
                  If Not sql_isEqual Then
                    Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
                  End If
                  
                  'DOCLOG
                  queryString = " SELECT COUNT(*) FROM DOCLOG WHERE fISN = " & TransfersForItsAcc.fISN & _
                                            " and ((fSTATE = '1' and (fOP = 'N' or fOP = 'T' " & _
                                            " or (fOP = 'M' and fCOM = '¶ñ³Ýóí»É »Ý Ó¨³Ï»ñåáõÙÝ»ñÁ')))" & _
                                            " or (fSTATE = '2' and (fOP = 'R' or fOP = 'T' " & _
                                            " or (fOP = 'M' and fCOM = '¶ñ³Ýóí»É »Ý Ó¨³Ï»ñåáõÙÝ»ñÁ'))))" 
                  sqlValue = 6
                  colNum = 0
                  sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
                  If Not sql_isEqual Then
                    Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
                  End If
                  
                  'PAYMENTS
                  queryString = " SELECT COUNT(*) FROM PAYMENTS WHERE fISN = " & TransfersForItsAcc.fISN & _
                                            " and fDOCTYPE = 'FinTrans' and fCUR = '001' and fSUMMA = '10000.00'" & _
                                            " and fSUMMAAMD = '4000000.00' and fSUMMAUSD = '10000.00' and fCOM = 'Ð³Ù³Ó³ÛÝ Ã. Ñ³ßíÇ'" & _
                                            " and fCHARGESUM = '0.00' and fCHARGESUMAMD = '0.00' and fCHARGESUM2 = '0.00'" 
                  sqlValue = 1
                  colNum = 0
                  sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
                  If Not sql_isEqual Then
                    Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
                  End If
      
      ' Մուտք Ուղարկվող միջթղթակցային փոխանցումներ թղթապանակ
      Set SendingTransfersForIts = New_SendingTransfersForIts()
      With SendingTransfersForIts
              .folderDirect = "|²ñï³ùÇÝ ÷áË³ÝóáõÙÝ»ñÇ ²Þî|ÂÕÃ³å³Ý³ÏÝ»ñ|àõÕ³ñÏíáÕ Ñ³ÝÓÝ³ñ³ñ³·ñ»ñ|àõÕ³ñÏíáÕ ÙÇçÃÕÃ³Ïó³ÛÇÝ ÷áË³ÝóáõÙÝ»ñ"
              .stDate = todayDMY
              .eDate = todayDMY
              .wUser = "77"
              .wCur = "001"
              .packNum = "123"
              .paySysin = "Ð"
              .selectView = "FinOuts"
              .exportExcel = "0"
      End With
      
      Call Fill_SendingTransfersForIts(SendingTransfersForIts)
      
      ' Ուղարկել մասնակի խմբագրման
      state = ConfirmContractDoc(2, TransfersForItsAcc.cliCode, c_SendToPartEd, 2, "Î³ï³ñ»É")
      If Not state Then
            Log.Error("Փաստաթուղթը չի ուղարկվել մասնակի խմբագրման")
      End If
      BuiltIn.Delay(3000)
      frmPttel.Close
      
                  'DOCS
                  queryString = " SELECT COUNT(*) FROM DOCS WHERE fISN = " & TransfersForItsAcc.fISN & _
                                            " and fNAME = 'FinTrans' and fSTATE = '12'"
                  sqlValue = 1
                  colNum = 0
                  sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
                  If Not sql_isEqual Then
                    Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
                  End If
                  
                  'FOLDERS
                  queryString = " SELECT COUNT(*) FROM FOLDERS WHERE fISN = " & TransfersForItsAcc.fISN & _
                                            " and fNAME = 'FinTrans' and fCOM = 'öáË³ÝóáõÙ Çñ Ñ³ßÇíÝ»ñáí' and fECOM = 'Fin. Institution Own Transfer' " & _
                                            " and fDCBRANCH = '00' and fDCDEPART = '1' and fSPEC ='"& TransfersForItsAcc.cliCode &"77700000010201  7770010330030101        10000.00001ÎñÏÝ³ÏÇ áõÕ³ñÏíáÕ     77Ð³Ù³Ó³ÛÝ Ã. Ñ³ßíÇ                                                                               123Ð'" 
                  sqlValue = 1
                  colNum = 0
                  sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
                  If Not sql_isEqual Then
                    Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
                  End If

                  
                  'DOCLOG
                  queryString = " SELECT COUNT(*) FROM DOCLOG WHERE fISN = " & TransfersForItsAcc.fISN & _
                                            " and ((fSTATE = '1' and (fOP = 'N' or fOP = 'T' " & _
                                            " or (fOP = 'M' and fCOM = '¶ñ³Ýóí»É »Ý Ó¨³Ï»ñåáõÙÝ»ñÁ')))" & _
                                            " or (fSTATE = '2' and (fOP = 'R' or fOP = 'T' " & _
                                            " or (fOP = 'M' and fCOM = '¶ñ³Ýóí»É »Ý Ó¨³Ï»ñåáõÙÝ»ñÁ')))" & _
                                            " or (fOP = 'M' and fSTATE = '12' and fCOM = 'àõÕ³ñÏí»É ¿ Ù³ëÝ³ÏÇ ËÙµ³·ñÙ³Ý'))" 
                  sqlValue = 7
                  colNum = 0
                  sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
                  If Not sql_isEqual Then
                    Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
                  End If
                  
                  'PAYMENTS
                  queryString = " SELECT COUNT(*) FROM PAYMENTS WHERE fISN = " & TransfersForItsAcc.fISN 
                  sqlValue = 0
                  colNum = 0
                  sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
                  If Not sql_isEqual Then
                    Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
                  End If
      
      ' Մուտք Մասնակի խմբագրվող հանձնարարագրեր
      Set PartiallyEditableAssign = New_PartiallyEditableAssign()
      With PartiallyEditableAssign
              .folderDirect = "|²ñï³ùÇÝ ÷áË³ÝóáõÙÝ»ñÇ ²Þî|ÂÕÃ³å³Ý³ÏÝ»ñ|àõÕ³ñÏíáÕ Ñ³ÝÓÝ³ñ³ñ³·ñ»ñ|Ø³ëÝ³ÏÇ ËÙµ³·ñíáÕ Ñ³ÝÓÝ³ñ³ñ³·ñ»ñ"
              .stDate = todayDMY
              .eDate = todayDMY
              .paySysin =  "Ð"
              .acsBranch = "00"
              .acsDepart = "1"
              .selectView = "RePay"
              .exportExcel = "0"
      End With
      
      Call Fill_PartiallyEditableAssign(PartiallyEditableAssign)
      
      ' Ստուգել փաստաթղթի առկայությունը "Մասնակի խմբագրվող հանձնարարագրեր" թղթապանակում
      status = CheckContractDoc(1, TransfersForItsAcc.cliCode)
      
      If Not status Then
            Log.Error()
      End If

      ' Կատարել"Խմբագրել" գործողությունը
      Call ContractAction(c_ToEdit)
      
      ' Խմբագրել "Լրացուցիչ ինֆորմացիա" դաշտը
      Call Rekvizit_Fill("Document", 1, "General", "ADDINFO", "^A[Del]" & "Ð³ñÏ»ñÇ Ù³ñáõÙ")
      Call ClickCmdButton(1, "Î³ï³ñ»É")
      BuiltIn.Delay(1500)
      
      colNum =	wMDIClient.VBObject("frmPttel").GetColumnIndex("AIM")
      If Not Trim(frmPttel.VBObject("TDBGView").Columns.Item(colNum)) = "Ð³ñÏ»ñÇ Ù³ñáõÙ" Then
            Log.Error("Նպատակ դաշտը չի խմբագրվել")
      End If
      
                 'DOCS
                  queryString = " SELECT COUNT(*) FROM DOCS WHERE fISN = " & TransfersForItsAcc.fISN & _
                                            " and fNAME = 'FinTrans' and fSTATE = '12' and fBODY ='"& vbCRLF _
                                        & "USERID:  77"& vbCRLF _
                                        & "ACSBRANCH:00"& vbCRLF _
                                        & "ACSDEPART:1"& vbCRLF _
                                        & "DOCNUM:"&TransfersForItsAcc.cliCode & vbCRLF _
                                        & "DATE:"& todayTime & vbCRLF _
                                        & "ACCDB:000010201"& vbCRLF _
                                        & "ACCCR:10330030101"& vbCRLF _
                                        & "SUMMA:10000"& vbCRLF _
                                        & "CUR:001"& vbCRLF _
                                        & "ADDINFO:Ð³ñÏ»ñÇ Ù³ñáõÙ"& vbCRLF _
                                        & "PACK:123"& vbCRLF _
                                        & "TCORRACC:000548101"& vbCRLF _
                                        & "PAYSYSIN:Ð"& vbCRLF _
                                        & "MEDOP:A"& vbCRLF _
                                        & "MEDBANK:0445RU99305"& vbCRLF _
                                        & "MEDID:00052641523"& vbCRLF _
                                        & "TYPECODE1:+80 85 86"& vbCRLF _
                                        & "TYPECODE2:-10 20 21 22 23 24 30 31 32 25 26 92 93 11 27 33 28"& vbCRLF _
                                        & "'"
                  sqlValue = 1
                  colNum = 0
                  sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
                  If Not sql_isEqual Then
                    Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
                  End If
                  
                  'FOLDERS
                  queryString = " SELECT COUNT(*) FROM FOLDERS WHERE fISN = " & TransfersForItsAcc.fISN & _
                                            " and fNAME = 'FinTrans' and fCOM = 'öáË³ÝóáõÙ Çñ Ñ³ßÇíÝ»ñáí' and fECOM = 'Fin. Institution Own Transfer' " & _
                                            " and fDCBRANCH = '00' and fDCDEPART = '1' and fSPEC ='"& TransfersForItsAcc.cliCode &"77700000010201  7770010330030101        10000.00001ÎñÏÝ³ÏÇ áõÕ³ñÏíáÕ     77Ð³ñÏ»ñÇ Ù³ñáõÙ                                                                                  123Ð'" 
                  sqlValue = 1
                  colNum = 0
                  sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
                  If Not sql_isEqual Then
                    Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
                  End If

                  
                  'DOCLOG
                  queryString = " SELECT COUNT(*) FROM DOCLOG WHERE fISN = " & TransfersForItsAcc.fISN 
                  sqlValue = 10
                  colNum = 0
                  sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
                  If Not sql_isEqual Then
                    Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
                  End If
            
      ' Փաստաթուղթն ուղարկել արտաքին բաժին
      state = ConfirmContractDoc(1, TransfersForItsAcc.cliCode, c_SendToExternalSec, 5, "²Ûá")
      If Not state Then
            Log.Error("Փաստաթուղթը չի ուղարկվել արտաքին բաժին")
      End If
      
      Set frmPttel = Sys.Process("Asbank").VBObject("MainForm").Window("MDIClient", "", 1).VBObject("frmPttel")
      frmPttel.Close
      
                 'DOCS
                  queryString = " SELECT COUNT(*) FROM DOCS WHERE fISN = " & TransfersForItsAcc.fISN & _
                                            " and fNAME = 'FinTrans' and fSTATE = '2'"
                  sqlValue = 1
                  colNum = 0
                  sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
                  If Not sql_isEqual Then
                    Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
                  End If
                  
                  'FOLDERS
                  queryString = " SELECT COUNT(*) FROM FOLDERS WHERE fISN = " & TransfersForItsAcc.fISN & _
                                            " and fNAME = 'FinTrans' and fCOM = 'öáË³ÝóáõÙ Çñ Ñ³ßÇíÝ»ñáí' and fECOM = 'Fin. Institution Own Transfer'" & _
                                            " and fDCBRANCH = '' and fDCDEPART = '' and fSPEC ='"& TransfersForItsAcc.cliCode &"77700000010201  7770010330030101        10000.00001Ð³ëï³ïí³Í             77Ð³ñÏ»ñÇ Ù³ñáõÙ                  123Ð '" 
                  sqlValue = 1
                  colNum = 0
                  sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
                  If Not sql_isEqual Then
                    Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
                  End If

                  
                  'DOCLOG
                  queryString = " SELECT COUNT(*) FROM DOCLOG WHERE fISN = " & TransfersForItsAcc.fISN 
                  sqlValue = 13
                  colNum = 0
                  sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
                  If Not sql_isEqual Then
                    Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
                  End If
                  
                  'PAYMENTS
                  queryString = " SELECT COUNT(*) FROM PAYMENTS WHERE fISN = " & TransfersForItsAcc.fISN & _
                                            " and fDOCTYPE = 'FinTrans' and fCUR = '001' and fSUMMA = '10000.00'" & _
                                            " and fSUMMAAMD = '4000000.00' and fSUMMAUSD = '10000.00' and fCOM = 'Ð³ñÏ»ñÇ Ù³ñáõÙ'" & _
                                            " and fCHARGESUM = '0.00' and fCHARGESUMAMD = '0.00' and fCHARGESUM2 = '0.00'"
                  sqlValue = 1
                  colNum = 0
                  sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
                  If Not sql_isEqual Then
                    Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
                  End If
                  
                  'HI
                  queryString = " SELECT COUNT(*) FROM HI WHERE fBASE = " & TransfersForItsAcc.fISN & _
                                            " and fTYPE = '01' and fSUM = '4000000.00' and fCUR = '001' and fOP = 'TRF' " & _
                                            " and fCURSUM = '10000.00'" & _
                                            " and ((fDBCR = 'D' and fSPEC = '"& TransfersForItsAcc.cliCode &"                   Ð³ñÏ»ñÇ Ù³ñáõÙ                    0   400.0000    1' )" & _
                                            " or (fSPEC = '"& TransfersForItsAcc.cliCode &"                   Ð³ñÏ»ñÇ Ù³ñáõÙ                    1   400.0000    1'  and fDBCR = 'C'))"
                  sqlValue = 2
                  colNum = 0
                  sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
                  If Not sql_isEqual Then
                    Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
                  End If
      
      ' Մուտք Ուղարկվող միջթղթակցային փոխանցումենր թղթապանակ
      Set SendingTransfersForIts = New_SendingTransfersForIts()
      With SendingTransfersForIts
              .folderDirect = "|²ñï³ùÇÝ ÷áË³ÝóáõÙÝ»ñÇ ²Þî|ÂÕÃ³å³Ý³ÏÝ»ñ|àõÕ³ñÏíáÕ Ñ³ÝÓÝ³ñ³ñ³·ñ»ñ|àõÕ³ñÏíáÕ ÙÇçÃÕÃ³Ïó³ÛÇÝ ÷áË³ÝóáõÙÝ»ñ"
              .stDate = todayDMY
              .eDate = todayDMY
              .wUser = "77"
              .wCur = "001"
              .packNum = "123"
              .paySysin = "Ð"
              .selectView = "FinOuts"
              .exportExcel = "0"
      End With
      
      Call Fill_SendingTransfersForIts(SendingTransfersForIts)
      
      ' Մարել վճարման հանձնարարագիրը
      state = ConfirmContractDoc(2, TransfersForItsAcc.cliCode, c_ToFade, 5, "²Ûá")
      If state Then
      
            If wMDIClient.WaitVBObject("frmASDocForm", 2000).Exists Then
                  Call GroupReminderOrdersVer(grRemOrdISN, grRemOrdNum, todayDMY)
             Else
                  Log.Error("Մարում պատուհանը չի բացվել") 
             End If
      Else
            Log.Error("Մարել գործողություն չի կատարվել")
      End If
      frmPttel.Close
      
                 'DOCS
                  queryString = " SELECT COUNT(*) FROM DOCS WHERE fISN = " & TransfersForItsAcc.fISN & _
                                            " and fNAME = 'FinTrans' and fSTATE = '5'"
                  sqlValue = 1
                  colNum = 0
                  sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
                  If Not sql_isEqual Then
                    Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
                  End If
                  
                  'FOLDERS
                  queryString = " SELECT COUNT(*) FROM FOLDERS WHERE fISN = " & TransfersForItsAcc.fISN 
                  sqlValue = 0
                  colNum = 0
                  sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
                  If Not sql_isEqual Then
                    Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
                  End If

                  'DOCLOG
                  queryString = " SELECT COUNT(*) FROM DOCLOG WHERE fISN = " & TransfersForItsAcc.fISN 
                  sqlValue = 15
                  colNum = 0
                  sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
                  If Not sql_isEqual Then
                    Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
                  End If
                  
                  'PAYMENTS
                  queryString = " SELECT COUNT(*) FROM PAYMENTS WHERE fISN = " & TransfersForItsAcc.fISN & _
                                            " and fDOCTYPE = 'FinTrans' and fCUR = '001' and fSUMMA = '10000.00'" & _
                                            " and fSUMMAAMD = '4000000.00' and fSUMMAUSD = '10000.00' and fCOM = 'Ð³ñÏ»ñÇ Ù³ñáõÙ'" & _
                                            " and fCHARGESUM = '0.00' and fCHARGESUMAMD = '0.00' and fCHARGESUM2 = '0.00'"
                  sqlValue = 1
                  colNum = 0
                  sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
                  If Not sql_isEqual Then
                    Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
                  End If
                  
                  'HI
                  queryString = " SELECT COUNT(*) FROM HI WHERE fBASE = " & grRemOrdISN & _
                                            " and fTYPE = '01' and fSUM = '4000000.00' and fCUR = '001' and fOP = 'QIT'  and fCURSUM = '10000.00'" & _
                                            " and ((fDBCR = 'D' and fSPEC = '"& grRemOrdNum &"                   Ð³ñÏ»ñÇ Ù³ñáõÙ                    0   400.0000    1' )" & _
                                            " or (fSPEC = '"& grRemOrdNum &"                   Ð³ñÏ»ñÇ Ù³ñáõÙ                    1   400.0000    1'  and fDBCR = 'C'))"
                  sqlValue = 2
                  colNum = 0
                  sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
                  If Not sql_isEqual Then
                    Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
                  End If
                  
                  'MEMORDERS
                  queryString = " SELECT COUNT(*) FROM MEMORDERS WHERE fISN = " & grRemOrdISN & _
                                            " and fDOCTYPE = 'CmMOrdPk' and fSTATE = '5' and fSUMMA = '0.00' and fDOCNUM = '"& grRemOrdNum &"' "
                  sqlValue = 1
                  colNum = 0
                  sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
                  If Not sql_isEqual Then
                    Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
                  End If
      
      ' Մուտք "Հաշվառված ատացված փոխանցումներ" թղթապանակ
      Set AccForTransfers = New_AccForTransfers()
      With AccForTransfers
              .folderDirect = "|²ñï³ùÇÝ ÷áË³ÝóáõÙÝ»ñÇ ²Þî|ÂÕÃ³å³Ý³ÏÝ»ñ|Ð³ßí³éí³Í áõÕ³ñÏí³Í ÷áË³ÝóáõÙÝ»ñ"
              .stDate = todayDMY
              .eDate = todayDMY
              .wUser = "77"
              .docType = "FinTrans"
              .acsBranch = "00"
              .acsDepart = "1"
      End With
      
      Call Fill_AccForTransfers(AccForTransfers)
      
      state = CheckContractDoc(2, TransfersForItsAcc.cliCode)
      
      If Not state Then
            Log.Error("Փաստաթուղթն առկա չէ 'Ուղարկված փոխանցումներ' թղթապանակում")
      End If
      
      frmPttel.Close
      
      ' Փակել ՀԾ-Բանկ ծրագիրը
      Call Close_AsBank()  
      
End Sub