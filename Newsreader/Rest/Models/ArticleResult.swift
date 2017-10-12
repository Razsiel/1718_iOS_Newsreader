//
//  ArticleResult.swift
//  Newsreader_560825
//
//  Created by Geoffrey Arkenbout on 10/9/17.
//  Copyright © 2017 Geoffrey Arkenbout. All rights reserved.
//

import Foundation

public class ArticleResult : Decodable {
    public var results : Array<Article>
    public var nextId : Int
    
    enum CodingKeys : String, CodingKey {
        case nextId = "NextId"
        case results = "Results"
    }
}
