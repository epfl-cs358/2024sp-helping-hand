typedef MacAddress = String;
typedef IpAddress = String;

class NetworkDevice {
  final IpAddress ipAddress;
  final MacAddress macAddress;

  const NetworkDevice({
    required this.ipAddress,
    required this.macAddress,
  });

  Uri get uri => Uri.http(ipAddress);

  NetworkDevice withArgs({
    IpAddress? ipAddress,
    MacAddress? macAddress,
  }) =>
      NetworkDevice(
        ipAddress: ipAddress ?? this.ipAddress,
        macAddress: macAddress ?? this.macAddress,
      );
}
