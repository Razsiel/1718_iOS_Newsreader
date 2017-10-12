//
//  ApiClient.swift
//  Newsreader_560825
//
//  Created by Geoffrey Arkenbout on 10/11/17.
//  Copyright © 2017 Geoffrey Arkenbout. All rights reserved.
//

import Foundation

public class ApiClient {
    public func send(withUrl url: String,
                     withHttpMethod httpMethod: HttpMethod = HttpMethod.GET,
                     withParameters parameters: [String : Any] = [:],
                     withHeaders headers: [String : String] = [:],
                     onSuccesParser onSucces: @escaping (_ data: Data) -> (),
                     onFailure: @escaping () -> ()) -> URLSessionTask? {
        
        let baseUrl = URL(string: "https://inhollandbackend.azurewebsites.net")
        
        if let url = URL(string: url, relativeTo: baseUrl) {
            return HttpClient.send( withUrl: url,
                                    withHttpMethod: httpMethod,
                                    withParameters: parameters,
                                    withHeaders: headers,
                                    onSucces: onSucces,
                                    onFailure: onFailure)
        }
        return nil
    }
    
}
