//
//  ArticleTableViewCell.swift
//  Newsreader
//
//  Created by Geoffrey Arkenbout on 10/9/17.
//  Copyright © 2017 Geoffrey Arkenbout. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    public var article : Article?
    
    private var task : URLSessionTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func fill() {
        titleLabel.text = self.article?.title
        summaryLabel.text = self.article?.summary
        
        // cancel any request still in the air to prevent the wrong data from being loaded into the cell
        task?.cancel()
        
        // image handling
        // succes closure
        let succes = { (_ data: Data) in
            self.articleImage.image = UIImage(data: data)
        }
        
        // failure closure
        let failure = {
            self.articleImage.image = UIImage(named: "broken_image")
        }
        
        if let imageUrl = article?.image {
            if let url = URL(string: imageUrl) {
                task = HttpClient.send(withUrl: url, onSucces: succes, onFailure: failure)
            } else {
                failure()
            }
        } else {
            failure()
        }
    }
    
    override func prepareForReuse() {
        articleImage.image = UIImage(named: "placeholder")
    }

}
