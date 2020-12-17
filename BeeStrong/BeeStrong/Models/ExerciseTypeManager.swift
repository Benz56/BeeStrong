//
//  ExerciseTypeManager.swift
//  BeeStrong
//
//  Created by Benjamin Staugaard on 16/12/2020.
//

import Foundation
import CoreData

class ExerciseTypeManager: Manager {
    
    func add(title: String, bodyPart: String) {
        let et = ExerciseType(context: context)
        et.title = title
        et.bodyPart = bodyPart
        appDelegate.saveContext()
    }
    
    func delete(exerciseType: ExerciseType) {
        context.delete(exerciseType)
        appDelegate.saveContext()
    }
    
    func getAllExerciseTypes() -> [ExerciseType]? {
        let request: NSFetchRequest<ExerciseType> = ExerciseType.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        return executeRequest(request)
    }
}