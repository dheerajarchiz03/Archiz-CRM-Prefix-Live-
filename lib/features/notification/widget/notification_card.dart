import 'package:archiz_cxm360/common/components/card/custom_card.dart';
import 'package:archiz_cxm360/common/components/divider/custom_divider.dart';
import 'package:archiz_cxm360/common/components/text/text_icon.dart';
import 'package:archiz_cxm360/core/utils/dimensions.dart';
import 'package:archiz_cxm360/core/utils/style.dart';
import 'package:archiz_cxm360/features/notification/model/notifications_model.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
  });
  final Notifications notification;

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
            if (notification.fromFullName?.isNotEmpty ?? false)
              Text(
                notification.fromFullName ?? '',
                maxLines: 3,
                style: regularDefault,
              ),
            Text(
              notification.formattedDescription ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: lightDefault,
            ),
            const CustomDivider(space: Dimensions.space10),
            TextIcon(
                text: notification.date ?? '',
                icon: Icons.calendar_month_outlined),
          ],
        ),
      ),
    );
  }
}
