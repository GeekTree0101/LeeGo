//
//  ElementViewModel.swift
//  LeeGo
//
//  Created by Victor WANG on 17/01/16.
//  Copyright © 2016 LeeGo. All rights reserved.
//

import Foundation
import LeeGo

struct ElementViewModel<E: Element> {

    let element: E

    init(element: E) {
        self.element = element
    }
}

extension ElementViewModel {
    static func elementViewModelsWithElements(elements: [E]) -> [ElementViewModel] {
        return elements.map({ (element) -> ElementViewModel in
            return ElementViewModel(element: element)
        })
    }
}

extension ElementViewModel: BrickDataSource {
    func update(_ targetView: UIView, with brick: Brick) {
        switch targetView {
        case let titleLabel as UILabel where brick == LeMonde.title:
            titleLabel.attributedText = titleLabel.lg_updatedAttributedString(with: [element.isRestrict ? "󰀀" : nil, element.title, element.natureEdito])
        case let subtitleLabel as UILabel  where brick == LeMonde.subtitle:
            subtitleLabel.text = element.description
        case let illustration as UIImageView where brick == LeMonde.illustration:
            illustration.backgroundColor = UIColor.gray
        default:
            break
        }
    }
}
