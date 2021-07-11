import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mount_slamet/bloc/blog/blog_bloc.dart';
import 'package:mount_slamet/controllers/home_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
import 'package:html/dom.dart' as dom;

class InformasiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BlogBloc()..add(GetInformasiBlogEvent()),
      child: InformasiView(),
    );
  }
}

class InformasiView extends StatelessWidget {
  HomeController homeController;

  BlogBloc bloc;

  @override
  Widget build(BuildContext context) {
    homeController = Get.find<HomeController>();
    bloc = BlocProvider.of<BlogBloc>(context);
    return BlocConsumer<BlogBloc, BlogState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var html = loadingState();
        if (state is BlogStateSuccess) {
          print(state.data['data']);
          html = Html(
              data: """${state.data['data']['blog_isi'] ?? ""}""",
              onImageTap: (String url, RenderContext context,
                  Map<String, String> attributes, dom.Element element) {
                _launchURL(url);
                //open image in webview, or launch image in browser, or any other logic here
              },
              onLinkTap: (String url, RenderContext context,
                  Map<String, String> attributes, dom.Element element) {
                _launchURL(url);
              });
        }
        return ScreenUtilInit(
            designSize: Size(Constants.screenWidth, Constants.screenHeight),
            builder: () => Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    title: Txt(
                      "Informasi",
                      style: TxtStyle()..textColor(Colors.black87),
                    ),
                    iconTheme: IconThemeData(color: Colors.black87),
                  ),
                  body: SingleChildScrollView(child: Center(child: html)),
                ));
      },
    );
  }

  void _launchURL(_url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
  Widget loadingState() {
    return Parent(
      style: ParentStyle()
        ..ripple(true, splashColor: Colors.blueAccent)
        ..width(1.sw),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 10),
          Text(
            "Mengambil Data",
          ),
        ],
      ),
    );
  }
}
