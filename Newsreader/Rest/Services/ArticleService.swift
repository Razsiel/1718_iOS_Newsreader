//
//  ArticleService.swift
//  Newsreader
//
//  Created by Geoffrey Arkenbout on 10/9/17.
//  Copyright © 2017 Geoffrey Arkenbout. All rights reserved.
//

import Foundation

public class ArticleService {
    private let apiClient : ApiClient
    
    init(){
        apiClient = ApiClient()
    }
    
    public func getArticles(nextId : Int?,
                            onSucces: @escaping (_ result: ArticleResult) -> (),
                            onFailure: @escaping () -> ()) {
        apiClient.send(withUrl: "/api/articles",
                       withHttpMethod: HttpMethod.GET,
                       onSuccesParser: { (_ data: Data) in
                        do {
                            //parse on succes
                            let articleResult = try JSONDecoder().decode(ArticleResult.self, from: data)
                            onSucces(articleResult)
                        } catch {
                            print("There was an error trying to map api-data to object (\(ArticleResult.self)): \n \(error)")
                            onFailure()
                        }
        }, onFailure: onFailure)
    }
}
