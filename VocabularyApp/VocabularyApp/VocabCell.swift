//
//  VocabCell.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/08.
//

import Foundation
import UIKit

class VocabCell: UITableViewCell {
    let vocabLabel = UILabel()
    var exampleLabel: UILabel?
    let meaningLabel = UILabel()
    
    static let reuseID = "VocabCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VocabCell {
    private func setup() {
        vocabLabel.translatesAutoresizingMaskIntoConstraints = false
        vocabLabel.font = UIFont.boldSystemFont(ofSize: 23)
        
        meaningLabel.translatesAutoresizingMaskIntoConstraints = false
        meaningLabel.font = UIFont.systemFont(ofSize: 15)
        
        backgroundColor = .secondarySystemGroupedBackground
    }
        
    private func layout() {
        contentView.addSubview(vocabLabel)
        contentView.addSubview(meaningLabel)
        
        NSLayoutConstraint.activate([
            vocabLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 3),
            vocabLabel.topAnchor.constraint(equalTo: topAnchor),
            
            meaningLabel.topAnchor.constraint(equalTo: vocabLabel.bottomAnchor),
            meaningLabel.leadingAnchor.constraint(equalTo: vocabLabel.leadingAnchor),
            bottomAnchor.constraint(equalToSystemSpacingBelow: meaningLabel.bottomAnchor, multiplier: 1)
        ])
    }
    
}
