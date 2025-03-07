enum BluetoothDevice {
  testMonotonia("98:D3:71:FD:80:8B"),
  testRiel("98:D3:31:F6:5D:9D"),
  testPalanca("00:22:03:01:3C:45"),
  testTuercas("98:D3:11:FC:3B:3D");

  final String macAddress;
  const BluetoothDevice(this.macAddress);
}
