//
//  Set.swift
//  BeeStrong
//
//  Created by Hala Al-Janabi on 14/12/2020.
//

import Foundation

class set {
        var repetitions: Int
        var weight: Double
        let id = UUID()
        
        init(repetitions: Int, weight: Double, id:UUID) {
            self.repetitions = repetitions
            self.weight = weight
        }
}
