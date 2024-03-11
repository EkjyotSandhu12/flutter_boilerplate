
enum MethodType {
  get('GET'),
  post('POST'),
  put('PUT'),
  patch('PATCH'),
  delete("DELETE");
  const MethodType(this.type);
  final String type;
}

abstract class ApiConstants{

  ///==> BASE URL
  static String prod = 'www.prod.com';
  static String staging = 'www.staging.com';
  static String local = 'www.local.com';


  ///==> END POINTS
  static String getUser = '/users';
}