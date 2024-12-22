//
//  AppContext.swift
//  MineSweeper
//
//  Created by yy on 2024/12/22.
//

import Foundation

final class AppContext {
    static let shared = AppContext()
    
    // MARK: - Properties
    private(set) var environment: Environment = .development
    private(set) var logger: Logger!
    
    private init() {
        setupEnvironment()
    }
    
    // MARK: - Environment
    enum Environment {
        case development
        case staging
        case production
    }
    
    private func setupEnvironment() {
#if DEBUG
        environment = .development
#else
        environment = .production
#endif
    }
    
    // MARK: - Initialization
    func initLogger() {
        self.logger = TempLogger()
        logger.info("App started in \(environment) environment")
        logger.info("Environment configured as: \(environment)")
    }
    
    // MARK: - Logger Configuration
    func configureLogger(_ logger: Logger) {
        self.logger = logger
    }
}

// MARK: - Convenience Properties

extension AppContext {
    var isDevelopment: Bool {
        environment == .development
    }
    
    var isStaging: Bool {
        environment == .staging
    }
    
    var isProduction: Bool {
        environment == .production
    }
}

