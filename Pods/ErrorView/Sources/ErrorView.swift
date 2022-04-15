//
//  ErrorView.swift
//  Spark
//
//  Created by Philip on 28/3/19.
//  Copyright © 2019 Next Generation. All rights reserved.
//

import UIKit

public class ErrorView: UIView {
    var label: UILabel? {
        return subviews.first as? UILabel
    }
    var text: String? {
        get {
            return label?.text
        }
        set {
            label?.text = newValue
        }
    }
    
    var yh:CGFloat = 0
    
    var h:CGFloat{
        get{
            return yh
        }
        set(value){
            yh = value
        }
    }
    

    
    private var isShake: Bool = false
    public var dismissTime: TimeInterval = 4.0
    private var dismissTimer: Timer?
    
    public static var backgroundColor = UIColor.orange
    public static var font = UIFont.boldSystemFont(ofSize: 14.5)
    public static var textColor = UIColor.white
    
    //TODO:
    convenience public init?(addTo viewController: UIViewController, text: String, backgroundColor: UIColor = ErrorView.backgroundColor, font: UIFont = ErrorView.font, textColor: UIColor = ErrorView.textColor, dismissTime: TimeInterval = 4.0) {
        if let errorView = viewController.view.subviews.last as? ErrorView {
            guard errorView.label?.text != text else {
                if errorView.dismissTimer != nil {
                    errorView.labelShake()
                    errorView.dismissWithTime(dismissTime)
                }
                return nil
            }
        }
        self.init(frame: CGRect(x: 0, y: -viewController.view.frame.height/5, width: UIScreen.main.bounds.width, height: viewController.view.frame.height/5))
        self.h = viewController.view.frame.height/5
        self.backgroundColor = backgroundColor
        self.dismissTime = dismissTime
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.text = text
        label.textColor = textColor
        addSubview(label)
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        viewController.view.addSubview(self)
        viewPresent()
    }

    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        frame.origin.y = 0
        isHidden = false
    }
    
    func viewPresent() {
        guard dismissTimer == nil else {
            return
        }
        guard !isHidden, superview != nil else {
            return
        }
        //frame.origin.y = viewController.view.frame.height/2
        alpha = 0
        isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin.y = 0
            self.alpha = 1
        }) { _ in
            self.dismissWithTime(self.dismissTime)
        }
    }
    
    func labelShake() {
        guard !isShake else {
            return
        }
        isShake = true
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-8, 8, -7, 7, -3, 3, -1, 1, 0]
        label?.layer.add(animation, forKey: "shake")
        Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(self.labelShakeEnd), userInfo: nil, repeats: false)
    }
    
    @objc private func labelShakeEnd() {
        isShake = false
    }
    
    func dismissWithTime(_ timeInterval: TimeInterval) {
        dismissTimer?.invalidate()
        dismissTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.dismiss), userInfo: nil, repeats: false)
    }
    
    @objc func dismiss() {
        dismissTimer?.invalidate()
        dismissTimer = nil
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin.y -= self.h
            self.alpha = 0
        }) { _ in
            self.isHidden = true
            self.removeFromSuperview()
        }
    }
}
