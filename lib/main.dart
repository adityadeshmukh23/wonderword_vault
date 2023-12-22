import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(208, 175, 176, 149)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  bool _isMenuExtended = false;
  bool get isMenuExtended => _isMenuExtended;

  void toggleMenuExtended() {
    _isMenuExtended = !_isMenuExtended;
    notifyListeners();
  }

  var favorites = <WordPair>[];
  bool _isFavoritesPage = false;
  bool get isFavoritesPage => _isFavoritesPage;

  void setIsFavoritesPage(bool value) {
    _isFavoritesPage = value;
    notifyListeners();
  }

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}


class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String name = 'Aditya Deshmukh';
    String collegeId = 'adityad23@iitk.ac.in';
    String rollNo = '230066';
    String city = 'Nanded';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.deepPurple],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'My Profile',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Hero(
                tag: 'profile-image',
                child: const CircleAvatar(
                  radius: 120,
                  backgroundImage: AssetImage('assets/pic.png'),
                ),
              ),
              SizedBox(height: 20),
              Text(
                name,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Roll No: $rollNo',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'College ID: $collegeId',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'City: $city',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Go Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    String appBarTitle = appState.isFavoritesPage ? 'Favorites' : 'WonderWord Vault';

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.deepPurple, Colors.blue],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WonderWord Vault',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 42),
                  Text(
                    '“Explore. Express. Excel.”',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
                appState.setIsFavoritesPage(false);
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Favorites'),
              onTap: () {
                Navigator.pop(context);
                appState.setIsFavoritesPage(true);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple, Colors.blue],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                'Welcome Aditya,',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: appState.isFavoritesPage ? FavoritesPage() : GeneratorPage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            pair.asPascalCase,
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
          SizedBox(height: 20),
          
          Icon(
            Icons.engineering, 
            size: 150,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Favourites',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 2, 2, 33),
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 50),
          Expanded(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              child: ListView.builder(
                itemCount: context.watch<MyAppState>().favorites.length,
                itemBuilder: (context, index) {
                  final pair = context.watch<MyAppState>().favorites[index];
                  return buildFavoriteItem(context, pair);
                },
              ),
            ),
          ),
          SizedBox(height: 20), 
          ElevatedButton(
            onPressed: () {
              
              context.read<MyAppState>().favorites.clear();
              
              context.read<MyAppState>().notifyListeners();
            },
            child: Text('Delete All'),
          ),
        ],
      ),
    );
  }
}


Widget buildFavoriteItem(BuildContext context, WordPair pair) {
  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(197, 150, 0, 115),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Icon(
                Icons.favorite,
                color: Color.fromARGB(255, 179, 203, 23),
              ),
              SizedBox(width: 5),
              Text(
                pair.asPascalCase,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            context.read<MyAppState>().favorites.remove(pair);
            context.read<MyAppState>().notifyListeners();
          },
        ),
      ],
    ),
  );
}
