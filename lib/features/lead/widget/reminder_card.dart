import 'package:archiz_cxm360/common/components/card/custom_card.dart';
import 'package:archiz_cxm360/common/components/divider/custom_divider.dart';
import 'package:archiz_cxm360/common/components/text/text_icon.dart';
import 'package:archiz_cxm360/core/utils/dimensions.dart';
import 'package:archiz_cxm360/core/utils/local_strings.dart';
import 'package:archiz_cxm360/core/utils/style.dart';
import 'package:archiz_cxm360/features/lead/model/reminders_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReminderCard extends StatelessWidget {
  const ReminderCard({
    super.key,
    required this.reminder,
  });
  final Reminder reminder;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Mark as read
      },
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reminder.description ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: lightDefault,
            ),
            const CustomDivider(space: Dimensions.space10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextIcon(
                  text: reminder.date ?? '',
                  icon: Icons.calendar_month_outlined,
                ),
                TextIcon(
                  text: (reminder.isNotified == '0')
                      ? LocalStrings.notNotified.tr
                      : LocalStrings.notified.tr,
                  icon: (reminder.isNotified == '0')
                      ? Icons.not_interested_outlined
                      : Icons.done,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
