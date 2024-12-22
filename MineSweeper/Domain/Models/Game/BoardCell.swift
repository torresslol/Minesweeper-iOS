//
//  BoardCell.swift
//  MineSweeper
//
//  Created by yy on 2024/12/22.
//

import Foundation

// MARK: - 单个格子模型
struct BoardCell {
    var isMine: Bool
    var isRevealed: Bool
    var neighborMineCount: Int // 为 0 代表空格子
    
    init(isMine: Bool = false) {
        self.isMine = isMine
        self.isRevealed = false
        self.neighborMineCount = 0
    }
}
