//
//  ArticleTableViewController.swift
//  Newsreader_560825
//
//  Created by Geoffrey Arkenbout on 10/9/17.
//  Copyright © 2017 Geoffrey Arkenbout. All rights reserved.
//

import UIKit

class ArticleTableViewController: UITableViewController, IModalListener {
    
    var viewModel: ArticleTableViewModel = ArticleTableViewModel()
    
    @IBOutlet weak var loginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pull to refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.backgroundColor = UIColor.darkGray
        self.refreshControl!.tintColor = UIColor.white
        
        self.refreshControl!.addTarget(self,
                                       action: #selector(refresh),
                                       for: UIControlEvents.valueChanged)
        
        self.loginBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        updateLoginButton()
        
        // initial load of article data
        viewModel.loadMore(onSucces: refreshTable)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // refresh ui in case something changed in a different page
        self.refreshTable()
    }
    
    @IBAction func refresh(){
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
        }
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
        if  indexPath.row >= self.viewModel.getArticleCount() - 1 && !self.viewModel.hasRequest() {
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
        
        // detail view
        if let viewController = segue.destination as? ArticleDetailViewController {
            if let cell = sender as? ArticleTableViewCell {
                viewController.article = cell.article
            }
        }
        // login view
        else if let viewController = segue.destination as? LoginViewController {
            viewController.modalListener = self
        }
    }
    
    // Refreshes the table view
    func refreshTable(){
        // Send async call to UI-thread
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // IModalClose protocol implementation
    func onModalSucces() {
        loggedInStateChanged()
    }
    
    private func loggedInStateChanged() {
        // update the table data since logged in state changed and ui needs to reflect that
        refresh()
        updateLoginButton()
    }
    
    // update the login button functionality to either login or logout based on whether the user is logeed in currently
    private func updateLoginButton() {
        // is logged in -> logout
        if authenticationService.isLoggedIn() {
            DispatchQueue.main.async {
                // removes all events from the button
                self.loginBtn.removeTarget(nil, action: nil, for: .allEvents)
                // set the action of the button to logout
                self.loginBtn.setTitle("Log out", for: .normal)
                self.loginBtn.addTarget(self, action: #selector(self.logoutAction), for: .touchUpInside)
            }
        }
        // is not logged in -> login
        else {
            DispatchQueue.main.async {
                // removes all events from the button
                self.loginBtn.removeTarget(nil, action: nil, for: .allEvents)
                // set the action of the button to login
                self.loginBtn.setTitle("Login", for: .normal)
                self.loginBtn.addTarget(self, action: #selector(self.loginAction), for: .touchUpInside)
            }
        }
    }
    
    @IBAction private func logoutAction() {
        if authenticationService.logOut() {
            loggedInStateChanged()
        }
    }
    
    @IBAction private func loginAction() {
        performSegue(withIdentifier: "login", sender: self)
    }
}
