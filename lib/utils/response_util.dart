abstract class ResponseUtil {
  static Map<String, dynamic> errorClient(String e) {
    return {
      "statusCode": 400,
      "data": {"status": false, "message": e}
    };
  }

  static Map<String, dynamic> success(String e) {
    return {
      "statusCode": 200,
      "data": {"status": true, "message": e}
    };
  }

  static Map<String, dynamic> errorServer(String e) {
    return {
      "statusCode": 500,
      "data": {"status": true, "message": e}
    };
  }
}
