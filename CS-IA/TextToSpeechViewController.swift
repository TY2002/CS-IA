//
//  TextToSpeechExerciseViewController.swift
//  CS-IA
//
//  Created by Trevor Yip on 30/8/2019.
//  Copyright © 2019 Trevor Yip. All rights reserved.
//

// Text to speech tool partly based on https://www.appcoda.com/text-to-speech-ios-tutorial/
import UIKit
import Speech
import Firebase

/// The viewController containing the Text to Speech tool
class TextToSpeechViewController: UIViewController, AVSpeechSynthesizerDelegate {

    let speechSynthesizer = AVSpeechSynthesizer();
    var rate : Float!
    var pitch : Float!
    var volume : Float!
    
    var totalUtterances: Int! = 0
    var currentUtterance: Int! = 0
    
    var savedTextsColRef : CollectionReference!
    var usersColRef : CollectionReference!
    
    var docNum : Int! = 0
    var docName : String! = ""
    var userID : String! = ""
    
    ///Gradient: Megatron
    var T2SViewBackgroundFirstRGB : RGBObject = RGBObject.init(r: 198, g: 255, b: 221)
    var T2SViewBackgroundSecondRGB : RGBObject = RGBObject.init(r: 251, g: 215, b: 134)
    var T2SViewBackgroundThirdRGB : RGBObject = RGBObject.init(r: 247, g: 121, b: 125)
    
    /// Editable text field
    @IBOutlet weak var textToSay: UITextView!
    
    @IBOutlet weak var speakButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /// Says text in the textView/resumes speaking
    ///
    /// - Parameter sender: The speak button
    @IBAction func speak(_ sender: Any) {
        if !speechSynthesizer.isSpeaking
        {
            let textParagraphs = textToSay.text!.components(separatedBy: "\n")
            
            totalUtterances = textParagraphs.count
            currentUtterance = 0
            
            for pieceOfText in textParagraphs
            {
                let speechUtterance = AVSpeechUtterance(string: pieceOfText)
                speechUtterance.rate = rate
                speechUtterance.pitchMultiplier = pitch
                speechUtterance.volume = volume
                speechUtterance.postUtteranceDelay = 0.005
                
                speechSynthesizer.speak(speechUtterance)
            }
        }
        else
        {
            speechSynthesizer.continueSpeaking();
        }
        animateActionButtonAppearance(shouldHideSpeakButton: true)
    }
    
    /// Pauses speaking at current word
    ///
    /// - Parameter sender: The pause button
    @IBAction func pauseSpeech(_ sender: Any) {
        speechSynthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
        animateActionButtonAppearance(shouldHideSpeakButton: false)
    }
    
    /// Stops speaking immediately
    ///
    /// - Parameter sender: The stop button
    @IBAction func stopSpeech(_ sender: Any) {
        speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        animateActionButtonAppearance(shouldHideSpeakButton: false)
    }
    
    /// Saves text inside textView
    ///
    /// - Parameter sender: The save button
    @IBAction func saveText(_ sender: UIButton) {
        setText()
    }
    
    /// Presents alert on screen containing instructions when user presses instruction button
    ///
    /// - Parameter sender: Instruction button
    //Alert code based on https://learnappmaking.com/uialertcontroller-alerts-swift-how-to/
    @IBAction func instructions(_ sender: Any) {
        let T2Salert = UIAlertController(title: "Instructions", message: "The Text To Speech tool allows the app to convert text that you have typed on screen to spoken words.", preferredStyle: .alert)
        
        T2Salert.addAction(UIAlertAction(title: "Exit", style: .default, handler: nil))
        
        self.present(T2Salert, animated: true)
    }
    
    /// Shows/hides certain buttons on screen
    ///
    /// - Parameter shouldHideSpeakButton: Boolean that is set to decide which buttons should be shown or hidden
    func animateActionButtonAppearance(shouldHideSpeakButton: Bool)
    {
        var speakButtonAlphaValue: CGFloat = 1.0
        var pauseStopButtonsAlphaValue: CGFloat = 0.0
        
        if shouldHideSpeakButton
        {
            speakButtonAlphaValue = 0.0
            pauseStopButtonsAlphaValue = 1.0
        }
        
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.speakButton.alpha = speakButtonAlphaValue
            self.pauseButton.alpha = pauseStopButtonsAlphaValue
            self.stopButton.alpha = pauseStopButtonsAlphaValue
        })
    }
    
    /// Toggles the visibilty of buttons
    ///
    /// - Parameters:
    ///   - synthesizer: The current speechSynthesizer
    ///   - utterance: The current utterance
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didFinishSpeechUtterance utterance: AVSpeechUtterance!) {
        if currentUtterance == totalUtterances
        {
            animateActionButtonAppearance(shouldHideSpeakButton: false)
        }
    }
    
    /// Increments the currentUtterance
    ///
    /// - Parameters:
    ///   - synthesizer: The current speechSynthesizer
    ///   - utterance: The current utterance
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didStartSpeechUtterance utterance: AVSpeechUtterance!) {
        currentUtterance += 1;
    }
    
    /// Sets String in the document in the database to String in text field
    func setText()
    {
        usersColRef.document(userID).updateData(["text" + String(docNum) : textToSay.text])  { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    /// Sets String in text field to String in the document in the database
    func getText()
    {
        usersColRef.document(userID).getDocument { (document, error) in
            if let document = document, document.exists {
                self.textToSay.text = (document["text" + String(self.docNum)] as! String)
            }
            else
            {
                print("Document does not exist")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let bgView = UIView.init(frame: self.view.frame)
        let gradientLayer = UI_Util.get3ColourGradient(uiView: bgView, firstRGB: T2SViewBackgroundFirstRGB, secondRGB: T2SViewBackgroundSecondRGB, thirdRGB: T2SViewBackgroundThirdRGB)
        self.view.layer.insertSublayer(gradientLayer, below: pauseButton.layer)
        
        self.speakButton.alpha = 1.0
        self.pauseButton.alpha = 0.0
        self.stopButton.alpha = 0.0
        
        speechSynthesizer.delegate = self
        
        rate = AVSpeechUtteranceDefaultSpeechRate
        pitch = 1.0
        volume = 1.0
        
        savedTextsColRef = Firestore.firestore().collection("savedTexts")
        usersColRef = Firestore.firestore().collection("users")
        
        getText()
    }
}
