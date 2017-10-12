//
//  LoginResult.swift
//  Newsreader
//
//  Created by Geoffrey Arkenbout on 10/9/17.
//  Copyright © 2017 Geoffrey Arkenbout. All rights reserved.
//

import Foundation

public class LoginResult : Decodable {
    public var authtoken : String
    
    enum CodingKeys : String, CodingKey {
        case authtoken = "AuthToken"
    }
}
