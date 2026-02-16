import 'package:async/async.dart';
import 'package:archiz_prefix_crm/common/components/app-bar/custom_appbar.dart';
import 'package:archiz_prefix_crm/common/components/buttons/rounded_button.dart';
import 'package:archiz_prefix_crm/common/components/buttons/rounded_loading_button.dart';
import 'package:archiz_prefix_crm/common/components/custom_drop_down_button_with_text_field.dart';
import 'package:archiz_prefix_crm/common/components/custom_loader/custom_loader.dart';
import 'package:archiz_prefix_crm/common/components/text-form-field/custom_drop_down_text_field.dart';
import 'package:archiz_prefix_crm/common/components/text-form-field/custom_text_field.dart';
import 'package:archiz_prefix_crm/core/utils/dimensions.dart';
import 'package:archiz_prefix_crm/core/utils/local_strings.dart';
import 'package:archiz_prefix_crm/core/utils/style.dart';
import 'package:archiz_prefix_crm/core/utils/color_resources.dart';
import 'package:archiz_prefix_crm/features/customer/model/customer_model.dart';
import 'package:archiz_prefix_crm/features/ticket/controller/ticket_controller.dart';
import 'package:archiz_prefix_crm/features/ticket/model/departments_model.dart';
import 'package:archiz_prefix_crm/features/ticket/model/priorities_model.dart';
import 'package:archiz_prefix_crm/features/ticket/model/services_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddVisitScreen extends StatefulWidget {
  const AddVisitScreen({super.key});

  @override
  State<AddVisitScreen> createState() => _AddVisitScreenState();
}

class _AddVisitScreenState extends State<AddVisitScreen> {
  final AsyncMemoizer<CustomersModel> customersMemoizer = AsyncMemoizer();
  final AsyncMemoizer<DepartmentModel> departmentMemoizer = AsyncMemoizer();
  final AsyncMemoizer<PriorityModel> priorityMemoizer = AsyncMemoizer();
  final AsyncMemoizer<ServiceModel> serviceMemoizer = AsyncMemoizer();

  @override
  void dispose() {
    Get.find<TicketController>().clearData();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalStrings.createNewVisit.tr,
      ),
      body: GetBuilder<TicketController>(
        builder: (controller) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.space15, horizontal: Dimensions.space20),
              child: Column(
                children: [
                  // Visit Type Radio Buttons
                  Container(
                    width: double.infinity,
                    // padding: const EdgeInsets.all(Dimensions.space15),
                    // decoration: BoxDecoration(
                    //   border: Border.all(color: Colors.grey.shade300),
                    //   borderRadius: BorderRadius.circular(Dimensions.space8),
                    // ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Visit Type',
                          style: regularDefault.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: Dimensions.space14,
                          ),
                        ),
                        const SizedBox(height: Dimensions.space0),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'current',
                              groupValue: controller.selectedVisitType,
                              activeColor: ColorResources.primaryColor,
                              onChanged: (value) {
                                controller.setVisitType(value!);
                              },
                            ),
                            Text(
                              'Current Visit',
                              style: regularDefault.copyWith(
                                fontSize: Dimensions.space15,
                                color: ColorResources.colorBlack,
                              ),
                            ),
                            const SizedBox(width: Dimensions.space20),
                            Radio<String>(
                              value: 'future',
                              groupValue: controller.selectedVisitType,
                              activeColor: ColorResources.primaryColor,
                              onChanged: (value) {
                                controller.setVisitType(value!);
                              },
                            ),
                            Text(
                              'Future Visit',
                              style: regularDefault.copyWith(
                                fontSize: Dimensions.space15,
                                 color:  ColorResources.colorBlack,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.space15),
                  FutureBuilder(
                      future:
                      customersMemoizer.runOnce(controller.loadCustomers),
                      builder: (context, customerList) {
                        if (customerList.data?.status ?? false) {
                          return CustomDropDownTextField(
                            hintText: LocalStrings.selectClient.tr,
                            onChanged: (value) {
                              controller.userController.text = value;
                              controller.selectedCustomer = value;
                              controller.update();
                            },
                            items:
                            controller.customersModel.data!.map((customer) {
                              return DropdownMenuItem(
                                value: customer.userId,
                                child: Text(
                                  customer.company ?? '',
                                  style: regularDefault.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color),
                                ),
                              );
                            }).toList(),
                          );
                        } else if (customerList.data?.status == false) {
                          return CustomDropDownWithTextField(
                              selectedValue: LocalStrings.noClientFound.tr,
                              list: [LocalStrings.noClientFound.tr]);
                        } else {
                          return const CustomLoader(isFullScreen: false);
                        }
                      }),
                  if (controller.selectedCustomer.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: Dimensions.space15),
                      child: FutureBuilder(
                          future: controller.loadCustomerContacts(
                              controller.selectedCustomer),
                          builder: (context, contactsList) {
                            if (contactsList.data?.status ?? false) {
                              return CustomDropDownTextField(
                                hintText: LocalStrings.selectContact.tr,
                                onChanged: (value) {
                                  controller.contactController.text = value;
                                },
                                items: controller.contactsModel.data!
                                    .map((contact) {
                                  return DropdownMenuItem(
                                    value: contact.id,
                                    child: Text(
                                      '${contact.firstName ?? ''} ${contact.lastName ?? ''}',
                                      style: regularDefault.copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .color),
                                    ),
                                  );
                                }).toList(),
                              );
                            } else if (contactsList.data?.status == false) {
                              return CustomDropDownWithTextField(
                                  selectedValue: LocalStrings.noContactFound.tr,
                                  list: [LocalStrings.noContactFound.tr]);
                            } else {
                              return const CustomLoader(isFullScreen: false);
                            }
                          }),
                    ),
                  const SizedBox(height: Dimensions.space15),
                  FutureBuilder(
                      future: departmentMemoizer
                          .runOnce(controller.loadDepartments),
                      builder: (context, departmentList) {
                        if (departmentList.data?.status ?? false) {
                          return CustomDropDownTextField(
                            hintText: LocalStrings.selectDepartment.tr,
                            onChanged: (value) {
                              controller.departmentController.text = value;
                            },
                            items: controller.departmentModel.data!
                                .map((department) {
                              return DropdownMenuItem(
                                value: department.id,
                                child: Text(
                                  department.name ?? '',
                                  style: regularDefault.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color),
                                ),
                              );
                            }).toList(),
                          );
                        } else if (departmentList.data?.status == false) {
                          return CustomDropDownWithTextField(
                              selectedValue: LocalStrings.noDepartmentFound.tr,
                              list: [LocalStrings.noDepartmentFound.tr]);
                        } else {
                          return const CustomLoader(isFullScreen: false);
                        }
                      }),
                  const SizedBox(height: Dimensions.space15),
                  // Date Selection Field
                  GestureDetector(
                    onTap: controller.selectedVisitType == 'future' 
                      ? () => controller.selectDate(context)
                      : null,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(Dimensions.space15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(
                          color: ColorResources.getTextFieldDisableBorder(),
                        ),
                        borderRadius: BorderRadius.circular(Dimensions.space8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              controller.selectedDate != null
                                ? '${controller.selectedDate!.day}/${controller.selectedDate!.month}/${controller.selectedDate!.year}'
                                : 'Select Date',
                              style: regularDefault.copyWith(
                                fontSize: Dimensions.space12,
                                color: controller.selectedDate != null
                                  ? (controller.selectedVisitType == 'future' ? Colors.black : Colors.grey.shade600)
                                  : ColorResources.blueGreyColor,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.calendar_today_outlined,
                            color: ColorResources.getIconColor(),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.space15),
                  // Time Selection Field
                  GestureDetector(
                    onTap: controller.selectedVisitType == 'future' 
                      ? () => controller.selectTime(context)
                      : null,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(Dimensions.space15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(
                          color: ColorResources.getTextFieldDisableBorder(),
                        ),
                        borderRadius: BorderRadius.circular(Dimensions.space8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              controller.selectedTime != null
                                ? '${controller.selectedTime!.hour.toString().padLeft(2, '0')}:${controller.selectedTime!.minute.toString().padLeft(2, '0')}'
                                : 'Select Time',
                              style: regularDefault.copyWith(
                                fontSize: Dimensions.space12,
                                color: controller.selectedTime != null
                                  ? (controller.selectedVisitType == 'future' ? Colors.black : Colors.grey.shade600)
                                  : ColorResources.blueGreyColor,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.access_time_outlined,
                            color: ColorResources.getIconColor(),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.space15),
                  CustomTextField(
                    labelText: LocalStrings.purpose.tr,
                    textInputType: TextInputType.multiline,
                    maxLines: 4,
                    focusNode: controller.descriptionFocusNode,
                    controller: controller.descriptionController,
                    onChanged: (value) {
                      return;
                    },
                  ),
                  const SizedBox(height: Dimensions.space25),
                  controller.isSubmitLoading
                      ? const RoundedLoadingBtn()
                      : RoundedButton(
                    text: LocalStrings.save.tr,
                    press: () {
                      controller.submitTicket(context);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
