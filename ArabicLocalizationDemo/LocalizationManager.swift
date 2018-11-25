//
//  LocalizationManager.swift
//  ArabicLocalizationDemo
//
//  Created by Rizwan on 11/24/18.
//  Copyright © 2018 MakanEats. All rights reserved.
//

import Foundation
import UIKit
//Apple Constant
let appleLanguageKey = "AppleLanguages"

class L102Language {
    class func currentAppleLanguage() -> String {
        let langArray = UserDefaults.standard.object(forKey: appleLanguageKey) as! NSArray
        let currentLang = langArray.firstObject as! String
        return currentLang
    }
    
    class func setAppleLanguageTo(lang:String) {
        UserDefaults.standard.set([lang,currentAppleLanguage()], forKey: appleLanguageKey)
        UserDefaults.standard.synchronize()
    }
}
class LocalizerManager : NSObject {
    class func doSwizzling() {
        MethodSwizzleGivenClassName(cls: Bundle.self, orginalSelector: #selector(Bundle.localizedString(forKey:value:table:)), overideSelector: #selector(Bundle.specializedLocalizedStringForKey(key:value:table:)))
        
    }
}

extension Bundle {
    @objc func specializedLocalizedStringForKey(key:String,value:String?, table tableName: String?) -> String {
        let currentLang = L102Language.currentAppleLanguage()
        var bundle = Bundle()
        if let path = Bundle.main.path(forResource: currentLang, ofType: "lproj") {
            bundle = Bundle(path: path)!
        } else {
            let path = Bundle.main.path(forResource: "Base", ofType: "lproj")!
            bundle = Bundle(path: path)!
        }
        return bundle.specializedLocalizedStringForKey(key: key, value: value, table: tableName)
    }
    
}
//Exchange Lang Implementation
func MethodSwizzleGivenClassName(cls:AnyClass, orginalSelector: Selector, overideSelector: Selector) {
    let originalMethod:Method = class_getInstanceMethod(cls, orginalSelector)!
    let overideMethod:Method = class_getInstanceMethod(cls, overideSelector)!
    
    if (class_addMethod(cls, orginalSelector, method_getImplementation(overideMethod), method_getTypeEncoding(overideMethod))) {
        class_replaceMethod(cls, overideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
    } else {
        method_exchangeImplementations(originalMethod, overideMethod)
    }
}
//Flip Images in VCs Subviews
extension UIViewController {
    func loopThroughViewsToFlipImageViews(subviews:[UIView],orientation:UIImageOrientation) {
        if subviews.count > 0 {
            for subview in subviews {
                if subview.isKind(of: UIImageView.self) {
                    let flippedImage = subview as! UIImageView
                    if let img = flippedImage.image {
                        flippedImage.image = UIImage(cgImage: img.cgImage!, scale: img.scale, orientation: orientation)
                    }
                }
                loopThroughViewsToFlipImageViews(subviews: subview.subviews,orientation: orientation)
            }
        }
    }
}
//Layout Direction
extension UIApplication {
    var customUserInterfaceLayoutDirection : UIUserInterfaceLayoutDirection {
        get {
            var direction = UIUserInterfaceLayoutDirection.leftToRight
            if L102Language.currentAppleLanguage() == "ar" {
                direction = .rightToLeft
            }
            return direction
        }
    }
}
