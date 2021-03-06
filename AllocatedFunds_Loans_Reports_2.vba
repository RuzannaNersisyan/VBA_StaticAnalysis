'USEUNIT Subsystems_SQL_Library
'USEUNIT Library_Common
'USEUNIT Library_Contracts
'USEUNIT Constants
'USEUNIT Library_Colour
'USEUNIT OLAP_Library
'USEUNIT SWIFT_International_Payorder_Library
Option Explicit

'Test case ID 161817
'Test case ID 161850

Dim folderName, sDATE, fDATE, colName(5), param
Dim riskIndicatorChanges, objectiveRiskIndicator, contractRapayDates, repaymnetDates, creditLine
Dim actualFile1, actualFile2, actualFile3, actualFile4, actualFile5
Dim expectedFile1, expectedFile2, expectedFile3, expectedFile4, expectedFile5
Dim resultFile1, resultFile2, resultFile3, resultFile4, resultFile5

Sub AllocatedFunds_Loans_Reports_2(rowLimit)
		' ºÝÃ³Ñ³Ù³Ï³ñ·»ñ (§ÐÌ¦)|ä³ÛÙ³Ý³·ñ»ñ|î»Õ³µ³ßËí³Í ÙÇçáóÝ»ñ|ì³ñÏ»ñ (î»Õ³µ³ßËí³Í)
		Call Test_Initialize()

		' Համակարգ մուտք գործել ARMSOFT օգտագործողով
		Log.Message "Համակարգ մուտք գործել ARMSOFT օգտագործողով", "", pmNormal, DivideColor
  Call Test_StartUp(rowLimit) 
		
		'''''''''''''''''''''''''''''''''''''''''''''''''
		''''''è.¹³ë. ¨ å³Ñáõëï.ïáÏ. ÷á÷áËáõÃÛáõÝÝ»ñ''''''
		
		' Լրացնել Ռ. դաս. և պահուստ. տոկ. փոփոխություններ դիալոգային պատուհանը
		Log.Message "Ռ. դաս. և պահուստ. տոկ. փոփոխություններ", "", pmNormal, DivideColor
		Call GoTo_AgreementsCommomFilter(folderName & "èÇëÏ³ÛÝáõÃÛáõÝ|", "è.¹³ë. ¨ å³Ñáõëï.ïáÏ. ÷á÷áËáõÃÛáõÝÝ»ñ", riskIndicatorChanges)
		
		if WaitForExecutionProgress() then		
				' êáñï³íáñ»É µ³óí³Í åïï»ÉÁ
				Call columnSorting(colName, 4, "frmPttel")
				' Արտահանել Excel
				Call ExportToExcel("frmPttel", actualFile1)
				' Ստուգել տողերի քանակը
				Call CheckPttel_RowCount("frmPttel", 20460)
				' Համեմատել Excel ֆայլերը
				Call CompareTwoExcelFiles(actualFile1, expectedFile1, resultFile1)
				' ö³Ï»É բոլոր Excel ֆայլերը
				Call CloseAllExcelFiles()
				' ö³Ï»É åïï»ÉÁ
				BuiltIn.Delay(3000) 
		  wMDIClient.VBObject("frmPttel").Close
		else																																	
						Log.Error "Can't open pttel window.", "", pmNormal, ErrorColor
		end if
		
		'''''''''''''''''''''''''''''''''''''''''''''''''
		''''''úµÛ»ÏïÇí éÇëÏÇ ¹³ëÇãÇ ÷á÷áËáõÃÛáõÝÝ»ñ''''''
		
		' Լրացնել Օբյեկտիվ ռիսկի դասիչի փոփոխություններ դիալոգային պատուհանը
		Log.Message "Օբյեկտիվ ռիսկի դասիչի փոփոխություններ", "", pmNormal, DivideColor
		Call GoTo_AgreementsCommomFilter(folderName & "èÇëÏ³ÛÝáõÃÛáõÝ|", "úµÛ»ÏïÇí éÇëÏÇ ¹³ëÇãÇ ÷á÷áËáõÃÛáõÝÝ»ñ", objectiveRiskIndicator)
		
		if WaitForExecutionProgress() then	
				' êáñï³íáñ»É µ³óí³Í åïï»ÉÁ
				Call columnSorting(colName, 4, "frmPttel")	
				' Արտահանել, որպես txt ֆայլ
				Call ExportToTXTFromPttel("frmPttel", actualFile2)
				' Ստուգել տողերի քանակը
				Call CheckPttel_RowCount("frmPttel", 2)
				' Համեմատել txt ֆայլերը
				Call Compare_Files(actualFile2, expectedFile2, param)
				' ö³Ï»É åïï»ÉÁ
				BuiltIn.Delay(3000) 
		  wMDIClient.VBObject("frmPttel").Close
		else																																	
						Log.Error "Can't open pttel window.", "", pmNormal, ErrorColor
		end if
		
		'''''''''''''''''''''''''''''''''''''''''''''''''
		''''ä³ÛÙ.Ù³ñÙ³Ý(í»ñ³ýÇÝ³Ýë³íáñÙ³Ý) Å³ÙÏ»ïÝ»ñ'''''
		
		' Լրացնել Պայմ. մարման(վերաֆինանսավորման) ժամկետներ դիալոգային պատուհանը
		Log.Message "Պայմ. մարման(վերաֆինանսավորման) ժամկետներ", "", pmNormal, DivideColor
		Call GoTo_AgreementsCommomFilter(folderName & "Ä³ÙÏ»ïÝ»ñ|", "ä³ÛÙ.Ù³ñÙ³Ý(í»ñ³ýÇÝ³Ýë³íáñÙ³Ý) Å³ÙÏ»ïÝ»ñ", contractRapayDates)
		
		if WaitForExecutionProgress() then		
				' êáñï³íáñ»É µ³óí³Í åïï»ÉÁ
				Call columnSorting(colName, 4, "frmPttel")
				' Արտահանել Excel
				Call ExportToExcel("frmPttel", actualFile3)
				' Ստուգել տողերի քանակը
				Call CheckPttel_RowCount("frmPttel", 19537)
				' Համեմատել Excel ֆայլերը
				Call CompareTwoExcelFiles(actualFile3, expectedFile3, resultFile3)
				' ö³Ï»É բոլոր Excel ֆայլերը
				Call CloseAllExcelFiles() 
				' ö³Ï»É åïï»ÉÁ
				BuiltIn.Delay(3000)
		  wMDIClient.VBObject("frmPttel").Close
		else																																	
						Log.Error "Can't open pttel window.", "", pmNormal, ErrorColor
		end if
		
		'''''''''''''''''''''''''''''''''''''''''''''''''
		''''''''''''îáÏáëÝ»ñÇ Ù³ñÙ³Ý Å³ÙÏ»ïÝ»ñ'''''''''''
		
		' Լրացնել Տոկոսների մարման ժամկետներ դիալոգային պատուհանը
		Log.Message "Տոկոսների մարման ժամկետներ", "", pmNormal, DivideColor
		Call GoTo_AgreementsCommomFilter(folderName & "Ä³ÙÏ»ïÝ»ñ|", "îáÏáëÝ»ñÇ Ù³ñÙ³Ý Å³ÙÏ»ïÝ»ñ", repaymnetDates)
		
		if WaitForExecutionProgress() then		
				' êáñï³íáñ»É µ³óí³Í åïï»ÉÁ
				Call columnSorting(colName, 4, "frmPttel")
				' Արտահանել Excel
				Call ExportToExcel("frmPttel", actualFile4)
				' Ստուգել տողերի քանակը
				Call CheckPttel_RowCount("frmPttel", 69)
				' Համեմատել Excel ֆայլերը
				Call CompareTwoExcelFiles(actualFile4, expectedFile4, resultFile4)
				' ö³Ï»É բոլոր Excel ֆայլերը
				Call CloseAllExcelFiles()
				' ö³Ï»É åïï»ÉÁ
				BuiltIn.Delay(3000) 
		  wMDIClient.VBObject("frmPttel").Close
		else																																	
						Log.Error "Can't open pttel window.", "", pmNormal, ErrorColor
		end if
		
		'''''''''''''''''''''''''''''''''''''''''''''''''
		'''''''''ì³ñÏ³ÛÇÝ ·ÍÇ ·áñÍ»Éáõ Å³ÙÏ»ïÝ»ñ'''''''''
		
		' Լրացնել Վարկային գծի գործելու ժամկետներ դիալոգային պատուհանը
		Log.Message "Վարկային գծի գործելու ժամկետներ", "", pmNormal, DivideColor
		Call GoTo_AgreementsCommomFilter(folderName & "Ä³ÙÏ»ïÝ»ñ|", "ì³ñÏ³ÛÇÝ ·ÍÇ ·áñÍ»Éáõ Å³ÙÏ»ïÝ»ñ", creditLine)
		
		if WaitForExecutionProgress() then		
				' êáñï³íáñ»É µ³óí³Í åïï»ÉÁ
				Call columnSorting(colName, 4, "frmPttel")
				' Արտահանել, որպես txt ֆայլ
				Call ExportToTXTFromPttel("frmPttel", actualFile5)
				' Ստուգել տողերի քանակը
				Call CheckPttel_RowCount("frmPttel", 5)
				' Համեմատել txt ֆայլերը
				Call Compare_Files(actualFile5, expectedFile5, param)
				' ö³Ï»É åïï»ÉÁ
				BuiltIn.Delay(3000) 
		  wMDIClient.VBObject("frmPttel").Close
		else																																	
						Log.Error "Can't open pttel window.", "", pmNormal, ErrorColor
		end if
		
		Call Close_AsBank()		
End	Sub

Sub Test_StartUp(rowLimit)
		Call Initialize_AsBank("bank_Report", sDATE, fDATE)
  Login("ARMSOFT")
		Call SaveRAM_RowsLimit(rowLimit)
		Call ChangeWorkspace(c_Subsystems)
End	Sub

Sub Test_Initialize()
		folderName = "|ºÝÃ³Ñ³Ù³Ï³ñ·»ñ (§ÐÌ¦)|ä³ÛÙ³Ý³·ñ»ñ|î»Õ³µ³ßËí³Í ÙÇçáóÝ»ñ|ì³ñÏ»ñ (ï»Õ³µ³ßËí³Í)|¶áñÍáÕáõÃÛáõÝÝ»ñ, ÷á÷áËáõÃÛáõÝÝ»ñ|"
	
		sDATE = "20030101"
		fDATE = "20260101"  
		
		colName(0) = "fKEY"
		colName(3) = "fCOM"
		colName(1) = "fDATE"
		colName(2) = "fSUID"
		
		' è.¹³ë. ¨ å³Ñáõëï.ïáÏ. ÷á÷áËáõÃÛáõÝÝ»ñ
		expectedFile1 = Project.Path & "Stores\Reports\Subsystems\Allocated Funds\LoansTest2\Expected\expectedFile1.xlsx"
		' úµÛ»ÏïÇí éÇëÏÇ ¹³ëÇãÇ ÷á÷áËáõÃÛáõÝÝ»ñ
		expectedFile2 = Project.Path & "Stores\Reports\Subsystems\Allocated Funds\LoansTest2\Expected\expectedFile2.txt"
		' ä³ÛÙ.Ù³ñÙ³Ý(í»ñ³ýÇÝ³Ýë³íáñÙ³Ý) Å³ÙÏ»ïÝ»ñ
		expectedFile3 = Project.Path & "Stores\Reports\Subsystems\Allocated Funds\LoansTest2\Expected\expectedFile3.xlsx"
		' îáÏáëÝ»ñÇ Ù³ñÙ³Ý Å³ÙÏ»ïÝ»ñ
		expectedFile4 = Project.Path & "Stores\Reports\Subsystems\Allocated Funds\LoansTest2\Expected\expectedFile4.xlsx"
		' ì³ñÏ³ÛÇÝ ·ÍÇ ·áñÍ»Éáõ Å³ÙÏ»ïÝ»ñ
		expectedFile5 = Project.Path & "Stores\Reports\Subsystems\Allocated Funds\LoansTest2\Expected\expectedFile5.txt"
	
  ' è.¹³ë. ¨ å³Ñáõëï.ïáÏ. ÷á÷áËáõÃÛáõÝÝ»ñ
		actualFile1 = Project.Path & "Stores\Reports\Subsystems\Allocated Funds\LoansTest2\Actual\actualFile1.xlsx"
		' úµÛ»ÏïÇí éÇëÏÇ ¹³ëÇãÇ ÷á÷áËáõÃÛáõÝÝ»ñ
		actualFile2 = Project.Path & "Stores\Reports\Subsystems\Allocated Funds\LoansTest2\Actual\actualFile2.txt"
		' ä³ÛÙ.Ù³ñÙ³Ý(í»ñ³ýÇÝ³Ýë³íáñÙ³Ý) Å³ÙÏ»ïÝ»ñ
		actualFile3 = Project.Path & "Stores\Reports\Subsystems\Allocated Funds\LoansTest2\Actual\actualFile3.xlsx"
		' îáÏáëÝ»ñÇ Ù³ñÙ³Ý Å³ÙÏ»ïÝ»ñ
		actualFile4 = Project.Path & "Stores\Reports\Subsystems\Allocated Funds\LoansTest2\Actual\actualFile4.xlsx"
		' ì³ñÏ³ÛÇÝ ·ÍÇ ·áñÍ»Éáõ Å³ÙÏ»ïÝ»ñ
		actualFile5 = Project.Path & "Stores\Reports\Subsystems\Allocated Funds\LoansTest2\Actual\actualFile5.txt"
		
  ' è.¹³ë. ¨ å³Ñáõëï.ïáÏ. ÷á÷áËáõÃÛáõÝÝ»ñ
		resultFile1 = Project.Path & "Stores\Reports\Subsystems\Allocated Funds\LoansTest2\Result\resultFile1.xlsx"
		' ä³ÛÙ.Ù³ñÙ³Ý(í»ñ³ýÇÝ³Ýë³íáñÙ³Ý) Å³ÙÏ»ïÝ»ñ
		resultFile3 = Project.Path & "Stores\Reports\Subsystems\Allocated Funds\LoansTest2\Result\resultFile3.xlsx"
		' îáÏáëÝ»ñÇ Ù³ñÙ³Ý Å³ÙÏ»ïÝ»ñ
		resultFile4 = Project.Path & "Stores\Reports\Subsystems\Allocated Funds\LoansTest2\Result\resultFile4.xlsx"
		
  ' è.¹³ë. ¨ å³Ñáõëï.ïáÏ. ÷á÷áËáõÃÛáõÝÝ»ñ
		Set riskIndicatorChanges = New_AgreementsCommomFilter()
		with riskIndicatorChanges
				.onlyChangesExists = true
		end with
		
		' úµÛ»ÏïÇí éÇëÏÇ ¹³ëÇãÇ ÷á÷áËáõÃÛáõÝÝ»ñ
		Set objectiveRiskIndicator = New_AgreementsCommomFilter()
		with objectiveRiskIndicator
				.startDate = "31/12/13"
				.endDate = "28/02/14"
				.agreeN = "TV9228"
				.note3 = "03"
				.agreeOffice = "P01"
				.agreeSection = "05"
				.accessType = "C11"
				.onlyChangesExists = true
				.onlyChanges = 1
		end with
		
		' ä³ÛÙ.Ù³ñÙ³Ý(í»ñ³ýÇÝ³Ýë³íáñÙ³Ý) Å³ÙÏ»ïÝ»ñ
		Set contractRapayDates = New_AgreementsCommomFilter()
		with contractRapayDates
				.onlyChangesExists = true
				.onlyChanges = 1
				.showInOpFormExists = true
				.showInOpForm = 1
				.scheduleTypeExists = true
				.extensionExists = true
		end with
		
		' îáÏáëÝ»ñÇ Ù³ñÙ³Ý Å³ÙÏ»ïÝ»ñ
		Set repaymnetDates = New_AgreementsCommomFilter()
		with repaymnetDates
				.startDate = "30/01/11"
				.agreeN = "TV9166"
				.note = "04"
				.agreeSection = "05"
				.onlyChangesExists = true
				.onlyChanges = 1
				.showInOpFormExists = true
				.scheduleTypeExists = true
				.extensionExists = true
				.extension = "0"
		end with
		
		' ì³ñÏ³ÛÇÝ ·ÍÇ ·áñÍ»Éáõ Å³ÙÏ»ïÝ»ñ
		Set creditLine = New_AgreementsCommomFilter()
		with creditLine
				.startDate = "24/07/12"
				.note = "002"
				.accessType = "C11"
				.onlyChangesExists = true
		end with
		
End Sub