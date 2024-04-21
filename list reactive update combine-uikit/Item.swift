//
//  Item.swift
//  list reactive update combine-uikit
//
//  Created by Mahi Al Jawad on 21/4/24.
//

import Foundation
import Combine

struct Item {
    let checked: AnyPublisher<Bool, Never>
    let name: String
}
