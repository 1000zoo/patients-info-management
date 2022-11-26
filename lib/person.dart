
class Person {
  late String _name;
  late String _barcode;
  late String _gender;
  late String _imagePath;
  late String _birth;

  Person(this._name, this._barcode, this._gender, this._imagePath, this._birth);

  Person.fromJson(Map<String, dynamic> info) {
    _name = info['name'] ?? " ";
    _barcode = info['barcode'] ?? " ";
    _gender = info['gender'] ?? " ";
    _imagePath = info['imagePath'] ?? " ";
    _birth = info['birth'] ?? " ";
  }

  Map<String, dynamic> toJson() {
    return {
      'name' : _name,
      'barcode' : _barcode,
      'gender' : _gender,
      'imagePath' : _imagePath,
      'birth' : _birth
    };
  }

  @override
  String toString() {
    return 'Person{_name: $_name, _barcode: $_barcode, _gender: $_gender, _imagePath: $_imagePath, _birth: $_birth}';
  }

  String get birth => _birth;

  set birth(String value) {
    _birth = value;
  }

  String get imagePath => _imagePath;

  set imagePath(String value) {
    _imagePath = value;
  }

  String get gender => _gender;

  set gender(String value) {
    _gender = value;
  }

  String get barcode => _barcode;

  set barcode(String value) {
    _barcode = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }
}