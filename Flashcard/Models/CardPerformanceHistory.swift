//
//  CardPerformanceHistory.swift
//  Flashcard
//
//  Created by Shaun Jacobsen on 3/30/19.
//  Copyright © 2019 Shaun Jacobsen. All rights reserved.
//

import Foundation
import RealmSwift

class CardPerformanceHistory: Object {
  @objc dynamic var timestamp: Date = Date()
  @objc dynamic var answerMood: String = ""
  @objc dynamic var nextAppearanceOn: Date = Date()
  var card = LinkingObjects(fromType: Card.self, property: "history")
}
