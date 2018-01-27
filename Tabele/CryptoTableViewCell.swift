//
//  CryptoTableViewCell.swift
//  Tabele
//
//  Created by Matic on 22/01/2018.
//  Copyright © 2018 Matic. All rights reserved.
//

import UIKit

class CryptoTableViewCell: UITableViewCell {
    
    // simple IBOutlets from UITableViewCell so we can present some data in them. This class is used on line 83 in ViewController.swift
    @IBOutlet weak var cryptoImageView: UIImageView!
    @IBOutlet weak var shortNameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
