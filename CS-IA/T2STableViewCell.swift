//
//  T2STableViewCell.swift
//  CS-IA
//
//  Created by Trevor Yip on 18/9/2019.
//  Copyright © 2019 Trevor Yip. All rights reserved.
//

import UIKit

class T2STableViewCell: UITableViewCell {
    @IBOutlet weak var T2SImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if reuseIdentifier == "textToSpeech"
        {
            //self.T2SImage.image = UIImage(named: "T2S")
            //print("T2S HAS RUN")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
