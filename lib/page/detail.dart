import 'package:carrot_market_sample/components/manor_temperature_widget.dart';
import 'package:carrot_market_sample/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailContentView extends StatefulWidget {
  final Map<String, String> data;
  const DetailContentView({super.key, required this.data});

  @override
  State<DetailContentView> createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView>
    with TickerProviderStateMixin {
  late Size size;
  late List<String> imgList;
  double scrollpositionToAlpha = 0;
  int _current = 0;
  //List<Map<String, String>> imgList;
  ScrollController _controller = ScrollController();
  late AnimationController _animationController;
  late Animation _colorTween;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _colorTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_animationController);
    _controller.addListener(() {
      setState(() {
        if (_controller.offset > 255) {
          scrollpositionToAlpha = 255;
        } else {
          scrollpositionToAlpha = _controller.offset;
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _current = 0;
    size = MediaQuery.of(context).size;
    imgList = [
      //null처리를 꼭 해야하나?
      widget.data['image'] ?? '',
      widget.data['image'] ?? '',
      widget.data['image'] ?? '',
      widget.data['image'] ?? '',
      widget.data['image'] ?? '',
    ];

    // imgList = [
    //   {'id': '0', 'url': widget.data['image'] ?? ''},
    //   {'id': '1', 'url': widget.data['image'] ?? ''},
    //   {'id': '2', 'url': widget.data['image'] ?? ''},
    //   {'id': '3', 'url': widget.data['image'] ?? ''},
    //   {'id': '4', 'url': widget.data['image'] ?? ''},
    // ];
  }

  // PreferredSizeWidget _appBarWidget() {
  //   return AppBar(
  //     backgroundColor: Colors.transparent,
  //     elevation: 0,

  //     //leading 은 불필요하기도 하다 근데 색 바꾸는거랑.. 뭐때문에.. 한다고..
  //     leading: IconButton(
  //       onPressed: () {
  //         Navigator.pop(context);
  //       },
  //       icon: Icon(Icons.arrow_back, color: Colors.white),
  //     ),

  //     actions: [
  //       IconButton(
  //           onPressed: () {}, icon: Icon(Icons.share, color: Colors.white)),
  //       IconButton(
  //           onPressed: () {}, icon: Icon(Icons.more_vert, color: Colors.white)),
  //     ],
  //   );
  // }

  PreferredSizeWidget _appBarWidget() {
    return AppBar(
      backgroundColor: Colors.white.withAlpha(scrollpositionToAlpha.toInt()),
      elevation: 0,

      //leading 은 불필요하기도 하다 근데 색 바꾸는거랑.. 뭐때문에.. 한다고..
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back, color: Colors.white),
      ),

      actions: [
        IconButton(
            onPressed: () {}, icon: Icon(Icons.share, color: Colors.white)),
        IconButton(
            onPressed: () {}, icon: Icon(Icons.more_vert, color: Colors.white)),
      ],
    );
  }

  Widget _makeSliderImage() {
    return Container(
        child: Stack(children: [
      Hero(
        tag: widget.data['cid'] ?? '', // 더 나은 코드 있나 생각해보기
        child: CarouselSlider(
          items: imgList.map((url) {
            return Image.asset(url, width: size.width, fit: BoxFit.fill);
          }).toList(),

          // items: imgList.map((map) {
          //   return Image.asset(map[url], width: size.width, fit: BoxFit.fill);
          // }).toList(),

          //carouselController: _controller,
          options: CarouselOptions(
            height: size.width,
            initialPage: 0,

            enableInfiniteScroll: false,
            viewportFraction: 1, //0.5는 절반 1은 100%
            onPageChanged: (index, reason) {
              print(index);
              setState(() {
                _current = index;
              });
            },

            // autoPlay: true,
            // enlargeCenterPage: true,
            // aspectRatio: 2.0,
            // onPageChanged: (index, reason) {
            //   setState(() {
            //     _current = index;
            //   });
            // }),
          ),

          // Image.asset(widget.data['image'] ?? '',
          //     width: size.width, fit: BoxFit.fill),
        ),
      ),
      // 이미지 인디케이터
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.asMap().entries.map((entry) {
            return GestureDetector(
                //onTap: () => _controller.animateToPage(entry.key),
                child: Container(
              width: 10.0,
              height: 10.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    (Colors.red.withOpacity(_current == entry.key ? 1 : 0.4)),
              ),
            ));
          }).toList(),
        ),
      ),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: imgList.map((url) {
      //  return Container(
      //   width : 8.0,
      //   height : 8.0,
      //   margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
      //   decoration: BoxDecoration(
      //     shape: BoxShape.circle,
      //     color: _current == int.parse(map['id'])
      //     ? Color.fromRGBO(0, 0, 0, 0.9)
      //     : Color.fromRGBO(0, 0, 0, 0.4)),);}).toList(),),
    ]));
  }

  Widget _sellerSimpleInfo() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage('assets/images/user.png'),
        ),
        SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('판매자닉네임',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text('많이 사주세요.'),
        ]),
        Expanded(child: ManorTemperatureWidget(manorTemp: 30)),
      ]),
    );
  }

  Widget _line() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      color: Colors.grey.withOpacity(0.3),
    );
  }

  Widget _contentDetail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Text(
            widget.data["title"] as String,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "디지털/가전 ∙ 22시간 전",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 15),
          Text(
            "선물받은 새상품이고\n상품 꺼내보기만 했습니다\n거래는 직거래만 합니다.",
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          SizedBox(height: 15),
          Text(
            "채팅 3 ∙ 관심 17 ∙ 조회 295",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  // Widget _bodyWidget() {
  //더 길어지면 스크롤 가능하게..
  //return SingleChildScrollView(
  // Column(children: [
  //     _makeSliderImage(),
  //     _sellerSimpleInfo(),
  //     _line(),
  //     _contentDetail(),
  //     _line(),
  //     _otherCellContents(),
  //   ]),

  //판매자님의 판매상품 그리드뷰를 위한..
  Widget _bodyWidget() {
    //판매자님의 판매상품 그리드뷰를 위한..
    return CustomScrollView(controller: _controller, slivers: [
      SliverList(
        delegate: SliverChildListDelegate(
          [
            _makeSliderImage(),
            _sellerSimpleInfo(),
            _line(),
            _contentDetail(),
            _line(),
            _otherCellContents(),
          ],
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
          delegate: SliverChildListDelegate(List.generate(20, (index) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: Colors.grey.withOpacity(0.3),
                      height: 120,
                    ),
                  ),
                  Text(
                    "상품 제목",
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    "금액",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }).toList()),
        ),
      ),
    ]);
  }

  Widget _otherCellContents() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "판매자님의 판매 상품",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "모두보기",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomBarWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      width: size.width,
      height: 55,
      //color: Colors.red,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: SvgPicture.asset("assets/svg/heart_off.svg",
                width: 25, height: 25),
          ),
          Container(
            //margin:
            //    EdgeInsets.symmetric(horizontal: 15), //이것도 똑같아보이는데 차이점이 있나..
            margin: EdgeInsets.only(left: 15, right: 10),
            width: 1,
            height: 25,
            color: Colors.grey.withOpacity(0.3),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DataUtils.calcStringToWon(widget.data["price"] as String),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('가격제안 불가',
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  decoration: BoxDecoration(
                    color: Color(0xfff08f4f),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text("채팅하기")),
            ],
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _appBarWidget(),
        body: _bodyWidget(),
        bottomNavigationBar: _bottomBarWidget());
  }
}
