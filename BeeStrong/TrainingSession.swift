//
//  TrainingSession.swift
//  BeeStrong
//
//  Created by Hala Al-Janabi on 14/12/2020.
//

import Foundation

enum workoutStatus {
    case planned
    case current
    case done
}

class trainingSession {
    let date = Date()
    var status: workoutStatus
    var workouts = [workout]()
    var id = UUID()
    
    init(status: workoutStatus, workouts: [workout], date: Date) {
        self.status = status
    }
    
}
