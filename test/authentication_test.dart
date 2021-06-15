import 'package:flutter_test/flutter_test.dart';
import 'package:todo/utils/validator.dart';

void main(){
  test('Empty Phone number Test', () {
    var result = Validator.validatePhoneNumber('');
    expect(result, false);
  });

  test('Empty Event Title test', (){
    var result = Validator.validateString('');
    expect(result, false);
  });
}