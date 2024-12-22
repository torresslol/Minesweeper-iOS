//
//  SectionModel.swift
//  MineSweeper
//
//  Created by yy on 2024/12/22.
//

import Foundation
import IGListKit

class SectionModel: ListDiffable {
    let row: Int
    let cells: [CellModel]
    
    init(row: Int, cells: [CellModel]) {
        self.row = row
        self.cells = cells
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return row as NSNumber
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let other = object as? SectionModel else { return false }
        return row == other.row && cells == other.cells
    }
    
}
