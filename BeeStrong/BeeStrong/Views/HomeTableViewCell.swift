//
//  HomeTableViewCell.swift
//  BeeStrong
//
//  Created by Benjamin Staugaard on 02/11/2020.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var trainingSessionTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
