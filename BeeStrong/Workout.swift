//
//  Workout.swift
//  BeeStrong
//
//  Created by Hala Al-Janabi on 14/12/2020.
//

import Foundation

class workout {
    var workoutTitle: String
    var date = Date()
    var exercises = [exercise]()
    var id = UUID()
    
    init(workoutTitle: String, exercises: [exercise]) {
        self.workoutTitle = workoutTitle
    }
}
