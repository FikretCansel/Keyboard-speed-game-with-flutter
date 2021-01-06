import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueGrey[900],
        appBar: AppBar(
          title: Center(
            child: Text("Keyboard Speed Test"),
          ),
          backgroundColor: Colors.deepPurple[400],
        ),
        body: MyHomeScreen(),
      ),
    );
  }
}

class MyHomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomeScreen();
  }
}

class _MyHomeScreen extends State<MyHomeScreen> {
  int level =1;
  int step = 0;
  int typedCharLength = 0;
  int lastTypedAt;
  double velocityMarquee = 35;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLevel();
  }
  var textlevel = [
    "                          merhaba",
    "                          hızlı araba sürmek",
    "                          nerelisin bilmiyorum ama bilsem",
    "                          ne yapıyosun adamım bu diyarda dolaşmak eglenceli şeydir",
    "                          Yaş otuz beş! yolun yarısı eder Dante gibi ortasındayız ömrün.Delikanlı çağımızdaki cevher, ",
    "                          Türk edebiyatının kült şiirleri arasında yer alır. Behçet Necatigil’in deyişiyle: “Şiirlerinde, yaşamanın ve aşkın",
    "                          Artık demir almak günü gelmişse zamandan,Meçhule giden bir gemi kalkar bu limandan.Hiç yolcusu yokmuş gibi sessizce alır yol;Sallanmaz o"
  ];
  void saveLevel (int newlevel)async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("leveldata", newlevel);
  }
  void updataLastType() {
    lastTypedAt = new DateTime.now().millisecondsSinceEpoch;
  }
  getLevel ()async{
    final prefs = await SharedPreferences.getInstance();
    final getlevel = prefs.getInt('leveldata') ?? 1;
    setState(() {
      level=getlevel;
    });
  }
  void onStartClick() {
    updataLastType();
    setState(() {
      step++;
    });
    var timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      var now = new DateTime.now().millisecondsSinceEpoch;
      if (now - lastTypedAt > 20000 && step == 1) {
        setState(() {
          step = 2;
        });
        print(step);
        timer.cancel();
      }
      print("hello");
      if(step!=1) timer.cancel();
    });
  }

  void onReStartClick() {
    typedCharLength = 0;
    setState(() {
      step = 0;
    });
  }

  void onType(String value) {
    updataLastType();
    String trimmedValue = textlevel[level - 1].trimLeft();
    if (trimmedValue.indexOf(value) != 0) {
      setState(() {
        step = 2;
      });
    } else {
      setState(() {
        typedCharLength++;
      });
    }
    //level atladıgı
    if (trimmedValue.length == value.length) {
      if(level>=textlevel.length){
        setState(() {
          step=3;
          level=1;
        });
      }
      else{
        setState(() {
          step=4;
          level++;
          saveLevel(level);
          velocityMarquee + 5;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var shownWidget;
    if (step == 0)
      shownWidget = Container(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Başlamak için Tıkla",style: TextStyle(color: Colors.white,fontSize: 24),),
            SizedBox(
              height: 50,
            ),
            RaisedButton(
              onPressed: onStartClick,
              child: SizedBox(
                child: Center(
                    child: Text(
                  "Click for Start",
                )),
                width: 100,
                height: 100,
              ),
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(500.0),
                  side: BorderSide(color: Colors.white)),
              textColor: Colors.white,
            ),
          ],
        )),
      );
    else if (step == 1)
      shownWidget = Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Text("Score : $typedCharLength ",style: TextStyle(color: Colors.white,fontSize: 24,),),
              SizedBox(height: 50,),
              Container(
                height: 200,
                child: Marquee(
                  text: textlevel[level - 1].toString(),
                  style: TextStyle(
                      fontSize: 24,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  blankSpace: 20.0,
                  velocity: velocityMarquee,
                  startPadding: 0,
                  accelerationDuration: Duration(seconds: 4),
                  accelerationCurve: Curves.ease,
                  decelerationDuration: Duration(milliseconds: 500),
                  decelerationCurve: Curves.easeOut,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10, left: 10),
                child: TextField(
                  onChanged: onType,
                  decoration: InputDecoration(
                      hintText: "enter uptext",
                      labelStyle: new TextStyle(color: const Color(0xFF424242)),
                      border: new UnderlineInputBorder(
                          borderSide: new BorderSide(
                              color: Colors.red
                          )
                      )
                  ),
                  cursorColor: Colors.white,
                  autofocus: true,
                ),
              ),
            ],
          ),
        ),
      );
    else if(step==3){
      shownWidget = Container(
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("You Passed all levels:)).Congratulations.",style: TextStyle(color: Colors.white,fontSize: 24),),
                SizedBox(
                  height: 50,
                ),
                RaisedButton(
                  onPressed: onStartClick,
                  child: SizedBox(
                    child: Center(
                        child: Text(
                          "Click for ReStart",
                        )),
                    width: 100,
                    height: 100,
                  ),
                  color: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(500.0),
                      side: BorderSide(color: Colors.white)),
                  textColor: Colors.white,
                ),
              ],
            )),
      );
    }
    else if (step == 4) {
      shownWidget = Container(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Succesfull. New Level $level ",style: TextStyle(color: Colors.white,fontSize: 24,),),
            SizedBox(
              height: 50,
            ),
            RaisedButton(
              onPressed: onReStartClick,
              child: SizedBox(
                child: Center(
                    child: Text(

                      "Click for Start",
                    )),
                width: 100,
                height: 100,
              ),
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(500.0),
                  side: BorderSide(color: Colors.white)),
              textColor: Colors.white,
            ),
          ],
        )),
      );
    } else {
      shownWidget = Container(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Your Score : $typedCharLength",style: TextStyle(color: Colors.white,fontSize: 24,),),
            SizedBox(
              height: 50,
            ),
            RaisedButton(
              onPressed: onReStartClick,
              child: SizedBox(
                child: Center(
                    child: Text(
                      "Click for Start",
                    )),
                width: 100,
                height: 100,
              ),
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(500.0),
                  side: BorderSide(color: Colors.white)),
              textColor: Colors.white,
            ),
          ],
        )),
      );
    }
    return shownWidget;
  }
}
