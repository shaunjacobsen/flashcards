//
//  AddCardViewController.swift
//  Flashcard
//
//  Created by Shaun Jacobsen on 3/31/19.
//  Copyright © 2019 Shaun Jacobsen. All rights reserved.
//

import UIKit

class AddCardViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
  
  var isReversedCardShowing = false
  var isEditingCardText = false
  
  //
  // MARK: - IBOutlets
  //
  @IBOutlet weak var actionButtonsStackViewBottomConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var cardView: UIView!
  @IBOutlet weak var cardStackView: UIStackView!
  @IBOutlet weak var cardFrontTextField: UITextField!
  @IBOutlet weak var cardFrontNotesTextField: UITextView!
  @IBOutlet weak var cardViewBottomDistanceConstraint: NSLayoutConstraint!
  @IBOutlet weak var swapCardButtonBottomDistanceConstraint: NSLayoutConstraint!
  @IBOutlet weak var cardViewLeadingConstraint: NSLayoutConstraint!
  @IBOutlet weak var cardViewTrailingConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var reverseCardStackView: UIStackView!
  @IBOutlet weak var reverseCardTextField: UITextField!
  @IBOutlet weak var reverseCardNotesTextField: UITextView!
  
  @IBAction func handleTouchCancelButton(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func handleTouchFlipCardButton(_ sender: Any) {
    flipCard()
  }

  let screenSize = UIScreen.main.bounds
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardViewTapped))
    cardView.addGestureRecognizer(tapGesture)

    cardView.layer.cornerRadius = 8
    cardView.layer.shadowColor = UIColor.black.cgColor
    cardView.layer.shadowOpacity = 0.11
    cardView.layer.shadowOffset = CGSize(width: 0, height: 3)
    cardView.layer.shadowRadius = 14
    
    reverseCardStackView.layer.opacity = 0
    
    actionButtonsStackViewBottomConstraint.constant = 0
    
  }
  
  //
  // MARK: - Text field delegate methods
  //
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    isEditingCardText = true
    UIView.animate(withDuration: 0.3, animations: {
      self.cardViewBottomDistanceConstraint.constant = 285
      self.actionButtonsStackViewBottomConstraint.constant = 320
      self.view.layoutIfNeeded()
    })
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    isEditingCardText = false
    UIView.animate(withDuration: 0.2, animations: {
      self.cardViewBottomDistanceConstraint.constant = 40
      self.actionButtonsStackViewBottomConstraint.constant = 0
      self.view.layoutIfNeeded()
    })
  }
  
  func textViewDidBeginEditing(_ textField: UITextView) {
    UIView.animate(withDuration: 0.3, animations: {
      self.cardViewBottomDistanceConstraint.constant = 285
      self.actionButtonsStackViewBottomConstraint.constant = 320
      self.view.layoutIfNeeded()
    })
  }
  
  func textViewDidEndEditing(_ textField: UITextView) {
    UIView.animate(withDuration: 0.2, animations: {
      self.cardViewBottomDistanceConstraint.constant = 40
      self.actionButtonsStackViewBottomConstraint.constant = 0
      self.view.layoutIfNeeded()
    })
  }
  
  //
  // MARK: - Touchable methods
  //
  
  @objc func cardViewTapped() {
    cardFrontNotesTextField.endEditing(true)
    cardFrontTextField.endEditing(true)
  }
  
  //
  // MARK: - Generate new card
  //
  
  @objc func flipCard() {
    
    if !isReversedCardShowing {
      UIView.transition(with: cardView, duration: 0.4, options: .transitionFlipFromLeft, animations: {
        UIView.animate(withDuration: 0.4, animations: {
          self.cardStackView.layer.opacity = 0
          self.reverseCardStackView.layer.opacity = 100
        })
        
      }, completion: { done in
        if self.isEditingCardText {
          self.reverseCardTextField.becomeFirstResponder()
        }
      })
      isReversedCardShowing = true
    } else {
      UIView.transition(with: cardView, duration: 0.4, options: .transitionFlipFromRight, animations: {
        UIView.animate(withDuration: 0.4, animations: {
          self.cardStackView.layer.opacity = 100
          self.reverseCardStackView.layer.opacity = 0
        })
      }, completion: { done in
        if self.isEditingCardText {
          self.cardFrontTextField.becomeFirstResponder()
        }
      })
      isReversedCardShowing = false
    }
    
  }

}
