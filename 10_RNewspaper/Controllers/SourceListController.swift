//
//  ViewController.swift
//  10_RNewspaper
//
//  Created by Mykola Matsko on 6/4/19.
//  Copyright © 2019 Mykola Matsko. All rights reserved.
//

import UIKit

class SourceListController: UITableViewController {
    
    private var token: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(sortArray), for: .valueChanged)
        self.refreshControl = refreshControl
        
        token = NewsAPI.service.observe(\.sources) {
            _, _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        NewsAPI.service.fetchSources()
    
    }
        
    @objc func sortArray() {
        print("Hello refresh")
        NewsAPI.service.fetchSources()
        self.refreshControl?.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "PushArticlesSegue",
            let destination = segue.destination as? ArticleListController,
            let indexPath = tableView.indexPathForSelectedRow
            else { return }
        destination.source = NewsAPI.service.sources[indexPath.row]
        destination.nameID = NewsAPI.service.sources[indexPath.row].name
    }
}

// MARK: UITableViewDataSource

extension SourceListController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NewsAPI.service.sources.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SourceCell", for: indexPath) as! SourceCell
        cell.source = NewsAPI.service.sources[indexPath.row]
        return cell
    }
}
