import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Teste GetX'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = Get.put(GetXControl());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: controller.tabPages.value.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: AppBar(
            toolbarHeight: 30,
            actions: [
              TabBar(
                indicatorColor: Colors.red,
                dividerColor: Colors.white,
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                tabs: controller.tabPages.value,
              ),
              const Spacer()
            ],

            // bottom: ,
          ),
        ),
        body: TabBarView(
          children: [
            Pagina(tag: 'Aba1'),
            Pagina(tag: 'Aba2'),
          ],
        ),
      ),
    );
  }
}

class GetXControl extends GetxController {
  final tabPages = <Tab>[].obs;
  final bgColor = Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);


  final tecUltimo = TextEditingController();
  final tecDisabled = TextEditingController();

  var listaTeste = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    tecUltimo.addListener(() {
      debugPrint('${tecDisabled.text}/${tecUltimo.text}');
      tecDisabled.text = tecUltimo.text;
    });
    tabPages.value = [
      tabWidget(
        title: 'Aba1',
      ),
      tabWidget(
        title: 'Aba2',
      ),
    ];
  }

  @override
  void onClose() {
    tecUltimo.dispose();
    super.onClose();
  }

  Tab tabWidget({String? title}) {
    return Tab(
      height: 30,
      child: Container(
        padding: const EdgeInsets.all(2.0),
        width: 120,
        child: Row(
          children: [
            SizedBox(
              width: 80,
              child: Text(
                title ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Pagina extends StatelessWidget {
  final String tag;

  Pagina({super.key, required this.tag}) {
    Get.lazyPut(() => GetXControl(), tag: tag);
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<GetXControl>(tag: tag);

    return Container(
      color: controller.bgColor,
      child: Column(
        children: [
          Container(
            width: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              controller: controller.tecUltimo,
              onFieldSubmitted: (value) => controller.listaTeste.add(value),
            ),
          ),
                    Container(
            width: 200,
            
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              enabled: false,
              controller: controller.tecDisabled,
              onFieldSubmitted: (value) => controller.listaTeste.add(value),
            ),
          ),
          Obx(
            () {
              return Expanded(
                child: ListView.builder(
                  itemCount: controller.listaTeste.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(controller.listaTeste[index]),
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
