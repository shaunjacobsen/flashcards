//
//  DeckTableViewCell.swift
//  Flashcard
//
//  Created by Shaun Jacobsen on 3/30/19.
//  Copyright © 2019 Shaun Jacobsen. All rights reserved.
//

import UIKit

class DeckCell: UITableViewCell {

  @IBOutlet weak var deckCell: UIView!
  @IBOutlet weak var deckLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    deckCell.layer.cornerRadius = 6
    deckCell.layer.shadowPath = UIBezierPath(roundedRect: deckCell.bounds, cornerRadius: deckCell.layer.cornerRadius).cgPath
    deckCell.layer.shadowColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.12).cgColor
    deckCell.layer.shadowOpacity = 0.12
    deckCell.layer.shadowOffset = CGSize(width: 0, height: 0)
    deckCell.layer.shadowRadius = 0
    deckCell.layer.masksToBounds = false
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

}
