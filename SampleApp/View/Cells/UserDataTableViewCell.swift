//
//  UserDataTableViewCell.swift
//  SampleApp
//
//  Created by DoodleBlue on 14/07/23.
//

import UIKit

class UserDataTableViewCell: UITableViewCell {

    @IBOutlet weak var DataLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
