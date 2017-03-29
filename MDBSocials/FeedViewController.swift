//
//  FeedViewController.swift
//  MDBSocials
//
//  Created by Boris Yue on 2/21/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import Firebase

enum GoingStatus {
    case interested
    case notResponded
}

class FeedViewController: UIViewController {

    var emptyView: UIView!
    var tableView: UITableView!
    var posts: [Post] = []
    var auth = FIRAuth.auth()
    var postsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Posts")
    var storage: FIRStorageReference = FIRStorage.storage().reference()
    var postToPass: Post?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        setUpEmptyTable()
        fetchPosts {
            self.setUpUI()
        }
    }
    
    func setUpEmptyTable() {
        //empty view
        emptyView = UIView()
        if posts.count == 0 {
            let emptyImage = UIImageView(frame: CGRect(x: view.frame.width / 2 - 50, y: view.frame.height / 2 - view.frame.width * 0.25, width: 100, height: 100))
            emptyImage.image = #imageLiteral(resourceName: "newpost")
            emptyView.addSubview(emptyImage)
            let emptyLabel = UILabel()
            emptyLabel.text = "No posts to show."
            emptyLabel.sizeToFit()
            emptyLabel.frame.origin.x = view.frame.width / 2 - emptyLabel.frame.width / 2
            emptyLabel.frame.origin.y = emptyImage.frame.maxY + 20
            emptyView.addSubview(emptyLabel)
            view.addSubview(emptyView)
        }
    }
    
    func setUpUI() {
        view.backgroundColor = Constants.grayColor
        setUpTableView()
        automaticallyAdjustsScrollViewInsets = false //makes navbar not cover tableview
    }
    
    func setUpNavBar() {
        self.title = "Feed"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = Constants.purpleColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Post", style: .plain, target: self, action: #selector(newPost))
    }
    
    func newPost() {
        self.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.modalPresentationStyle = .popover
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "NewSocialVC") as! NewSocialViewController
        newVC.delegate = self
        self.present(newVC, animated: true, completion: nil)
    }
    
    func logOut() {
        let firebaseAuth = auth
        do {
            try firebaseAuth?.signOut()
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginNavigation") as! UINavigationController
            self.show(loginVC, sender: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func setUpTableView() {
        emptyView.removeFromSuperview()
        tableView = UITableView(frame: CGRect(x: 12, y: (navigationController?.navigationBar.frame.maxY)! , width: view.frame.width - 24, height: view.frame.height))
        //Register the tableViewCell you are using
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "feedCell")
        //Set properties of TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 120
        tableView.separatorStyle = .none
        tableView.backgroundColor = Constants.grayColor
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150 / 2, right: 0)
        tableView.tableFooterView = UIView() // gets rid of the extra cells beneath
        view.addSubview(tableView)
    }

    func addNewPostToDatabase(post: [String: Any]) {
        let key = postsRef.childByAutoId().key
        let childUpdates = ["/\(key)/": post]
        postsRef.updateChildValues(childUpdates)
    }
    
    func fetchPosts(withBlock: @escaping () -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!
        postsRef.observe(.childAdded, with: { (snapshot) in
            let post = Post(id: snapshot.key, postDict: snapshot.value as! [String : Any]?)
            self.posts.append(post)
            withBlock() //ensures that next block is called
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            let detailVC = segue.destination as! DetailViewController
            detailVC.post = postToPass
        }
    }
}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as! FeedTableViewCell
        MDBSocialsUtils.clearCell(cell: cell)
        cell.awakeFromNib() //initialize cell
        cell.delegate = self
        let currentPost = posts[posts.count - 1 - indexPath.row] //show most recent posts first
        cell.tag = posts.count - 1 - indexPath.row //associate row number with each cell
        currentPost.getProfilePic(withBlock: {(image) in
            cell.eventPicture.image = image
        })
        cell.eventName.text = currentPost.name
        cell.eventName.sizeToFit()
        cell.eventName.frame.origin.x = cell.contentView.frame.width / 2 - cell.eventName.frame.width / 3 + 24
        cell.author.text = "Posted by " + currentPost.author!
        cell.author.sizeToFit()
        cell.author.frame.origin.x = cell.eventName.frame.minX - cell.author.frame.width / 2 + cell.eventName.frame.width / 2
        cell.date.text = currentPost.date!
        cell.date.sizeToFit()
        cell.date.frame.origin.x = tableView.frame.width - cell.date.frame.width - 7
        cell.timeIcon.frame.origin.x = cell.date.frame.minX - 20
        cell.timeIcon.frame.origin.y = 12
        addPostObserver(forPost: currentPost, updateCell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { //makes the cells smaller
        cell.contentView.backgroundColor = Constants.grayColor
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 0, y: 5, width: cell.contentView.frame.width, height: cell.contentView.frame.height - 10))
        whiteRoundedView.layer.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1).cgColor
        whiteRoundedView.layer.cornerRadius = 5
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: -1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)
    }
    
    func addPostObserver(forPost: Post, updateCell: FeedTableViewCell) { //update num interested when button clicked
        self.postsRef.child("\(forPost.id!)").observe(.value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            let idArray = value?["interestedUsers"] as? [String] ?? []
            DispatchQueue.main.async {
                updateCell.interests.text = "\(idArray.count)" + " Interested"
                updateCell.interests.sizeToFit()
                updateCell.interests.frame.origin.x = 24
                updateCell.interests.frame.origin.y = 12
                updateCell.interestsImage.frame = CGRect(x: 6, y: 12, width: 15, height: 15)
            }
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        postToPass = posts[posts.count - 1 - indexPath.row]
        self.performSegue(withIdentifier: "toDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
}

extension FeedViewController: NewSocialViewControllerDelegate {
    func sendValue(_ info: [String: Any]) { //gets the information from new post
        addNewPostToDatabase(post: info)
    }
    
}

extension FeedViewController: FeedCellDelegate {
    func addInterestedUser(forCell: FeedTableViewCell) {
        posts[forCell.tag].addInterestedUser(withId: (FIRAuth.auth()?.currentUser?.uid)!)
    }
    
    func removeInterestedUser(forCell: FeedTableViewCell) {
        posts[forCell.tag].removeInterestedUser(withId: (FIRAuth.auth()?.currentUser?.uid)!)
    }
}
