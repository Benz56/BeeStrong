//
//  ExerciseTableViewCell.swift
//  BeeStrong
//
//  Created by Benjamin Staugaard on 17/12/2020.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet var setLabel: [UILabel]!
    @IBOutlet var reps: [UITextField]!
    @IBOutlet var kg: [UITextField]!
    
    @IBAction func onAddSet(_ sender: UIButton) {
        //TODO Add label, rep, kg to collectionview and constrain them.
        //     Tag them such that first row is reps = 1 and kg = 2 and next row is reps = 3 and kg = 4 etc etc.
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reps[0].tag = 1
        kg[0].tag = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
