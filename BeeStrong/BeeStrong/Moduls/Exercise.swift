//
//  Exercise.swift
//  BeeStrong
//
//  Created by Hala Al-Janabi on 14/12/2020.
//

import Foundation

class Exercise {
        var exerciseTitle: String
        var bodyPart: String
        var sets = [Set]()
        let id = UUID()
    
    init(exerciseTitle: String, bodyPart: String, sets: [Set]) {
        self.exerciseTitle = exerciseTitle
        self.bodyPart = bodyPart
        
    }
}
