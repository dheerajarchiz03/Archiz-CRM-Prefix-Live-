import 'package:archiz_cxm360/common/components/app-bar/custom_appbar.dart';
import 'package:archiz_cxm360/common/components/custom_fab.dart';
import 'package:archiz_cxm360/common/components/custom_loader/custom_loader.dart';
import 'package:archiz_cxm360/common/components/no_data.dart';
import 'package:archiz_cxm360/common/components/overview_card.dart';
import 'package:archiz_cxm360/common/components/search_field.dart';
import 'package:archiz_cxm360/common/components/text/text_icon.dart';
import 'package:archiz_cxm360/core/route/route.dart';
import 'package:archiz_cxm360/core/service/api_service.dart';
import 'package:archiz_cxm360/core/utils/color_resources.dart';
import 'package:archiz_cxm360/core/utils/dimensions.dart';
import 'package:archiz_cxm360/core/utils/local_strings.dart';
import 'package:archiz_cxm360/features/estimate/controller/estimate_controller.dart';
import 'package:archiz_cxm360/features/estimate/repo/estimate_repo.dart';
import 'package:archiz_cxm360/features/estimate/widget/estimate_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class EstimateScreen extends StatefulWidget {
  const EstimateScreen({super.key});

  @override
  State<EstimateScreen> createState() => _EstimateScreenState();
}

class _EstimateScreenState extends State<EstimateScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(EstimateRepo(apiClient: Get.find()));
    final controller = Get.put(EstimateController(estimateRepo: Get.find()));
    controller.isLoading = true;
    super.initState();
    handleScroll();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initialData();
    });
  }

  bool showFab = true;
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  void handleScroll() async {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (showFab) setState(() => showFab = false);
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!showFab) setState(() => showFab = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EstimateController>(builder: (controller) {
      return Scaffold(
        appBar: CustomAppBar(
          title: LocalStrings.estimates.tr,
          isShowActionBtn: true,
          actionWidget: IconButton(
              onPressed: () => controller.changeSearchIcon(),
              icon: Icon(controller.isSearch ? Icons.clear : Icons.search)),
        ),
        floatingActionButton: AnimatedSlide(
          offset: showFab ? Offset.zero : const Offset(0, 2),
          duration: const Duration(milliseconds: 300),
          child: AnimatedOpacity(
            opacity: showFab ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: CustomFAB(
                isShowIcon: true,
                isShowText: false,
                press: () {
                  Get.toNamed(RouteHelper.addEstimateScreen);
                }),
          ),
        ),
        body: controller.isLoading
            ? const CustomLoader()
            : RefreshIndicator(
                color: Theme.of(context).primaryColor,
                backgroundColor: Theme.of(context).cardColor,
                onRefresh: () async {
                  await controller.initialData(shouldLoad: false);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  child: Column(
                    children: [
                      Visibility(
                        visible: controller.isSearch,
                        child: SearchField(
                          title: LocalStrings.estimateDetails.tr,
                          searchController: controller.searchController,
                          onTap: () => controller.searchEstimate(),
                        ),
                      ),
                      if (controller.estimatesModel.overview != null)
                        ExpansionTile(
                          title: Row(
                            children: [
                              Container(
                                width: Dimensions.space3,
                                height: Dimensions.space15,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: Dimensions.space5),
                              Text(
                                LocalStrings.estimateSummery.tr,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                          shape: const Border(),
                          initiallyExpanded: true,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.space15),
                              child: SizedBox(
                                height: 80,
                                child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return OverviewCard(
                                          name: controller.estimatesModel
                                              .overview![index].status!.tr,
                                          number: controller.estimatesModel
                                              .overview![index].total
                                              .toString(),
                                          color: ColorResources.blueColor);
                                    },
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                            width: Dimensions.space5),
                                    itemCount: controller
                                        .estimatesModel.overview!.length),
                              ),
                            ),
                          ],
                        ),
                      Padding(
                        padding: const EdgeInsets.all(Dimensions.space15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocalStrings.estimates.tr,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            InkWell(
                              onTap: () {},
                              child: TextIcon(
                                  text: LocalStrings.filter.tr,
                                  icon: Icons.sort_outlined),
                            ),
                          ],
                        ),
                      ),
                      controller.estimatesModel.data?.isNotEmpty ?? false
                          ? ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.space15),
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return EstimateCard(
                                  index: index,
                                  estimateModel: controller.estimatesModel,
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: Dimensions.space10),
                              itemCount: controller.estimatesModel.data!.length)
                          : const NoDataWidget(),
                    ],
                  ),
                ),
              ),
      );
    });
  }
}
