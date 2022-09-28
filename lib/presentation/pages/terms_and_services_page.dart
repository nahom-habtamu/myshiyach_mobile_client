import 'package:flutter/material.dart';

import '../widgets/common/curved_container.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/post_detail/detail_item.dart';

class TermsAndServicesPage extends StatelessWidget {
  static String routeName = "/termsAndServicesPage";
  const TermsAndServicesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff11435E),
      appBar: const CustomAppBar(title: 'Terms and Services'),
      body: CurvedContainer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              DetailItem(
                title: const LicenceTextHeader(
                  text: "END USER LICENSE AGREEMENT",
                ),
                subtitle: Column(
                  children: const [
                    LicenseTextParagraph(
                      text:
                          'My Shiyach is licensed to You (End-User) by My Shiyach PLC, located andregistered at Addis Ababa Yeka, Bole, Addis Ababa, Yeka __________,Ethiopia ("Licensor"), for use only under the terms of this License Agreement.',
                    ),
                    SizedBox(height: 15),
                    LicenseTextParagraph(
                      text:
                          'By downloading the Licensed Application from Google\'s software distribution platform("Play Store"), and any update thereto (as permitted by this License Agreement), You indicate that You agree to be bound by all of the terms and conditions of this License Agreement, and that You accept this License Agreement. Play Store is referred to in this License Agreement as "Services.',
                    ),
                    SizedBox(height: 15),
                    LicenseTextParagraph(
                      text:
                          'The parties of this License Agreement acknowledge that the Services are not a Party to this License Agreement and are not bound by any provisions or obligations with regard to the Licensed Application, such as warranty, liability, maintenance and support thereof. My Shiyach PLC, not the Services, is solely responsible for theLicensed Application and the content thereof.',
                    ),
                    SizedBox(height: 15),
                    LicenseTextParagraph(
                      text:
                          'This License Agreement may not provide for usage rules for the Licensed Applicationthat are in conflict with the latest Google Play Terms of Service ("Usage Rules"). MyShiyach PLC acknowledges that it had the opportunity to review the Usage Rules and this License Agreement is not conflicting with them.',
                    ),
                    SizedBox(height: 15),
                    LicenseTextParagraph(
                      text:
                          'My Shiyach when purchased or downloaded through the Services, is licensed to You for use only under the terms of this License Agreement. The Licensor reserves all rights not expressly granted to You. My Shiyach is to be used on devices that operate with Google\'s operating system ("Android"). ',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const DetailItem(
                title: LicenceTextHeader(
                  text: "1. THE APPLICATION ",
                ),
                subtitle: LicenseTextParagraph(
                  text:
                      'My Shiyach ("Licensed Application") is a piece of software created to To facilitaecommerce trading in Ethiopia — and customized for Android mobile devic("Devices"). It is used to To sell products online.',
                ),
              ),
              const SizedBox(height: 15),
              DetailItem(
                title: const LicenceTextHeader(
                  text: "2. SCOPE OF LICENSE",
                ),
                subtitle: Column(
                  children: const [
                    LicenseTextParagraph(
                      text:
                          '2.1 This license will also govern any updates of the Licensed Application provided by Licensor that replace, repair, and/or supplement the first Licensed Application, unless a separate license is provided for such update, in which case the terms of that new license will govern.',
                    ),
                    SizedBox(height: 15),
                    LicenseTextParagraph(
                      text:
                          '2.2 You may not reverse engineer, translate, disassemble, integrate, decompile, remove, modify, combine, create derivative works or updates of, adapt, or attempt to derive the source code of the Licensed Application, or any part thereof (except with My Shiyach PLC\'s prior written consent).',
                    ),
                    SizedBox(height: 15),
                    LicenseTextParagraph(
                      text:
                          '2.3 You may not copy (excluding when expressly authorized by this license and the  Usage Rules) or alter the Licensed Application or portions thereof. You may create  and store copies only on devices that You own or control for backup keeping under  the terms of this license, the Usage Rules, and any other terms and conditions that  apply to the device or software used. You may not remove any intellectual property  notices. You acknowledge that no unauthorized third parties may gain access to  these copies at any time. If you sell your Devices to a third party, you must remove  the Licensed Application from the Devices before doing so.',
                    ),
                    SizedBox(height: 15),
                    LicenseTextParagraph(
                      text:
                          '2.4 Violations of the obligations mentioned above, as well as the attempt of such  infringement, may be subject to prosecution and damages.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              DetailItem(
                title: const LicenceTextHeader(
                  text: "3. TECHNICAL REQUIREMENTS",
                ),
                subtitle: Column(
                  children: const [
                    LicenseTextParagraph(
                      text:
                          '3.1 The Licensed Application requires a firmware version 1.0.0 or higher. Licensor  recommends using the latest version of the firmware',
                    ),
                    SizedBox(height: 15),
                    LicenseTextParagraph(
                      text:
                          '3.2 You acknowledge that it is Your responsibility to confirm and determine that the  app end-user device on which You intend to use the Licensed Application satisfies  the technical specifications mentioned above.',
                    ),
                    SizedBox(height: 15),
                    LicenseTextParagraph(
                      text:
                          '3.3 Licensor reserves the right to modify the technical specifications as it sees  appropriate at any time.  ',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              DetailItem(
                title: const LicenceTextHeader(
                  text: "4. MAINTENANCE AND SUPPORT",
                ),
                subtitle: Column(
                  children: const [
                    LicenseTextParagraph(
                      text:
                          '4.1 The Licensor is solely responsible for providing any maintenance and support  services for this Licensed Application. You can reach the Licensor at the email  address listed in the Play Store Overview for this Licensed Application.',
                    ),
                    SizedBox(height: 15),
                    LicenseTextParagraph(
                      text:
                          '4.2 My Shiyach PLC and the End-User acknowledge that the Services have no  obligation whatsoever to furnish any maintenance and support services with respect  to the Licensed Application.',
                    ),
                  ],
                ),
              ),
              DetailItem(
                title: const LicenceTextHeader(
                  text: "5. USER-GENERATED CONTRIBUTIONS",
                ),
                subtitle: Column(
                  children: const [
                    LicenseTextParagraph(
                      text:
                          'The Licensed Application may invite you to chat, contribute to, or participate in blogs,  message boards, online forums, and other functionality, and may provide you with the  opportunity to create, submit, post, display, transmit, perform, publish, distribute, or  broadcast content and materials to us or in the Licensed Application, including but  not limited to text, writings, video, audio, photographs, graphics, comments,  suggestions, or personal information or other material (collectively, "Contributions").  Contributions may be viewable by other users of the Licensed Application and  through third-party websites or applications. As such, any Contributions you transmit  may be treated as non-confidential and non-proprietary. When you create or make  available any Contributions, you thereby represent and warrant that:  ',
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: LicenseTextParagraph(
                        text:
                            '1. The creation, distribution, transmission, public display, or performance, and the  accessing, downloading, or copying of your Contributions do not and will not  infringe the proprietary rights, including but not limited to the copyright, patent,  trademark, trade secret, or moral rights of any third party.  ',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: LicenseTextParagraph(
                        text:
                            '2. You are the creator and owner of or have the necessary licenses, rights,  consents, releases, and permissions to use and to authorize us, the Licensed  Application, and other users of the Licensed Application to use your Contributions  in any manner contemplated by the Licensed Application and this License  Agreement.',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: LicenseTextParagraph(
                        text:
                            '3. You have the written consent, release, and/or permission of each and every  identifiable individual person in your Contributions to use the name or likeness or  each and every such identifiable individual person to enable inclusion and use of  your Contributions in any manner contemplated by the Licensed Application and  this License Agreement.',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: LicenseTextParagraph(
                        text:
                            '4. Your Contributions are not false, inaccurate, or misleading.',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: LicenseTextParagraph(
                        text:
                            '5. Your Contributions are not unsolicited or unauthorized advertising, promotional  materials, pyramid schemes, chain letters, spam, mass mailings, or other forms of  solicitation.  ',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: LicenseTextParagraph(
                        text:
                            '6. Your Contributions are not obscene, lewd, lascivious, filthy, violent, harassing,libelous, slanderous, or otherwise objectionable (as determined by us).',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: LicenseTextParagraph(
                        text:
                            '7. Your Contributions do not ridicule, mock, disparage, intimidate, or abuseanyone.',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: LicenseTextParagraph(
                        text:
                            '8. Your Contributions are not used to harass or threaten (in the legal sense of  those terms) any other person and to promote violence against a specific person  or class of people.',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: LicenseTextParagraph(
                        text:
                            '9. Your Contributions do not violate any applicable law, regulation, or rule.',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: LicenseTextParagraph(
                        text:
                            '10. Your Contributions do not violate the privacy or publicity rights of any thirdparty.',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: LicenseTextParagraph(
                        text:
                            '11. Your Contributions do not violate any applicable law concerning child',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: LicenseTextParagraph(
                        text:
                            '12. Your Contributions do not include any offensive comments that are connected to race, national origin, gender, sexual preference, or physical handicap',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: LicenseTextParagraph(
                        text:
                            '13. Your Contributions do not otherwise violate, or link to material that violates,  any provision of this License Agreement, or any applicable law or regulation.',
                      ),
                    ),
                    SizedBox(height: 15),
                    LicenseTextParagraph(
                      text:
                          'Any use of the Licensed Application in violation of the foregoing violates this License  Agreement and may result in, among other things, termination or suspension of your  rights to use the Licensed Application.  ',
                    )
                  ],
                ),
              ),
              const SizedBox(height: 15),
              DetailItem(
                title: const LicenceTextHeader(
                  text: "6. CONTRIBUTION LICENSE",
                ),
                subtitle: Column(
                  children: const [
                    LicenseTextParagraph(
                      text:
                          'By posting your Contributions to any part of the Licensed Application or making  Contributions accessible to the Licensed Application by linking your account from the  Licensed Application to any of your social networking accounts, you automatically  grant, and you represent and warrant that you have the right to grant, to us an  unrestricted, unlimited, irrevocable, perpetual, non-exclusive, transferable, royaltyfree, fully-paid, worldwide right, and license to host, use copy, reproduce, disclose,  sell, resell, publish, broad cast, retitle, archive, store, cache, publicly display,reformat,translate, transmit, excerpt (in whole or in part), and distribute such  Contributions (including, without limitation, your image and voice) for any purpose,  commercial advertising, or otherwise, and to prepare derivative works of, or  incorporate in other works, such as Contributions, and grant and authorize  sublicenses of the foregoing. The use and distribution may occur in any media  formats and through any media channels',
                    ),
                    SizedBox(height: 15),
                    LicenseTextParagraph(
                      text:
                          'This license will apply to any form, media, or technology now known or hereafter developed, and includes our use of your name, company name, and franchise name, as applicable, and any of the trademarks, service marks, trade names, logos, and personal and commercial images you provide. You waive all moral rights in your Contributions, and you warrant that moral rights have not otherwise been asserted in your Contributions.',
                    ),
                    SizedBox(height: 15),
                    LicenseTextParagraph(
                      text:
                          'We do not assert any ownership over your Contributions. You retain full ownership of  all of your Contributions and any intellectual property rights or other proprietary rights  associated with your Contributions. We are not liable for any statements or  representations in your Contributions provided by you in any area in the Licensed  Application. You are solely responsible for your Contributions to the Licensed  Application and you expressly agree to exonerate us from any and all responsibility  and to refrain from any legal action against us regarding your Contributions.',
                    ),
                    SizedBox(height: 15),
                    LicenseTextParagraph(
                      text:
                          'We have the right, in our sole and absolute discretion, (1) to edit, redact, or otherwise change any Contributions; (2) to recategorize any Contributions to place them in more appropriate locations in the Licensed Application; and (3) to prescreen or delete any Contributions at any time and for any reason, without notice. We have no obligation to monitor your Contributions.',
                    )
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const DetailItem(
                title: LicenceTextHeader(
                  text: "7. LIABILITY",
                ),
                subtitle: LicenseTextParagraph(
                  text:
                      '7.1 Licensor takes no accountability or responsibility for any damages caused due to a breach of duties according to Section 2 of this License Agreement. To avoid data loss, You are required to make use of backup functions of the Licensed Application to the extent allowed by applicable third-party terms and conditions of use. You are aware that in case of alterations or manipulations of the Licensed Application, You will not have access to the Licensed Application.',
                ),
              ),
              const SizedBox(height: 15),
              DetailItem(
                title: const LicenceTextHeader(
                  text: "8. WARRANTY",
                ),
                subtitle: Column(
                  children: const [
                    LicenseTextParagraph(
                      text:
                          '8.1 Licensor warrants that the Licensed Application is free of spyware, trojan horses, viruses, or any other malware at the time of Your download. Licensor warrants that the Licensed Application works as described in the user documentation. ',
                    ),
                    SizedBox(height: 15),
                    LicenseTextParagraph(
                        text:
                            '8.2 No warranty is provided for the Licensed Application that is not executable on the device, that has been unauthorizedly modified, handled inappropriately or culpably, combined or installed with inappropriate hardware or software, used with inappropriate accessories, regardless if by Yourself or by third parties, or if there are any other reasons outside of My Shiyach PLC\'s sphere of influence that affect the executability of the Licensed Application.'),
                    SizedBox(height: 15),
                    LicenseTextParagraph(
                      text:
                          '8.3 You are required to inspect the Licensed Application immediately after installing it and notify My Shiyach PLC about issues discovered without delay by email provided in Product Claims. The defect report will be taken into consideration and further investigated if it has been emailed within a period of ninety (90) days after discovery. ',
                    ),
                    SizedBox(height: 15),
                    LicenseTextParagraph(
                      text:
                          '8.4 If we confirm that the Licensed Application is defective, My Shiyach PLC reserves a choice to remedy the situation either by means of solving the defect or substitute delivery. ',
                    ),
                    SizedBox(height: 15),
                    LicenseTextParagraph(
                      text:
                          '8.5 In the event of any failure of the Licensed Application to conform to any applicable warranty, You may notify the Services Store Operator, and Your Licensed Application purchase price will be refunded to You. To the maximum extent permitted by applicable law, the Services Store Operator will have no other warranty obligation whatsoever with respect to the Licensed Application, and any other losses, claims, damages, liabilities, expenses, and costs attributable to any negligence to adhere to any warranty ',
                    ),
                    SizedBox(height: 15),
                    LicenseTextParagraph(
                      text:
                          '8.5 In the event of any failure of the Licensed Application to conform to any applicable warranty, You may notify the Services Store Operator, and Your Licensed Application purchase price will be refunded to You. To the maximum extent permitted by applicable law, the Services Store Operator will have no other warranty obligation whatsoever with respect to the Licensed Application, and any other losses, claims, damages, liabilities, expenses, and costs attributable to any negligence to adhere to any warranty ',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              DetailItem(
                title: const LicenceTextHeader(
                  text: "9. PRODUCT CLAIMS",
                ),
                subtitle: Column(
                  children: const [
                    LicenseTextParagraph(
                      text:
                          'My Shiyach PLC and the End-User acknowledge that My Shiyach PLC, and not the Services, is responsible for addressing any claims of the End-User or any third party relating to the Licensed Application or the End-User’s possession and/or use of that Licensed Application, including, but not limited to:',
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: LicenseTextParagraph(
                        text: '(i) product liability claims;',
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: LicenseTextParagraph(
                        text:
                            '(ii) any claim that the Licensed Application fails to conform to any applicable legalor regulatory requirement; and',
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: LicenseTextParagraph(
                        text:
                            '(iii) claims arising under consumer protection, privacy, or similar legislation.',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const DetailItem(
                title: LicenceTextHeader(
                  text: "10. LEGAL COMPLIANCE",
                ),
                subtitle: LicenseTextParagraph(
                  text:
                      'You represent and warrant that You are not located in a country that is subject to a US Government embargo, or that has been designated by the US Government as a "terrorist supporting" country; and that You are not listed on any US Government list of prohibited or restricted parties.',
                ),
              ),
              const SizedBox(height: 15),
              DetailItem(
                title: const LicenceTextHeader(
                  text: "11. CONTACT INFORMATION",
                ),
                subtitle: Column(
                  children: const [
                    LicenseTextParagraph(
                      text:
                          'For general inquiries, complaints, questions or claims concerning the Licensed Application, please contact:.',
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: LicenseTextParagraph(
                        text: 'My Shiyach PLC',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: LicenseTextParagraph(
                        text: 'Addis Ababa Yeka, Bole',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: LicenseTextParagraph(
                        text: 'Ethiopia',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: LicenseTextParagraph(
                        text: 'myshiyach@gmail.com',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const DetailItem(
                title: LicenceTextHeader(
                  text: "12. TERMINATION",
                ),
                subtitle: LicenseTextParagraph(
                  text:
                      'The license is valid until terminated by My Shiyach PLC or by You. Your rights under this license will terminate automatically and without notice from My Shiyach PLC if You fail to adhere to any term(s) of this license. Upon License termination, You shall stop all use of the Licensed Application, and destroy all copies, full or partial, of the Licensed Application.',
                ),
              ),
              const SizedBox(height: 15),
              DetailItem(
                title: const LicenceTextHeader(
                  text: "13. THIRD-PARTY TERMS OF AGREEMENTS AND BENEFICIARY",
                ),
                subtitle: Column(
                  children: const [
                    LicenseTextParagraph(
                      text:
                          'My Shiyach PLC represents and warrants that My Shiyach PLC will comply with applicable third-party terms of agreement when using Licensed Application. ',
                    ),
                    SizedBox(height: 15),
                    LicenseTextParagraph(
                      text:
                          'In Accordance with Section 9 of the "Instructions for Minimum Terms of Developer\'s End-User License Agreement," Google\'s subsidiaries shall be third-party beneficiaries of this End User License Agreement and — upon Your acceptance of the terms and conditions of this License Agreement, Google will have the right (and will be deemed to have accepted the right) to enforce this End User License Agreement against You as a third-party beneficiary thereof.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const DetailItem(
                title: LicenceTextHeader(
                  text: "14. INTELLECTUAL PROPERTY RIGHTS",
                ),
                subtitle: LicenseTextParagraph(
                  text:
                      'My Shiyach PLC and the End-User acknowledge that, in the event of any third-party claim that the Licensed Application or the End-User\'s possession and use of that Licensed Application infringes on the third party\'s intellectual property rights, My Shiyach PLC, and not the Services, will be solely responsible for the investigation, defense, settlement, and discharge or any such intellectual property infringement claims.',
                ),
              ),
              const SizedBox(height: 15),
              DetailItem(
                title: const LicenceTextHeader(
                  text: "16. MISCELLANEOUS",
                ),
                subtitle: Column(
                  children: const [
                    LicenseTextParagraph(
                      text:
                          '16.1 If any of the terms of this agreement should be or become invalid, the validity of the remaining provisions shall not be affected. Invalid terms will be replaced by valid ones formulated in a way that will achieve the primary purpose.',
                    ),
                    SizedBox(height: 15),
                    LicenseTextParagraph(
                      text:
                          '16.1 If any of the terms of this agreement should be or become invalid, the validity of the remaining provisions shall not be affected. Invalid terms will be replaced by valid ones formulated in a way that will achieve the primary purpose.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LicenseTextParagraph extends StatelessWidget {
  final String text;
  const LicenseTextParagraph({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.grey[800],
        fontSize: 13,
      ),
    );
  }
}

class LicenceTextHeader extends StatelessWidget {
  final String text;
  const LicenceTextHeader({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.italic,
          fontSize: 18,
        ),
      ),
    );
  }
}
