//
//  S2TTableViewCell.swift
//  CS-IA
//
//  Created by Trevor Yip on 18/9/2019.
//  Copyright © 2019 Trevor Yip. All rights reserved.
//

import UIKit

class S2TTableViewCell: UITableViewCell {
    
    @IBOutlet weak var S2TImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if reuseIdentifier == "speechToText"
        {
            //self.S2TImage.image = UIImage(named: "S2T")
            //print("S2T HAS RUN")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
