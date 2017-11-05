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
    public func getArticles(withNextId : Int?,
                            onSucces: @escaping (_ result: ArticleResult) -> (),
                            onFailure: @escaping () -> ()) -> URLSessionTask? {
        var params = [String : Any]()
        if let nextId = withNextId {
            params["nextId"] = nextId
        }
        // call to network layer
        return apiClient.send(toRelativePath: "/api/articles",
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
     Makes a http call to /api/articles/(id) and parses the incoming data
     
     - parameters:
         - withId: The id of the article that will be gotten
         - count: OPTIONAL, how many items will be loaded as well
         - onSucces: Closure to call if the data was retrieved and parsed succesfully
         - onFailure: Closure to call if the data could not be retrieved or parsed
     
     - returns: The URLSessionTask object that makes the request. By capturing this object, a request can be cancelled at any time by calling .cancel()
     */
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
    
    /**
     Makes a http call to /api/articles/(id)/like. NOTE: does not parse any data since api call returns an empty JSON object
     
     - parameters:
         - withId: The article to like
         - onSucces: Closure to call if the data was retrieved and parsed succesfully
         - onFailure: Closure to call if the data could not be retrieved or parsed
     
     - returns: The URLSessionTask object that makes the request. By capturing this object, a request can be cancelled at any time by calling .cancel()
     */
    public func likeArticle(withId id: Int,
                            newState state: Bool,
                            onSucces: @escaping () -> (),
                            onFailure: @escaping () -> ()) -> URLSessionTask? {
        // call to network layer
        return apiClient.send(toRelativePath: "/api/articles/\(id)/like",
            withHttpMethod: state ? HttpMethod.PUT : HttpMethod.DELETE,
            onSuccesParser: { (_ data: Data) in
                // call succes closure
                onSucces()
        }, onFailure: onFailure)
    }
}
