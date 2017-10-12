//
//  ArticleTableViewController.swift
//  Newsreader
//
//  Created by Geoffrey Arkenbout on 10/9/17.
//  Copyright © 2017 Geoffrey Arkenbout. All rights reserved.
//

import UIKit

class ArticleTableViewController: UITableViewController {

    var articles : [Article] = []
    var nextId : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Pull to refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.backgroundColor = UIColor.darkGray
        self.refreshControl!.tintColor = UIColor.white
        
        self.refreshControl!.addTarget(self,
                                       action: #selector(refresh),
                                       for: UIControlEvents.valueChanged)
        
        // initial load of article data
        loadMore()
    }
    
    @IBAction func refresh(){
        self.refreshControl?.endRefreshing()
        self.tableView.reloadData()
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
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleIdentifier", for: indexPath) as! ArticleTableViewCell

        // Configure the cell...
        // call service class
        cell.article = articles[indexPath.row]
        cell.fill()

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let viewController = segue.destination as? ArticleDetailViewController {
            if let cell = sender as? ArticleTableViewCell {
                viewController.article = cell.article
            }
        }
    }
    
    func refreshTable(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func loadMore() {
        
        let succes =  { (_ result : ArticleResult) in
            print("succes!!!")
            print(result.nextId)
            for article : Article in result.results {
                self.articles.append(article)
            }
            self.nextId = result.nextId
            self.refreshTable()
        }
        
        let failure = {
            print("failed...")
        }
        
        articleService.getArticles(nextId: nextId, onSucces: succes, onFailure: failure)
    }

}
