//
//  ExerciseTextField.swift
//  BeeStrong
//
//  Created by Benjamin Staugaard on 17/12/2020.
//

import UIKit

class ExerciseTextField: UITextField {
    
    var row = 0
    var set = 0 // Zero indexed.
    var fieldType: FieldType?
}

enum FieldType {
    case reps, kg
}
