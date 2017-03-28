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
    var interests: UILabel!
    var interestedButton: UIButton!
    var delegate: FeedCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.frame = CGRect(x: contentView.frame.origin.x, y: contentView.frame.origin.y, width: contentView.frame.width, height: 120) //because for some reason the row height is always 44?!?!?!
        self.separatorInset = UIEdgeInsets.zero // make cell border extend to lefts
        setUpImage()
        setUpEventNameText()
        setUpMemberNameText()
        setUpDateText()
        addInterestedIcon()
        addInterestedLabel()
        addInterestedButton()

    }
    
    func setUpImage() {
        eventPicture = UIImageView(frame: CGRect(x: 40, y: contentView.frame.height / 2 - 50, width: 100, height: 100))
        eventPicture.layer.cornerRadius = Constants.regularCornerRadius
        eventPicture.layer.masksToBounds = true
        contentView.addSubview(eventPicture)
    }

    func setUpEventNameText() {
        eventName = UILabel(frame: CGRect(x: 0, y: eventPicture.frame.minY + 10, width: 50, height: 50))
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
        date = UILabel(frame: CGRect(x: 0, y: author.frame.minY + 18, width: 50, height: 50))
        date.font = UIFont.boldSystemFont(ofSize: 12)
        contentView.addSubview(date)
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
        interestedButton = UIButton()
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
