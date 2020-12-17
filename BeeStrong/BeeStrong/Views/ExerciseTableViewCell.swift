//
//  ExerciseTableViewCell.swift
//  BeeStrong
//
//  Created by Benjamin Staugaard on 17/12/2020.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {

    private var latestBottomConstraint: NSLayoutConstraint?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var setLabels: [UILabel]!
    @IBOutlet var repsTextFields: [ExerciseTextField]!
    @IBOutlet var kgTextFields: [ExerciseTextField]!
    
    @IBAction func onAddSet(_ sender: UIButton) {
        //TODO
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
