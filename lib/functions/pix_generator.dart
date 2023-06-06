import 'dart:developer';

String crc16ccitt(String input) {
  int crc = 0xFFFF;
  int polynomial = 0x1021;

  List<int> bytes = input.codeUnits;

  for (int byte in bytes) {
    crc ^= (byte << 8);

    for (int i = 0; i < 8; i++) {
      if ((crc & 0x8000) != 0) {
        crc = (crc << 1) ^ polynomial;
      } else {
        crc = crc << 1;
      }
    }
  }
  return (crc.toUnsigned(16).toRadixString(16)).padLeft(4, '0').toUpperCase();
}

String payLoadEstatico(
    String pKey, String pBenef, String pCity, String pCodTransph,
    {num? pValue}) {
  const payloadFormatIndicator = '000201';
  const merchantAccountInformation = '26';
  const merchantCategoryCode = '52040000';
  const transactionCurrency = '5303986';
  const transactionAmount = '54';
  const countryCode = '5802BR';
  const merchantName = '59';
  const merchantCity = '60';
  const additionalDataFieldTemplate = '62';
  const crc16 = '6304';

  String merchantAccountInformationString =
      '0014BR.GOV.BCB.PIX01${pKey.length}$pKey';
  String valorTotal =
      pValue == null ? '' : pValue.toStringAsFixed(2).replaceAll(',', '.');
  String txid =
      '05${pCodTransph.length.toString().padLeft(2, '0')}$pCodTransph';

  String codPayLoad = '';

  if (pValue != null) {
    codPayLoad = payloadFormatIndicator +
        merchantAccountInformation +
        merchantAccountInformationString.length.toString() +
        merchantAccountInformationString +
        merchantCategoryCode +
        transactionCurrency +
        transactionAmount +
        valorTotal.length.toString().padLeft(2, '0') +
        valorTotal +
        countryCode +
        merchantName +
        pBenef.length.toString().padLeft(2, '0') +
        pBenef +
        merchantCity +
        pCity.length.toString().padLeft(2, '0') +
        pCity +
        additionalDataFieldTemplate +
        txid.length.toString().padLeft(2, '0') +
        txid +
        crc16;
  } else {
    codPayLoad = payloadFormatIndicator +
        merchantAccountInformation +
        merchantAccountInformationString.length.toString() +
        merchantAccountInformationString +
        merchantCategoryCode +
        transactionCurrency +
        countryCode +
        merchantName +
        pBenef.length.toString().padLeft(2, '0') +
        pBenef +
        merchantCity +
        pCity.length.toString().padLeft(2, '0') +
        pCity +
        additionalDataFieldTemplate +
        txid.length.toString().padLeft(2, '0') +
        txid +
        crc16;
  }

  String crc = crc16ccitt(codPayLoad);

  log(codPayLoad + crc);

  return codPayLoad + crc;
}
