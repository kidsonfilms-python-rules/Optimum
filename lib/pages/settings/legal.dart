import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftc_scouting_app/services/database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AppLegalPage extends StatefulWidget {
  final DatabaseService databaseService;
  const AppLegalPage(this.databaseService, {Key? key}) : super(key: key);

  @override
  _AppLegalPageState createState() => _AppLegalPageState(databaseService);
}

class _AppLegalPageState extends State<AppLegalPage> {
  final DatabaseService databaseService;
  _AppLegalPageState(this.databaseService);

  var termsOfService = """**Terms & Conditions**

By downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app. You’re not allowed to copy or modify the app, any part of the app, or our trademarks in any way. You’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages or make derivative versions. The app itself, and all the trademarks, copyright, database rights, and other intellectual property rights related to it, still belong to Siddharth Ray.

Siddharth Ray is committed to ensuring that the app is as useful and efficient as possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. We will never charge you for the app or its services without making it very clear to you exactly what you’re paying for.

The Optimum app stores and processes personal data that you have provided to us, to provide my Service. It’s your responsibility to keep your phone and access to the app secure. We therefore recommend that you do not jailbreak or root your phone, which is the process of removing software restrictions and limitations imposed by the official operating system of your device. It could make your phone vulnerable to malware/viruses/malicious programs, compromise your phone’s security features and it could mean that the Optimum app won’t work properly or at all.

The app does use third-party services that declare their Terms and Conditions.

Link to Terms and Conditions of third-party service providers used by the app

*   [Google Play Services](https://policies.google.com/terms)
*   [Google Analytics for Firebase](https://firebase.google.com/terms/analytics)
*   [Firebase Crashlytics](https://firebase.google.com/terms/crashlytics)

You should be aware that there are certain things that Siddharth Ray will not take responsibility for. Certain functions of the app will require the app to have an active internet connection. The connection can be Wi-Fi or provided by your mobile network provider, but Siddharth Ray cannot take responsibility for the app not working at full functionality if you don’t have access to Wi-Fi, and you don’t have any of your data allowance left.

If you’re using the app outside of an area with Wi-Fi, you should remember that the terms of the agreement with your mobile network provider will still apply. As a result, you may be charged by your mobile provider for the cost of data for the duration of the connection while accessing the app, or other third-party charges. In using the app, you’re accepting responsibility for any such charges, including roaming data charges if you use the app outside of your home territory (i.e. region or country) without turning off data roaming. If you are not the bill payer for the device on which you’re using the app, please be aware that we assume that you have received permission from the bill payer for using the app.

Along the same lines, Siddharth Ray cannot always take responsibility for the way you use the app i.e. You need to make sure that your device stays charged – if it runs out of battery and you can’t turn it on to avail the Service, Siddharth Ray cannot accept responsibility.

With respect to Siddharth Ray’s responsibility for your use of the app, when you’re using the app, it’s important to bear in mind that although we endeavor to ensure that it is updated and correct at all times, we do rely on third parties to provide information to us so that we can make it available to you. Siddharth Ray accepts no liability for any loss, direct or indirect, you experience as a result of relying wholly on this functionality of the app.

At some point, we may wish to update the app. The app is currently available on Android & iOS – the requirements for the both systems(and for any additional systems we decide to extend the availability of the app to) may change, and you’ll need to download the updates if you want to keep using the app. Siddharth Ray does not promise that it will always update the app so that it is relevant to you and/or works with the Android & iOS version that you have installed on your device. However, you promise to always accept updates to the application when offered to you, We may also wish to stop providing the app, and may terminate use of it at any time without giving notice of termination to you. Unless we tell you otherwise, upon any termination, (a) the rights and licenses granted to you in these terms will end; (b) you must stop using the app, and (if needed) delete it from your device.

**Changes to This Terms and Conditions**

I may update our Terms and Conditions from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Terms and Conditions on this page.

These terms and conditions are effective as of 2022-02-26

**Contact Us**

If you have any questions or suggestions about my Terms and Conditions, do not hesitate to contact me at ftcteam16236@gmail.com.

This Terms and Conditions page was generated by [App Privacy Policy Generator](https://app-privacy-policy-generator.nisrulz.com/)""";

  var privacyPolicy = """**Privacy Policy**

Siddharth Ray built the Optimum app as an Open Source app. This SERVICE is provided by Siddharth Ray at no cost and is intended for use as is.

This page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service.

If you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy.

The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at Optimum unless otherwise defined in this Privacy Policy.

**Information Collection and Use**

For a better experience, while using our Service, I may require you to provide us with certain personally identifiable information, including but not limited to FIRST® Tech Challenge Team Number, FIRST® Tech Challenge Team Nickname. The information that I request will be retained on your device and is not collected by me in any way.

The app does use third-party services that may collect information used to identify you.

Link to the privacy policy of third-party service providers used by the app

*   [Google Play Services](https://www.google.com/policies/privacy/)
*   [Google Analytics for Firebase](https://firebase.google.com/policies/analytics)
*   [Firebase Crashlytics](https://firebase.google.com/support/privacy/)

**Log Data**

I want to inform you that whenever you use my Service, in a case of an error in the app I collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing my Service, the time and date of your use of the Service, and other statistics.

**Cookies**

Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory.

This Service does not use these “cookies” explicitly. However, the app may use third-party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.

**Service Providers**

I may employ third-party companies and individuals due to the following reasons:

*   To facilitate our Service;
*   To provide the Service on our behalf;
*   To perform Service-related services; or
*   To assist us in analyzing how our Service is used.

I want to inform users of this Service that these third parties have access to their Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.

**Security**

I value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its absolute security.

**Links to Other Sites**

This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by me. Therefore, I strongly advise you to review the Privacy Policy of these websites. I have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.

**Children’s Privacy**

These Services do not address anyone under the age of 13. I do not knowingly collect personally identifiable information from children under 13 years of age. In the case I discover that a child under 13 has provided me with personal information, I immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact me so that I will be able to do the necessary actions.

**Changes to This Privacy Policy**

I may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page.

This policy is effective as of 2022-02-26

**Contact Us**

If you have any questions or suggestions about my Privacy Policy, do not hesitate to contact me at ftcteam16236@gmail.com.

This privacy policy page was created at [privacypolicytemplate.net](https://privacypolicytemplate.net) and modified/generated by [App Privacy Policy Generator](https://app-privacy-policy-generator.nisrulz.com/)""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          "LEGAL",
          style: GoogleFonts.getFont('Poppins',
              fontWeight: FontWeight.w200,
              textStyle: const TextStyle(color: Colors.white)),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(
            top: 8.0, bottom: 8.0, left: 20.0, right: 20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 250,
                    child: Text(
                      "By using Optimum, you agree to our Terms of Service",
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          textStyle: const TextStyle(color: Colors.white)),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.0),
                                topRight: Radius.circular(16.0)),
                          ),
                          // backgroundColor: const Color.fromRGBO(29, 29, 29, 1),
                          backgroundColor: Colors.transparent,
                          barrierColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                                child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 20.0,
                                      sigmaY: 20.0,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white12,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        border: Border.all(
                                          color: Colors.black26,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Container(
                                          padding: const EdgeInsets.all(16.0),
                                          child: MarkdownBody(
                                              selectable: true,
                                              data: termsOfService),
                                        ),
                                      ),
                                    )));
                          });
                    },
                    child: Text("SEE >",
                        style: GoogleFonts.getFont("Poppins",
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.white30)),
                  ),
                ],
              ),
              Text("TERMS OF SERVICE",
                  style: GoogleFonts.getFont("Poppins",
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.white30)),
              Container(
                margin: const EdgeInsets.only(bottom: 15, top: 5),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Color.fromRGBO(155, 155, 155, 0.5), width: 1.0),
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 250,
                    child: Text(
                      "By using Optimum, you agree to our Privacy Policy",
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          textStyle: const TextStyle(color: Colors.white)),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.0),
                                topRight: Radius.circular(16.0)),
                          ),
                          // backgroundColor: const Color.fromRGBO(29, 29, 29, 1),
                          backgroundColor: Colors.transparent,
                          barrierColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                                child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 20.0,
                                      sigmaY: 20.0,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white12,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        border: Border.all(
                                          color: Colors.black26,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Container(
                                          padding: const EdgeInsets.all(16.0),
                                          child: MarkdownBody(
                                              selectable: true,
                                              data: privacyPolicy),
                                        ),
                                      ),
                                    )));
                          });
                    },
                    child: Text("SEE >",
                        style: GoogleFonts.getFont("Poppins",
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.white30)),
                  ),
                ],
              ),
              Text("PRIVACY POLICY",
                  style: GoogleFonts.getFont("Poppins",
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.white30)),
              Container(
                margin: const EdgeInsets.only(bottom: 15, top: 5),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Color.fromRGBO(155, 155, 155, 0.5), width: 1.0),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
