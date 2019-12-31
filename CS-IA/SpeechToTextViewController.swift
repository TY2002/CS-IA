//
//  ViewController.swift
//  CS-IA
//
//  Created by Trevor Yip on 17/8/2019.
//  Copyright © 2019 Trevor Yip. All rights reserved.
//

//Speech-to-text code partly based on https://www.appcoda.com/siri-speech-framework/
//Image picking code based on http://www.codingexplorer.com/choosing-images-with-uiimagepickercontroller-in-swift/
import UIKit
import Speech

/// The viewController containing the Speech To Text tool
class SpeechToTextViewController: UIViewController, SFSpeechRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// Button to start and stop recording
    @IBOutlet weak var micButton: UIButton!
    /// The text box for output text
    @IBOutlet weak var textToHear: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    ///Gradient: Wedding Day Blues
    var S2TViewBackgroundFirstRGB : RGBObject = RGBObject.init(r: 64, g: 224, b: 208)
    var S2TViewBackgroundSecondRGB : RGBObject = RGBObject.init(r: 255, g: 140, b: 0)
    var S2TViewBackgroundThirdRGB : RGBObject = RGBObject.init(r: 255, g: 0, b: 128)
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"));
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine();
    
    /// Loads image picker, allowing user to pick images from the device's camera roll
    ///
    /// - Parameter sender: The "Choose Image" button
    @IBAction func loadImagePicker(_ sender: UIButton)
    {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    /// Starts and stops recording external audio; as well as changing text when micButton is tapped
    ///
    /// - Parameter sender: micButton
    @IBAction func micTapped(_ sender: UIButton) {
        if audioEngine.isRunning
        {
            audioEngine.stop();
            recognitionRequest?.endAudio();
            micButton.isEnabled = false;
            micButton.setTitle("Start Recording", for: .normal);
        }
        else
        {
            startRecording();
            micButton.setTitle("Stop Recording", for: .normal);
        }
    }
    
    /// Presents alert on screen containing instructions when user presses instruction button
    ///
    /// - Parameter sender: Instruction button
    //Alert code based on https://learnappmaking.com/uialertcontroller-alerts-swift-how-to/
    @IBAction func instructions(_ sender: Any) {
        let S2Talert = UIAlertController(title: "Instructions", message: "The Speech To Text tool allows you to transcribe spoken words into text on the screen. Only the first word will be displayed.", preferredStyle: .alert)
        
        S2Talert.addAction(UIAlertAction(title: "Exit", style: .default, handler: nil))
        
        self.present(S2Talert, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var audioSession: AVAudioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .spokenAudio, options: .defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch let error{
            print("audioSession properties weren't set because of an error: ", error)
        }
        
        let bgView = UIView.init(frame: self.view.frame)
        let gradientLayer = UI_Util.get3ColourGradient(uiView: bgView, firstRGB: S2TViewBackgroundFirstRGB, secondRGB: S2TViewBackgroundSecondRGB, thirdRGB: S2TViewBackgroundThirdRGB)
        self.view.layer.insertSublayer(gradientLayer, below: micButton.layer)
        
        imagePicker.delegate = self
        micButton.isEnabled = false;
        speechRecognizer?.delegate = self;
        
        ///Requests authorization for speech recognition from user
        SFSpeechRecognizer.requestAuthorization{ (authStatus) in
            var buttonEnabled = false;
            
            switch(authStatus)
            {
            case .authorized:
                buttonEnabled = true;
            case .denied:
                buttonEnabled = false;
                print("User denied access to speech recognition");
            case .restricted:
                buttonEnabled = false;
                print("Speech recognition restricted on this device");
            case .notDetermined:
                buttonEnabled = false;
                print("Speech recognition not yet authorised")
            }
            
            OperationQueue.main.addOperation()
            {
                    self.micButton.isEnabled = buttonEnabled;
            }
        }
    }
    
    /// Starts recording
    func startRecording()
    {
        if recognitionTask != nil
        {
            recognitionTask?.cancel();
            recognitionTask = nil;
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest();
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else
        {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object");
        }
        
        recognitionRequest.shouldReportPartialResults = true;
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false;
            
            if result != nil
            {
                ///Only shows the first word of external audio input
                let tempString = result?.bestTranscription.formattedString;
                self.textToHear.text = tempString?.components(separatedBy: " ")[0]
                isFinal = (result?.isFinal)!;
            }
            
            if error != nil || isFinal
            {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0);
                
                self.recognitionRequest = nil;
                self.recognitionTask = nil;
                
                self.micButton.isEnabled = true;
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0);
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer);
        }
        
        audioEngine.prepare();
        
        do
        {
            try audioEngine.start();
        }
        catch
        {
            print("audioEngine couldn't start because of an error.");
        }
        
        textToHear.text = "Say something, I'm listening!";
    }
    
    /// Toggles the state of micButton
    ///
    /// - Parameters:
    ///   - speechRecognizer: The current speechRecognizer
    ///   - available: The availability of speech recognition
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            micButton.isEnabled = true
        } else {
            micButton.isEnabled = false
        }
    }
    
    //MARK: - Image picking
    
    /// Assigns picked image from camera roll to imageView
    /// - Parameters:
    ///   - picker: UIImagePicker Controller
    ///   - info: Info Key
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
