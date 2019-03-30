//
//  Deck.swift
//  Flashcard
//
//  Created by Shaun Jacobsen on 3/30/19.
//  Copyright © 2019 Shaun Jacobsen. All rights reserved.
//

import Foundation
import RealmSwift

class Deck: Object {
  @objc dynamic var name: String = ""
  @objc dynamic var source: String = ""
  @objc dynamic var createdBy: String = ""
  @objc dynamic var createdOn: Date = Date()
  @objc dynamic var progressStartedOn: Date?
  @objc dynamic var cards: [Card]?
}
