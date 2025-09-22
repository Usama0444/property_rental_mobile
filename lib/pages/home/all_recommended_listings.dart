import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_text_field.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/main.dart';
import 'package:property_rental_app/pages/search_screen/widget/search_property_widget.dart';
import 'package:property_rental_app/universal_models/add_listing_model.dart';
import '../home/controller/home_controller.dart';
 
 
class AllRecommendedListings extends StatelessWidget {
  AllRecommendedListings({
    super.key,
  });

  final controller = Get.put(HomeController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
         
          const SizedBox(height: 14),
          

       
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
                "Recommended Listings",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: blackColor3B,
                  fontSize: 20,
                  fontFamily: 'Avenir',
                ),
              ),
            
          ),
//              const SizedBox(height: 20),
//  Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Row(
//               children: [
//                 Flexible(
//                   child: GestureDetector(
//                     onTap: () {
                    
//                     },
//                     child: CustomTextField(
                      
//                         enabled: false,
//                         hintText: 'Search for City, Community or Building',
//                         controller: controller.searchController),
//                   ),
//                 ),]),),
          const SizedBox(height: 20),
      Expanded(
        child: FutureBuilder(
          future:  FirebaseFirestore.instance
                    .collection('listings')
            .where('sellerID', isNotEqualTo: auth.currentUser!.uid)
            .where('isActive', isEqualTo: true)
            .where('isRecommended', isEqualTo: true)
            .get(),
           
          builder: (context, snapshot) {
        
            if (snapshot.connectionState == ConnectionState.waiting) {
        return const SizedBox();
            }
            if (snapshot.hasError) {
        print(snapshot.error.toString());
        return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Padding(
          padding: EdgeInsets.only(top: Get.height / 3.5),
          child: const Center(
            child: SizedBox(
              child: Text(
                'No Recommended Listings Ads yet.',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: textColor,
                  fontSize: 14,
                  fontFamily: 'Avenir',
                ),
              ),
            ),
          ),
        );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                      AddListingModel listingModel =
                      AddListingModel.fromDocumentSnapshot(
                          snapshot.data!.docs[index]);
             
                 return   Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: SearchPropertyWidget(
                              listingId: snapshot.data!.docs[index].id,
                              searchModel: listingModel,
                            ),
                          );
                      
                  
                },
              ),
            );
                  },
                ),
      )
        ],
      ),
    );
  }
}


