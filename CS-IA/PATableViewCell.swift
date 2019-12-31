//
//  PATableViewCell.swift
//  CS-IA
//
//  Created by Trevor Yip on 18/9/2019.
//  Copyright © 2019 Trevor Yip. All rights reserved.
//

import UIKit

class PATableViewCell: UITableViewCell {
    
    @IBOutlet weak var PAImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if reuseIdentifier == "playAudio"
        {
            //self.PAImage.image = UIImage(named: "AudioFile")
            //print("PA HAS RUN")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
