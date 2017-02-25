//
//  FeedTableViewCell.swift
//  MDBSocials
//
//  Created by Boris Yue on 2/22/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    var author: UILabel!
    var eventName: UILabel!
    var eventPicture: UIImageView!
    var interests: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.frame = CGRect(x: contentView.frame.origin.x, y: contentView.frame.origin.y, width: contentView.frame.width, height: 120) //because for some reason the row height is always 44?!?!?!
        self.separatorInset = UIEdgeInsets.zero // make cell border extend to lefts
        eventPicture = UIImageView(frame: CGRect(x: 40, y: contentView.frame.height / 2 - 50, width: 100, height: 100))
        eventPicture.image = #imageLiteral(resourceName: "mdb")
        eventPicture.layer.cornerRadius = 5
        eventPicture.layer.masksToBounds = true
        contentView.addSubview(eventPicture)
        
        
        setUpEventNameText()
        setUpMemberNameText()
    }

    func setUpEventNameText() {
        eventName = UILabel(frame: CGRect(x: eventPicture.frame.maxX + contentView.frame.width * 0.3, y: eventPicture.frame.minY, width: 50, height: 50))
        eventName.font = UIFont.boldSystemFont(ofSize: 15)
        contentView.addSubview(eventName)
    }
    
    func setUpMemberNameText() {
        author = UILabel(frame: CGRect(x: 0, y: eventName.frame.minY + 25, width: 50, height: 50))
        author.font = UIFont.systemFont(ofSize: 13)
//        author.sizeToFit()
//        author.frame.origin.x = eventPicture.frame.maxX + contentView.frame.width * 0.3 - author.frame.width / 4
        contentView.addSubview(author)
    }

}
