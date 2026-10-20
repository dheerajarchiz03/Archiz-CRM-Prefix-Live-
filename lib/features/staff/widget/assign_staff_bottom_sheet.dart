import 'package:async/async.dart';
import 'package:archiz_cxm360/common/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:archiz_cxm360/common/components/buttons/rounded_button.dart';
import 'package:archiz_cxm360/common/components/buttons/rounded_loading_button.dart';
import 'package:archiz_cxm360/common/components/custom_drop_down_button_with_text_field.dart';
import 'package:archiz_cxm360/common/components/custom_loader/custom_loader.dart';
import 'package:archiz_cxm360/common/components/text-form-field/custom_drop_down_text_field.dart';
import 'package:archiz_cxm360/core/utils/color_resources.dart';
import 'package:archiz_cxm360/core/utils/dimensions.dart';
import 'package:archiz_cxm360/core/utils/local_strings.dart';
import 'package:archiz_cxm360/core/utils/style.dart';
import 'package:archiz_cxm360/features/staff/controller/staff_controller.dart';
import 'package:archiz_cxm360/features/staff/model/staff_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssignStaffBottomSheet extends StatefulWidget {
  const AssignStaffBottomSheet({super.key});

  @override
  State<AssignStaffBottomSheet> createState() => _AssignStaffBottomSheetState();
}

class _AssignStaffBottomSheetState extends State<AssignStaffBottomSheet> {
  final AsyncMemoizer<StaffsModel> staffMemoizer = AsyncMemoizer();

  @override
  void dispose() {
    Get.find<StaffController>().transferDataTo = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StaffController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Dimensions.space10,
          children: [
            BottomSheetHeaderRow(
              header: LocalStrings.deleteStaff.tr,
              bottomSpace: 0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.space10),
              child: Text(
                LocalStrings.transferDatadesc.tr,
                style: lightDefault,
              ),
            ),
            FutureBuilder(
              future: staffMemoizer.runOnce(controller.loadOtherStaff),
              builder: (context, staffList) {
                if (staffList.data?.status ?? false) {
                  return CustomDropDownTextField(
                    needLabel: true,
                    labelText: LocalStrings.staffMember.tr,
                    hintText: LocalStrings.selectStaff.tr,
                    onChanged: (value) {
                      controller.transferDataTo = value.toString();
                    },
                    selectedValue: controller.transferDataTo,
                    items: controller.otherStaffsModel.data!.map((value) {
                      return DropdownMenuItem(
                        value: value.id,
                        child: Text(
                          value.fullName?.tr ?? '',
                          style: regularDefault.copyWith(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.color,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                } else if (staffList.data?.status == false) {
                  return CustomDropDownWithTextField(
                    selectedValue: LocalStrings.noSourceFound.tr,
                    list: [LocalStrings.noSourceFound.tr],
                  );
                } else {
                  return const CustomLoader(isFullScreen: false);
                }
              },
            ),
            const SizedBox(height: Dimensions.space20),
            controller.isSubmitLoading
                ? const RoundedLoadingBtn()
                : RoundedButton(
                    text: LocalStrings.confirm.tr,
                    color: ColorResources.colorRed,
                    press: () {
                      Get.back();
                      Get.find<StaffController>().deleteStaff();
                      Navigator.pop(context);
                    },
                  ),
            const SizedBox(height: Dimensions.space10),
          ],
        );
      },
    );
  }
}
