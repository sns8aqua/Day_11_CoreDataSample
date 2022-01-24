//
//  DisplayTableViewCell.swift
//  CoreDataSample
//
//  Created by Santhosh on 23/01/22.
//

import UIKit
import CoreData
class DisplayTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var nameText:  UILabel!
    @IBOutlet weak var emailText:  UILabel!
    @IBOutlet weak var passwordText:  UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func setData(data: User?) {
        guard let data = data else { return }
        nameText.text = data.name ?? ""
        emailText.text = data.email ?? ""
        passwordText.text = data.password ?? ""
        
        
    }
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
