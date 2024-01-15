/// Contains information about a callback handler
class HandlerInfo {
  /// The callback handler function.
  Function handler;

  /// A flag indicating whether the handler has been initialized.
  bool initialized;

  /// Creates a [HandlerInfo] instance with the provided [handler] and optional [initialized] flag.
  HandlerInfo({required this.handler, this.initialized = false});
}
