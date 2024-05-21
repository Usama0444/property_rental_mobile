import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_appbar.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/common_widgets/custom_text_field.dart';
import 'package:property_rental_app/common_widgets/search_drop_down.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/add_listing/controller/listing_controller.dart';
import 'package:property_rental_app/pages/bottom_nav_bar/user_bottom_nav_bar.dart';
import 'package:property_rental_app/pages/make_it_stand_out/make_it_stand_out.dart';
import 'package:property_rental_app/universal_models/add_listing_model.dart';

import '../../../common_widgets/loading_dialog.dart';
import '../../../utils/validator.dart';
import 'widget/property_title_row.dart';

class EnterPropertyDetails extends StatelessWidget {
  EnterPropertyDetails({super.key, this.listingId});

  final controller = Get.put(EnterPropertyDetailsController());
  final String? listingId;

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(
            title: '',
            isSuffixIcon: true,
            isBottomBorder: false,
            suffixWidget: CustomButton(
                text: /*Save &*/ 'Exit',
                width: 116,
                isBorder: true,
                backgroundColor: whiteColor,
                textColor: textColor66,
                borderRadius: 45,
                onPressed: () {
                  Get.offAll(BottomNavBar());
                }),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('listings')
                .doc(listingId)
                .snapshots(),
            builder: (context, snapshot) {
              AddListingModel listingModel = AddListingModel.initialize();
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }
              if (snapshot.hasError) {
                print(snapshot.error.toString());
              }
              if (!snapshot.data!.exists) {
                listingModel = AddListingModel.initialize();
              }
              if (snapshot.data!.exists) {
                listingModel = AddListingModel.fromDocumentSnapshot(
                    snapshot.data! as DocumentSnapshot<Map<String, dynamic>>)
                  ..listingImageMemories = <Rx<Uint8List>>[].obs;
              }

              return Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Enter property details',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: blackColor3B,
                              fontSize: 20,
                              fontFamily: 'Avenir',
                            ),
                          ),
                          const SizedBox(height: 12),
                          const PropertyTitleRow(
                            title: 'Ad Title or Property name',
                          ),
                          const SizedBox(height: 6),
                          CustomTextField(
                              errorfontSize: 0,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter property name.';
                                }
                                return null;
                              },
                              hintText: 'Enter property name',
                              borderRadius: 8,
                              hintColor: const Color(0xFF808080),
                              controller: listingModel.propertyName),
                          const SizedBox(height: 2),
                          const Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              'Enter the name of the property.',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: textColor,
                                fontSize: 12,
                                fontFamily: 'Avenir',
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const PropertyTitleRow(
                            title: 'Property Type',
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 50,
                            width: Get.width,
                            child: Obx(
                              () => SearchDropDown(
                                hintText: "Enter property type",
                                controller: controller.propertyTypeController,
                                dropdownItems: controller.propertyTypeList,
                                selectedValue: listingModel.propertyType.value,
                                onChanged: (value) {
                                  listingModel.propertyType.value = value!;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              'Select the property type.',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: textColor,
                                fontSize: 12,
                                fontFamily: 'Avenir',
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const PropertyTitleRow(
                            title: 'Phone number',
                          ),
                          const SizedBox(height: 6),
                          CustomTextField(
                              keyboardType: TextInputType.phone,
                              errorfontSize: 0,
                              hintText: 'Enter phone number',
                              validator: (value) {
                                return isPhoneValid(value!);
                              },
                              // validator: (value) {
                              //   if (value!.isEmpty) {
                              //     return 'Please enter phone number.';
                              //   }
                              //   return null;
                              // },
                              borderRadius: 8,
                              hintColor: const Color(0xFF808080),
                              controller: listingModel.phoneNo),
                          const SizedBox(height: 2),
                          const Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              'Contact Phone Number',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: textColor,
                                fontSize: 12,
                                fontFamily: 'Avenir',
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const PropertyTitleRow(
                            title: 'Country',
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 50,
                            width: Get.width,
                            child: Obx(
                              () => SearchDropDown(
                                hintText: "Select country",
                                controller: controller.countryController,
                                dropdownItems: controller.countryList,
                                selectedValue: listingModel.countryName.value,
                                onChanged: (value) {
                                  listingModel.countryName.value = value!;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              'In which Country is it located?',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: textColor,
                                fontSize: 12,
                                fontFamily: 'Avenir',
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const PropertyTitleRow(
                            title: 'Town',
                          ),
                          const SizedBox(height: 6),
                          CustomTextField(
                              errorfontSize: 0,
                              hintText: 'Enter town name',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter town.';
                                }
                                return null;
                              },
                              borderRadius: 8,
                              hintColor: const Color(0xFF808080),
                              controller: listingModel.town),
                          // SizedBox(
                          //   height: 50,
                          //   width: Get.width,
                          //   child: Obx(
                          //     () => SearchDropDown(
                          //       hintText: "",
                          //       controller: controller.townController,
                          //       dropdownItems: controller.townList,
                          //       selectedValue: controller.townDropdownValue.value,
                          //       onChanged: (value) {
                          //         controller.townDropdownValue.value = value!;
                          //       },
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(height: 2),
                          const Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              'In which town is the Property located in?.',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: textColor,
                                fontSize: 12,
                                fontFamily: 'Avenir',
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const PropertyTitleRow(
                            title: 'Street/Specific location',
                          ),
                          const SizedBox(height: 6),
                          CustomTextField(
                              hintText: 'Enter street location',
                              borderRadius: 8,
                              errorfontSize: 0,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter town.';
                                }
                                return null;
                              },
                              hintColor: const Color(0xFF808080),
                              controller: listingModel.street),
                          const SizedBox(height: 2),
                          const Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              'Which street is your property located.',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: textColor,
                                fontSize: 12,
                                fontFamily: 'Avenir',
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Bedrooms',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: blackColor3B,
                              fontSize: 20,
                              fontFamily: 'Avenir',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Obx(
                            () => Wrap(
                              children: List.generate(
                                controller.bedroomsList.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    ///////////
                                    listingModel.selectedBedroom.clear();
                                    for (int i = 0; i <= index; i++) {
                                      listingModel.selectedBedroom
                                          .add(controller.bedroomsList[i]);
                                    }
                                    // listingModel.selectedBedroom
                                    //     .add(controller.bedroomsList[index]);
                                    print(listingModel.selectedBedroom);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        right: 12, bottom: 12),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 13),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: listingModel
                                                  .selectedBedroom.isNotEmpty
                                              ? listingModel.selectedBedroom
                                                          .last ==
                                                      controller
                                                          .bedroomsList[index]
                                                  ? primaryColor
                                                  : greyBorderColor
                                              : greyBorderColor,
                                        ),
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Text(
                                      controller.bedroomsList[index],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const PropertyTitleRow(
                            title: 'Monthly Payment/Cost',
                          ),
                          const SizedBox(height: 6),
                          CustomTextField(
                              hintText: '',
                              errorfontSize: 10,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter Cost.';
                                }
                                RegExp regex = RegExp(r'[0-9]+$');
                                if (!regex.hasMatch(value)) {
                                  return 'Please enter valid Cost (only numbers allowed).';
                                }
                                return null;
                              },
                              borderRadius: 8,
                              keyboardType: TextInputType.number,
                              controller: listingModel.payment),
                          const SizedBox(height: 2),
                          const Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              'Total Amount payable on rent/purchase',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: textColor,
                                fontSize: 12,
                                fontFamily: 'Avenir',
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const PropertyTitleRow(
                            title: 'Any Extra Payment? indicate',
                          ),
                          const SizedBox(height: 6),

                          Obx(() => ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: listingModel.indicatePayList.length,
                              itemBuilder: (context, addIndex) {
                                return Obx(() {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: Get.width * 0.55,
                                          height: 40,
                                          child: CustomTextField(
                                              hintText: '',
                                              borderRadius: 8,
                                              // validator: (value) {
                                              //   if (value!.isEmpty) {
                                              //     return 'Please enter Cost.';
                                              //   }
                                              //   RegExp regex = RegExp(r'[0-9]+$');
                                              //   if (!regex.hasMatch(value)) {
                                              //     return 'Please enter valid Cost (only numbers allowed).';
                                              //   }
                                              //   return null;
                                              // },
                                              keyboardType: TextInputType.text,
                                              controller: listingModel
                                                  .indicatePayList[addIndex]
                                                  .extraName),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        SizedBox(
                                          width: Get.width * 0.2,
                                          height: 40,
                                          child: CustomTextField(
                                              hintText: '',
                                              borderRadius: 8,
                                              // validator: (value) {
                                              //   if (value!.isEmpty) {
                                              //     return 'Please enter Cost.';
                                              //   }
                                              //   RegExp regex = RegExp(r'[0-9]+$');
                                              //   if (!regex.hasMatch(value)) {
                                              //     return 'Please enter valid Cost (only numbers allowed).';
                                              //   }
                                              //   return null;
                                              // },
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: listingModel
                                                  .indicatePayList[addIndex]
                                                  .extraCost),
                                        ),
                                        if (addIndex >= 1)
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: GestureDetector(
                                                onTap: () {
                                                  listingModel.indicatePayList
                                                      .removeAt(addIndex);
                                                  // controller
                                                  //     .removeWorkingHoursRow(
                                                  //     0, addIndex);
                                                },
                                                child: Container(
                                                  height: 23,
                                                  width: 23,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: primaryColor,
                                                          shape:
                                                              BoxShape.circle),
                                                  child: const Center(
                                                      child: Icon(
                                                    Icons.remove,
                                                    color: Colors.white,
                                                    size: 21,
                                                  )),
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (addIndex == 0)
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: GestureDetector(
                                                onTap: () {
                                                  listingModel.indicatePayList
                                                      .add(IndicatePayListModel
                                                          .initialize());
                                                  // controller
                                                  //     .addWorkingHoursRow(0);
                                                },
                                                child: Container(
                                                  height: 23,
                                                  width: 23,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: primaryColor,
                                                          shape:
                                                              BoxShape.circle),
                                                  child: const Center(
                                                      child: Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                    size: 21,
                                                  )),
                                                ),
                                              ),
                                            ),
                                          ),
                                        SizedBox(
                                          width: Get.width * 0.02,
                                        ),
                                      ],
                                    ),
                                  );
                                });
                              })),
                          // CustomTextField(
                          //     hintText: '',
                          //     borderRadius: 8,
                          //     // validator: (value) {
                          //     //   if (value!.isEmpty) {
                          //     //     return 'Please enter Cost.';
                          //     //   }
                          //     //   RegExp regex = RegExp(r'[0-9]+$');
                          //     //   if (!regex.hasMatch(value)) {
                          //     //     return 'Please enter valid Cost (only numbers allowed).';
                          //     //   }
                          //     //   return null;
                          //     // },
                          //     keyboardType: TextInputType.number,
                          //     controller: listingModel.extraPay),
                          const SizedBox(height: 2),
                          const Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              'Any Extra Payment?Indicate',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: textColor,
                                fontSize: 12,
                                fontFamily: 'Avenir',
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const PropertyTitleRow(
                            title: 'Ad Description',
                          ),
                          const SizedBox(height: 6),

                          CustomTextField(
                              hintText: 'Enter property description',
                              borderRadius: 8,
                              hintColor: const Color(0xFF808080),
                              errorfontSize: 0,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter description';
                                }
                                return null;
                              },
                              maxLines: 6,
                              controller: listingModel.description),
                          const SizedBox(height: 24),
                          CustomButton(
                            text: 'Next',
                            height: 44,
                            width: Get.width,
                            onPressed: () {
                              RegExp numRegExp = RegExp(r'^[0-9]+$');
                              if (key.currentState!.validate()) {
                                ///chaecking if number or empty then go ahead
                                // if (listingModel.extraPay.text.isEmpty ||
                                //     numRegExp
                                //         .hasMatch(listingModel.extraPay.text)) {
                                ///checking bedrooms
                                String address =
                                    controller.getFullAddress(listingModel);

                                Future<List<Location>> locations =
                                    controller.getAddressCoordinates(address);

                                locations.then((List<Location> locs) {
                                  if (locs.isNotEmpty) {
                                    listingModel.latitude = locs[0].latitude;
                                    listingModel.longitude = locs[0].longitude;
                                    // print("Latitude: $latitude, Longitude: $longitude");
                                  } else {
                                    print("Address not found.");
                                  }
                                });

                                if (listingModel.selectedBedroom.length != 0) {
                                  int indicatePaySum = 0;
                                  for (var item
                                      in listingModel.indicatePayList) {
                                    indicatePaySum +=
                                        int.parse(item.extraCost.text) ?? 0;
                                  }

                                  listingModel.extraPay.text =
                                      indicatePaySum.toString();

                                  ///adding indicate payment in total
                                  int totalAmount = int.parse(listingModel
                                          .payment.text
                                          .toString()) +
                                      indicatePaySum;

                                  listingModel.cost.text =
                                      totalAmount.toString();

                                  print(listingModel.cost.text.toString());
                                  print(totalAmount.toString());
                                  print(listingModel.extraPay.text.toString());

                                  // if (listingModel.extraPay.text != '' ||
                                  //     listingModel.extraPay.text.isNotEmpty) {
                                  //   int total = int.parse(listingModel
                                  //           .payment.text
                                  //           .toString()) +
                                  //       int.parse(listingModel.extraPay.text
                                  //           .toString());
                                  //   listingModel.cost.text = total.toString();
                                  // }

                                  Get.to(() => MakeItStandOut(
                                      listingId: listingId,
                                      listingModel: listingModel));
                                } else {
                                  loadingDialog(
                                      message: 'Please select bedrooms',
                                      button: true);
                                }
                                // } else {
                                //   loadingDialog(
                                //       message:
                                //           'Please enter numbers only in extra payment.',
                                //       button: true);
                                // }
                              }
                            },
                          ),
                          const SizedBox(height: 34),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
