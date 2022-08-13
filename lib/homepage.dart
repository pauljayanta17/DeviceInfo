import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
import 'package:yourdeviceinfo/data_display.dart';
class HomePage extends StatefulWidget {
  static final String routeName ='/homepage';
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
 
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'Version Security Patch': build.version.securityPatch,
      'Version sdkInt': build.version.sdkInt,
      'Version release': build.version.release,
      'Version incremental': build.version.incremental,
      'Version codename': build.version.codename,
      'Board': build.board,
      'Brand': build.brand,
      'Device': build.device,
      'Display': build.display,
      'Fingerprint': build.fingerprint,
      'Hardware': build.hardware,
      'Host': build.host,
      'ID': build.id,
      'Manufacturer': build.manufacturer,
      'Model': build.model,
      'Product': build.product,
      'Supported32BitAbis': build.supported32BitAbis,
      'SupportedAbis': build.supportedAbis,
      'Tags': build.tags,
      'Type': build.type,
      'IsPhysicalDevice': build.isPhysicalDevice,
      'AndroidId': build.androidId,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color.fromARGB(255, 5, 117, 61),
        title: Text(
            Platform.isAndroid ? 'Android Device Info' : 'iOS Device Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: _deviceData.keys.map((String property) {
            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>DataDisplay(title:property)));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(19),
                  gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 167, 161, 243),
                  Color.fromARGB(255, 143, 222, 228),
                  ]),
                ),
                margin: EdgeInsets.all(4),
                
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.indigoAccent,
                            borderRadius: BorderRadius.circular(6)),
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          property,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.045,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.04,
                      ),
                      Container(
                        
                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                        child: Text(
                      '${_deviceData[property]}',
                      maxLines: 10,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: size.width * 0.047,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 135, 7, 255)
                      ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(right: size.width * 0.02))
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
