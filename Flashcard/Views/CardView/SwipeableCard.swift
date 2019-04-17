//
//  Card.swift
//  Flashcard
//
//  Created by Shaun Jacobsen on 4/16/19.
//  Copyright © 2019 Shaun Jacobsen. All rights reserved.
//

import UIKit

protocol SwipeableCardDelegate: NSObjectProtocol {
  func dragCardLeft(card: SwipeableCard)
  func dragCardRight(card: SwipeableCard)
  func dragCardUp(card: SwipeableCard)
  func currentCardStatus(card: SwipeableCard, distance: CGFloat)
}

class SwipeableCard: UIView {
  
  @IBOutlet weak var mainLabel: UILabel!
  @IBOutlet weak var secondaryLabel: UILabel!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    xibSetup()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    xibSetup()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  

}
