//
//  ArticleService.swift
//  Newsreader_560825
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
    
    /**
     Makes a http call to /api/articles and parses the incoming data
     
     - parameters:
         - onSucces: Closure to call if the data was retrieved and parsed succesfully
         - onFailure: Closure to call if the data could not be retrieved or parsed
     
     - returns: The URLSessionTask object that makes the request. By capturing this object, a request can be cancelled at any time by calling .cancel()
     */
    public func getArticles(onSucces: @escaping (_ result: ArticleResult) -> (),
                            onFailure: @escaping () -> ()) -> URLSessionTask? {
        // call to network layer
        return apiClient.send(toRelativePath: "/api/articles",
                              withHttpMethod: HttpMethod.GET,
                              onSuccesParser: { (_ data: Data) in
                        // call shared parser
                        self.onArticleResultSucces(data: data,
                                                   onSucces: onSucces,
                                                   onFailure: onFailure)
        }, onFailure: onFailure)
    }
    
    public func getArticle(withId id : Int,
                           count: Int?,
                           onSucces: @escaping (_ result: ArticleResult) -> (),
                           onFailure: @escaping () -> ()) -> URLSessionTask? {
        var params = [String : Any]()
        if let _count = count {
            params["count"] = _count
        }
        
        // call to network layer
        return apiClient.send(toRelativePath: "/api/articles/\(id)",
                              withHttpMethod: HttpMethod.GET,
                              withParameters: params,
                              onSuccesParser: { (_ data: Data) in
                        // call shared parser
                        self.onArticleResultSucces(data: data,
                                                   onSucces: onSucces,
                                                   onFailure: onFailure)
        }, onFailure: onFailure)
    }
    
    /**
     A shared function for parsing result data from the api to an ArticleResult object
     */
    private func onArticleResultSucces(data: Data,
                                       onSucces: @escaping (_ result: ArticleResult) -> (),
                                       onFailure: @escaping () -> ()) {
        do {
            //parse on succes
            let articleResult = try JSONDecoder().decode(ArticleResult.self, from: data)
            onSucces(articleResult)
        } catch {
            print("There was an error trying to map api-data to object (\(ArticleResult.self)): \n \(error)")
            onFailure()
        }
    }
}
