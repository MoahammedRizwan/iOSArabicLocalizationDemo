//
//  ViewController.swift
//  ArabicLocalizationDemo
//
//  Created by Rizwan on 11/21/18.
//  Copyright © 2018 MakanEats. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var vehicleHeader:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if L102Language.currentAppleLanguage() == "ar" {
            loopThroughViewsToFlipImageViews(subviews: self.view.subviews,orientation : UIImageOrientation.upMirrored)
        } else {
            loopThroughViewsToFlipImageViews(subviews: self.view.subviews, orientation: UIImageOrientation.up)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func nextButtonPressed(sender:UIButton) {
        if let viewControllerToPush = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController {
            self.navigationController?.pushViewController(viewControllerToPush, animated: true)
        }
    }
    
    //Mark - Switch Languages Manually
    @IBAction func switchLanguageButtonPressed(sender:UIButton) {
        let localizedTitle = NSLocalizedString("Hi", comment: "")
        let localizedContent = NSLocalizedString("Are u sure want to switch language", comment: "")
        let alert = UIAlertController(title: localizedTitle, message: localizedContent, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { void in
            self.switchLanguage()
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    func switchLanguage() {
        if L102Language.currentAppleLanguage() == "en" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            loopThroughViewsToFlipImageViews(subviews: self.view.subviews, orientation: UIImageOrientation.upMirrored)
            L102Language.setAppleLanguageTo(lang: "ar")
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            L102Language.setAppleLanguageTo(lang: "en")
            loopThroughViewsToFlipImageViews(subviews: self.view.subviews, orientation: UIImageOrientation.up)
        }
        if let rootViewController : UIWindow = (UIApplication.shared.delegate?.window)! {
            rootViewController.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "rootNavigation")
            if let mainWindow = UIApplication.shared.delegate?.window {
                mainWindow?.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
                UIView.transition(with: mainWindow!, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
                    
                }) { (finished) -> Void in
                    
                }
            }
        }
    }
}
