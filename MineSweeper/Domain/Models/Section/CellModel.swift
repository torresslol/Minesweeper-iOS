//
//  CellModel.swift
//  MineSweeper
//
//  Created by yy on 2024/12/22.
//

import Foundation
import IGListKit

class CellModel: ListDiffable, Equatable {
    var state: CellState
    var rowIndex: Int
    var columnIndex: Int

    init(state: CellState, row: Int, column: Int) {
        self.state = state
        self.rowIndex = row
        self.columnIndex = column
    }

    func diffIdentifier() -> NSObjectProtocol {
        return "\(rowIndex)-\(columnIndex)" as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let other = object as? CellModel else { return false }
        return state == other.state && rowIndex == other.rowIndex && columnIndex == other.columnIndex
    }
    
    static func == (lhs: CellModel, rhs: CellModel) -> Bool {
        return lhs.state == rhs.state &&
        lhs.rowIndex == rhs.rowIndex &&
        lhs.columnIndex == rhs.columnIndex
    }
}
