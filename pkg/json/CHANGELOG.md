# 0.20.4

- Allow custom `fromJson` to have an arbitrary parameter type.

# 0.20.3

- Add support for DateTime, serializing it to an ISO-8601 String.

# 0.20.2

- Fix generated code syntax error when defining fields containing the dollar sign `$` by using raw strings.
- Remove vendored package workaround, require ^3.5.0-154 Dart SDK.

# 0.20.1

- Vendor macro packages as workaround for analyzer issue.

# 0.20.0

- Initial preview of JSON encoding and decoding with a JsonCodable macro.
