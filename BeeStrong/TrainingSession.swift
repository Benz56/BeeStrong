//
//  TrainingSession.swift
//  BeeStrong
//
//  Created by Hala Al-Janabi on 14/12/2020.
//

import Foundation

enum WorkoutStatus {
    case planned
    case current
    case done
}

class TrainingSession {
    let date = Date()
    var status: WorkoutStatus
    var workouts = [Workout]()
    var id = UUID()
    
    init(status: WorkoutStatus, workouts: [Workout], date: Date) {
        self.status = status
    }
    
}
