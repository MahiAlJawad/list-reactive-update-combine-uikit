//
//  ItemCell.swift
//  list reactive update combine-uikit
//
//  Created by Mahi Al Jawad on 21/4/24.
//

import UIKit
import Combine

class ItemCell: UITableViewCell {
    @IBOutlet weak var checkImage: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        cancellables = Set<AnyCancellable>()
    }

    func configure(_ item: Item) {
        item.checked
            .receive(on: RunLoop.main)
            .prepend(false)
            .map { UIImage(systemName: $0 == true ? "checkmark.circle.fill": "checkmark.circle") }
            .assign(to: \.image, on: checkImage)
            .store(in: &cancellables)
        
        label.text = item.name
    }
    
}
