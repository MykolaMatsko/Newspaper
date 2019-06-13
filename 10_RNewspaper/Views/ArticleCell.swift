//
//  ArticleCell.swift
//  10_RNewspaper
//
//  Created by Mykola Matsko on 6/5/19.
//  Copyright © 2019 Mykola Matsko. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {
    
    @IBOutlet private var bannerView: UIImageView!
    @IBOutlet private var publishedLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var snippetLabel: UILabel!
    private var task: URLSessionDataTask?
    
    func render(article: Article, using formatter: DateFormatter) {
        if let image = article.imageURL {
            downloadBanner(from: image)
        }
        if let published = article.published {
            publishedLabel.text = formatter.string(from: published)
        } else {
            publishedLabel.text = nil
        }
        titleLabel.text = article.title
        snippetLabel.text = article.snippet
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        guard let task = task else { return }
        task.cancel()
    }
    
    private func downloadBanner(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.bannerView.image = UIImage(data: data)
            }
        }
        task.resume()
        self.task = task
    }
}
