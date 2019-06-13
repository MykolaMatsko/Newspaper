//
//  Source.swift
//  10_RNewspaper
//
//  Created by Mykola Matsko on 6/4/19.
//  Copyright © 2019 Mykola Matsko. All rights reserved.
//

import Foundation

class Source: NSObject, Codable  {
    let id: String
    let name: String
    let category: String
    
    override var description: String {
        return "id: \(id) - name: \(name) - category: \(category)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case category
    }
    
    
    init(id: String, name: String, overview: String, category: String) {
        self.id = id
        self.name = name
        self.category = category
    }
}
