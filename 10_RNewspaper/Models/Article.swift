//
//  Article.swift
//  10_RNewspaper
//
//  Created by Mykola Matsko on 6/5/19.
//  Copyright © 2019 Mykola Matsko. All rights reserved.
//

import Foundation

class Article: NSObject, Codable {
    
    let author: String?
    let title: String?
    let snippet: String?
    let sourceURL: URL?
    let imageURL: URL?
    let published: Date?
    
    enum CodingKeys: String, CodingKey {
        case author
        case title
        case snippet = "description"
        case sourceURL = "url"
        case imageURL = "urlToImage"
        case published = "publishedAt"
    }
    
    required init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        author = try container.decodeIfPresent(String.self, forKey: .author)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        let rawSnippet = try container.decodeIfPresent(String.self, forKey: .snippet)
        snippet = rawSnippet?.deletingCharacters(in: CharacterSet.newlines)
        sourceURL = try container.decodeIfPresent(URL.self, forKey: .sourceURL)
        imageURL = try container.decodeIfPresent(URL.self, forKey: .imageURL)
        published = try container.decodeIfPresent(Date.self, forKey: .published)
        
        
    }
    
    
    init(author: String, title: String, snippet: String, sourceURL: URL, imageURL: URL, published: Date) {
        self.author = author
        self.title = title
        self.snippet = snippet
        self.sourceURL = sourceURL
        self.imageURL = imageURL
        self.published = published
    }
}
