//
//  Extensions.swift
//  TasksApp
//
//  Created by Iggy Mwangi on 2/27/17.
//  Copyright © 2017 iggy. All rights reserved.
//

import Foundation


extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
