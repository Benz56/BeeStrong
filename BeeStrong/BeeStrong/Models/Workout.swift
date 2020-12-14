//
//  Workout.swift
//  BeeStrong
//
//  Created by Hala Al-Janabi on 14/12/2020.
//

import Foundation

class Workout {
    var workoutTitle: String
    var exercises = [Exercise]()
    var id = UUID()
    
    init(workoutTitle: String, exercises: [Exercise]) {
        self.workoutTitle = workoutTitle
    }
}
