import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DetailScreen extends StatefulWidget {
  final dataCountry, dataCountryCode;
  DetailScreen(this.dataCountry, this.dataCountryCode);
  @override
  _DetailScreenState createState() =>
      _DetailScreenState(dataCountry, dataCountryCode);
}

class _DetailScreenState extends State<DetailScreen> {
  var dataCountry;
  var dataCountryCode;
  _DetailScreenState(this.dataCountry, this.dataCountryCode);
  String _country;
  var _casesNumber,
      _todaycosesNumber,
      _deathsNumber,
      _todayDeathNumber,
      _recoveredNumber,
      _activeNumber;

  bool _loader = false;

  @override
  void initState() {
    super.initState();
    requestGetMapAPI();
  }

  requestGetMapAPI() async {
    setState(() {
      _loader = true;
    });
    try {
      if (dataCountry == "United States") {
        dataCountry = "USA";
      }
      if (dataCountry == "United Kingdom") {
        dataCountry = "UK";
      }
      if (dataCountry == "South Korea") {
        dataCountry = "S. Korea";
      }
      if (dataCountry == "Myanmar (Burma)") {
        dataCountry = "Myanmar";
      }
      if (dataCountry == "Democratic Republic of the Congo") {
        dataCountry = "DRC";
      }
      if (dataCountry == "Central African Republic") {
        dataCountry = "CAR";
      }

      final url =
          "https://coronavirus-19-api.herokuapp.com/countries/" + dataCountry;
      final response = await http.get(url,
          headers: {HttpHeaders.contentTypeHeader: "application/json"});

      if (response.statusCode == 200) {
        //var use r = new User.fromJson(responseJson);
        final responseJson = json.decode(response.body);
        int _deaths, _count, _recovered, _active, _todayCases, _todayDeaths;
        setState(() {
          _country = responseJson['country'].toString();
          _deaths = int.tryParse(responseJson['deaths'].toString());
          _count = int.tryParse(responseJson['cases'].toString());
          _recovered = int.tryParse(responseJson['recovered'].toString());
          _active = int.tryParse(responseJson['active'].toString());
          _todayCases = int.tryParse(responseJson['todayCases'].toString());
          _todayDeaths = int.tryParse(responseJson['todayDeaths'].toString());
          _todayDeathNumber = NumberFormat.compact().format(_todayDeaths);
          _casesNumber = NumberFormat.compact().format(_count);
          _recoveredNumber = NumberFormat.compact().format(_recovered);
          _todaycosesNumber = NumberFormat.compact().format(_todayCases);
          _deathsNumber = NumberFormat.compact().format(_deaths);
          _activeNumber = NumberFormat.compact().format(_active);

          //print(responseJson.toString());
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
      //await requestGetFlagAPI(_country);
    } catch (exception) {
      print(exception);
      setState(() {
        _loader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: _loader
          ? new Center(
              child: Container(
              color: Colors.transparent,
              width: 100.0,
              height: 100.0,
              child: new Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: new Center(child: new CircularProgressIndicator())),
            ))
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16, top: 0),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      //height: MediaQuery.of(context).size.height * 0.28,
                      child: new Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.blueAccent,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 30.0,horizontal: 15.0),
//                          padding: EdgeInsets.only(
//                              top: 30, bottom: 30, left: 10, right: 10),
                          child: new Column(
                            children: <Widget>[
                              new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Text(
                                    "Total Cases ",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 24),
                                  ),
                                ],
                              ),
                              new SizedBox(
                                height: 5,
                              ),
                              new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Image.network(
                                    'https://www.countryflags.io/$dataCountryCode/flat/64.png',
                                    width: 32,
                                    height: 32,
                                  ),
                                  new Text(
                                    '  $_country ',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ],
                              ),
                              new SizedBox(
                                height: 5,
                              ),
                              new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Text(
                                    ' $_casesNumber',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 28),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    new Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.6,
                      padding: EdgeInsets.all(10),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
//                            decoration: new BoxDecoration(
//                                borderRadius:
//                                    new BorderRadius.all(Radius.circular(12))),
                            width: MediaQuery.of(context).size.width * 0.40,
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: Colors.green,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 32,horizontal: 15),
                                    child: new Column(
                                      children: <Widget>[
                                        new Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            new Text(
                                              "Recovered",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        new SizedBox(
                                          height: 5,
                                        ),
                                        new Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            new Text(
                                              '$_recoveredNumber',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 28),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                new SizedBox(
                                  height: 5,
                                ),
                                new Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: Colors.red,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 25,horizontal: 15),
                                    child: new Column(
                                      children: <Widget>[
                                        new Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            new Text(
                                              "Deaths",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        new SizedBox(
                                          height: 5,
                                        ),
                                        new Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            new Text(
                                              '$_deathsNumber',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 28),
                                            ),
                                          ],
                                        ),
                                        new SizedBox(
                                          height: 5,
                                        ),
                                        new Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            new Text(
                                              '+$_todayDeathNumber',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                new SizedBox(
                                  height: 5,
                                ),
                                new Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: Colors.grey[600],
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 25,horizontal: 15),
                                    child: new Column(
                                      children: <Widget>[
                                        new Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            new Text(
                                              "Confirmed",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        new SizedBox(
                                          height: 5,
                                        ),
                                        new Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            new Text(
                                              '$_activeNumber',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 28),
                                            ),
                                          ],
                                        ),
                                        new SizedBox(
                                          height: 5,
                                        ),
                                        new Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            new Text(
                                              '+$_todaycosesNumber',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 18,
                          ),
                          Container(
                            decoration: new BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: new BorderRadius.all(
                                  Radius.circular(16.0),
                                ),
                                border: Border.all(
                                    width: 1,
                                    color: Colors.grey,
                                    style: BorderStyle.solid)),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 16.0),
                                  decoration: new BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: new BorderRadius.all(
                                      Radius.circular(12.0),
                                    ),
                                  ),
                                  child: Text(
                                    "Symptoms",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                Image.network(
                                  'https://www.gstatic.com/healthricherkp/covidsymptoms/light_fever.gif',
                                  height: 80,
                                ),
                                Text(
                                  "Fever",
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                Image.network(
                                  'https://www.gstatic.com/healthricherkp/covidsymptoms/light_cough.gif',
                                  height: 80,
                                ),
                                Text(
                                  "Dry cough",
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                Image.network(
                                  'https://www.gstatic.com/healthricherkp/covidsymptoms/light_tiredness.gif',
                                  height: 80,
                                ),
                                Text(
                                  "Tiredness",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            height: MediaQuery.of(context).size.height * 0.60,
                            width: MediaQuery.of(context).size.width * 0.40,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
