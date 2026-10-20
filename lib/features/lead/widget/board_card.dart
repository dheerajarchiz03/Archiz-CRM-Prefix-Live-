import 'package:archiz_cxm360/common/components/card/custom_card.dart';
import 'package:archiz_cxm360/common/components/divider/custom_divider.dart';
import 'package:archiz_cxm360/common/components/text/text_icon.dart';
import 'package:archiz_cxm360/core/helper/date_converter.dart';
import 'package:archiz_cxm360/core/route/route.dart';
import 'package:archiz_cxm360/core/utils/color_resources.dart';
import 'package:archiz_cxm360/core/utils/dimensions.dart';
import 'package:archiz_cxm360/core/utils/style.dart';
import 'package:archiz_cxm360/features/lead/model/lead_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BoardCard extends StatelessWidget {
  final Lead lead;

  const BoardCard({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteHelper.leadDetailsScreen, arguments: lead.id!);
      },
      child: CustomCard(
        margin: const EdgeInsets.only(
            top: Dimensions.space8,
            right: Dimensions.space5,
            left: Dimensions.space5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${lead.name}',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: regularLarge,
            ),
            const SizedBox(height: Dimensions.space5),
            Text(
              '${lead.title} - ${lead.company}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: lightSmall.copyWith(color: ColorResources.blueGreyColor),
            ),
            const SizedBox(height: Dimensions.space5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lead.leadValue ?? '-',
                  style: regularDefault,
                ),
                Text(
                  lead.sourceName ?? '-',
                  style: lightSmall,
                ),
              ],
            ),
            const CustomDivider(space: Dimensions.space5),
            TextIcon(
              text: DateConverter.formatValidityDate(lead.dateAdded ?? ''),
              icon: Icons.calendar_month,
            ),
          ],
        ),
      ),
    );
  }
}
