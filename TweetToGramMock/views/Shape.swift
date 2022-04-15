//
//  Shape.swift
//  TweetToGramMock
//
//  Created by Val V on 26/03/22.
//

import UIKit
import SDWebImage

class Shape: UIImageView {
    
    
    
    private var rightDotView:UIView!
    private var leftDotView:UIView!
    private var topDotView:UIView!
    private var bottomDotView:UIView!
    let id = UUID().uuidString
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        backgroundColor = .blue
        addBothDots()
        addVerticalDots()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }
    

    private func setupUI(){
        tag = 2
        contentMode = .scaleToFill
        clipsToBounds = true

    }
    
    
     func addBothDots(){
        layer.borderColor = UIColor.black.cgColor
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
    
     func addVerticalDots(){
        topDotView = UIView()
        topDotView.backgroundColor = .red
        addSubview(topDotView)
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(topDotMoveGesture(_:)))
        topDotView.addGestureRecognizer(panRecognizer)
        topDotView.layer.cornerRadius = 15/2
        topDotView.anchor(top:topAnchor,paddingTop:-(15/2), width: 15, height: 15)
        topDotView.centerX(inView: self)
        topDotView.isHidden = true
        
        bottomDotView = UIView()
        bottomDotView.backgroundColor = .red
        addSubview(bottomDotView)
        let btm = UIPanGestureRecognizer(target: self, action: #selector(bottomDotMoveGesture(_:)))
        bottomDotView.addGestureRecognizer(btm)
        bottomDotView.layer.cornerRadius = 15/2
        bottomDotView.anchor(bottom:bottomAnchor,paddingBottom:-(15/2), width: 15, height: 15)
        bottomDotView.centerX(inView: self)
        bottomDotView.isHidden = true
    }
    
    
    func addBorder(){
        layer.borderWidth = 0.5
        rightDotView.isHidden = false
        leftDotView.isHidden = false
        topDotView.isHidden = false
        bottomDotView.isHidden = false
        
    }
    
    func removeBorder(){
        layer.borderWidth = 0
        rightDotView.isHidden = true
        leftDotView.isHidden = true
        topDotView.isHidden = true
        bottomDotView.isHidden = true
    }
    
    func addImage(image:String){
        self.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "profile")) { img, err, cache, url in
            
        }
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
    
    @objc func topDotMoveGesture(_ sender:UIPanGestureRecognizer){
            let loc = sender.location(in: self)
            var getSuperView = frame
            //origin -> 40
            //dragged top to -23
            //new origin increase by 40 (-23) => 17
            //height increases by 23
           let originChange =  getSuperView.origin.y + loc.y //origin change
           getSuperView.origin.y = originChange
           getSuperView.size.height += -loc.y
            frame = getSuperView

    }
    @objc func bottomDotMoveGesture(_ sender:UIPanGestureRecognizer){
        let loc = sender.location(in: self)
        var getSuperView = frame
        //height 90
        //bottom drag to 120
        //height increases by 120 - 90
        print("orgin y \(getSuperView.origin.y)")
        print("height is \(getSuperView.height)")
        print("y change \(loc.y)")
        getSuperView.size.height += (loc.y - getSuperView.height)
        print("new height \(getSuperView.height)")
        frame = getSuperView

    }
    
}
