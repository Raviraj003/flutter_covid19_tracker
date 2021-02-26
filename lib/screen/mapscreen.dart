import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:covidapps/screen/detailscreen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {

  HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  static const LatLng _center = const LatLng(20.5937, 78.9629);
  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';
  bool _loader = false;
  Placemark placemark;
  var firstaddr, firstAddrCode;
  var _casesNumber, _deathsNumber, _recoveredNumber, _todayCases, _todayDeath, _todayRecovery;
  Timer timer;

  Future<bool> _onWillPop() async {
    return (await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => exit(0),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }
  @override
  void initState() {
    super.initState();
    requestGetMapAPI();
    timer = Timer.periodic(Duration(seconds: 15), (Timer t) => requestGetMapAPI());
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  requestGetMapAPI() async {
    setState(() {
      _loader = true;
    });
    try {
      final url = "https://coronavirus-19-api.herokuapp.com/countries/World";
      final response = await http.get(url,
          headers: {HttpHeaders.contentTypeHeader: "application/json"});

      if (response.statusCode == 200) {
        //var use r = new User.fromJson(responseJson);
        final responseJson = json.decode(response.body);
        int cases, death, recover, todayCase, todayDeath, todayRecovery;
        setState(() {
//          if(responseJson['country'].toString() == "World"){
            setState(() {
              cases = int.tryParse(responseJson['cases'].toString());
              death = int.tryParse(responseJson['deaths'].toString());
              recover = int.tryParse(responseJson['recovered'].toString());
              todayCase = int.tryParse(responseJson['todayCases'].toString());
              todayDeath = int.tryParse(responseJson['todayDeaths '].toString());
              todayRecovery = int.tryParse(responseJson['recovered'].toString());
              _casesNumber = NumberFormat.compact().format(cases);
              _deathsNumber = NumberFormat.compact().format(death);
              _recoveredNumber = NumberFormat.compact().format(recover);
              _todayCases = NumberFormat.compact().format(todayCase);
              _todayDeath = NumberFormat.compact().format(todayDeath);
              print(responseJson.toString());
            });
//          }
          print(responseJson.toString());
          setState(() {
            _loader = false;
          });
        });
      } else {
        return null;
        setState(() {
          _loader = false;
        });
      }
    } catch (exception) {
      print(exception);
      setState(() {
        _loader = false;
      });
    }
  }


//  print('Formatted Number is $numberToFormat');

  Completer<GoogleMapController> _controller = Completer();
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void getAddress(double latitude, double longitude) async{
    final coordinates = new Coordinates(latitude, longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);


    var first = addresses.first;
    setState(() {
      firstaddr = first.countryName;
      firstAddrCode = first.countryCode;
    });
    print("${first.countryName}");
    print(first.countryCode);

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: OfflineBuilder(
        debounceDuration: Duration.zero,
        connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
            ) {
              if (connectivity == ConnectivityResult.none) {
                  return Scaffold(
                    body: Center(child: Text('Please check your internet connection!')),
                  );
                }
                return child;
              },
              child: new Scaffold(
                  body: new SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new SizedBox(
                              height: MediaQuery.of(context).size.height * 0.04,
                            ),
                            _loader ? new Center(
                                child: Container(
                                  color: Colors.transparent,

                                  width: 100.0,

                                  height: 100.0,

                                  child: new Padding(

                                      padding: const EdgeInsets.all(5.0),

                                      child: new Center(

                                          child: new CircularProgressIndicator())),
                                )
                            ) : new Container(
                              margin: EdgeInsets.only(right: 18,left: 18,top: 10,bottom: 5),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.15,
                              child: new Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                color: Colors.blueAccent,
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 20.0),
                                  child: new Column(
                                    children: <Widget>[
                                      new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Text("Total Cases ", style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Roboto',
                                            fontSize: 22
                                          ),),
                                          new Image.asset('assets/images/global_icon.png',
                                            color: Colors.white54,
                                            width: 32, height:  32,),
                                        ],
                                      ),
                                      new SizedBox(
                                        height: 10,
                                      ),
                                      new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          new Text('$_casesNumber', style: TextStyle(
                                              fontFamily: 'Roboto',
                                              color: Colors.white,
                                              fontSize: 26
                                          ),),
                                          new Text('+$_todayCases', style: TextStyle(
                                              fontFamily: 'Roboto',
                                              color: Colors.white,
                                              fontSize: 16
                                          ),),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            _loader ? new Center(
                                child: Container(
                                  color: Colors.transparent,

                                  width: 100.0,

                                  height: 100.0,

                                  child: new Padding(

                                      padding: const EdgeInsets.all(5.0),

                                      child: new Center(

                                          child: new CircularProgressIndicator())),
                                )
                            ) : new Container(
                              margin: EdgeInsets.only(right: 19,left: 19,top: 5,bottom: 5),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.15,
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Container(
                                    child: new Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      color: Colors.red,
                                      child: Container(
                                        //margin: EdgeInsets.only(left: 32,right: 32,top: 5,bottom: 5),
                                        width: MediaQuery.of(context).size.width * 0.42,
                                        padding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 20.0),
                                        child: new Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            new SizedBox(
                                              height: 15,
                                            ),
                                            new Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                new Text('Deaths', style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22
                                                ),),
                                              ],
                                            ),

                                            new SizedBox(
                                              height: 10,
                                            ),
                                            new Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                new Text('$_deathsNumber', style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 26
                                                ),),
                                              ],
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  new Container(
                                    child: new Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      color: Colors.green,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.42,
                                        //margin: EdgeInsets.only(left: 18,right: 17,top: 5,bottom: 5),
                                        padding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 20.0),
                                        child: new Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            new SizedBox(
                                              height: 15,
                                            ),
                                            new Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                new Text('Recovered', style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22
                                                ),),
                                              ],
                                            ),

                                            new SizedBox(
                                              height: 10,
                                            ),
                                            new Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                new Text('$_recoveredNumber', style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 26
                                                ),),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            new SizedBox(
                              height: MediaQuery.of(context).size.height * 0.015,
                            ),
                            new SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.59,
                              child: new GoogleMap(
                                gestureRecognizers: Set()..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
                                  ..add(Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()))
                                  ..add(Factory<HorizontalDragGestureRecognizer>(() => HorizontalDragGestureRecognizer()))
                                  ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
                                  ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer())),
                                onMapCreated: _onMapCreated,
                                onTap: (latLng) async{
                                  await getAddress(latLng.latitude, latLng.longitude);
                                  print("Latitude: ${latLng.latitude}, Longitude: ${latLng.longitude}, _address ${firstaddr.toString()}");
                                  if(firstaddr != "" || firstaddr != null && firstAddrCode != "" || firstAddrCode != null){
                                    Navigator.push(context,
                                        new MaterialPageRoute(builder: (context) => new DetailScreen(firstaddr.toString(),firstAddrCode.toString())));
                                  }
                                },
                                //enable zoom gestures
                                zoomGesturesEnabled: true,
                                initialCameraPosition: CameraPosition(
                                  target: _center,
                                  zoom: 0.0,
                                ),
                              ),
                            ),
                            new Container(
                              color: Colors.grey[400],
                              child: new Center(
                                child: Text("Select Country to view details.",style: TextStyle(color: Colors.black),),
                              ),
                            ),

                          ],
                        ),
                    ),
                  ),

              ),
    );
  }
}