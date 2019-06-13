//
//  String.swift
//  10_RNewspaper
//
//  Created by Mykola Matsko on 6/5/19.
//  Copyright © 2019 Mykola Matsko. All rights reserved.
//

import Foundation

extension String {
    func deletingCharacters(in characters: CharacterSet) -> String {
        return self.components(separatedBy: characters).filter { !$0.isEmpty }.joined(separator: " ")
    }
    
    mutating func deleteMillisecondsIfPresent(){
        if count == 24 {
            let range = index(endIndex, offsetBy: -5)..<index(endIndex, offsetBy: -1)
            removeSubrange(range)
        }
    }
}
