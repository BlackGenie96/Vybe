import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:vybe_2/Data/OrganizerProfileService.dart';

class Payments extends StatefulWidget{
  @override
  _PaymentsState createState() => new _PaymentsState();
}

class _PaymentsState extends State<Payments>{

  OrganizerProfileService service = new OrganizerProfileService();

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Color(0xff301370),
      ),
      child: new Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor:Color(0xff301370),
            iconTheme: IconTheme.of(context).copyWith(
              color: Colors.white,
            ),
            elevation:0
          ),
          body: FutureBuilder<int>(
            future: service.getDays(),
            builder:(context,snapshot){
              if(snapshot.hasData){
                int days = snapshot.data;

                return createBody(days);
              }else if(snapshot.hasError){
                return Text('Please try again later', textAlign:TextAlign.center,style:TextStyle(fontFamily:'SF-Pro',color:Colors.white,));
              }

              return Center(child: CircularProgressIndicator(backgroundColor:Colors.white));
            }
          )
        ),
      ),
    );
  }

  Widget createBody(int days) => SafeArea(
    child: SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 20.0),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Image.asset('assets/logo.png'),
            ),
            SizedBox(height: 15.0),
            Text('Days Left:',textAlign:TextAlign.center,style:TextStyle(color:Colors.white,fontFamily:'SF-Pro',fontSize:22)),
            SizedBox(height: 15.0),
            Text('$days',textAlign:TextAlign.center,style:TextStyle(color:Colors.white,fontFamily:'SF-Pro',fontSize:22)),
            Icon(Icons.all_inclusive,color: Colors.white,),
            SizedBox(height: 30.0),
            RaisedButton(
                color: Colors.white,
                textColor:Color(0xff301370),
                padding : const EdgeInsets.all(16.0),
                shape : RoundedRectangleBorder(borderRadius:BorderRadius.circular(20.0),),
                child: Text('Approve Payment',textAlign:TextAlign.center,style:TextStyle(fontFamily:'SF-Pro')),
                onPressed: (){
                  Toast.show("Coming soon.", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  //Navigator.push(context, MaterialPageRoute(builder:(context) => ChatBox(),));
                }
            ),
          ],
        ),
      ),
    ),
  );
}