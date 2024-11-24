import 'package:carrot_market_sample/page/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: GestureDetector(
      //     onTap: () {},
      //     child: Row(
      //       children: [
      //         Text("아라동"),
      //         Icon(Icons.arrow_drop_down),
      //       ],
      //     ),
      //   ),
      //   elevation: 1,
      //   actions: [
      //     IconButton(onPressed: () {}, icon: Icon(Icons.search)),
      //     IconButton(onPressed: () {}, icon: Icon(Icons.tune)),
      //     IconButton(
      //       onPressed: () {},
      //       icon: SvgPicture.asset(
      //         "assets/svg/bell.svg",
      //         width: 22,
      //       ),
      //     ),
      //   ],
      // ),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomNavigationBarwidget(),
    );
  }

  BottomNavigationBarItem _bottomNavigationBarItem(
      String iconName, String label) {
    return BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: SvgPicture.asset(
            'assets/svg/${iconName}_off.svg',
            width: 22,
          ),
        ),
        activeIcon: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: SvgPicture.asset(
            'assets/svg/${iconName}_on.svg',
            width: 22,
          ),
        ),
        label: label);
  }

  Widget _bottomNavigationBarwidget() {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed, //애니메이션 없애기
        onTap: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        currentIndex: _currentPageIndex,
        selectedFontSize: 12,

//업데이트 된건지.. 필요없어서 주석처리함
        // selectedItemColor: Colors.black,
        // selectedLabelStyle: TextStyle(color: Colors.black),

        items: [
          _bottomNavigationBarItem('home', '홈'),
          _bottomNavigationBarItem('notes', '동네생활'),
          _bottomNavigationBarItem('location', '내 근처'),
          _bottomNavigationBarItem('chat', '채팅'),
          _bottomNavigationBarItem('user', '나의 당근'),
        ]);
  }

  Widget _bodyWidget() {
    switch (_currentPageIndex) {
      case 0:
        return Home();
        break;
      case 1:
        return Container();
        break;
      case 2:
        return Container();
        break;
      case 3:
        return Container();
        break;
      case 4:
        return Container();
        break;
    }
    return Container();
  }
}
