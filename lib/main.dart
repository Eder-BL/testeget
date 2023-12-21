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
      home: MyHomePage(title: 'Teste GetX'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
 
  MyHomePage({super.key, required this.title}) {
    Get.lazyPut(() => GControl());
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<GControl>();

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
            Get.put(Pagina(tag: 'Aba1'), tag: 'Aba1'),
            Get.put(Pagina(tag: 'Aba2'), tag: 'Aba2'),
          ],
        ),
      ),
    );
  }
}

class GControl extends GetxController {
  final tabPages = <Tab>[].obs;
  final bgColor = Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

  final tecUltimo = TextEditingController();
  final tecDisabled = TextEditingController();

  var msg = 'Mensagem de teste'.obs;

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
    Get.lazyPut(() => GControl(), tag: tag);
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<GControl>(tag: tag);
    var nomeEstranho = 'nomeEstranho'.obs;

    return Container(
      color: controller.bgColor,
      child: Column(
        children: [
          Row(
            children: [
              Obx(
                () => Text(controller.msg.value),
              ),
              Container(
                width: 20,
                height: 20,
                color: Colors.red,
              ),
              Obx(
                () => Text(nomeEstranho.value),
              ),
            ],
          ),
          Container(
            width: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              controller: controller.tecUltimo,
              onFieldSubmitted: (value) {
                controller.listaTeste.add(value);
                nomeEstranho.value = value;
                controller.msg.value = value;
              },
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
              onFieldSubmitted: (value) {
                controller.listaTeste.add(value);
                nomeEstranho.value = value;
              },
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
