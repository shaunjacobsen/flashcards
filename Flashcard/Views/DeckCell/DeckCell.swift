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
    
    deckCell.layer.shadowColor = UIColor.black.cgColor
    deckCell.layer.shadowOpacity = 0.11
    deckCell.layer.shadowOffset = CGSize(width: 0, height: 3)
    deckCell.layer.shadowRadius = 8
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

}
