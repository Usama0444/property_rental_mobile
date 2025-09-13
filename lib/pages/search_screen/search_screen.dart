import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_switch_button.dart';
import 'package:property_rental_app/common_widgets/custom_text_field.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/main.dart';
import 'package:property_rental_app/pages/home/widget/filter_bottomsheet.dart';
import 'package:property_rental_app/pages/notifications/notifications.dart';
import 'package:property_rental_app/universal_models/add_listing_model.dart';
import '../home/controller/home_controller.dart';
import 'widget/search_property_widget.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({
    super.key,
    required this.role,
    required this.isComingFromActivity,
    this.type,
  });

  final controller = Get.put(HomeController());
  final bool isComingFromActivity;
  final String? type;
  // final controller = Get.put(SearchScreenController());
  final String role;
  @override
  Widget build(BuildContext context) {

    // print(controller.propertyStatus.value + '   ===============hadbvkih');
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      controller.isBuyRent.value = 10;
                      controller.propertyType.value = 10;
                      controller.selectedBedroom.value = 10;
                      controller.isFilter.value = false;
                      controller.minValue.value = 1000.0;
                      controller.maxValue.value = 104000.0;
                      controller.filterSearchCtrl.clear();
                      filterBottomSheet();
                    },
                    child: CustomTextField(
                        enabled: false,
                        hintText: 'Search for City, Community or Building',
                        controller: controller.searchController),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const Notifications());
                  },
                  child: Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.all(9),
                    child: Image.asset(
                      'assets/icons/notification_icon.png',
                      height: 24,
                      width: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Divider(
            color: greyBorderColor,
            height: 0.5,
          ),
          // Container(
          //   height: 42,
          //   width: Get.width,
          //   color: primaryColor.withOpacity(0.1),
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       RichText(
          //         text: const TextSpan(
          //           text: 'Show ',
          //           style: TextStyle(
          //             fontWeight: FontWeight.w500,
          //             color: blackColor,
          //             fontSize: 14,
          //             fontFamily: 'Avenir',
          //           ),
          //           children: <TextSpan>[
          //             TextSpan(
          //               text: 'Verified ',
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w700,
          //                 color: blackColor,
          //                 fontSize: 14,
          //                 fontFamily: 'Avenir',
          //               ),
          //             ),
          //             TextSpan(
          //               text: 'listings first',
          //               style: TextStyle(
          //                 color: blackColor,
          //                 fontSize: 14,
          //                 fontWeight: FontWeight.w500,
          //                 fontFamily: 'Avenir',
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //       Obx(
          //         () => CustomSwitchButtonWidget(
          //           status: controller.isVerified.value,
          //           onToggle: (value) {
          //             controller.isVerified.value =
          //                 !controller.isVerified.value;
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Obx(
              () => Text(
                controller.propertyStatus.value == 'all'
                    ? 'Buy and sell your properties'
                    : controller.propertyStatus.value == 'For Sale'
                        ? "Properties for sale"
                        : "Available properties for rent",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: blackColor3B,
                  fontSize: 20,
                  fontFamily: 'Avenir',
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Obx(() => StreamBuilder(
                stream: controller.isFilter.value == true
                    ? controller.filter()
                    :
                     controller.propertyStatus.value == 'all'
                        ? FirebaseFirestore.instance
                            .collection('listings')
                            .where('sellerID',
                                isNotEqualTo: auth.currentUser!.uid)
                            .snapshots()
                        : FirebaseFirestore.instance
                            .collection('listings')
                            .where('sellerID',
                                isNotEqualTo: auth.currentUser!.uid)
                            .where('listingRole',
                                isEqualTo: controller.propertyStatus.value)
                            .snapshots(),
                builder: (context, snapshot) {
                  print(controller.isFilter.value);
                  // print( controller.filter());

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox();
                  }
                  if (snapshot.hasError) {
                    print(snapshot.error.toString());
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(top: Get.height / 3.5),
                      child: const Center(
                          child: SizedBox(
                              child: Text(
                        'No property Ads yet.',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: textColor,
                          fontSize: 14,
                          fontFamily: 'Avenir',
                        ),
                      ))),
                    );
                  }
                  return Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: (snapshot as AsyncSnapshot<QuerySnapshot>)
                          .data!
                          .docs
                          .length,
                      itemBuilder: (context, index) {
                        // Ensure that the type of `snapshot` is explicitly defined as AsyncSnapshot<QuerySnapshot>
                        AsyncSnapshot<QuerySnapshot> querySnapshot =
                            snapshot as AsyncSnapshot<QuerySnapshot>;

                        // Access the docs property from querySnapshot
                        AddListingModel listingModel =
                            AddListingModel.fromDocumentSnapshot(
                                querySnapshot.data!.docs[index]
                                    as DocumentSnapshot<Map<String, dynamic>>);

                        return Obx(() {
                          // print(double.parse(listingModel.cost.text));
                          print(
                              controller.minValue.value.toString() + 'hvdckhj');
                          print(controller.maxValue.value);
                          return double.parse(listingModel.cost.text) >=
                                      controller.minValue.value &&
                                  double.parse(listingModel.cost.text) <=
                                      controller.maxValue.value
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: SearchPropertyWidget(
                                    listingId:
                                        querySnapshot.data!.docs[index].id,
                                    searchModel: listingModel,
                                  ),
                                )
                              : SizedBox();
                        });
                      },
                    ),
                  )
                      /*Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        AddListingModel listingModel =
                            AddListingModel.fromDocumentSnapshot(
                                snapshot.data!.docs[index]
                                    as DocumentSnapshot<Map<String, dynamic>>);

                        // SearchModel newModel =
                        //     controller.buyAndSellPropertyList[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: SearchPropertyWidget(
                            listingId: snapshot.data!.docs[index].id,
                            searchModel: listingModel */ /*newModel*/ /*,
                            // searchModelUI: newModel,
                          ),
                        );
                      },
                    )),*/
                      );
                },
              ))
        ],
      ),
    );
  }
}

/// Obx(
//                     () => controller.propertyStatus.value == 'all'
//                         ? ListView.builder(
//                             shrinkWrap: true,
//                             padding: EdgeInsets.zero,
//                             itemCount: controller.buyAndSellPropertyList.length,
//                             itemBuilder: (context, index) {
//                               SearchModel newModel =
//                                   controller.buyAndSellPropertyList[index];
//                               return Padding(
//                                 padding: const EdgeInsets.only(bottom: 16),
//                                 child: SearchPropertyWidget(
//                                   searchModel: newModel,
//                                 ),
//                               );
//                             },
//                           )
//                         : controller.propertyStatus.value == 'rent'
//                             ? ListView.builder(
//                                 shrinkWrap: true,
//                                 padding: EdgeInsets.zero,
//                                 itemCount:
//                                     controller.buyAndSellPropertyList.length,
//                                 itemBuilder: (context, index) {
//                                   SearchModel newModel =
//                                       controller.buyAndSellPropertyList[index];
//                                   return controller.propertyStatus.value ==
//                                               'rent' &&
//                                           newModel.status == 'rent'
//                                       ? Padding(
//                                           padding:
//                                               const EdgeInsets.only(bottom: 16),
//                                           child: SearchPropertyWidget(
//                                             searchModel: newModel,
//                                           ),
//                                         )
//                                       : const SizedBox.shrink();
//                                 },
//                               )
//                             : ListView.builder(
//                                 shrinkWrap: true,
//                                 padding: EdgeInsets.zero,
//                                 itemCount:
//                                     controller.buyAndSellPropertyList.length,
//                                 itemBuilder: (context, index) {
//                                   SearchModel newModel =
//                                       controller.buyAndSellPropertyList[index];
//                                   return controller.propertyStatus.value ==
//                                               'sale' &&
//                                           newModel.status == 'sale'
//                                       ? Padding(
//                                           padding:
//                                               const EdgeInsets.only(bottom: 16),
//                                           child: SearchPropertyWidget(
//                                             searchModel: newModel,
//                                           ),
//                                         )
//                                       : const SizedBox.shrink();
//                                 },
//                               ),
//                   ),
