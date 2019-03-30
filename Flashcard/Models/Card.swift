//
//  Card.swift
//  Flashcard
//
//  Created by Shaun Jacobsen on 3/30/19.
//  Copyright © 2019 Shaun Jacobsen. All rights reserved.
//

import Foundation
import RealmSwift

class Card: Object {
  @objc dynamic var questionText: String = ""
  @objc dynamic var questionNotes: String?
  @objc dynamic var answerText: String = ""
  @objc dynamic var answerNotes: String?
  @objc dynamic var inverseOf: Card?
  @objc dynamic var lastAnswerMood: String?
  @objc dynamic var lastAnsweredOn: Date?
  @objc dynamic var nextAppearanceOn: Date?
  @objc dynamic var history: [CardPerformanceHistory]?
}
