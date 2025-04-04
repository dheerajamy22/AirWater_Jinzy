import 'package:encrypt/encrypt.dart';

class EncryptData{


   static encryptAES(String text) {
      print('enc data ${text}');

      String enc = '';
      final dynamic key = Key.fromUtf8('amysoftech2024@jinzyHrm#Portal&#');
      final dynamic iv = IV.fromUtf8('amysoftech@2024&');
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

      enc = encrypter.encrypt(text, iv: iv).base64;
      print('encryption $enc');
      return enc;
   }

static decryptAES(String text) {

      String dec = '';
      final dynamic key = Key.fromUtf8('amysoftech2024@jinzyHrm#Portal&#');
      final dynamic iv = IV.fromUtf8('amysoftech@2024&');
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

     dec = encrypter.decrypt64(text,iv: iv);
      print('decy $dec');
      return dec;
   }


}