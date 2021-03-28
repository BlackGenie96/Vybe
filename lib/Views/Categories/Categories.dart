import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:vybe_2/Data/CategoriesService.dart';
import 'package:vybe_2/Models/Category.dart';
import 'package:vybe_2/Views/Navigation/Navigation.dart';

class Categories extends StatefulWidget{
  @override
  _CategoriesState createState() => new _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  CategoriesService service = new CategoriesService();
  String userId;
  String userName;
  String userSurname;
  String userEmail;
  //String chosen;
  String parent;
  String chosenCat;
  bool _loading = false;
  Future<List<Category>> catList;

  @override
  void initState(){
    super.initState();

    service.retrieveFromPrefs().then((String catId){
      setState(() {
        chosenCat = catId;
      });
    });

    catList = service.fetchCategories(parent);
  }
  @override
  Widget build(BuildContext context) {
    return new Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
        accentColor: Color(0xff301370),
      ),
      child: new Builder(
        builder: (context)=>Scaffold(
          appBar: AppBar(
            title: Text('Categories',style: TextStyle(fontFamily:'SF-Pro',color:Colors.white,)),
            backgroundColor: Color(0xff301370),
            iconTheme : IconTheme.of(context).copyWith(
              color: Color(0xff301370),
            ),
          ),
          body: Center(
            child: _loading ? CircularProgressIndicator() : FutureBuilder<List<Category>>(
              future:catList,
              builder: (context, snapshot){

                //TODO: use connection state to handle different view while loading
                if(snapshot.hasData){
                  //get chosen category from shared preferences and assign to chosen category variable in this class
                  List<Category> data = snapshot.data;
                  return _categoryListView(data);
                }else if(snapshot.hasError){
                  return Text("${snapshot.error}");
                }
                return new CircularProgressIndicator(
                  backgroundColor:Colors.white,

                );
              },
            ),
          ),
        ),
      ),
    );
  }

  ListView _categoryListView(data){
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index){
        Category tempCategory = data[index];
        return _tile(tempCategory);
      });
  }

  ListTile _tile(Category category) => ListTile(
    title: Text(
      category.catName,
      style: TextStyle(
        fontSize: 20,
        fontFamily: 'SF-Pro',
        fontWeight: FontWeight.w700,
      ),
    ),
    onTap: (){
      setState(() => _loading = true);
      if(category.hasChildren){
        setState(() {
          catList = service.fetchCategories(category.catId);
        });
      }else {
        service.updateCategory(category).then((String result){
          setState(() => _loading = false);
          if(int.parse(result) > 0){
            setState(() {
              chosenCat = result;
            });
            _goToHome();
          }else{
            CircularProgressIndicator(value: 0.0);
            Toast.show('There was a problem with selecting your category. Please try again', context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
        });
      }
    },
    trailing: category.catId == chosenCat
        ? Icon(Icons.check_box,color: Colors.green[800])
        : Icon(Icons.check_box_outline_blank, color:Colors.grey[700]),
  );

  void _goToHome(){
    //after updating the chosen category go to main activity
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context){
          return MaterialApp(
            home: Navigation(),
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              accentColor: Color(0xffffffff),
              primaryColor: Color(0xffffffff),
            ),
          );
        }
      ),
    );
  }
}

