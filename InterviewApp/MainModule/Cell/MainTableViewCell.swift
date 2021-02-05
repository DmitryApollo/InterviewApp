//
//  MainTableViewCell.swift
//  InterviewApp
//
//  Created by Дмитрий on 05/02/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    let userImageView = UIImageView()
    let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(userImageView)
        addSubview(titleLabel)
        
        userImageView.layer.cornerRadius = 25
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.layer.masksToBounds = true
        
        let leadingConstraint = NSLayoutConstraint(item: userImageView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 16)
        let verticalConstraint = NSLayoutConstraint(item: userImageView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: userImageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 50)
        let heightConstraint = NSLayoutConstraint(item: userImageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 50)
        self.addConstraints([leadingConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let leadingConstraintLabel = NSLayoutConstraint(item: titleLabel, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: userImageView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 16)
        let verticalConstraintLabel = NSLayoutConstraint(item: titleLabel, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        
        self.addConstraints([leadingConstraintLabel, verticalConstraintLabel])

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        userImageView.image = nil
        titleLabel.text = ""
    }
}
