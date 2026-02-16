import 'package:archiz_prefix_crm/common/components/divider/custom_divider.dart';
import 'package:archiz_prefix_crm/common/components/text/text_icon.dart';
import 'package:archiz_prefix_crm/core/helper/date_converter.dart';
import 'package:archiz_prefix_crm/core/helper/string_format_helper.dart';
import 'package:archiz_prefix_crm/core/route/route.dart';
import 'package:archiz_prefix_crm/core/utils/color_resources.dart';
import 'package:archiz_prefix_crm/core/utils/dimensions.dart';
import 'package:archiz_prefix_crm/core/utils/style.dart';
import 'package:archiz_prefix_crm/features/ticket/model/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VisitCard extends StatelessWidget {
  const VisitCard({super.key, required this.index, required this.ticketModel});

  final int index;
  final TicketsModel ticketModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          RouteHelper.visitDetailsScreen,
          arguments: ticketModel.data![index].id!,
        );
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
                  color: ColorResources.ticketStatusColor(
                    ticketModel.data![index].status!,
                  ),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${ticketModel.data![index].company}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.space0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width / 2,
                        child: Text(
                          Converter.parseHtmlString(
                            ticketModel.data![index].userFirstName ?? '',
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: lightSmall.copyWith(
                            color: ColorResources.blueGreyColor,
                          ),
                        ),
                      ),
                      // Text(ticketModel.data![index].priorityName?.tr ?? '',
                      //     style: lightSmall.copyWith(
                      //         color: ColorResources.ticketPriorityColor(
                      //             ticketModel.data![index].priority ?? ''))),
                    ],
                  ),
                  const SizedBox(height: Dimensions.space5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Distance in KM: ${ticketModel.data![index].id ?? '0'}',
                        style: lightSmall.copyWith(
                          color: ColorResources.blueGreyColor,
                          fontSize: Dimensions.space12,
                        ),
                      ),
                      Text(
                        'Rate per KM : ${ticketModel.data![index].status ?? 'Pending'}',
                        style: lightSmall.copyWith(
                          color: ColorResources.blueColor,
                          fontSize: Dimensions.space12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.space5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        // 'Status: ${ticketModel.data![index].id ?? '0'}',
                        'Status: ${ 'Visit Done'}',
                        style: lightSmall.copyWith(
                          color: ColorResources.blueGreyColor,
                          fontSize: Dimensions.space12,
                        ),
                      ),
                      Text(
                        'Expense: Rs.  ${ticketModel.data![index].status ?? 'Pending'}',
                        style: lightSmall.copyWith(
                          // color: ColorResources.ticketStatusColor(
                          //   ticketModel.data![index].status ?? '',
                          // ),
                          color: ColorResources.blueColor,
                          fontSize: Dimensions.space12,
                        ),
                      ),
                    ],
                  ),
                  const CustomDivider(space: Dimensions.space10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextIcon(
                        text: ticketModel.data![index].company ?? '',
                        icon: Icons.create_sharp,
                      ),
                      TextIcon(
                        text: DateConverter.formatValidityDate(
                            ticketModel.data![index].dateCreated ?? ''),
                        icon: Icons.calendar_month,
                      ),
                    ],
                  )
                  // const CustomDivider(space: Dimensions.space5),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     TextIcon(
                  //       text: ticketModel.data![index].company ?? '',
                  //       icon: Icons.account_box_rounded,
                  //       textStyle: regularDefault.copyWith(
                  //         fontSize: Dimensions.space12,
                  //       ),
                  //     ),
                  //     TextIcon(
                  //       text: DateConverter.formatValidityDate(
                  //         ticketModel.data![index].dateCreated ?? '',
                  //       ),
                  //       icon: Icons.calendar_month,
                  //       textStyle: regularDefault.copyWith(
                  //         fontSize: Dimensions.space12,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
