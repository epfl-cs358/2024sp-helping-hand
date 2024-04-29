class NetworkDevice {
  final int subnet;
  final int id;

  const NetworkDevice({
    required this.subnet,
    required this.id,
  });

  String get ipAddress => "192.168.$subnet.$id";
  Uri get uri => Uri.http(ipAddress);
}

class ActiveLanDevice {
  final NetworkDevice lan;
  final String macAddress;

  const ActiveLanDevice({
    required this.lan,
    required this.macAddress,
  });
}
