//
//  NewsAPI.swift
//  10_RNewspaper
//
//  Created by Mykola Matsko on 6/4/19.
//  Copyright © 2019 Mykola Matsko. All rights reserved.
//

import Foundation
import UIKit

class NewsAPI: NSObject {
    
    static let service = NewsAPI()
    
    private struct Response: Codable {
        let sources: [Source]?
        let articles: [Article]?
    }
    
    
    private enum API {
        
        private static let basePath = "https://newsapi.org/v2"
        /*
         Head on over to https://newsapi.org/register to get your
         free API key, and then replace the value below with it.
         */
        private static let key = "eb8f8d3861e8413d8d733ad8ed2ac8f1"
        
        case sources
        case articles(Source)
        
        func fetch(completion: @escaping (Data) -> ()) {

            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: path()) { (data, response, error) in
                guard let data = data, error == nil else {
                    return
                }
                completion(data)
            }
            task.resume()
        }
        
        private func path() -> URL {
            switch self {
            case .sources:
                return URL(string: "\(API.basePath)/sources?&apiKey=\(API.key)")!
            case .articles(let source):
                return URL(string: "\(API.basePath)/top-headlines?sources=\(source.id)&apiKey=\(API.key)")!
            }
        }
    }
    
    @objc dynamic private(set) var sources: [Source] = []
    @objc dynamic private(set) var articles: [Article] = []
    
    func fetchSources() {
        API.sources.fetch { data in
            do {
                if let sources = try JSONDecoder().decode(Response.self, from: data).sources {
                    self.sources = sources
                    for source in sources {
                        print(source)
                    }
                }
            } catch {
                print("decoding error")
            }
        }
    }
    
    func fetchArticles(for source: Source) {
        let formatter = ISO8601DateFormatter()
        let customDateHundler: (Decoder) throws -> Date = {
            decoder in
            var string = try decoder.singleValueContainer().decode(String.self)
            string.deleteMillisecondsIfPresent()
            guard let date = formatter.date(from: string) else {
                return Date()
            }
            return date
        }
        API.articles(source).fetch { data in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .custom(customDateHundler)
            if let articles = try! decoder.decode(Response.self, from: data).articles {
                self.articles = articles
            }
        }
    }
    
    func resetArticles() {
        articles = []
    }
}
