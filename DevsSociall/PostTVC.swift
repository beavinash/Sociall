//
//  PostTVC.swift
//  DevsSociall
//
//  Created by Avinash Reddy on 1/14/17.
//  Copyright © 2017 theEine. All rights reserved.
//

import UIKit

class PostTVC: UITableViewCell {
    
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(post: Post) {
        self.post = post
        self.caption.text = post.caption
        self.likesLabel.text = "\(post.likes)"
    }

}
