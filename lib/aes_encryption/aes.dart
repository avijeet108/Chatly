import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';

class MyEncryptionDecryption {
  //For AES Encryption/Decryption
  static final key = encrypt.Key.fromLength(32);
  static final iv = encrypt.IV.fromLength(16);
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));

  static encryptAES(text) {
    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64;
  }

  static decryptAES(text) {
    String fixed = base64.normalize(text);

    String decrypted = encrypter.decrypt64(fixed, iv: iv);
    return decrypted;
  }
}
