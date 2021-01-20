import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  //--------------------------Horizontal Sliding Country List----------------------//
  Widget countryFlags(String flagName, String countryName) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color:Theme.of(context).primaryColor, width: 2.0)
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Container(
                width: 100.0,
                height: 50.0,
                child: RawMaterialButton(
                  onPressed: () {},
                  child: Flag(
                        flagName,
                        height: 50.0,
                        width: 100.0,
                        fit: BoxFit.fill,
                      ),
                ),
              ),
              Text(countryName, style:TextStyle(fontFamily:'Langar'))
            ],
          ),
        ),
      ),
    );
  }

  //--------------------------Horizontal Sliding Language List----------------------//
  Widget languages(String lang, String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color:Theme.of(context).primaryColor, width: 2.0)
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Text(lang, style:TextStyle(fontFamily:'Langar')),
              Text('($text)')
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(
              flex: 1,
            ),
            Text(
              'Settings',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
            Spacer(
              flex: 2,
            )
          ],
        ),
        elevation: 0.0,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 20.0),
            child: Text('Change Avatar',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          ),
          Container(
            height: 120.0,
            width: 120.0,
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(color: Theme.of(context).accentColor, width: 5),
                image: DecorationImage(
                  image: AssetImage('assets/avatar/avatar1.png'),
                  fit: BoxFit.contain,
                )),
            child: Align(
              alignment: Alignment.lerp(
                  Alignment.bottomCenter, Alignment.bottomRight, 0.25),
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.yellow[900],
                ),
                child: Icon(
                  LineAwesomeIcons.pencil,
                  size: 20.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 20.0),
            child: Text('Change Language',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              // color: Colors.grey[300],
            ),
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: <Widget>[
                  languages('English', 'News'),
                  languages('Arabic', 'أخبار'),
                  languages('German', 'Nachrichten'),
                  languages('Spanish', 'Noticias'),
                  languages('French', 'Nouvelles'),
                  languages('Hebrew', 'חֲדָשׁוֹת'),
                  languages('Italian', 'notizia'),
                  languages('Dutch', 'Nieuws'),
                  languages('Norwegian', 'Nyheter'),
                  languages('Portuguese', 'Notícia'),
                  languages('Russian', 'Новости'),
                  languages('Chinese', '新闻'),
                ])),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 20.0),
            child: Text('Change Country',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              // color: Colors.grey[300],
            ),
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: <Widget>[
                  countryFlags('IN','India'),
                  countryFlags('US','United States of America'),
                  countryFlags('GB','United Kingdom'),
                  countryFlags('AE','United Arab Emirates'),
                  countryFlags('UA','Ukraine'),
                  countryFlags('TR','Turkey'),
                  countryFlags('TH','Thailand'),
                  countryFlags('CH','Switzerland'),
                  countryFlags('SE','Sweden'),
                  countryFlags('SA','Saudi Arabia'),
                  countryFlags('PL','Poland'),
                  countryFlags('NZ','New Zealand'),
                  countryFlags('MX','Mexico'),
                  countryFlags('JP','Japan'),
                  countryFlags('BR','Brazil'),
                  countryFlags('AU','Australia'),
                ])),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 20.0),
            child: Text('Change Password',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}