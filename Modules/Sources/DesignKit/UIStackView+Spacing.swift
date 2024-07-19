import UIKit
import SnapKit

public extension UIStackView {
    
    func addSpacing(height: CGFloat) {
        let spacer = UIView()
        
        self.addArrangedSubview(spacer)
        
        spacer.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
    }
}
