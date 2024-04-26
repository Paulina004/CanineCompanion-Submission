# Canine Companion

###### Tags: `Pet Tracking` `Dog Care` 
###### Languages: `SwiftUI/Swift` `Python`


> [!IMPORTANT]
> This app is the intellectual property of its contributors. Please do not claim, copy, or use the code as your own. Thank you.

<img src="logo.png" width="400" height="280">

## Description
Canine Companion is a comprehensive iOS mobile app designed specifically for dog owners. This innovative platform revolutionizes pet care by integrating health and wellness monitoring, real-time location tracking, and personalized care recommendations utilizing advanced large language model (LLM) technology. Our app is designed to make pet care both accessible and effective, simplifying how you connect with and care for your pets. With features like robust app development, secure database management, user authentication, and cutting-edge generative AI, Canine Companion sets a new standard in pet technology.

## Pods
- [x] Firebase
- [x] FirebaseCore
- [x] FirebaseAuth
- [x] FirebaseDatabase
- [x] ChatGPTSwift ~> 1.3.1

## Chatbot Backend Necessary Modules & Server Setup
Please view [other README.md](CanineCompanionBackend/README.md) about that.


## App Installation Instructions
To use Canine Companion, developers can run the app via Xcode, compatible with the iOS Simulator or a physical iPhone set to developer mode. To do so, you'll need the latest version of Xcode installed on your Mac, along with a valid Apple ID for signing.

---

### Xcode Simulator
Begin by cloning the Canine Companion repository to your local environment with the command git clone [repository-url]. Ensure you install the pods in the Podfile. Once cloned, locate and open the .xcodeproj file in Xcode. You’ll then be able to choose an iOS Simulator to your liking from the top device menu in Xcode. Hit the 'Run' button or use the shortcut Cmd + R to compile and launch Canine Companion in the simulator.
### Using iPhone as Simulator
First, connect your iPhone to your Mac via a USB cable. Open the same .xcodeproj file in Xcode, and ensure your device is selected from the device dropdown menu in Xcode’s toolbar. Before running the app, you’ll need to navigate to the 'Signing & Capabilities' section under the project settings and select your Development Team to sign the app. Once setup is complete, press the 'Run' button or Cmd + R to build and deploy Canine Companion on your iPhone.

---

By following these steps, you can quickly get Canine Companion up and running.


## Features
Canine Companion offers a range of features designed to enhance the care and management of your dog. Our platform integrates advanced technology with user-friendly interfaces to provide a comprehensive solution for dog owners.
Here are some of the key features:
- **Health and Wellness Monitoring:** Keep track of your dog’s health by logging activities, meals, medications, vet appointments, and vaccine records. The app provides reminders and notifications to ensure you never miss a meal time.
- **Personalized Care Assistance:** Utilize our advanced LLM-powered chatbot to receive personalized advice and answers to your pet-related questions.
- **Interactive Map with Dog Park Locator:** Discover new places for your dog to play and socialize. Our map feature highlights nearby dog parks with purple paw prints and provides instant directions so you can easily find the best spots for outdoor fun.
- **Comprehensive Pet Profile Management:** Create and manage detailed profiles for each of your dogs. This centralized information hub helps you maintain accurate records of your pet's health history, preferences, and care requirements.
- **User Account and Settings Control:** Adjust app settings to suit your preferences, manage your password, sign out, or delete your account. You can also add or remove pets from your account, ensuring that each of your dogs receives personalized attention.


## Technology Stack

- **Programming Languages:** Swift for iOS app back-end and Python for GPT + RAG development.
- **Front-End Framework:** SwiftUI for a native and responsive user interface.
app.
- **Authentication:** Firebase Authentication for secure sign-ups, sign-ins, and user account
management.
- **Database:** Firebase Realtime Database for storing and syncing data in real time.
- **Mapping:** Apple’s MapKit for robust mapping and location services tailored for iOS
users.
- **AI and Chatbot Technology:** OpenAI's GPT for the conversational AI and LangChain
for implementing the RAG architecture.
- **Development Tools:** Xcode for iOS development, VSCode for Python scripting, GitHub for version control, and Figma for wireframing and UI design.

## Credits

> [!NOTE]
> A heartfelt thank you to the Canine Companion development team:
> 
> * **Paulina DeVito** (Scrum Master & Full Stack Developer) 
> * **Jenna Leali** (Originator & Full Stack Developer)
> * **Rawan Alhindi** (Full Stack Developer)
> * **Jamar Andrade** (Back-End Developer)
> * **Marty Cheng** (Back-End Developer)
> 
> Your hard work and dedication have been instrumental in bringing this app to life.

