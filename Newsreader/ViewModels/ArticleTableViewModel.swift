//
//  ArticleTableViewModel.swift
//  Newsreader_560825
//
//  Created by Geoffrey Arkenbout on 10/12/17.
//  Copyright © 2017 Geoffrey Arkenbout. All rights reserved.
//

import Foundation

public class ArticleTableViewModel {
    var articles : [Article] = []
    var nextId : Int? = nil
    var pendingRequest: URLSessionTask? = nil
    
    public func loadMore(onSucces: @escaping () -> ()) {
        let succes =  { (_ result : ArticleResult) in
            for article : Article in result.results {
                self.articles.append(article)
            }
            self.nextId = result.nextId
            onSucces()  
            self.pendingRequest = nil
        }
        
        let failure = {
            print("failed...")
        }
        
        if nextId == nil {
            self.pendingRequest = articleService.getArticles(onSucces: succes, onFailure: failure)
        } else {
            self.pendingRequest = articleService.getArticle(nextId: self.nextId, count: 20, onSucces: succes, onFailure: failure)
        }
    }
    
    public func getArticle(at: Int) -> Article? {
        return self.articles[at]
    }
    
    public func getArticleCount() -> Int {
        return self.articles.count
    }
    
    public func clearArticles() {
        self.articles = []
    }
    
    public func hasRequest() -> Bool {
        return self.pendingRequest != nil
    }
    
    public func cancelCurrentRequest() {
        self.pendingRequest?.cancel()
        self.pendingRequest = nil
    }
}