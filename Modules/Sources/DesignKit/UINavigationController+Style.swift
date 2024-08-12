import UIKit

public extension UINavigationController {
    static func styleJobHunt() {
        
        let appearence = UINavigationBar.appearance()
        
        appearence.tintColor = .textField

        let imageBack = UIImage(resource: .angleArrowLeft)

        appearence.backIndicatorImage = imageBack
        appearence.backIndicatorTransitionMaskImage = imageBack

        appearence.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
}
