import Foundation

class TempLogger: Logger {
    func debug(_ message: String, file: String, function: String, line: Int) {
        print("🔍 DEBUG: \(message)")
    }
    
    func info(_ message: String, file: String, function: String, line: Int) {
        print("ℹ️ INFO: \(message)")
    }
    
    func warning(_ message: String, file: String, function: String, line: Int) {
        print("⚠️ WARNING: \(message)")
    }
    
    func error(_ message: String, file: String, function: String, line: Int) {
        print("❌ ERROR: \(message)")
    }
    
    func verbose(_ message: String, file: String, function: String, line: Int) {
        print("📝 VERBOSE: \(message)")
    }
} 
