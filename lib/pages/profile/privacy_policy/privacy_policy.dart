import 'package:flutter/material.dart';
import 'package:property_rental_app/common_widgets/custom_appbar.dart';
import 'package:property_rental_app/constants/app_colors.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [

          CustomAppBar(title: 'Privacy Policy', isBackButton: true),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Text(
                      "Lörem ipsum mikrotas dement till krosesavis, paralig. Konfas jura. Biodona äll satement, spelyvun. Palyck podinera.Poskade keduläska är tehant om supras för begon. Tralig bevis ofor. Osk dopehet. Kans dedigisk manyna om påprest. Possa dovura plus kada för att hunik. Tilingar dotulogi infragon preras. Vas hell. Telegun oskade falig kör.Pseudonar twerka twerka och gigasa utan plande. Befotedade ålyskap lyposs, nypregisk. Sobens varas fiskpedikyr maligt parar. Fagt manypän.Stenoliga mikrotris. Anaren besoll. Ora bede antelubel eftersom trena. Pappafeminist difer suning nygisk, att plangen.Profel regnbågsbarn och post. Prel krohes inte krosesm antipinade miser. Doska örade trekvartspudel. Teleköledes kön, betingen telell.Hybridkrig mun emedan snurrmästare homosibengen. Tet donade i dihera. Fäjatenat tiv att åset bloppis. Hemityktig kaheten, supragant.Trevis duse. Prehurat stenor ser. Tugon ål sedan antilig ett stadsutglesning. Trabena intrassade. Du kan vara drabbad.Soldusch fobed spår autost: suprass. Lar tar. Ase dopoling kadurtad plar. Ohus adat.Respejunera tade. Sen dör tuvis på passivhus och kängen. Plana turistkorridor, förutom kontrarade. Siråna fans, ölur mist.Profel regnbågsbarn och post. Prel krohes inte krosesm antipinade miser. Doska örade trekvartspudel. Teleköledes kön, betingen telell. ",
                      textAlign: TextAlign.justify,
                      style: TextStyle(

                        fontWeight: FontWeight.w600,
                        color: blackColor3B,
                        fontSize: 14,
                        fontFamily: 'Avenir',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
