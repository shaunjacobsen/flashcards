//
//  CardCell.swift
//  Flashcard
//
//  Created by Shaun Jacobsen on 3/31/19.
//  Copyright © 2019 Shaun Jacobsen. All rights reserved.
//

import UIKit

class CardCell: UITableViewCell {

  @IBOutlet weak var cardCell: UIView!
  @IBOutlet weak var cardName: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    cardCell.layer.cornerRadius = 6
    cardCell.layer.shadowPath = UIBezierPath(roundedRect: cardCell.bounds, cornerRadius: cardCell.layer.cornerRadius).cgPath
    cardCell.layer.shadowColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.12).cgColor
    cardCell.layer.shadowOpacity = 0.12
    cardCell.layer.shadowOffset = CGSize(width: 0, height: 0)
    cardCell.layer.shadowRadius = 0
    cardCell.layer.masksToBounds = false
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

}
