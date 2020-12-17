//
//  ExerciseTypeCollectionViewCell.swift
//  BeeStrong
//
//  Created by Benjamin Staugaard on 16/12/2020.
//

import UIKit

class ExerciseTypeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var bodyPart: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let def = UIView(frame: bounds)
        def.backgroundColor = UIColor.white
        self.backgroundView = def

        let selected = UIView(frame: bounds)
        selected.backgroundColor = UIColor.systemYellow
        self.selectedBackgroundView = selected
    }
}
