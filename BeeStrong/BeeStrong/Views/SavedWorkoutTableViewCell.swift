//
//  SavedWorkoutTableViewCell.swift
//  BeeStrong
//
//  Created by Benjamin Staugaard on 17/12/2020.
//

import UIKit

class SavedWorkoutTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var exercisesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
