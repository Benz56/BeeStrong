//
//  WorkoutDetailTableViewCell.swift
//  BeeStrong
//
//  Created by Sofie Louise Madsen on 18/12/2020.
//

import UIKit

class WorkoutDetailTableViewCell: UITableViewCell{
 
    @IBOutlet var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none
    }
    
}
