//
//  UserViewCell.swift
//  DMNetworkingIntro
//
//  Created by Beau Enslow on 2/16/24.
//

import UIKit

class UserViewCell: UITableViewCell {


    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var email: UILabel!
    
    func assignData(for user: User){
        firstName.text = user.firstName
        lastName.text = user.lastName
        email.text = user.email
        avatar.setRounded()
        
        NetworkManager.shared.getAvatar(for: user) { image in
            DispatchQueue.main.async{
                self.avatar.image = image
            }
        }
    }
}


extension UIImageView {
   func setRounded() {
      let radius = CGRectGetWidth(self.frame) / 2
      self.layer.cornerRadius = radius
      self.layer.masksToBounds = true
   }
}
