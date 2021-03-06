import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:NewsLoose/screens/registration.dart';
import 'package:NewsLoose/helper/lookup.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    assignValues();
  }

  SharedPreferences localStorage;
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user;
  String name = '', email = '';
  int imageNumber = 1;
  bool _loading = true;

  assignValues() async {
    user = await auth.currentUser();
    setState(() {
      _loading = false;
    });
  }

  void _showAboutDialogBox() {
    showAboutDialog(
        context: context,
        applicationIcon: Image.asset('assets/images/logo.png', width:50, height:50),
        applicationName: 'NewsLoose',
        applicationVersion: '0.0.1',
        applicationLegalese: "Developed on Utkarsh Mishra",
        // routeSettings: RouteSettings(),
        useRootNavigator: false,
        children: [
          SizedBox(
            height: 10.0,
          ),
          Text(
              "THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES, "
              "INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. "
              "IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR "
              "CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; "
              "LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, "
              "STRICT LIABILITY,OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED "
              "OF THE POSSIBILITY OF SUCH DAMAGE.")
        ]);
  }

  Widget items(IconData icon, String text, String page) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          if (page == 'license') {
            // ignore: await_only_futures
            _showAboutDialogBox();
          }
          if (page == 'logout') {
            await auth.signOut();

            localStorage = await SharedPreferences.getInstance();
            await localStorage.setBool('login', true);

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => RegPage(),
              ),
              (route) => false,
            );
          } else {
            Navigator.pushNamed(context, page);
          }
        },
        child: Container(
          height: 10.0,
          margin: EdgeInsets.symmetric(
            horizontal: 20.0,
          ).copyWith(bottom: 20.0),
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.orange[700],
          ),
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 25.0,
                color: Colors.white,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              Icon(
                LineAwesomeIcons.angle_right,
                size: 20.0,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _loading
            ? Center(
                child: Container(
                  child: CircularProgressIndicator(),
                ),
              )
            : SafeArea(
                child: Stack(children: [
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/avatar/background.jpg'),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(70.0),
                          bottomRight: Radius.circular(70.0)),
                    ),
                  ),
                  StreamBuilder(
                      stream: Firestore.instance
                          .collection('User Data')
                          .document(user.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView(
                            children: [
                              Container(
                                height: 120.0,
                                width: 120.0,
                                margin: EdgeInsets.only(top: 20),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Theme.of(context).accentColor,
                                        width: 5),
                                    image: DecorationImage(
                                      image: AssetImage(imageLookUp(
                                          snapshot.data['Image Number'])),
                                      fit: BoxFit.contain,
                                    )),
                              ),
                              Container(
                                  height: 350.0,
                                  width: 120.0,
                                  margin: EdgeInsets.only(
                                      top: 40, left: 30, right: 30),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.yellow[400],
                                          Theme.of(context).accentColor,
                                        ],
                                        tileMode: TileMode.repeated),
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(snapshot.data['Name'],
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontFamily: 'Pacifico',
                                                  fontSize: 23.0)),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0,
                                              right: 8.0,
                                              bottom: 8.0),
                                          child: Text(snapshot.data['Email Id'],
                                              style: TextStyle(
                                                  color: Colors.blue[800],
                                                  fontFamily: 'Langar',
                                                  fontSize: 15.0)),
                                        ),
                                      ),
                                      items(Icons.settings, 'Settings',
                                          '/settings'),
                                      items(Icons.insert_drive_file_outlined,
                                          'License', 'license'),
                                      items(Icons.home, 'About', '/about'),
                                      items(Icons.logout, 'Logout', 'logout'),
                                    ],
                                  )),
                            ],
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                ]),
              ));
  }
}
