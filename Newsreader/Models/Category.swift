//
//  Category.swift
//  Newsreader_560825
//
//  Created by Geoffrey Arkenbout on 10/9/17.
//  Copyright © 2017 Geoffrey Arkenbout. All rights reserved.
//

import Foundation

public class Category : Decodable {
    public var id : Int
    public var name : String
    
    enum CodingKeys : String, CodingKey {
        case id = "Id"
        case name = "Name"
    }
}
