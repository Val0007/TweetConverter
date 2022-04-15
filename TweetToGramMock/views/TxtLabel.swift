//
//  TxtLabel.swift
//  TweetToGramMock
//
//  Created by Val V on 13/03/22.
//

import UIKit

class TxtLabel: UILabel {

    private var rightDotView:UIView!
    private var leftDotView:UIView!
    
    let txt:String
    
    var pointSize:Float{
        return Float(font.pointSize)
    }

    init(frame: CGRect,txt:String) {
        self.txt = txt
        super.init(frame: frame)
        setup()
    }
    
    
//    let topInset = CGFloat(5.0), bottomInset = CGFloat(5.0), leftInset = CGFloat(8.0), rightInset = CGFloat(8.0)
//
//    override func drawText(in rect: CGRect) {
//           let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
//           super.drawText(in: rect.inset(by: insets))
//       }
//    
    
    required init?(coder: NSCoder) {
        self.txt = ""
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    
     func setup(){
        font = UIFont.systemFont(ofSize: 18)
        text = txt
        textAlignment  = .center
        translatesAutoresizingMaskIntoConstraints  = true
        layer.borderColor = UIColor.black.cgColor
        numberOfLines = 0
        tag = 1
        isUserInteractionEnabled = true
        textColor = .black
        
        addBothDots()
    }
    
     func addBothDots(){
        leftDotView = UIView()
        leftDotView.backgroundColor = .red
        addSubview(leftDotView)
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(leftDotMoveGesture(_:)))
        leftDotView.addGestureRecognizer(panRecognizer)
        leftDotView.layer.cornerRadius = 15/2
        leftDotView.anchor(left:leftAnchor,paddingLeft: -(15/2), width: 15, height: 15)
        leftDotView.centerY(inView: self)
        leftDotView.isHidden = true
        
        rightDotView = UIView()
        rightDotView.backgroundColor = .red
        addSubview(rightDotView)
        let rightDotPanRecognizer = UIPanGestureRecognizer(target: self, action: #selector(rightDotMoveGesture(_:)))
        rightDotView.addGestureRecognizer(rightDotPanRecognizer)
        rightDotView.layer.cornerRadius = 15/2
        rightDotView.anchor(right:rightAnchor,paddingRight: -(15/2),width: 15, height: 15)
        rightDotView.centerY(inView: self)
        rightDotView.isHidden = true
    }
    
    func addBorder(){
        layer.borderWidth = 0.5
        rightDotView.isHidden = false
        leftDotView.isHidden = false
        
    }
    
    func removeBorder(){
        layer.borderWidth = 0
        rightDotView.isHidden = true
        leftDotView.isHidden = true
    }
    
    @objc func leftDotMoveGesture(_ sender:UIPanGestureRecognizer){
            let loc = sender.location(in: self)
            var getSuperView = frame
            //origin -> 26
            //dragged left by -0.5
            //new width increase by 26 + -0.5 => 25.5
            //new width 190 - -0.5 = 190.5
            let newOrigin = getSuperView.origin.x + loc.x
            getSuperView.origin.x = newOrigin
           getSuperView.size.width += -loc.x
            frame = getSuperView

    }
    
    @objc func rightDotMoveGesture(_ sender:UIPanGestureRecognizer){
        print("Right move")
        let loc = sender.location(in: self)
        print("X loc is \(loc.x)")
        var getSuperView = frame
        print("label x is \(frame.origin.x)")
        getSuperView.size.width += (loc.x - getSuperView.width )
        frame = getSuperView
    }
}
