//
//  MainButton.swift
//  MineSweeper
//
//  Created by yy on 2024/12/22.
//

import Foundation
import UIKit

class MainButton: UIButton {
    
    // Customizable properties
    var enabledBackgroundColor: UIColor = .hint{
        didSet { updateAppearance() }
    }
    
    var disabledBackgroundColor: UIColor = .revealed {
        didSet { updateAppearance() }
    }
    
    var enabledTitleColor: UIColor = .white {
        didSet { updateAppearance() }
    }
    
    var disabledTitleColor: UIColor = .lightGray {
        didSet { updateAppearance() }
    }
    
    override var isEnabled: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    // Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        updateAppearance()
    }
    
    private func updateAppearance() {
        backgroundColor = isEnabled ? enabledBackgroundColor : disabledBackgroundColor
        setTitleColor(
            isEnabled ? enabledTitleColor : disabledTitleColor,
            for: .normal
        )
        titleLabel?.font = .title
        isUserInteractionEnabled = isEnabled
    }
}
