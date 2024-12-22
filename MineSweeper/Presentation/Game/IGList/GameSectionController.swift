//
//  GameSectionController.swift
//  MineSweeper
//
//  Created by yy on 2024/12/22.
//

import IGListKit
//
//  GameSectionController.swift
//  MineSweeper
//
//  Created by yy on 2024/12/22.
//

import UIKit

class GameSectionController: ListSectionController {
    weak var gameViewController: GameViewController?
    private var sectionModel: SectionModel?
    private let logger: Logger
    
    init(logger: Logger = AppContext.shared.logger) {
        self.logger = logger
        super.init()
        minimumInteritemSpacing = 4
        minimumLineSpacing = 4
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0)
    }
    
    override func didUpdate(to object: Any) {
        sectionModel = object as? SectionModel
    }
    
    override func numberOfItems() -> Int {
        return sectionModel?.cells.count ?? 0
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext,
              let viewController = gameViewController else { return .zero }
        
        let config = viewController.getGameConfiguration()

        let totalWidth = context.containerSize.width - (
            inset.left + inset.right
        )
        let totalSpacing = (
            CGFloat(config.columns - 1) * minimumInteritemSpacing
        )
        let cellWidth = (totalWidth - totalSpacing) / CGFloat(config.columns)
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(
            of: GameBoardCell.self,
            for: self,
            at: index
        ) as? GameBoardCell,
              let model = sectionModel?.cells[index] else {
            logger
                .error("Failed to dequeue cell or get model at index: \(index)")
            fatalError()
        }
        
        cell.configure(viewModel: model)
        return cell
    }
    
    override func didSelectItem(at index: Int) {
        guard let viewController = gameViewController,
              let model = sectionModel?.cells[index] else { return }
        
        viewController.highlightedCell?.stopBreathingAnimation()
        viewController.highlightedCell = nil
        
        viewController
            .handleCellSelected(at: model.rowIndex, column: model.columnIndex)
    }
}

