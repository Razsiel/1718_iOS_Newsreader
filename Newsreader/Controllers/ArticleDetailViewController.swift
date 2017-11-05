//
//  ArticleDetailViewController.swift
//  Newsreader_560825
//
//  Created by Geoffrey Arkenbout on 10/11/17.
//  Copyright © 2017 Geoffrey Arkenbout. All rights reserved.
//

import UIKit

class ArticleDetailViewController: UIViewController, UIToggleButtonDelegate {
    
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeBtn: UIToggleButton!
    
    public var article : Article?
    
    private var articleImageTask: URLSessionTask?
    private var articleLikeTask: URLSessionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = self.article?.title
        summaryLabel.text = self.article?.summary
        dateLabel.text = self.article?.publishDate
        
        // cancel a still running task (not sure if tasks are automatically cancelled when a view gets dismissed)
        articleImageTask?.cancel()
        
        if let imageUrl = self.article?.image {
            articleImageTask = articleImage.loadImageAsync(from: imageUrl)
        }
        
        // read more toolbar button
        let btn = UIBarButtonItem(title: "Lees meer",
                                  style: .plain,
                                  target: self,
                                  action: #selector(self.onReadMoreButtonClick(_:)))
        self.navigationItem.setRightBarButton(btn, animated: false)
        
        // like button
        
        self.likeBtn.activeText = "Unlike"
        self.likeBtn.disabledText = "Like"
        
        // show/hide button based on logged in state
        self.likeBtn.isHidden = !authenticationService.isLoggedIn()
        
        // set button state to reflect the article isLiked state
        if let article = self.article {
            self.likeBtn.activateButton(bool: article.isLiked)
        }
        
        // ste listener to this instance of the controller
        self.likeBtn.setStateChangeListener(self)
    }
    
    @IBAction func onReadMoreButtonClick(_ sender : AnyObject) {
        if let articleUrl = self.article?.url {
            if let url = URL(string: articleUrl) {
                let application = UIApplication.shared
                application.open(url)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // cleanup of the task (just in case)
        articleImageTask?.cancel()
        articleLikeTask?.cancel()
    }
    
    // UIToggleButtonDelegate protocol implementation
    func onStateChange(state: Bool) {
        if let articleId = self.article?.id {
            articleLikeTask = articleService.likeArticle(withId: articleId, newState: state, onSucces: {
                // change local article isliked property
                self.article?.isLiked = state
            }, onFailure: {
                // show error to user and reset button to previous state
                if let isLiked = self.article?.isLiked {
                    self.likeBtn.activateButton(bool: isLiked)
                }
            })
        }
    }
}
