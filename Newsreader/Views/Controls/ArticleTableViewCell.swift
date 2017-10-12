//
//  ArticleTableViewCell.swift
//  Newsreader_560825
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
    
    public func fill(with article: Article) {
        self.article = article
        
        titleLabel.text = self.article!.title
        summaryLabel.text = self.article!.summary
        
        task?.cancel()
        
        let imageUrl = self.article!.image
        self.task = articleImage.loadImageAsync(from: imageUrl)
    }
    
    override func prepareForReuse() {
        self.articleImage.image = UIImage(named: "placeholder")
    }

}
