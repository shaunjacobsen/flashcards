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
  
  var imagePicker: ImagePicker!
  
  //
  // MARK: - IBOutlets
  //
  @IBOutlet weak var actionButtonsStackViewBottomConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var cardView: UIView!
  @IBOutlet weak var cardStackView: UIStackView!
  @IBOutlet weak var cardFrontTextField: UITextField!
  @IBOutlet weak var cardFrontNotesTextField: UITextView!
  @IBOutlet weak var cardFrontImageView: UIImageView!
  @IBOutlet weak var cardFrontTextErrorLabel: UILabel!
  @IBOutlet weak var cardViewBottomDistanceConstraint: NSLayoutConstraint!
  @IBOutlet weak var swapCardButtonBottomDistanceConstraint: NSLayoutConstraint!
  @IBOutlet weak var cardViewLeadingConstraint: NSLayoutConstraint!
  @IBOutlet weak var cardViewTrailingConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var reverseCardStackView: UIStackView!
  @IBOutlet weak var reverseCardTextField: UITextField!
  @IBOutlet weak var reverseCardNotesTextField: UITextView!
  @IBOutlet weak var reverseCardImageView: UIImageView!
  @IBOutlet weak var reverseCardTextErrorLabel: UILabel!
  
  @IBOutlet weak var addImageButton: UIButton!
  @IBOutlet weak var addSoundButton: UIButton!
  
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
      createCard(frontText: cardFrontTextField.text!, frontNotes: cardFrontNotesTextField.text ?? "", rearText: reverseCardTextField.text!, rearNotes: reverseCardNotesTextField.text ?? "", image: nil, shouldSpeak: false, spokenDialect: nil, deck: selectedDeck!)
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  @IBAction func handleTapAddImageButton(_ sender: UIButton) {
    self.imagePicker.present(from: sender)
  }
  
  @IBAction func handleTapAddSoundButton(_ sender: UIButton) {
    // present a list at the bottom with all the dialects available
    // at the top of this list should be the dialects that are present, if any, in the existing deck
  }
  
  
  let screenSize = UIScreen.main.bounds
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    
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
    
  }
  
  //
  // MARK: - Text field delegate methods
  //
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    isEditingCardText = true
    hideErrorText()
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
  // MARK: - Card operations
  //
  
  func createCard(frontText: String, frontNotes: String, rearText: String, rearNotes: String, image: String?, shouldSpeak: Bool, spokenDialect: String?, deck: Deck) {
    do {
      try self.realm.write {
        if let deck = selectedDeck {
          let newCard = Card()
          newCard.questionText = frontText
          newCard.questionNotes = frontNotes
          newCard.answerText = rearText
          newCard.answerNotes = rearNotes
          newCard.image = image ?? ""
          newCard.shouldSpeak = shouldSpeak
          newCard.spokenDialect = spokenDialect ?? ""
          deck.cards.append(newCard)
        }
      }
    } catch {
      displayGenericAlert(title: "Error creating card", message: "We're sorry, there was a problem creating a new card. Please try again.")
    }
  }
  
  func addImage(image: UIImage) -> String? {
    let data = UIImage.pngData(image)
    guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else { return nil }
    do {
      let imageFilename = "\(UUID().uuidString).png"
      try data()!.write(to: directory.appendingPathComponent(imageFilename)!)
      return imageFilename
    } catch {
      print("Could not save image")
      return nil
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
      })
      isReversedCardShowing = true
      setupStaticViews(for: .rear)
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
      })
      isReversedCardShowing = false
      setupStaticViews(for: .front)
    }
    
  }
  
  func setupStaticViews(for cardFace: CardSide) {
    switch cardFace {
    case .front:
      if cardFrontImageView!.image != nil {
        addImageButton.setImage(UIImage(named: "add-image-button-filled"), for: UIControl.State.normal)
      } else {
        addImageButton.setImage(UIImage(named: "add-image-button"), for: UIControl.State.normal)
      }
    case .rear:
      if reverseCardImageView!.image != nil {
        addImageButton.setImage(UIImage(named: "add-image-button-filled"), for: UIControl.State.normal)
      } else {
        addImageButton.setImage(UIImage(named: "add-image-button"), for: UIControl.State.normal)
      }
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

extension AddCardViewController: ImagePickerDelegate {
  
  func didSelect(image: UIImage?) {
    if isReversedCardShowing {
      reverseCardImageView.image = image
    } else {
      cardFrontImageView.image = image
    }
  }
  
}
