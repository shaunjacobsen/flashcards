//
//  Card.swift
//  Flashcard
//
//  Created by Shaun Jacobsen on 4/16/19.
//  Copyright © 2019 Shaun Jacobsen. All rights reserved.
//

import UIKit

let THRESHOLD_MARGIN = (UIScreen.main.bounds.size.width / 2) * 0.5
let VERTICAL_THRESHOLD_MARGIN = (UIScreen.main.bounds.size.height / 2) * 0.5
let SCALE_STRENGTH: CGFloat = 4
let SCALE_RANGE: CGFloat = 0.90

protocol SwipeableCardDelegate: NSObjectProtocol {
  func cardMovement(card: SwipeableCard)
  func cardWentLeft(card: SwipeableCard)
  func cardWentRight(card: SwipeableCard)
  func cardWentUp(card: SwipeableCard)
  func currentCardStatus(card: SwipeableCard, distance: CGFloat)
}

protocol TappableCardDelegate: NSObjectProtocol {
  func cardTapped(card: SwipeableCard)
}

class SwipeableCard: UIView {
  
  var frontLabel: String?
  var frontNotes: String?
  var rearLabel: String?
  var rearNotes: String?
  var isReversedCardShowing = false
  var xCenter: CGFloat = 0.0
  var yCenter: CGFloat = 0.0
  var originalPoint = CGPoint.zero
  var didGenerateFeedback = false
  lazy var generator = UIImpactFeedbackGenerator(style: .medium)
  
  lazy var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handleDragging))
  lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cardViewTapped))
  
  weak var swipeDelegate: SwipeableCardDelegate?
  weak var tapDelegate: TappableCardDelegate?
  
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
    
    if let frontText = frontLabel {
      mainLabel.text = frontText
      secondaryLabel.text = frontNotes ?? ""
    }
  }
  
  @objc func cardViewTapped() {
    tapDelegate?.cardTapped(card: self)
    
    UIView.transition(with: self, duration: 0.4, options: .transitionFlipFromLeft, animations: {
      UIView.animate(withDuration: 0.4, animations: {
        if self.isReversedCardShowing {
          if let frontText = self.frontLabel {
            self.mainLabel.text = frontText
            self.secondaryLabel.text = self.frontNotes ?? ""
            self.isReversedCardShowing = false
          }
        } else {
          if let rearText = self.rearLabel {
            self.mainLabel.text = rearText
            self.secondaryLabel.text = self.rearNotes ?? ""
            self.isReversedCardShowing = true
          }
        }
        
      })
    }, completion: { _ in
    })
    
  }
  
  @objc func handleDragging(_ gestureRecognizer: UIPanGestureRecognizer) {
    xCenter = gestureRecognizer.translation(in: self).x
    yCenter = gestureRecognizer.translation(in: self).y
    switch gestureRecognizer.state {
    case .began:
      originalPoint = self.center;
      break;
      
    case .changed:
      let rotationStrength = min(xCenter / UIScreen.main.bounds.size.width, 1)
      let rotationAngle = .pi/12 * rotationStrength
      let scale = max(1 - abs(rotationStrength) / SCALE_STRENGTH, SCALE_RANGE)
      center = CGPoint(x: originalPoint.x + xCenter, y: originalPoint.y + yCenter)
      colorize(xCenter: xCenter, yCenter: yCenter)
      if !didGenerateFeedback && (xCenter > THRESHOLD_MARGIN || xCenter < -THRESHOLD_MARGIN || yCenter < -VERTICAL_THRESHOLD_MARGIN) {
        generator.impactOccurred()
        didGenerateFeedback = true
      } else if xCenter < 50 && xCenter > -50 && yCenter > -50 {
        didGenerateFeedback = false
      }
      let transforms = CGAffineTransform(rotationAngle: rotationAngle)
      let scaleTransform: CGAffineTransform = transforms.scaledBy(x: scale, y: scale)
      self.transform = scaleTransform
      break;
      
    case .ended:
      afterSwipeAction()
      break;
      
    case .possible:break
    case .cancelled:break
    case .failed:break
    }
  }
  
  func colorize(xCenter: CGFloat, yCenter: CGFloat) {
    UIView.animate(withDuration: 0.15) {
      if xCenter > THRESHOLD_MARGIN {
        // green
        self.layer.backgroundColor = UIColor(red:0.52, green:0.94, blue:0.28, alpha:1.0).cgColor
        self.mainLabel.textColor = UIColor.white
        self.secondaryLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
      } else if xCenter < -THRESHOLD_MARGIN {
        // red
        self.layer.backgroundColor = UIColor(red:1.00, green:0.25, blue:0.34, alpha:1.0).cgColor
        self.mainLabel.textColor = UIColor.white
        self.secondaryLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
      } else if yCenter < -VERTICAL_THRESHOLD_MARGIN {
        // yellow
        self.layer.backgroundColor = UIColor(red:0.99, green:0.83, blue:0.03, alpha:1.0).cgColor
        self.mainLabel.textColor = UIColor.black
        self.secondaryLabel.textColor = UIColor.darkGray
      } else {
        self.layer.backgroundColor = UIColor.white.cgColor
        self.mainLabel.textColor = UIColor.black
        self.secondaryLabel.textColor = UIColor.darkGray
      }
    }
    
  }
  
  private func afterSwipeAction() {
    if xCenter > THRESHOLD_MARGIN {
      cardWentRight()
    } else if xCenter < -THRESHOLD_MARGIN {
      cardWentLeft()
    } else if yCenter < -VERTICAL_THRESHOLD_MARGIN {
      cardWentUp()
    } else {
      UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [], animations: {
        self.center = self.originalPoint
        self.transform = CGAffineTransform(rotationAngle: 0)
        self.swipeDelegate?.currentCardStatus(card: self, distance: 0)
      })
    }
  }
  
  private func cardWentLeft() {
    let finishPoint = CGPoint(x: 2 * xCenter + originalPoint.x, y: frame.size.height * 2)
    UIView.animate(withDuration: 0.5, animations: {
      self.center = finishPoint
    }, completion: {(_) in
      self.removeFromSuperview()
    })
    // handle card actions here
    swipeDelegate?.cardWentLeft(card: self)
    swipeDelegate?.cardMovement(card: self)
  }
  
  private func cardWentRight() {
    let finishPoint = CGPoint(x: 2 * xCenter + originalPoint.x, y: frame.size.height * 2)
    UIView.animate(withDuration: 0.5, animations: {
      self.center = finishPoint
    }, completion: {(_) in
      self.removeFromSuperview()
    })
    // handle card actions here
    swipeDelegate?.cardWentRight(card: self)
    swipeDelegate?.cardMovement(card: self)
  }
  
  private func cardWentUp() {
    let finishPoint = CGPoint(x: 0, y: 1000)
    UIView.animate(withDuration: 0.5, animations: {
      self.center = finishPoint
    }, completion: {(_) in
      self.removeFromSuperview()
    })
    // handle card actions here
    swipeDelegate?.cardWentUp(card: self)
    swipeDelegate?.cardMovement(card: self)
  }

}
