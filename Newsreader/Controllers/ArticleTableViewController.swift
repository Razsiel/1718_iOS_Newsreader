//
//  ArticleTableViewController.swift
//  Newsreader_560825
//
//  Created by Geoffrey Arkenbout on 10/9/17.
//  Copyright © 2017 Geoffrey Arkenbout. All rights reserved.
//

import UIKit

class ArticleTableViewController: UITableViewController {

    var viewModel: ArticleTableViewModel = ArticleTableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pull to refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.backgroundColor = UIColor.darkGray
        self.refreshControl!.tintColor = UIColor.white
        
        self.refreshControl!.addTarget(self,
                                       action: #selector(refresh),
                                       for: UIControlEvents.valueChanged)
        
        // initial load of article data
        viewModel.loadMore(onSucces: refreshTable)
    }
    
    @IBAction func refresh(){
        self.refreshControl?.endRefreshing()
        viewModel.cancelCurrentRequest()
        // clear articles cache
        viewModel.clearArticles()
        // refresh the view
        refreshTable()
        // reload data
        viewModel.loadMore(onSucces: refreshTable)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.getArticleCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleIdentifier", for: indexPath) as! ArticleTableViewCell

        // Fill the cell
        if let article = viewModel.getArticle(at: indexPath.row) {
            cell.fill(with: article)
        }

        return cell
    }
    
    // Infinite scrolling
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if  indexPath.row >= self.viewModel.getArticleCount() - 1 && !viewModel.hasRequest() {
            let viewModel = self.viewModel
            
            viewModel.loadMore(onSucces: {
                self.viewModel = viewModel
                self.refreshTable()
            })
        }
    }
    
    // Prepare data that needs to be sent to a different view/window
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let viewController = segue.destination as? ArticleDetailViewController {
            if let cell = sender as? ArticleTableViewCell {
                viewController.article = cell.article
            }
        }
    }
    
    // Refreshes the table view
    func refreshTable(){
        // Send async call to UI-thread
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
