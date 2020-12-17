//
//  WorkoutManager.swift
//  BeeStrong
//
//  Created by Benjamin Staugaard on 16/12/2020.
//

import Foundation
import CoreData

class WorkoutManager: Manager {
    
    func add(title: String, with exercises: [Exercise]) {
        let w = Workout(context: context)
        w.title = title
        w.exercises = NSOrderedSet(array: exercises)
        appDelegate.saveContext()
    }
    
    func delete(workout: Workout) {
        context.delete(workout)
        appDelegate.saveContext()
    }
    
    func getAllWorkouts() -> [Workout]? {
        let request: NSFetchRequest<Workout> = Workout.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        return executeRequest(request)
    }
}
