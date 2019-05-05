//
//  Extensions.swift
//  MovieList
//
//  Created by coreylin on 8/18/18.
//  Copyright © 2018 coreylin. All rights reserved.
//

extension Collection {
  func forEachPair(body: (Element, Element) -> Void) {
    var prev: Element?
    for cur in self {
      if let prev = prev {
        body(prev, cur)
      }
      prev = cur
    }
  }
}
