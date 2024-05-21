import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:property_rental_app/common_widgets/custom_appbar.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/main.dart';
import 'package:property_rental_app/universal_models/notification_model.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          const CustomAppBar(
            title: 'Notifications',
            isBackButton: true,
          ),
          Expanded(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('notifications')
                .where(Filter.or(
                    Filter('ownerID', isEqualTo: auth.currentUser!.uid),
                    Filter('buyerID', isEqualTo: auth.currentUser!.uid)))
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                    width: 80,
                    height: 55,
                    child: Center(
                        child: CircularProgressIndicator(
                      color: primaryColor,
                    )));
              }
              if (snapshot.hasError) {
                print(snapshot.error.toString());
                print('error');
              }
              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                    child: Text(
                  'No Notifications yet',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: greyColor,
                    fontFamily: 'Avenir',
                  ),
                ));
              }
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    NotificationsModel notifyModel =
                        NotificationsModel.fromDocumentSnapshot(
                            snapshot.data!.docs[index]);
                    return Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.0, // Adjust thickness as needed
                            color: greyBorderColor, // Customize color
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        children: [
                          Image.asset(
                            notifyModel.bookingType == 'Rent' &&
                                    notifyModel.isPaymentDone == true
                                ? 'assets/images/booking.png'
                                : notifyModel.bookingType == 'Tour' &&
                                        notifyModel.isPaymentDone == true
                                    ? "assets/icons/ksh_icon.png"
                                    : "assets/icons/visit_icon.png",
                            height: 46,
                            width: 46,
                          ),
                          const SizedBox(width: 25),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ///condition 1
                                notifyModel.buyerID == auth.currentUser!.uid &&
                                        notifyModel.bookingType == 'Rent'
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  const TextSpan(
                                                    text:
                                                        'Your reservation for the ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12,
                                                      color: greyColor,
                                                      fontFamily: 'Avenir',
                                                    ),
                                                  ),
                                                  WidgetSpan(
                                                    alignment:
                                                        PlaceholderAlignment
                                                            .top,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 5),
                                                      child: Text(
                                                        notifyModel
                                                            .propertyName,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12,
                                                          color: primaryColor,
                                                          fontFamily: 'Avenir',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        ' is booked for ${DateFormat('MMMM dd').format(DateTime.fromMillisecondsSinceEpoch(notifyModel.checkIn))}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12,
                                                      color: greyColor,
                                                      fontFamily: 'Avenir',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    :

                                    ///condition 2
                                    notifyModel.buyerID ==
                                                auth.currentUser!.uid &&
                                            notifyModel.bookingType == 'Tour' &&
                                            notifyModel.isPaymentDone == true
                                        ? Row(
                                            children: [
                                              Expanded(
                                                child: RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        text: 'Visit ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12,
                                                          color: greyColor,
                                                          fontFamily: 'Avenir',
                                                        ),
                                                      ),
                                                      WidgetSpan(
                                                        alignment:
                                                            PlaceholderAlignment
                                                                .top,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 5),
                                                          child: Text(
                                                            notifyModel
                                                                .propertyName,
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 12,
                                                              color:
                                                                  primaryColor,
                                                              fontFamily:
                                                                  'Avenir',
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: ' with \'${notifyModel.propertyOwnerName}\' on ${DateFormat('MMMM dd').format(DateTime.fromMillisecondsSinceEpoch(notifyModel.checkIn))}' +
                                                            (notifyModel.ownerNumber ==
                                                                    ''
                                                                ? ''
                                                                : '. His contact ${notifyModel.ownerNumber}'),
                                                        // ' with \'${notifyModel.propertyOwnerName}\' on ${DateFormat('MMMM dd').format(DateTime.fromMillisecondsSinceEpoch(notifyModel.checkIn))}.${notifyModel.ownerNumber==''}? His contact ${notifyModel.ownerNumber}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12,
                                                          color: greyColor,
                                                          fontFamily: 'Avenir',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )

                                        ///condition 3
                                        : notifyModel
                                                        .buyerID ==
                                                    auth.currentUser!.uid &&
                                                notifyModel
                                                        .bookingType ==
                                                    'Tour' &&
                                                notifyModel
                                                        .isPaymentDone ==
                                                    false
                                            ? Row(
                                                children: [
                                                  Expanded(
                                                    child: RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          const TextSpan(
                                                            text:
                                                                'Your Remains payment ',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 12,
                                                              color: greyColor,
                                                              fontFamily:
                                                                  'Avenir',
                                                            ),
                                                          ),
                                                          WidgetSpan(
                                                            alignment:
                                                                PlaceholderAlignment
                                                                    .top,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          5),
                                                              child: Text(
                                                                'Ksh ${notifyModel.pendingPayment}',
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12,
                                                                  color:
                                                                      primaryColor,
                                                                  fontFamily:
                                                                      'Avenir',
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const TextSpan(
                                                            text:
                                                                ' is due for the',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 12,
                                                              color: greyColor,
                                                              fontFamily:
                                                                  'Avenir',
                                                            ),
                                                          ),
                                                          WidgetSpan(
                                                            alignment:
                                                                PlaceholderAlignment
                                                                    .top,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          5),
                                                              child: Text(
                                                                '"${notifyModel.propertyName}"',
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12,
                                                                  color:
                                                                      primaryColor,
                                                                  fontFamily:
                                                                      'Avenir',
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                ' for ${DateFormat('MMMM dd').format(DateTime.fromMillisecondsSinceEpoch(notifyModel.checkIn))}',
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 12,
                                                              color: greyColor,
                                                              fontFamily:
                                                                  'Avenir',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            :

                                            ///condition 4
                                            notifyModel
                                                            .ownerID ==
                                                        auth.currentUser!.uid &&
                                                    notifyModel
                                                            .bookingType ==
                                                        'Tour' &&
                                                    notifyModel
                                                            .isPaymentDone ==
                                                        false
                                                ? Row(
                                                    children: [
                                                      Expanded(
                                                        child: RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              const TextSpan(
                                                                text:
                                                                    'The Remaining payment for ',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 12,
                                                                  color:
                                                                      greyColor,
                                                                  fontFamily:
                                                                      'Avenir',
                                                                ),
                                                              ),
                                                              WidgetSpan(
                                                                alignment:
                                                                    PlaceholderAlignment
                                                                        .top,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              5),
                                                                  child: Text(
                                                                    '"${notifyModel.propertyName}"',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          12,
                                                                      color:
                                                                          primaryColor,
                                                                      fontFamily:
                                                                          'Avenir',
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              const TextSpan(
                                                                text:
                                                                    ' tour is ',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 12,
                                                                  color:
                                                                      greyColor,
                                                                  fontFamily:
                                                                      'Avenir',
                                                                ),
                                                              ),
                                                              WidgetSpan(
                                                                alignment:
                                                                    PlaceholderAlignment
                                                                        .top,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              5),
                                                                  child: Text(
                                                                    'Ksh ${notifyModel.pendingPayment}',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          12,
                                                                      color:
                                                                          primaryColor,
                                                                      fontFamily:
                                                                          'Avenir',
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    ' for ${DateFormat('MMMM dd').format(DateTime.fromMillisecondsSinceEpoch(notifyModel.checkIn))}',
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 12,
                                                                  color:
                                                                      greyColor,
                                                                  fontFamily:
                                                                      'Avenir',
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                :

                                                ///condition 5
                                                notifyModel
                                                                .ownerID ==
                                                            auth.currentUser!
                                                                .uid &&
                                                        notifyModel
                                                                .bookingType ==
                                                            'Tour' &&
                                                        notifyModel
                                                                .isPaymentDone ==
                                                            true
                                                    ? Row(
                                                        children: [
                                                          Expanded(
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  const TextSpan(
                                                                    text:
                                                                        'Visit ',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          12,
                                                                      color:
                                                                          greyColor,
                                                                      fontFamily:
                                                                          'Avenir',
                                                                    ),
                                                                  ),
                                                                  WidgetSpan(
                                                                    alignment:
                                                                        PlaceholderAlignment
                                                                            .top,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              5),
                                                                      child:
                                                                          Text(
                                                                        notifyModel
                                                                            .propertyName,
                                                                        style:
                                                                            const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              primaryColor,
                                                                          fontFamily:
                                                                              'Avenir',
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: ' with \'${notifyModel.buyerName}\' on ${DateFormat('MMMM dd').format(DateTime.fromMillisecondsSinceEpoch(notifyModel.checkIn))}' +
                                                                        (notifyModel.buyerNumber ==
                                                                                ''
                                                                            ? ''
                                                                            : '. His contact ${notifyModel.buyerNumber}'),
                                                                    style:
                                                                        const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          12,
                                                                      color:
                                                                          greyColor,
                                                                      fontFamily:
                                                                          'Avenir',
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : notifyModel.ownerID ==
                                                                auth.currentUser!
                                                                    .uid &&
                                                            notifyModel
                                                                    .bookingType ==
                                                                'Rent'
                                                        ? Row(
                                                            children: [
                                                              Expanded(
                                                                child: RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    children: [
                                                                      const TextSpan(
                                                                        text:
                                                                            'The reservation for the ',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              greyColor,
                                                                          fontFamily:
                                                                              'Avenir',
                                                                        ),
                                                                      ),
                                                                      WidgetSpan(
                                                                        alignment:
                                                                            PlaceholderAlignment.top,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              bottom: 5),
                                                                          child:
                                                                              Text(
                                                                            notifyModel.propertyName,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 12,
                                                                              color: primaryColor,
                                                                              fontFamily: 'Avenir',
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            ' is booked for ${DateFormat('MMMM dd').format(DateTime.fromMillisecondsSinceEpoch(notifyModel.checkIn))} by ${notifyModel.buyerName}. Contact number is ${notifyModel.buyerNumber}',
                                                                        style:
                                                                            const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              greyColor,
                                                                          fontFamily:
                                                                              'Avenir',
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : const SizedBox(),

                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(top: 0, left: 8),
                                    child: Text(
                                      notifyModel.orderDate,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 8,
                                        color: blueColor,
                                        fontFamily: 'Avenir',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  });
            },
          )),
        ],
      ),
    );
  }
}
