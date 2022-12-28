import UIKit

extension Double {
    var multiplierX: Double {
        return Double(self) * Double(UIScreen.main.bounds.size.width / 375)  // 12 mini iphone width
    }
    
    var multiplierY: Double {
        return Double(self) * Double(UIScreen.main.bounds.size.height / 812)  // 12 mini iphone height
    }
}

extension Int {
    var multiplierX: Double {
        return Double(self) * Double(UIScreen.main.bounds.size.width / 375)
    }
    
    var multiplierY: Double {
        return Double(self) * Double(UIScreen.main.bounds.size.height / 812)
    }
}

