CS-IA - README

Phonics Tools by Trevor Yip

------------Description------------

This iOS app is an app that assists with the learning of phonics sounds. It consists of 3 tools - a Speech-to-Text tool, a Text-to-Speech tool, and a Play Audio Tool.

Each tool is within a View of its own, and can be accessed through tapping a cell on the table on the main screen. To get to the main screen, the user must first sign up by entering their email and password and creating a new account or login with an existing account. User data is stored in the cloud database Firebase Firestore for an easier authentication process and increased security.

The Speech-to-Text tool uses speech recognition to accept external audio input, and will recognise English words. The audio detection is toggled through the use of a button on the screen. To accomplish this feature, I used Apple's built-in Speech framework and adjusted it to fit my solution.

The Text-to-Speech tool has text input and audio output, with buttons toggling speech, reading out the contents of an editable text box. There are 3 buttons, "Play", "Pause", and "Stop" to easily control the audio that is being outputted. To accomplish this feature, I used Apple's built-in Speech framework and adjusted it to fit my solution.

The Play Audio tool consists of a grid of buttons that play phonics sounds when pressed. Each buttons also has an image on it to signify the phonics sound that will be played when it is pressed. To accomplish this feature, I used the DDsounds library to play audio files.

------------Advantages------------

The app has accomplished the task of being an effective solution, as my client has expressed that "the overall app would be very useful, especially for Year One students who need practice with spelling, listening and sounds, words and sentences. The app was both effective in the purpose of teaching the users, as well as allowing them to learn independently." in the testing process.

------------Limitations/Weaknesses------------

At the present moment in the user signup process, only the format of the email is checked and it isn’t verified if it is an actual email address. In the future, an improvement to this system would be for the product to send a verification email to the email that the user entered in order to verify its validity.
Another improvement that could be implemented would be to add child friendly pictures on each page, and to increase the amount of content available in the app. The phonics sounds that my client asked for were for the first four units of Book One in the phonics curriculum, and other units could also be added in the future.

------------How to Run the App on an iOS device------------

Tap on the app once it has been installed on an iOS device.

------------How to Use the App------------

Instructions for each tool can be found by tapping the button at the top right corner of the screen containing the tool.

------------Credit------------

Firebase Firestore: For providing a free cloud database and authentication system

Apple: For creating Swift and associated built-in libraries

My client: For providing images for the buttons used in the Play Audio tool & the phonics sounds used in the Play Audio tool

My CS teacher: For creating the DDsounds library

Credit for source code is given in the form of comments within the code
