Option Explicit
'USEUNIT Library_Common
'USEUNIT Contract_Summary_Report_Library

'Test Case N 165042          
                       
Sub Contract_Summary_Report_Credit_Check_Rows_Test()
  BuiltIn.Delay(20000)

  Dim startDATE, fDATE, Date, cont_date
  
  Date = "201211"
  cont_date = "111111"                                       
  Utilities.ShortDateFormat = "yyyymmdd"
  startDATE = "20030101"
  fDATE = "20250101"
  
  'Test StartUp 
  Call Initialize_AsBank("bank", startDATE, fDATE)
  Login ("CREDITOPERATOR")
  Call wTreeView.DblClickItem("|ì³ñÏ»ñ (ï»Õ³µ³ßËí³Í)|ä³ÛÙ³Ý³·ñ»ñÇ ³Ù÷á÷áõÙ")
  
  Call Contract_Sammary_Report_Fill(Date, Null, Null, Null, Null, Null, Null, Null, _
                                      Null, Null, Null, Null, Null, Null, Null, _
                                      Null, Null, Null, Null, Null, Null, Null, False, False, _
                                      Null, False, False, False, _
                                      True, True, True, True, True, _
                                      True, True, True, True, True, True, _
                                      True, True, True, True, True, True, True,1)
    
  BuiltIn.Delay(150000)                              
        
  '¶áõÙ³ñ ëÛ³Ý ëïáõ·áõÙ
  Call Compare_ColumnFooterVlaue("frmPttel", "FAGRSUM", "2,491,777,235.61")
  'Ä³ÙÏ»ï³Ýó ·áõÙ³ñ ëÛ³Ý ëïáõ·áõÙ
  Call Compare_ColumnFooterVlaue("frmPttel", "FAGRSUMJ", "2,458,957,278.61")
  '¸áõñë ·ñí³Í ·áõÙ³ñ ëÛ³Ý ëïáõ·áõÙ
  Call Compare_ColumnFooterVlaue("frmPttel", "FAGROUTSUM", "4,493,000.00")
  'îáÏáë ëÛ³Ý ëïáõ·áõÙ
  Call Compare_ColumnFooterVlaue("frmPttel", "FPERSUM", "310,574,432.97")
  '²ñ¹ÛáõÝ³í»ï îáÏáë ëÛ³Ý ëïáõ·áõÙ
  Call Compare_ColumnFooterVlaue("frmPttel", "FEFFINC", "14,218.23")
  'âû·ï. Ù³ëÇ ïáÏáë ëÛ³Ý ëïáõ·áõÙ
  Call Compare_ColumnFooterVlaue("frmPttel", "FPERSUMNOCH", "108,452,088.83")
  'Ä³ÙÏ»ï³Ýó ãû·ï. Ù³ëÇ ïáÏáë ëÛ³Ý ëïáõ·áõÙ
  Call Compare_ColumnFooterVlaue("frmPttel", "FPERSUMNOCHJ", "1,749,823.90")
  'âí³ëï³Ï³Í ïáÏáë ëÛ³Ý ëïáõ·áõÙ
  Call Compare_ColumnFooterVlaue("frmPttel", "FPERSUMFUTUR", "294,507.44")
  'Ä³ÙÏ»Ý³ó ïáÏáë ëÛ³Ý ëïáõ·áõÙ
  Call Compare_ColumnFooterVlaue("frmPttel", "FPERSUMJ", "258,558,588.97")
  '¸áõñë ·ñí³Í ïáÏáë ëÛ³Ý ëïáõ·áõÙ
  Call Compare_ColumnFooterVlaue("frmPttel", "FPEROUTSUM", "366,780.13")
  '´îÐ¸ ïáÏ. ëÛ³Ý ëïáõ·áõÙ
  Call Compare_ColumnFooterVlaue("frmPttel", "FREFINSUM", "706,070,626.05")
  '¸.·. ´îÐ¸ ëÛ³Ý ëïáõ·áõÙ
  Call Compare_ColumnFooterVlaue("frmPttel", "FREFINOUTSUM", "1,286,861.08")
  'Ä³ÙÏ»ï³Ýó ·áõÙ³ñ ïáõÛÅ ëÛ³Ý ëïáõ·áõÙ
  Call Compare_ColumnFooterVlaue("frmPttel", "FPENSUM", "3,862,106,026.84")
  'Ä³ÙÏ»ï³Ýó ïáÏáëÇ ïáõÛÅ ëÛ³Ý ëïáõ·áõÙ
  Call Compare_ColumnFooterVlaue("frmPttel", "FPENSUM2", "455,605,106.68")
  '¸áõñë ·ñí³Í ïáõÛÅ ëÛ³Ý ëïáõ·áõÙ
  Call Compare_ColumnFooterVlaue("frmPttel", "FPENOUTSUM", "3,746,642.13")
  '¸áõñë ·ñí³Í ïáÏ. ïáõÛÅ ëÛ³Ý ëïáõ·áõÙ
  Call Compare_ColumnFooterVlaue("frmPttel", "FPENOUTSUM2", "1,229,821.23")
  'Ä³ÙÏ»ï³Ýó ·áõÙ³ñÇ ïáÏáë ëÛ³Ý ëïáõ·áõÙ
  Call Compare_ColumnFooterVlaue("frmPttel", "FLOSSSUM", "375,530.94")
  '¸.·. Å³ÙÏ. ·.ïÏ. ëÛ³Ý ëïáõ·áõÙ
  Call Compare_ColumnFooterVlaue("frmPttel", "FLOSSOUTSUM", "375,496.74")
  '¶ñ³íÇ ³ñÅ»ùÁ ëÛ³Ý ëïáõ·áõÙ
  Call Compare_ColumnFooterVlaue("frmPttel", "FMORTGAGESUM", "44,588,125.00")
  'ºñ³ßË³íáñáõÃÛ³Ý ³ñÅ»ù ëÛ³Ý ëïáõ·áõÙ
  Call Compare_ColumnFooterVlaue("frmPttel", "FGUARSUM", "2,002,100,000.00")
  'ä³Ñáõëï³íáñí³Í ·áõÙ³ñ ëÛ³Ý ëïáõ·áõÙ
  Call Compare_ColumnFooterVlaue("frmPttel", "FAGRSUM", "2,491,777,235.61")
  'ê³Ñ³Ù³Ý³ã³÷ ëÛ³Ý ëïáõ·áõÙ
  Call Compare_ColumnFooterVlaue("frmPttel", "FAGRLIMIT", "2,376,933,172.00")
  'âû·ï. Ù³ë ëÛ³Ý ëïáõ·áõÙ
  Call Compare_ColumnFooterVlaue("frmPttel", "FAGRUNUSE", "131,625,892.40")
  'ä³ÛÙ³Ý³·ñÇ ·áõÙ³ñ ëÛ³Ý ëïáõ·áõÙ
  Call Compare_ColumnFooterVlaue("frmPttel", "FSUMMA", "2,975,147,672.00")
  'Ü»ñÏ³ ³ñÅ»ù 
  Call Compare_ColumnFooterVlaue("frmPttel", "FPRESVALUE", "7,933,042,586.95")

  Call wMainForm.MainMenu.Click("Դիտում |CreditFilter")
  BuiltIn.Delay(1000)

  'Test CleanUp 
  Call Close_AsBank()
End Sub