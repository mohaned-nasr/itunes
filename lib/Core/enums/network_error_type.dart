enum NetworkErrorType {
  timeout,
  noConnection,
  badRequest,       // 400
  unauthorized,     // 401
  forbidden,        // 403
  notFound,         // 404
  serverError,      // 500+
  cancelled,
  unknown,
}