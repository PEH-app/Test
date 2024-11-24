import 'package:carrot_market_sample/page/detail.dart';
import 'package:carrot_market_sample/repository/contents_repository.dart';
import 'package:carrot_market_sample/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String currentLocation = 'ara';
  ContentsRepository contentsRepository = ContentsRepository();

  //if문도 가능하다 아라 = ara
  final Map<String, String> locationTypeToString = {
    'ara': '아라동',
    'ora': '오라동',
    'donam': '도남동'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {},
          child: PopupMenuButton<String>(
            offset: Offset(0, 27),
            shape: ShapeBorder.lerp(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                1),
            onSelected: (String where) {
              setState(() {
                currentLocation = where;
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(value: 'ara', child: Text('아라동')),
                PopupMenuItem(value: 'ora', child: Text('오라동')),
                PopupMenuItem(value: 'donam', child: Text('도남동')),
              ];
            },
            child: Row(
              children: [
                Text(locationTypeToString[currentLocation]!), //아라동
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        elevation: 1,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.tune)),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/svg/bell.svg",
              width: 22,
            ),
          ),
        ],
      ),
      body: _bodyWidget(),
    );
  }

  _loadContents() {
    return contentsRepository.loadContentsFromLocation(currentLocation);
  }

  _makeDataList(List<Map<String, String>> datas) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 10), //seperate까지 padding 주기위해..
      itemBuilder: (BuildContext _context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailContentView(data: datas[index])),
            );
            //print(datas[index]["title"]);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Hero(
                    tag: datas[index]["cid"]!,
                    child: Image.asset(
                      datas[index]["image"]!,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          datas[index]["title"]!,
                          overflow:
                              TextOverflow.ellipsis, //텍스트가 오버플로우 될시 ...으로 표시
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(height: 5),
                        Text(
                          datas[index]["location"]!,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.3)),
                        ),
                        SizedBox(height: 5),
                        Text(DataUtils.calcStringToWon(datas[index]["price"]!)),
                        SizedBox(height: 5),
                        Container(
                          color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SvgPicture.asset(
                                "assets/svg/heart_off.svg",
                                width: 13,
                                height: 13,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(datas[index]["likes"]!),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext _context, int index) {
        return Container(
          height: 1,
          color: Colors.black.withOpacity(0.2),
        );
      },
      itemCount: datas.length,
    );
  }

//null처리가 잘 되지 않았음. (두번짼가 세번째 카테고리)
  Widget _bodyWidget() {
    List<Map<String, String>> datas = _loadContents();
    if (datas.isNotEmpty) {
      return _makeDataList(datas);
    } else
      return Center(child: Text('데이터가 없습니다.'));
  }
}
  

  // Widget _bodyWidget() {
  //   //데이터가 언제올지 모르니까..
  //   //Buildcontext dynamic
  //   return FutureBuilder(
  //       future: _loadContents(),
  //       builder: (context, snapshot) {
          
  //           List<Map<String, String>> datas = snapshot.data;
        
          
  //         //Object? datas = snapshot.data;

  //         return ListView.separated(
  //             padding:
  //                 EdgeInsets.symmetric(horizontal: 10), //seperate까지 띄우기위해..
  //             itemBuilder: (BuildContext _context, int index) {
  //               return Container(
  //                 padding: const EdgeInsets.symmetric(vertical: 10),
  //                 child: Row(
  //                   children: [
  //                     ClipRRect(
  //                       borderRadius: BorderRadius.all(Radius.circular(10)),
  //                       child: Image.asset(
  //                         datas[index]["image"]!,
  //                         width: 100,
  //                         height: 100,
  //                       ),
  //                     ),
  //                     Expanded(
  //                       child: Container(
  //                         height: 100,
  //                         padding: EdgeInsets.only(left: 20),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               datas[index]["title"]!,
  //                               overflow: TextOverflow.ellipsis,
  //                               style: TextStyle(fontSize: 15),
  //                             ),
  //                             SizedBox(height: 5),
  //                             Text(
  //                               datas[index]["location"]!,
  //                               style: TextStyle(
  //                                   fontSize: 12,
  //                                   color: Colors.black.withOpacity(0.3)),
  //                             ),
  //                             SizedBox(height: 5),
  //                             Text(calcStringToWon(datas[index]["price"]!)),
  //                             SizedBox(height: 5),
  //                             Container(
  //                               color: Colors.red,
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.end,
  //                                 children: [
  //                                   SvgPicture.asset(
  //                                     "assets/svg/heart_off.svg",
  //                                     width: 13,
  //                                     height: 13,
  //                                   ),
  //                                   SizedBox(
  //                                     width: 5,
  //                                   ),
  //                                   Text(datas[index]["likes"]!),
  //                                 ],
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               );
  //             },
  //             separatorBuilder: (BuildContext _context, int index) {
  //               return Container(
  //                 height: 1,
  //                 color: Colors.black.withOpacity(0.2),
  //               );
  //             },
  //             itemCount: 10);
  //       });
  

  //   return ListView.separated(
  //       padding: EdgeInsets.symmetric(horizontal: 10), //seperate까지 띄우기위해..
  //       itemBuilder: (BuildContext _context, int index) {
  //         return Container(
  //           padding: const EdgeInsets.symmetric(vertical: 10),
  //           child: Row(
  //             children: [
  //               ClipRRect(
  //                 borderRadius: BorderRadius.all(Radius.circular(10)),
  //                 child: Image.asset(
  //                   datas[index]["image"]!,
  //                   width: 100,
  //                   height: 100,
  //                 ),
  //               ),
  //               Expanded(
  //                 child: Container(
  //                   height: 100,
  //                   padding: EdgeInsets.only(left: 20),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         datas[index]["title"]!,
  //                         overflow: TextOverflow.ellipsis,
  //                         style: TextStyle(fontSize: 15),
  //                       ),
  //                       SizedBox(height: 5),
  //                       Text(
  //                         datas[index]["location"]!,
  //                         style: TextStyle(
  //                             fontSize: 12,
  //                             color: Colors.black.withOpacity(0.3)),
  //                       ),
  //                       SizedBox(height: 5),
  //                       Text(calcStringToWon(datas[index]["price"]!)),
  //                       SizedBox(height: 5),
  //                       Container(
  //                         color: Colors.red,
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.end,
  //                           children: [
  //                             SvgPicture.asset(
  //                               "assets/svg/heart_off.svg",
  //                               width: 13,
  //                               height: 13,
  //                             ),
  //                             SizedBox(
  //                               width: 5,
  //                             ),
  //                             Text(datas[index]["likes"]!),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               )
  //             ],
  //           ),
  //         );
  //       },
  //       separatorBuilder: (BuildContext _context, int index) {
  //         return Container(
  //           height: 1,
  //           color: Colors.black.withOpacity(0.2),
  //         );
  //       },
  //       itemCount: 10);
  // }


// ListView.separated(
//             padding: EdgeInsets.symmetric(horizontal: 10), //seperate까지 띄우기위해..
//             itemBuilder: (BuildContext _context, int index) {
//               return Container(
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 child: Row(
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                       child: Image.asset(
//                         datas[index]["image"]!,
//                         width: 100,
//                         height: 100,
//                       ),
//                     ),
//                     Expanded(
//                       child: Container(
//                         height: 100,
//                         padding: EdgeInsets.only(left: 20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               datas[index]["title"]!,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(fontSize: 15),
//                             ),
//                             SizedBox(height: 5),
//                             Text(
//                               datas[index]["location"]!,
//                               style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.black.withOpacity(0.3)),
//                             ),
//                             SizedBox(height: 5),
//                             Text(calcStringToWon(datas[index]["price"]!)),
//                             SizedBox(height: 5),
//                             Container(
//                               color: Colors.red,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   SvgPicture.asset(
//                                     "assets/svg/heart_off.svg",
//                                     width: 13,
//                                     height: 13,
//                                   ),
//                                   SizedBox(
//                                     width: 5,
//                                   ),
//                                   Text(datas[index]["likes"]!),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               );
//             },
//             separatorBuilder: (BuildContext _context, int index) {
//               return Container(
//                 height: 1,
//                 color: Colors.black.withOpacity(0.2),
//               );
//             },
//             itemCount: 10);