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
  @IBOutlet weak var cardAuxLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    cardCell.layer.cornerRadius = 6
    cardCell.layer.shadowColor = UIColor.black.cgColor
    cardCell.layer.shadowOpacity = 0.08
    cardCell.layer.shadowOffset = CGSize(width: 0, height: 4)
    cardCell.layer.shadowRadius = 4
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

}
