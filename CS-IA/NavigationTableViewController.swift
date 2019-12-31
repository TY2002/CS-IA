//
//  NavigationTableViewController.swift
//  CS-IA
//
//  Created by Trevor Yip on 11/8/2019.
//  Copyright © 2019 Trevor Yip. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

///The navigation viewController
class NavigationTableViewController: UITableViewController {
    
    let segueIdentifiers : Array<String>! = ["navigationToPA", "navigationToS2T", "navigationToT2S"]
    let imageNames : Array<String>! = ["AudioFile", "S2T", "T2S"]
    
    var exerciseTypesColRef : CollectionReference!
    var usersColRef : CollectionReference!
    
    ///Array of all sections in Table
    var allSections : Array<SectionObject>!
    
    ///Boolean controlling custom segues
    var custom : Bool = false
    
    var rowNum : Int = 0
    var userID : String! = Auth.auth().currentUser?.uid
    var loggedInBefore : Bool! = true
    
    ///Gradient: King Yna
    var tableViewBackgroundFirstRGB : RGBObject = RGBObject.init(r: 26, g: 42, b: 108)
    var tableViewBackgroundSecondRGB : RGBObject = RGBObject.init(r: 178, g: 31, b: 31)
    var tableViewBackgroundThirdRGB : RGBObject = RGBObject.init(r: 253, g: 187, b: 45)
    
    //Back Button Code based on https://stackoverflow.com/questions/30052587/how-can-i-go-back-to-the-initial-view-controller-in-swift
    @objc func back(sender: UIBarButtonItem) {
        do
        {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "unwindToStartViewController", sender: self)
        }
        catch let signOutError as NSError
        {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newBackButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        
        self.navigationItem.rightBarButtonItem = newBackButton
        
        //Code based on https://stackoverflow.com/questions/18638779/setting-a-background-layer-below-uitableview
        ///Sets background gradient
        let bgView = UIView.init(frame: self.tableView.frame)
        UI_Util.setGradient(uiView: bgView, firstRGB: tableViewBackgroundFirstRGB, secondRGB: tableViewBackgroundSecondRGB, thirdRGB: tableViewBackgroundThirdRGB)
        self.tableView.backgroundView = bgView
        
        exerciseTypesColRef = Firestore.firestore().collection("exerciseTypes")
        usersColRef = Firestore.firestore().collection("users")
        allSections = []
        
        ///Get Documents from Firebase in Collection exerciseTypes
        exerciseTypesColRef.getDocuments { (docsSnapshot, error) in
            ///Checking for errors
            if let error = error
            {
                print("ERROR GETTING DOCUMENTS \(error)");
            }
            ///Loops through all documents, transfers data to temporary SectionObject Object and adds it to allSections
            else
            {
                var tempSectionObject : SectionObject
                for document in docsSnapshot!.documents
                {
                    tempSectionObject = SectionObject.init(name: document["title"] as! String, content: document["exerciseNames"] as! Array<String>)
                    self.allSections.append(tempSectionObject)
                }
            }
            DispatchQueue.main.async
            {
                self.tableView.reloadData()
            }
        }
        
        ///Creates documents in database for new users
        if !loggedInBefore
        {
            self.usersColRef.document(self.userID).setData([
                "text0" : "Type here",
                "text1" : "Type here"
                ])
        }
    }
    
    // MARK: - Table view data source
    
    /// Returns the number of sections in the table
    ///
    /// - Parameter tableView: The current tableView
    /// - Returns: The number of sections in the table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allSections.count;
    }
    
    /// Returns the title of the section header
    ///
    /// - Parameters:
    ///   - tableView: The current tableView
    ///   - section: The current section
    /// - Returns: The title of the section
    override func tableView(_ tableView : UITableView, titleForHeaderInSection section : Int) -> String?
    {
        return allSections![section].name
    }
    
    /// Configures the font and font size of section header
    ///
    /// - Parameters:
    ///   - tableView: The current tableView
    ///   - section: The current section
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        //Font-changing code based on https://stackoverflow.com/questions/30247112/change-uitableviewcell-font-in-ios-8-and-swift
        header.textLabel?.font = UIFont(name: "Futura", size: 18)
    }
    
    /// Returns the number of rows in the current section
    ///
    /// - Parameters:
    ///   - tableView: The current tableView
    ///   - section: The current section
    /// - Returns: The number of rows in the current section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allSections![section].content.count
    }
    
    /// Configures the content inside the current cell; configures the font and font size of the title
    ///
    /// - Parameters:
    ///   - tableView: The current tableView
    ///   - indexPath: The indexPath of the current cell
    /// - Returns: The cell after its contents are set
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell = UITableViewCell.init()
        
        cell = tableView.dequeueReusableCell(withIdentifier: "playAudio", for: indexPath)
        cell.textLabel?.text = allSections[indexPath.section].content[indexPath.row]
        cell.imageView?.image = UIImage(named: imageNames[indexPath.section])
        //Font-changing code based on https://stackoverflow.com/questions/30247112/change-uitableviewcell-font-in-ios-8-and-swift
        cell.textLabel?.font = UIFont(name: "Futura", size: 18)
        
        return cell
    }
    
    /// Performs custom segue when a row is selected
    ///
    /// - Parameters:
    ///   - tableView: The current tableView
    ///   - indexPath: The indexPath of the selected row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        custom = true
        let segueIdentifier : String = segueIdentifiers[indexPath.section]
        if segueIdentifier == "navigationToT2S"
        {
            rowNum = indexPath.row
        }
        performSegue(withIdentifier: segueIdentifier, sender: Any?.self)
        custom = false
    }

    /// Prevents default segues from being performed
    ///
    /// - Parameters:
    ///   - identifier: The segue identifier
    ///   - sender: The segue
    /// - Returns: Boolean value controlling whether the segue should be performed
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
    {
        return custom
    }
    
    // MARK: - Navigation
    
    //Code based on https://stackoverflow.com/questions/24040692/prepare-for-segue-in-swift
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "navigationToT2S"
        {
            if let textToSpeechViewController = segue.destination as? TextToSpeechViewController
            {
                textToSpeechViewController.docNum = rowNum
                textToSpeechViewController.userID = userID
            }
        }
    }
}
