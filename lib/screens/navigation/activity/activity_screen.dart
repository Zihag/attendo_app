import 'package:flutter/material.dart';
import 'package:fw_tab_bar/fw_tab_bar.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Lắng nghe thay đổi của TabController để cập nhật giao diện
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {}); // Đồng bộ giao diện khi tab thay đổi
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Activity Screen'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[300],
            child: TabBarWidget(
              firstTab: 'Today',
              secondTab: 'All',
              currentIndex: _tabController.index, // Cập nhật index hiện tại từ TabController
              
              onTabChanged: (int index) {
                _tabController.animateTo(index); // Đồng bộ TabController khi người dùng nhấn
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController, // Kết nối với TabController
              physics: NeverScrollableScrollPhysics(),
              children: const <Widget>[
                Center(child: Text("Today Activities")),
                Center(child: Text("All Activities")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
