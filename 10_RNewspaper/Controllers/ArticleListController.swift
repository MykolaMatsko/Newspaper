//
//  ArticleController.swift
//  10_RNewspaper
//
//  Created by Mykola Matsko on 6/5/19.
//  Copyright © 2019 Mykola Matsko. All rights reserved.
//

import UIKit
import SafariServices

class ArticleListController: UITableViewController, SFSafariViewControllerDelegate {
    
    var source: Source?
    var nameID = ""
    
    private let formatter = DateFormatter()
    private var token: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(sortArray), for: .valueChanged)
        self.refreshControl = refreshControl
        
        formatter.dateFormat = "MMM d, h:mm a"
        navigationItem.title = nameID
        
        
    }
    
    @objc func sortArray() {
        print("Article refresh")
        
        guard let source = source else { return }
        NewsAPI.service.fetchArticles(for: source)
        self.refreshControl?.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let source = source else { return }
        token = NewsAPI.service.observe(\.articles) {
            _, _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        NewsAPI.service.fetchArticles(for: source)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        token?.invalidate()
        NewsAPI.service.resetArticles()
    }
}

// MARK: UITableViewDataSource

extension ArticleListController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(" count =\(NewsAPI.service.articles.count)")
        return NewsAPI.service.articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        cell.render(article: NewsAPI.service.articles[indexPath.row], using: formatter)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = NewsAPI.service.articles[indexPath.row].sourceURL else { return }
        
        print(url)
        
        let safariVC = SFSafariViewController(url: url)
        self.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
