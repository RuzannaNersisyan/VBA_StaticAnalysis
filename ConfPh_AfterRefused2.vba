'USEUNIT Library 
'USEUNIT Library_Initialise
'USEUNIT Library_CheckDB

' ä³ÛÙ³Ý³·ñÇ ä³Ñí³ÍùÇ ëïáõ·áõÙ Ù»ñÅáõÙÇó Ñ»ïá

Sub ConfPh_AfterRefused2()
  Const confPath = "X:\Testing\CONFIRM PHASES\simple_confirmers.txt"
  Dim Is_ex
  Dim DocN
  Dim operation
  operation = True
     
 ' Delete confirmers table 
  DeleteRecords_DOCS ("C5VAGRCR") 
  DeleteRecords_FOLDERS ("C5VAGRCR") 
  
  Log.Message("Without_Confirmers_Tbl Test started")
  Call Initialize_AsBank("bank", startDATE, fDATE)
 ' Create confirmers table 
  Call Call_Function ("Util", "ImportFiles", confPath)   
  Login("MMJPOPERATOR")
 ' Document creation
  Call MMJPContractCreator(payerCode,lenderCode,temlateType,curCode,sum,branchCode, _ 
                            state ,contractID,,note,note2,note3fBASE,sDOCNUM)
                     
  DocN = sDOCNUM                                   
  Call SendToConfirm(DocN)
  Login ("VERIFIERS")
  Call Confirm(operation,"I",DocN) 
  operation = False
  Call Confirm(operation,"II",DocN)
  Login ("VERIFIERS")
  Is_ex = Is_Exists_Confirmer(DocN,"III")
  If Is_ex Then
    Log.Error("After Refused by (II)COnfirmer ducument  must not be in selected(III) confirmers Confirm Pepers folder")
  End If
  Login("MMJPOPERATOR")
  Is_ex = Is_Exists_WorkPapers(DocN)
  If Is_ex = FALSE Then    
    Log.Error("After refused document must returned into the WorkPapers")
  Else    
    If Is_Exisis_Agreements(DocN) Then
      Log.Error("After Refused document must not be in the Agreements.")
    End If  
  End If
  Call Close_AsBank()   
End Sub
