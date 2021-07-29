import 'package:flutter/material.dart';
import 'package:help_others/services/Constants.dart';

class privacyPolicy extends StatefulWidget {
  @override
  _privacyPolicyState createState() => _privacyPolicyState();
}

class _privacyPolicyState extends State<privacyPolicy> {
  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Privacy Policy",
          style: TextStyle(color: Constants.searchIcon),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Privacy Policy",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                  "Nadin and Nishan built the BBold app as a Free app. This SERVICE is provided by Nadin and Nishan at no cost and is intended for use as is.\nThis page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service.\nIf you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy.\nThe terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at BBold unless otherwise defined in this Privacy Policy. "),
              SizedBox(
                height: 15,
              ),
              Text(
                "Information Collection and Use",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text(
                  "For a better experience, while using our Service, I may require you to provide us with certain personally identifiable information, including but not limited to Name, Mobile Number, Location (optional), Photo (Optional). The information that I request will be retained on your device and is not collected by me in any way.\nThe app does use third party services that may collect information used to identify you. Link to privacy policy of third party service providers used by the app"),
              SizedBox(
                height: 10,
              ),
              Text("* Google Play Services"),
              Text("* AdMob"),
              Text("* Google Analytics for Firebase"),
              Text("* Firebase Crashlytics"),
              SizedBox(
                height: 15,
              ),
              Text(
                "Log Data",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text(
                  "I want to inform you that whenever you use my Service, in a case of an error in the app I collect data and information (through third party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing my Service, the time and date of your use of the Service, and other statistics."),
              SizedBox(
                height: 15,
              ),
              Text(
                "Cookies",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text(
                  "Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory.\nThis Service does not use these “cookies” explicitly. However, the app may use third party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service."),
              SizedBox(
                height: 15,
              ),
              Text(
                "Service Providers",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text(
                  "I may employ third-party companies and individuals due to the following reasons:"),
              Text("* To facilitate our Service;"),
              Text("* To provide the Service on our behalf;"),
              Text("* To perform Service-related services; or"),
              Text("* To assist us in analyzing how our Service is used."),
              Text(
                  "I want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose."),
              SizedBox(
                height: 15,
              ),
              Text(
                "Security",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text(
                  "I value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its absolute security."),
              SizedBox(
                height: 15,
              ),
              Text(
                "Links to Other Sites",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text(
                  "This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by me. Therefore, I strongly advise you to review the Privacy Policy of these websites. I have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services."),
              SizedBox(
                height: 15,
              ),
              Text(
                "Children’s Privacy",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text(
                  "These Services do not address anyone under the age of 13. I do not knowingly collect personally identifiable information from children under 13 years of age. In the case I discover that a child under 13 has provided me with personal information, I immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact me so that I will be able to do necessary actions."),
              SizedBox(
                height: 15,
              ),
              Text(
                "Changes to This Privacy Policy",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text(
                  "I may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page.\nThis policy is effective as of 2021-08-01"),
              SizedBox(
                height: 15,
              ),
              Text(
                "Contact Us",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text(
                  "If you have any questions or suggestions about my Privacy Policy, do not hesitate to contact me at ultimaterocker1994@gmail.com."),
            ]),
          ),
        ),
      ),
    );
  }
}
