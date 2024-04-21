//
//  ViewModel.swift
//  list reactive update combine-uikit
//
//  Created by Mahi Al Jawad on 21/4/24.
//

import Foundation
import Combine

class ViewModel {
    enum UIEvent {
        case reload
    }
    
    var items = [Item]()
    
    private var itemCheckStatus = [false, false, false, false, false, false, false, false]
    private var itemNames = ["A", "B", "C", "D", "E", "F", "G", "H"]
    
    private var cancellables = Set<AnyCancellable>()
    
    private let checkItemPublisher = Timer.publish(every: 2, on: .main, in: .default).autoconnect()
    
    private let shuffleItemsPublisher = Timer.publish(every: 10, on: .main, in: .default).autoconnect()
    
    private var uiEventSubject = PassthroughSubject<UIEvent, Never>()
    
    init() {
        items = makeItems()
        keepShufflingItems()
        keepCheckUncheckItems()
    }
}

extension ViewModel {
    private func makeItems() -> [Item] {
        itemNames.reduce(into: [Item]()) { partialResult, itemName in
            guard let itemIndex = itemNames.firstIndex(where: { $0 == itemName }) else { return }
            
            let item = Item(
                checked: checkItemPublisher
                    .map { _ in self.itemCheckStatus[itemIndex] }
                    .eraseToAnyPublisher(),
                name: itemName
            )
            partialResult.append(item)
        }
    }
    
    private func keepCheckUncheckItems() {
        checkItemPublisher.sink { _ in
            for index in 0..<self.itemNames.count {
                self.itemCheckStatus[index] = Bool.random()
            }
        }
        .store(in: &cancellables)
    }
    
    private func keepShufflingItems() {
        shuffleItemsPublisher.sink { _ in
            print("Shuffling datasource")
            self.itemNames.shuffle()
            self.items = self.makeItems()
            self.uiEventSubject.send(.reload)
        }
        .store(in: &cancellables)
    }
}

extension ViewModel {
    var numberOfItems: Int {
        items.count
    }
    
    var uiEventPublisher: AnyPublisher<UIEvent, Never> {
        uiEventSubject.eraseToAnyPublisher()
    }
}
