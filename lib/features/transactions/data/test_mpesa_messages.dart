/// A collection of real M-Pesa SMS messages for testing the parser.
class TestMpesaMessages {
  /// Money received message with phone number
  static const String moneyInWithPhone = '''
TFB6F1QLYE Confirmed.You have received Ksh150.00 from SLYVIA  MUTISYA 0705657335 on 11/6/25 at 11:10 AM  New M-PESA balance is Ksh11,767.02. Earn interest daily on Ziidi MMF,Dial *334#''';

  /// Money received from business account
  static const String moneyInFromBusiness = '''
TF74UYCQX4 Confirmed.You have received Ksh50,000.00 from Equity Bulk Account 300600 on 7/6/25 at 10:26 AM New M-PESA balance is Ksh50,000.00.  Separate personal and business funds through Pochi la Biashara on *334#.''';

  /// Money sent to person with phone number
  static const String moneyOutToPerson = '''
TFA2AQNYSG Confirmed. Ksh50.00 sent to PATRIC  KINYILI 0724020631 on 10/6/25 at 12:49 PM. New M-PESA balance is Ksh11,617.02. Transaction cost, Ksh0.00.  Amount you can transact within the day is 497,650.00. Earn interest daily on Ziidi MMF,Dial *334#''';

  /// PayBill for Safaricom bundles
  static const String payBillSafaricom = '''
TFA69DNO0W Confirmed. Ksh500.00 sent to SAFARICOM POSTPAID BUNDLES for account SAFARICOM DATA BUNDLES on 10/6/25 at 6:57 AM. New M-PESA balance is Ksh5,970.02. Transaction cost, Ksh0.00.''';

  /// PayBill for medical center with account number
  static const String payBillMedical = '''
TF977T5VMN Confirmed. Ksh300.00 sent to UPPER HILL MEDICAL CENTRE 1 for account 3946153004 on 9/6/25 at 6:53 PM New M-PESA balance is Ksh6,627.02. Transaction cost, Ksh5.00.Amount you can transact within the day is 490,830.00. Save frequent paybills for quick payment on M-PESA app https://bit.ly/mpesalnk''';

  /// PayBill for KPLC with account number
  static const String payBillKPLC = '''
TF851XBNNT Confirmed. Ksh4,000.00 sent to KPLC PREPAID for account 22170970879 on 8/6/25 at 3:09 PM New M-PESA balance is Ksh20,022.52. Transaction cost, Ksh34.00.Amount you can transact within the day is 493,700.00. Save frequent paybills for quick payment on M-PESA app https://bit.ly/mpesalnk''';

  /// PayBill for school with student details
  static const String payBillSchool = '''
TF73UZF61B Confirmed. Ksh6,500.00 sent to THORN GROVE SCHOOLS LTD for account Rita Nyawira Grade 7 on 7/6/25 at 10:33 AM New M-PESA balance is Ksh36,067.52. Transaction cost, Ksh42.00.Amount you can transact within the day is 490,401.00. Save frequent paybills for quick payment on M-PESA app https://bit.ly/mpesalnk''';

  /// Till payment to individual
  static const String tillPaymentIndividual = '''
TF936R0R3F Confirmed. Ksh800.00 paid to ERIC MAINA. on 9/6/25 at 3:41 PM.New M-PESA balance is Ksh8,967.02. Transaction cost, Ksh0.00. Amount you can transact within the day is 493,140.00. Save frequent Tills for quick payment on M-PESA app https://bit.ly/mpesalnk''';

  /// Till payment to business
  static const String tillPaymentBusiness = '''
TF925RKVP4 Confirmed. Ksh3,000.00 paid to ECOPETROL K LIMITED. on 9/6/25 at 11:56 AM.New M-PESA balance is Ksh12,880.02. Transaction cost, Ksh16.50. Amount you can transact within the day is 497,000.00. Save frequent Tills for quick payment on M-PESA app https://bit.ly/mpesalnk''';
} 