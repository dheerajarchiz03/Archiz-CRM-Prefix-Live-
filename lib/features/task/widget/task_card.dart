import 'package:archiz_cxm360/common/components/divider/custom_divider.dart';
import 'package:archiz_cxm360/common/components/text/text_icon.dart';
import 'package:archiz_cxm360/core/helper/date_converter.dart';
import 'package:archiz_cxm360/core/helper/string_format_helper.dart';
import 'package:archiz_cxm360/core/route/route.dart';
import 'package:archiz_cxm360/core/utils/color_resources.dart';
import 'package:archiz_cxm360/core/utils/dimensions.dart';
import 'package:archiz_cxm360/core/utils/style.dart';
import 'package:archiz_cxm360/features/task/model/tasks_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task});
  final Task task;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteHelper.taskDetailsScreen, arguments: task.id!);
      },
      child: Card(
        margin: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                left: BorderSide(
                  width: 5.0,
                  color: ColorResources.taskStatusColor(task.status!),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width / 1.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${task.name}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: Dimensions.space3),
                            Text(
                              task.projectData?.name ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: lightSmall.copyWith(
                                color: ColorResources.blueGreyColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            Converter.taskPriorityString(task.priority ?? ''),
                            style: regularDefault.copyWith(
                              color: ColorResources.taskStatusColor(
                                task.priority ?? '',
                              ),
                            ),
                          ),
                          const SizedBox(height: Dimensions.space3),
                          Text(
                            task.relType?.capitalizeFirst ?? '-',
                            style: lightSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const CustomDivider(space: Dimensions.space10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextIcon(
                        text: Converter.taskStatusString(task.status ?? ''),
                        icon: Icons.check_circle_outline_rounded,
                      ),
                      TextIcon(
                        text: DateConverter.formatValidityDate(
                          task.dateAdded ?? '',
                        ),
                        icon: Icons.calendar_month,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
