Option Explicit
'USEUNIT  Clients_Library
'USEUNIT Subsystems_SQL_Library
'USEUNIT  Library_Common
'USEUNIT Constants
'USEUNIT BankMail_Library
'USEUNIT Acc_Statements_Library
'USEUNIT  Payment_Except_Library
'USEUNIT  SWIFT_International_Payorder_Library
'USEUNIT  Payment_Order_ConfirmPhases_Library
'USEUNIT BankMail_Library
'USEUNIT SWIFT_International_Payorder_Library
'USEUNIT Attach_File_Library

' Test Case 128031

Sub Attach_File_Where_Database_Is_On_Another_Server()

      Dim windName, colN, docNum, action, doNum, doActio
      Dim wDocType, attachments, state, frmPttel
      Dim fISN, department, docNumber, wDate, accDeb, accCred, cur1, cur2, summa1, aim, ptype, clientCode, clientName, filePathName, _
              creatFileName, sameFileName, saveAs, saveAsName, filePathName1, filePathName2, fileName, fileName1
      Dim fDATE, sDATE, paramName, paramValue, fileCount

      fDATE = "20250101"
      sDATE = "20120101"
      Call Initialize_AsBank("bank", sDATE, fDATE)
      
      ' Մուտք գործել համակարգ ARMSOFT օգտագործողով 
      Call Create_Connection()
      Login("ARMSOFT")
      
      ' Մուտք ադմինիստրատորի ԱՇՏ 4.0
      Call ChangeWorkspace(c_Admin40)

      ' DOCSATTACHSERVERDB պարամետրի արժեքի ճշգրտում   
      paramName = "DOCSATTACHSERVERDB"
      paramValue = "[QASQLENT].bankTesting_Sona_attachment"
      Call  SetParameter(paramName, paramValue)
      
      ' Մուտք ադմինիստրատորի ԱՇՏ 4.0
      Call ChangeWorkspace(c_Admin40)
      Call wTreeView.DblClickItem("|²¹ÙÇÝÇëïñ³ïáñÇ ²Þî 4.0|Ð³Ù³Ï³ñ·³ÛÇÝ ³ßË³ï³ÝùÝ»ñ|Ð³Ù³Ï³ñ·³ÛÇÝ ÝÏ³ñ³·ñáõÃÛáõÝÝ»ñ|Ð³Ù³Ï³ñ·³ÛÇÝ ÝÏ³ñ³·ñáõÃÛáõÝÝ»ñÇ ÁÝ¹É³ÛÝáõÙÝ»ñ|ö³ëï³ÃÕÃ»ñÇ ÁÝ¹É³ÛÝáõÙÝ»ñ")
      
      ' Ջնջել Արտարժույթի փոխանակում փաստաթուղթը Փաստաթղթերի ընդլայնում թղթապանակից 
      windName = "frmPttel"
      colN = 0
      docNum = "CurChng"
      action = c_Delete
      doNum = 3
      doActio = "²Ûá"
      state = ActionWithDocument(windName, colN, docNum, action, doNum, doActio)
      
      If state Then
            Log.Message("Փաստաթղթի ընդլայնում փաստաթուղթը ջնջվել է") 
      End If
      
      ' Ստեղծել Արտարժույթի փոխանակում փաստաթղթի ընդլայնում
      wDocType = "CurChng"
      attachments = 1
      Call CreateDocumentExtension(wDocType, attachments)
      
      Set frmPttel = Sys.Process("Asbank").VBObject("MainForm").Window("MDIClient", "", 1).VBObject("frmPttel")
      frmPttel.Close
      
      Login("ARMSOFT")
      
      ' Ջնջել \\host2\Sys\Testing\ClientsTest  թղթապանակից 
      aqFileSystem.DeleteFile("\\host2\Sys\Testing\ClientsTest\ForTest1.txt")
      
      wDate = aqConvert.DateTimeToFormatStr(aqDateTime.Today(), "%d/%m/%y")
      cur1 = "000"
      cur2 = "001"
      summa1 = "500"
      aim = "Fot Test"
      filePathName = "\\host2\Sys\Testing\ClientsTest\ForTest.txt"
      filePathName1 = "\\host2\Sys\Testing\ClientsTest\ASDoc.doc"
      filePathName2 = "\\host2\Sys\Testing\ClientsTest\Capture.PNG"
      creatFileName = "C:\Users\"& Sys.UserName & "\AppData\Local\Temp\AS-BANK\ATTACHMENTS\"
      fileName = "ForTest.txt"
      fileName1 = "ASDoc.doc"
      saveAs = "\\host2\Sys\Testing\ClientsTest\ForTest1.txt"
      sameFileName = "\\host2\Sys\Testing\Attach\ForTest.txt"
      
      ' Մուտք ադմինիստրատորի ԱՇՏ 4.0
      Call ChangeWorkspace(c_Admin40)
      
      ' Արտարժույթի փոխանակում փաստաթղթի ստեղծում
      Call CheckAttachedAction(fISN, department, docNumber, wDate, accDeb, accCred, cur1, cur2, summa1, aim, ptype, clientCode, clientName, filePathName, _
                                                         creatFileName, sameFileName, saveAs, filePathName1, fileName, fileName1 )
          
      log.Message(fISN)
      
      ' Կցված ֆայլի առկայության ստուգում կցված ֆայլեր թղթապանակում
      fileCount = "1"
      Call CheckAttachedFilesFromAttachFileDoc(docNum, wDate, wDate, fISN, fileCount)
      
      frmPttel.Close
      
      ' Փակել ՀԾ-Բանկ ծրագիրը
      Call Close_AsBank

End Sub