//
//  AddCardViewController.swift
//  Flashcard
//
//  Created by Shaun Jacobsen on 3/31/19.
//  Copyright © 2019 Shaun Jacobsen. All rights reserved.
//

import UIKit
import RealmSwift

enum CardSide {
  case front
  case rear
}

class AddCardViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
  
  let realm = try! Realm()
  
  var selectedDeck: Deck?
  
  var isReversedCardShowing = false
  var isEditingCardText = false
  var isAutocorrectEnabled = false
  
  //
  // MARK: - IBOutlets
  //
  @IBOutlet weak var actionButtonsStackViewBottomConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var cardView: UIView!
  @IBOutlet weak var cardStackView: UIStackView!
  @IBOutlet weak var cardFrontTextField: UITextField!
  @IBOutlet weak var cardFrontNotesTextField: UITextView!
  @IBOutlet weak var cardFrontTextErrorLabel: UILabel!
  @IBOutlet weak var cardViewBottomDistanceConstraint: NSLayoutConstraint!
  @IBOutlet weak var swapCardButtonBottomDistanceConstraint: NSLayoutConstraint!
  @IBOutlet weak var cardViewLeadingConstraint: NSLayoutConstraint!
  @IBOutlet weak var cardViewTrailingConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var reverseCardStackView: UIStackView!
  @IBOutlet weak var reverseCardTextField: UITextField!
  @IBOutlet weak var reverseCardNotesTextField: UITextView!
  @IBOutlet weak var reverseCardTextErrorLabel: UILabel!
  
  @IBAction func handleTouchCancelButton(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func handleTouchFlipCardButton(_ sender: Any) {
    flipCard()
  }
  
  @IBAction func handleTouchAddButtonCard(_ sender: Any) {
    let side: CardSide = isReversedCardShowing ? .rear : .front
    // if currently showing card's text field is blank
    // show a warning on the card itself
    if !isTextFieldFilledOn(side: side) {
      showErrorTextOn(side: side)
    } else if !isTextFieldFilledOn(side: side == .rear ? .front : .rear) {
    // else if other side is blank, flip and prompt
      flipCard()
    } else {
    // else (both are not blank), add
      createCard(frontText: cardFrontTextField.text!, frontNotes: cardFrontNotesTextField.text ?? "", rearText: reverseCardTextField.text!, rearNotes: reverseCardNotesTextField.text ?? "", deck: selectedDeck!)
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  let screenSize = UIScreen.main.bounds
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    NotificationCenter.default.removeObserver(self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardViewTapped))
    cardView.addGestureRecognizer(tapGesture)

    cardView.layer.cornerRadius = 8
    cardView.layer.shadowColor = UIColor.black.cgColor
    cardView.layer.shadowOpacity = 0.11
    cardView.layer.shadowOffset = CGSize(width: 0, height: 3)
    cardView.layer.shadowRadius = 14
    
    cardFrontTextErrorLabel.isHidden = true
    reverseCardTextErrorLabel.isHidden = true
    
    reverseCardStackView.layer.opacity = 0
    
    actionButtonsStackViewBottomConstraint.constant = 0
    
    let inputAccessoryBar = UIToolbar()
    let autocorrectButton = UIBarButtonItem(title: "Autocorrect", style: .plain, target: self, action: #selector(toggleAutocorrect))
    inputAccessoryBar.items = [autocorrectButton]
    inputAccessoryBar.sizeToFit()
    cardFrontTextField.inputAccessoryView = AddCardInputAccessoryView()
  }
  
  //
  // MARK: - Text field delegate methods & observers
  //
  
  @objc func keyboardWillAppear() {
    UIView.animate(withDuration: 0.2, animations: {
      self.cardViewBottomDistanceConstraint.constant = 285
      self.actionButtonsStackViewBottomConstraint.constant = 320
      self.view.layoutIfNeeded()
    })
  }
  
  @objc func keyboardWillDisappear() {
    UIView.animate(withDuration: 0.2, animations: {
    self.cardViewBottomDistanceConstraint.constant = 40
    self.actionButtonsStackViewBottomConstraint.constant = 0
    self.view.layoutIfNeeded()
    })
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    isEditingCardText = true
    hideErrorText()
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    isEditingCardText = false
  }

  func textViewDidBeginEditing(_ textField: UITextView) {

  }

  func textViewDidEndEditing(_ textField: UITextView) {

  }
  
  @objc func toggleAutocorrect() {
    if isAutocorrectEnabled {
      self.cardFrontTextField.autocorrectionType = .no
      self.cardFrontTextField.spellCheckingType = .no
      self.isAutocorrectEnabled = false
    } else {
      self.cardFrontTextField.autocorrectionType = .yes
      self.cardFrontTextField.spellCheckingType = .yes
      self.isAutocorrectEnabled = true
    }
    self.cardFrontTextField.reloadInputViews()
  }
  
  //
  // MARK: - Touchable methods
  //
  
  @objc func cardViewTapped() {
    cardFrontNotesTextField.endEditing(true)
    cardFrontTextField.endEditing(true)
    reverseCardTextField.endEditing(true)
    reverseCardNotesTextField.endEditing(true)
  }
  
  //
  // MARK: - Generate new card
  //
  
  func createCard(frontText: String, frontNotes: String, rearText: String, rearNotes: String, deck: Deck) {
    do {
      try self.realm.write {
        if let deck = selectedDeck {
          let newCard = Card()
          newCard.questionText = frontText
          newCard.questionNotes = frontNotes
          newCard.answerText = rearText
          newCard.answerNotes = rearNotes
          deck.cards.append(newCard)
        }
      }
    } catch {
      displayGenericAlert(title: "Error creating card", message: "We're sorry, there was a problem creating a new card. Please try again.")
    }
  }
  
  func isTextFieldFilledOn(side: CardSide) -> Bool {
    if side == .front {
      return !cardFrontTextField.text!.isEmpty
    } else {
      return !reverseCardTextField.text!.isEmpty
    }
  }
  
  func hideErrorText() {
    cardFrontTextErrorLabel.isHidden = true
    cardFrontTextErrorLabel.isHidden = true
  }
  
  func showErrorTextOn(side: CardSide) {
    hideErrorText()
    if side == .front {
      cardFrontTextErrorLabel.isHidden = false
    } else {
      reverseCardTextErrorLabel.isHidden = false
    }
  }
  
  @objc func flipCard() {
  
    if !isReversedCardShowing {
      UIView.transition(with: cardView, duration: 0.4, options: .transitionFlipFromLeft, animations: {
        UIView.animate(withDuration: 0.4, animations: {
          self.cardStackView.layer.opacity = 0
          self.reverseCardStackView.layer.opacity = 100
        })
      }, completion: { _ in
        if self.isEditingCardText {
          self.reverseCardTextField.becomeFirstResponder()
        }
        self.isReversedCardShowing = true
      })
      
    } else {
      UIView.transition(with: cardView, duration: 0.4, options: .transitionFlipFromRight, animations: {
        UIView.animate(withDuration: 0.4, animations: {
          self.cardStackView.layer.opacity = 100
          self.reverseCardStackView.layer.opacity = 0
        })
      }, completion: { _ in
        if self.isEditingCardText {
          self.cardFrontTextField.becomeFirstResponder()
        }
        self.isReversedCardShowing = false
      })
    }
    
    
  }
  
  //
  // MARK: - Helpers
  //
  
  func displayGenericAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
    self.present(alert, animated: true)
  }

}
