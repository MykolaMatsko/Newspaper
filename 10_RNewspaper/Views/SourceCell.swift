//
//  SourceCell.swift
//  10_RNewspaper
//
//  Created by Mykola Matsko on 6/5/19.
//  Copyright © 2019 Mykola Matsko. All rights reserved.
//

import UIKit

class SourceCell: UITableViewCell {
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var categoryLabel: UILabel!
    
    var source: Source? {
        didSet {
            guard let source = source else { return }
            nameLabel.text = source.name
            categoryLabel.text = source.category.capitalized
        }
    }
}
