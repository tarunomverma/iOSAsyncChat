//
//  Extensions.swift
//  Async
//
//  Created by Tarun Verma on 29/12/2020.
//

import UIKit

class Colors {
    
    static let paleGrey = UIColor(hexString: "#F2F2F2")
    static let paleBlue = UIColor(hexString: "#74CDDC")
    static let paleGreen = UIColor(hexString: "#84C0D4")
    
}

//=================================================================================================

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension Date {
    
    func getDateTime(timeStamp :Int?) -> String {
        guard let timeStamp = timeStamp else { return ""}
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp/1000))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, h:mm a"
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
    }
    
    func getTime(timeStamp :Int?) -> String {
        guard let timeStamp = timeStamp else { return ""}
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp/1000))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
    }
}

//=================================================================================================

extension UIImage {

    public static func loadFrom(url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

}

//=================================================================================================

extension UIViewController {
    
    func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func addCancelButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                 target: self,
                                                                 action: #selector(dismissModal))
    }
    
    @objc func dismissModal() {
        self.dismiss(animated: true, completion: nil)
    }
}

//=================================================================================================

extension UIView {
    
    func bottomSafeAreaInset() -> CGFloat {
        let window = UIApplication.shared.keyWindow
        if let bottomPadding = window?.safeAreaInsets.bottom, bottomPadding > 0 {
            return bottomPadding
        } else {
            return 0
        }
    }
}
