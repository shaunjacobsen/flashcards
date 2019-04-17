//
//  Card.swift
//  Flashcard
//
//  Created by Shaun Jacobsen on 4/16/19.
//  Copyright © 2019 Shaun Jacobsen. All rights reserved.
//

import UIKit

let THRESHOLD_MARGIN = (UIScreen.main.bounds.size.width / 2) * 0.5
let SCALE_STRENGTH: CGFloat = 4
let SCALE_RANGE: CGFloat = 0.90

protocol SwipeableCardDelegate: NSObjectProtocol {
  func cardMovement(card: SwipeableCard)
  func cardWentLeft(card: SwipeableCard)
  func cardWentRight(card: SwipeableCard)
  func cardWentUp(card: SwipeableCard)
  func currentCardStatus(card: SwipeableCard, distance: CGFloat)
}

class SwipeableCard: UIView {
  
  var xCenter: CGFloat = 0.0
  var yCenter: CGFloat = 0.0
  var originalPoint = CGPoint.zero
  lazy var generator = UIImpactFeedbackGenerator(style: .light)
  
  lazy var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handleDragging))
  
  weak var delegate: SwipeableCardDelegate?
  
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
  
  @objc func handleDragging(_ gestureRecognizer: UIPanGestureRecognizer) {
    xCenter = gestureRecognizer.translation(in: self).x
    yCenter = gestureRecognizer.translation(in: self).y
    switch gestureRecognizer.state {
    case .began:
      originalPoint = self.center;
      break;
    case .changed:
      let rotationStrength = min(xCenter / UIScreen.main.bounds.size.width, 1)
      let rotationAngel = .pi/8 * rotationStrength
      let scale = max(1 - abs(rotationStrength) / SCALE_STRENGTH, SCALE_RANGE)
      center = CGPoint(x: originalPoint.x + xCenter, y: originalPoint.y + yCenter)
//      print("xCenter: \(xCenter)")
//      print("THRESHOLD_MARGIN: \(THRESHOLD_MARGIN)")
//
//      if Int(xCenter) == Int(THRESHOLD_MARGIN) || Int(xCenter) == Int(-THRESHOLD_MARGIN) {
//        generator.impactOccurred()
//      }
      let transforms = CGAffineTransform(rotationAngle: rotationAngel)
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
  
  func afterSwipeAction() {
    if xCenter > THRESHOLD_MARGIN {
      cardWentLeft()
    }
    else if xCenter < -THRESHOLD_MARGIN {
      cardWentRight()
    } else if yCenter < (UIScreen.main.bounds.size.height / 2) * 0.5 {
      cardWentUp()
    } else {
      UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [], animations: {
        self.center = self.originalPoint
        self.transform = CGAffineTransform(rotationAngle: 0)
        self.delegate?.currentCardStatus(card: self, distance: 0)
      })
    }
  }
  
  func cardWentLeft() {
    let finishPoint = CGPoint(x: 2 * xCenter + originalPoint.x, y: frame.size.height * 2)
    UIView.animate(withDuration: 0.5, animations: {
      self.center = finishPoint
    }, completion: {(_) in
      self.removeFromSuperview()
    })
    // handle card actions here
    delegate?.cardMovement(card: self)
    delegate?.cardWentLeft(card: self)
  }
  
  func cardWentRight() {
    let finishPoint = CGPoint(x: 2 * xCenter + originalPoint.x, y: frame.size.height * 2)
    UIView.animate(withDuration: 0.5, animations: {
      self.center = finishPoint
    }, completion: {(_) in
      self.removeFromSuperview()
    })
    // handle card actions here
    delegate?.cardMovement(card: self)
    delegate?.cardWentRight(card: self)
  }
  
  func cardWentUp() {
    let finishPoint = CGPoint(x: xCenter, y: -frame.size.height * 2)
    UIView.animate(withDuration: 0.5, animations: {
      self.center = finishPoint
    }, completion: {(_) in
      self.removeFromSuperview()
    })
    // handle card actions here
    delegate?.cardMovement(card: self)
    delegate?.cardWentUp(card: self)
  }

}
