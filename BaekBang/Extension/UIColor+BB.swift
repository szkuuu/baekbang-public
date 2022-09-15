import UIKit

extension UIColor {

    /// Accent Color (#FF8000)
    open class var bbAccent: UIColor {
        .init(red: 0xFF / 255, green: 0x80 / 255, blue: 0x00 / 255, alpha: 1)
    }

    /// Black Color (#3D3D3D)
    open class var bbBlack1: UIColor {
        .init(red: 0x3D / 255, green: 0x3D / 255, blue: 0x3D / 255, alpha: 1)
    }
    
    /// Black Color (#6F6F6F)
    open class var bbBlack2: UIColor {
        .init(red: 0x6F / 255, green: 0x6F / 255, blue: 0x6F / 255, alpha: 1)
    }

    /// Gray1 Color (#AAAAAA)
    open class var bbGray1: UIColor {
        .init(red: 0xAA / 255, green: 0xAA / 255, blue: 0xAA / 255, alpha: 1)
    }

    /// Gray2 Color (#DBDBDB)
    open class var bbGray2: UIColor {
        .init(red: 0xDB / 255, green: 0xDB / 255, blue: 0xDB / 255, alpha: 1)
    }
    
    /// Gray3 Color (#F7F7F7)
    open class var bbGray3: UIColor {
        .init(red: 0xF7 / 255, green: 0xF7 / 255, blue: 0xF7 / 255, alpha: 1)
    }

    /// Orange Color (bbAccent with opacity 50%)
    open class var bbOrange1: UIColor {
        UIColor.bbAccent.withAlphaComponent(0.5)
    }
}
