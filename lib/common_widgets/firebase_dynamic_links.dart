// import 'package:property_rental_app/universal_models/add_listing_model.dart';
//
// class FirebaseDynamicLinkService{
//   static Future<String> createDynamicLink(AddListingModel listingModel){
//
//
//   }
// }

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

Future createDynamicLink(
  BuildContext context,
  String title,
  String image,
  String itemId,
) async {
  bool short = true;
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: 'https://propertyrental.page.link',

    link: Uri.parse('https://itoneclick.page.link/testing/?id=$itemId'),
    androidParameters: AndroidParameters(
      packageName: '"com.rental.property_rental_app',
      minimumVersion: 0,
    ),
    // socialMetaTagParameters:
    // SocialMetaTagParameters(title: title, imageUrl: Uri.parse(image)),
    // dynamicLinkParametersOptions: DynamicLinkParametersOptions(
    //   shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
    // ),
    // iosParameters: IOSParameters(
    //   bundleId: 'ios bundleId',
    //   minimumVersion: '0',
    // ),
  );

  Uri url;
  if (short) {
    final ShortDynamicLink shortLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    url = shortLink.shortUrl;
  } else {
    // url = await parameters.buildUrl();
  }

  return url.toString();
}
