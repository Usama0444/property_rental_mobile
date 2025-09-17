import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/common_widgets/global_functions.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/apartment_details/widget/select_reservation_check_in.dart';
import 'package:property_rental_app/pages/apartment_details/widget/select_your_reservation.dart';
import 'package:property_rental_app/universal_models/user_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../universal_models/add_listing_model.dart';

class BookTourWidget extends StatelessWidget {
  const BookTourWidget({
    super.key,
    this.isSale,
    required this.listingID,
    this.comingFromMyAdd,
  });
  final String listingID;
  final bool? isSale;
  final bool? comingFromMyAdd;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
  future: FirebaseFirestore.instance
      .collection('listings')
      .doc(listingID)
      .withConverter<Map<String, dynamic>>(
        fromFirestore: (snapshot, _) => snapshot.data()!,
        toFirestore: (data, _) => data,
      )
      .get(),
  builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const SizedBox();
    }
    if (snapshot.hasError) {
      print(snapshot.error.toString());
      return const Text('Error loading listing data');
    }
    if (!snapshot.hasData || !snapshot.data!.exists) {
      return const Text('Data doesn\'t exist');
    }
    AddListingModel searchModel = AddListingModel.fromDocumentSnapshot(snapshot.data!);
        return Container(
          height: 78,
          decoration: BoxDecoration(
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 10)
            ],
          ),
          width: Get.width,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            children: [
              CustomButton(
                  width: 90,
                  text: /*searchModelUI.buttonText*/ 'Call',
                  isPrefixIcon: true,
                  fontSize: 12,
                  buttonIconWidth: 7,
                  // backgroundColor:
                  //     Colors.deepOrangeAccent /*.withOpacity(0.7)*/,
                  horizontalPadding: 01,
                  // suffixTextIconWidth: 2,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: Image.asset(
                      'assets/icons/call_2.png',
                      height: 16,
                      width: 14,
                      color: whiteColor,
                    ),
                  ),
                  onPressed: () {
                    print('55555555555');
                    print(searchModel.phoneNo.text);

                    makePhoneCall(searchModel!.phoneNo.text);
                  }),
              const SizedBox(
                width: 5,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(searchModel.sellerID)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox();
                  }
                  if (snapshot.hasError) {
                    print(snapshot.error.toString());
                  }
                  UserModel uModel = UserModel.fromDocumentSnapshot(
                      snapshot.data as DocumentSnapshot<Map<String, dynamic>>);
                  return CustomButton(
                      width: 90,
                      text: /*searchModelUI.buttonText*/ 'Email',
                      isPrefixIcon: true,
                      // suffixTextIconWidth: 2,
                      buttonIconWidth: 7,
                      fontSize: 12,
                      // backgroundColor: Colors.deepOrangeAccent,
                      horizontalPadding: 01,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 2.0),
                        child: Image.asset(
                          'assets/icons/mail (1).png',
                          height: 16,
                          width: 14,
                          color: whiteColor,
                        ),
                      ),
                      onPressed: () {
                        String? encodeQueryParameters(
                            Map<String, String> params) {
                          return params.entries
                              .map((MapEntry<String, String> e) =>
                                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                              .join('&');
                        }

                        final Uri emailLaunchUri = Uri(
                          scheme: 'mailto',
                          path: uModel.userEmail.text,
                          query: encodeQueryParameters(<String, String>{
                            'subject': 'Property Rental',
                          }),
                        );

                        launchUrl(emailLaunchUri);
                        // sendEmail(uModel.userEmail.text, );
                      });
                },
              ),
              const SizedBox(
                width: 5,
              ),
              CustomButton(
                  width: 110,
                  text: /*searchModelUI.buttonText*/ 'Whatsapp',
                  isPrefixIcon: true,
                  suffixTextIconWidth: 2,
                  buttonIconWidth: 7,
                  fontSize: 12,
                  backgroundColor: Colors.green,
                  horizontalPadding: 01,
                  fontWeight: FontWeight.w500,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: Image.asset(
                      'assets/icons/whatsapp (1).png',
                      height: 16,
                      width: 14,
                      color: whiteColor,
                    ),
                  ),
                  onPressed: () {
                    openWhatsAppChat(searchModel!.phoneNo.text);
                  }),
            ],
          ),
        );
      },
    );
  }
}

///StreamBuilder(
//           stream: FirebaseFirestore.instance
//               .collection('listings')
//               .doc(listingID)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const SizedBox();
//             }
//             if (snapshot.hasError) {
//               print(snapshot.error.toString());
//             }
//             if (!snapshot.data!.exists) {
//               return const Text('Data does\'nt exist');
//             }
//             AddListingModel listingModel = AddListingModel.fromDocumentSnapshot(
//                 snapshot.data as DocumentSnapshot<Map<String, dynamic>>);
//
//             return Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       listingModel.listingRole != 'Rent'
//                           ? 'KSH ${listingModel.cost.text}'
//                           : 'KSH ${listingModel.cost.text}/Night',
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w700,
//                         color: blackColor3B,
//                         fontSize: 16,
//                         fontFamily: 'Avenir',
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 6,
//                     ),
//                     listingModel.listingRole == 'Rent'?  StreamBuilder(
//                         stream: FirebaseFirestore.instance
//                             .collection('feedbacks')
//                             .where('propertyID', isEqualTo: listingID)
//                             .snapshots(),
//                         builder: (context, snapshot2) {
//                           if (snapshot2.connectionState ==
//                               ConnectionState.waiting) {
//                             return const SizedBox();
//                           }
//                           if (snapshot2.hasError) {
//                             print(snapshot2.error.toString());
//                           }
//                           // if (snapshot2.data!.docs.isEmpty) {
//                           //   return SizedBox();
//                           // }
//                           return Text(
//                          '${snapshot2.data!.docs.length==0?0:snapshot2.data!.docs.length} Reviews',
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w700,
//                               color: blackColor3B,
//                               fontSize: 12,
//                               fontFamily: 'Avenir',
//                             ),
//                           );
//                         }):
//                     Text(
//                       isSale == true
//                           ? 'Click to add tour details'
//                           : '13+ Reviews',
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w700,
//                         color: blackColor3B,
//                         fontSize: 12,
//                         fontFamily: 'Avenir',
//                       ),
//                     ),
//                   ],
//                 ),
//               comingFromMyAdd==false?  CustomButton(
//                     text: listingModel.listingRole != 'Rent'
//                         ? 'Book a Tour'
//                         : 'Book Now',
//                     height: 44,
//                     width: 133,
//                     onPressed: () {
//                       print(listingModel.sellerID);
//                       print(listingModel.description.text);
//                       print('listingID');
//                       listingModel.listingRole != 'Rent'
//                           ? reservationBottomSheet(
//                               listingModel.sellerID, listingModel, listingID)
//                           : reservationCheckInBottomSheet(
//                               listingModel: listingModel, listingID: listingID);
//                     }):SizedBox()
//               ],
//             );
//           },
//         )
