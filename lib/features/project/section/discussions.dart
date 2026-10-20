import 'package:archiz_cxm360/common/components/custom_loader/custom_loader.dart';
import 'package:archiz_cxm360/common/components/no_data.dart';
import 'package:archiz_cxm360/core/service/api_service.dart';
import 'package:archiz_cxm360/core/utils/dimensions.dart';
import 'package:archiz_cxm360/features/project/controller/project_controller.dart';
import 'package:archiz_cxm360/features/project/repo/project_repo.dart';
import 'package:archiz_cxm360/features/project/widget/discussion_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectDiscussions extends StatefulWidget {
  const ProjectDiscussions({super.key, required this.id});
  final String id;

  @override
  State<ProjectDiscussions> createState() => _ProjectDiscussionsState();
}

class _ProjectDiscussionsState extends State<ProjectDiscussions> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(ProjectRepo(apiClient: Get.find()));
    final controller = Get.put(ProjectController(projectRepo: Get.find()));
    controller.isLoading = true;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadProjectGroup(widget.id, 'discussions');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectController>(
      builder: (controller) {
        return Scaffold(
          body: controller.isLoading
              ? const CustomLoader()
              : controller.projectDiscussionsModel.status ?? false
              ? RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Theme.of(context).cardColor,
                  onRefresh: () async {
                    controller.loadProjectGroup(widget.id, 'discussions');
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(Dimensions.space15),
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return DiscussionCard(
                        discussion:
                            controller.projectDiscussionsModel.data![index],
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: Dimensions.space10),
                    itemCount: controller.projectDiscussionsModel.data!.length,
                  ),
                )
              : const Center(child: NoDataWidget()),
        );
      },
    );
  }
}
