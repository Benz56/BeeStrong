//
//  TrainingSessionManager.swift
//  BeeStrong
//
//  Created by Benjamin Staugaard on 16/12/2020.
//

import Foundation
import CoreData

class TrainingSessionsManager: Manager {
    
    func add(for startDate: Date, for endDate: Date, with workouts: [Workout]) {
        let ts = TrainingSession(context: context)
        ts.startDate = startDate
        ts.endDate = endDate
        ts.workouts = NSSet(array: workouts)
        appDelegate.saveContext()
    }
    
    func delete(session: TrainingSession) {
        context.delete(session)
        appDelegate.saveContext()
    }
    
    func getAllTrainingSessions() -> [TrainingSession]? {
        let request: NSFetchRequest<TrainingSession> = TrainingSession.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
        return executeRequest(request)
    }
}
