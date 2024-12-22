//
//  GameDifficulty.swift
//  MineSweeper
//
//  Created by yy on 2024/12/22.
//

import Foundation

typealias GameConfiguration = (rows: Int, columns: Int, mines: Int)

// MARK: - 难度等级,（手机上的竖屏游戏，所以行数大于列数）
enum GameDifficulty {
    case beginner
    case intermediate
    case expert
    
    var configuration: GameConfiguration {
        switch self {
        case .beginner:      return (6, 4, 2)    // 6x4 格子，2个地雷
        case .intermediate:  return (8, 6, 12)   // 8x6 格子，12个地雷
        case .expert:        return (10, 8, 20)   // 10x8 格子，20个地雷
        }
    }
}
