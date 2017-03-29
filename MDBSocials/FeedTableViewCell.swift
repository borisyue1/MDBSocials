//
//  FeedTableViewswift
//  MDBSocials
//
//  Created by Boris Yue on 2/22/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit

protocol FeedCellDelegate {
    
    func addInterestedUser(forCell: FeedTableViewCell)
    func removeInterestedUser(forCell: FeedTableViewCell)
}

class FeedTableViewCell: UITableViewCell {

    var author: UILabel!
    var eventName: UILabel!
    var eventPicture: UIImageView!
    var date: UILabel!
    var interestsImage: UIImageView!
    var timeIcon: UIImageView!
    var interests: UILabel!
    var interestedButton: UIButton!
    var delegate: FeedCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.frame = CGRect(x: contentView.frame.origin.x, y: contentView.frame.origin.y, width: contentView.frame.width, height: Constants.cellHeight) //because for some reason the row height is always 44?!?!?!
//        self.separatorInset = UIEdgeInsets.zero // make cell border extend to lefts
        setUpImage()
        setUpEventNameText()
        setUpMemberNameText()
        setUpDateText()
        addInterestedIcon()
        addInterestedLabel()
        addInterestedButton()

    }
    
    func setUpImage() {
        eventPicture = UIImageView(frame: CGRect(x: contentView.frame.width / 2 - 40, y: contentView.frame.height / 2 - 130, width: 180, height: 180))
        eventPicture.layer.cornerRadius = Constants.regularCornerRadius
        eventPicture.layer.masksToBounds = true
        contentView.addSubview(eventPicture)
    }

    func setUpEventNameText() {
        eventName = UILabel(frame: CGRect(x: 0, y: eventPicture.frame.maxY + 10, width: 50, height: 50))
        eventName.font = UIFont.boldSystemFont(ofSize: 18)
        eventName.textColor = Constants.purpleColor
        contentView.addSubview(eventName)
    }
    
    func setUpMemberNameText() {
        author = UILabel(frame: CGRect(x: 0, y: eventName.frame.minY + 25, width: 50, height: 50))
        author.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(author)
    }
    
    func setUpDateText() {
        date = UILabel(frame: CGRect(x: 0, y: 12, width: 50, height: 50))
        date.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(date)
        addTimeIcon()
    }
    
    func addTimeIcon() {
        timeIcon = UIImageView()
        timeIcon.frame.size = CGSize(width: 15, height: 15)
        timeIcon.image = #imageLiteral(resourceName: "timer")
        contentView.addSubview(timeIcon)
    }
    
    func addInterestedIcon() {
        interestsImage = UIImageView()
        interestsImage.frame.size = CGSize(width: 20, height: 20)
        interestsImage.image = #imageLiteral(resourceName: "people")
        contentView.addSubview(interestsImage)
    }
    
    func addInterestedLabel() {
        interests = UILabel()
        interests.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(interests)
    }
    
    func addInterestedButton() {
        interestedButton = UIButton(frame: CGRect(x: contentView.frame.width / 2 + 5, y: author.frame.minY + 25, width: 77, height: 15))
        interestedButton.layer.cornerRadius = 2
        interestedButton.layer.masksToBounds = true
        interestedButton.setTitle("Interested", for: .normal)
        interestedButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        interestedButton.backgroundColor = Constants.purpleColor
        interestedButton.addTarget(self, action: #selector(addInterestedUser), for: .touchUpInside)
        interestedButton.isSelected = false
        contentView.addSubview(interestedButton)
    }
    
    func addInterestedUser() {
        interestedButton.setTitle("Nope", for: .selected)
        if !interestedButton.isSelected {
            delegate?.addInterestedUser(forCell: self)
        } else {
            delegate?.removeInterestedUser(forCell: self)
        }
        interestedButton.isSelected = !interestedButton.isSelected
        
    }
    
}
