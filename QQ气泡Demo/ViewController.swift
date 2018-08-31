//
//  ViewController.swift
//  QQ气泡Demo
//
//  Created by best su on 2018/8/16.
//  Copyright © 2018年 best su. All rights reserved.
//

import UIKit

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

class ViewController: UIViewController {

    var titleLabel: UILabel!
    var shaperLayer: CAShapeLayer!
    
    
    var radiu: CGFloat = 0
    
    var oldViewFrame: CGRect = CGRect.zero
    var oldViewCenter: CGPoint = CGPoint.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        demo()
        setUI()
        setPanGuester()
    }
    
    /// hitText的使用
    private func demo(){
        view.addSubview(textView)
        textView.frame = self.view.frame
    }
    
    
    private func setUI(){
        view.addSubview(iconView)
        view.addSubview(panView)
        
        titleLabel = UILabel.init(frame: panView.bounds)
        titleLabel.text = "9"
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        panView.addSubview(titleLabel)
        
        // 初始化shaperLayer
        self.shaperLayer = CAShapeLayer.init()
        radiu = iconView.frame.width/2
        oldViewFrame = self.iconView.frame
        oldViewCenter = iconView.center
    }
    
    private func setPanGuester(){
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(panClick(gue:)))
        panView.addGestureRecognizer(pan)
    }
    
    @objc private func panClick(gue: UIPanGestureRecognizer){
        if gue.state == UIGestureRecognizerState.changed{
            
            self.panView.center = gue.location(in: self.view)
            if radiu < 6{
                self.iconView.isHidden = true
                self.shaperLayer.removeFromSuperlayer()
            }else{
                cacluatorPoint()
            }
        }else if gue.state == UIGestureRecognizerState.ended || gue.state == UIGestureRecognizerState.cancelled || gue.state == UIGestureRecognizerState.failed{
            self.iconView.isHidden = true
            self.shaperLayer.removeFromSuperlayer()
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.panView.center = self.oldViewCenter
            }) { (_) in
                self.iconView.isHidden = false
                self.iconView.frame = self.oldViewFrame
                self.radiu = self.oldViewFrame.size.width/2;
                self.iconView.layer.cornerRadius = self.radiu;
            }
        }
        
    }
    
    private func cacluatorPoint(){
         //1.中心点
        let center1 = self.iconView.center
        let center2 = self.panView.center
        //2.2个中心点的距离(勾股定理)
        let minHeght = (center1.y-center2.y)*(center1.y-center2.y)
        let minWidth = (center1.x-center2.x)*(center1.x-center2.x)
        let dis = CGFloat(sqrtf(Float(minHeght + minWidth)))
        //3.计算正弦余弦
        let sin = (center2.x-center1.x) / dis;
        let cos = (center1.y-center2.y) / dis;
        //4.半径
        let r1 = oldViewFrame.size.width/2 - dis/10//self.iconView.frame.size.width/2
        let r2 = self.panView.frame.size.width/2
        radiu = r1
        
        //5.计算6个关键点
        let pA = CGPoint(x: center1.x - r1*cos, y: center1.y - r1*sin)
        let pB = CGPoint(x: center1.x + r1*cos, y: center1.y + r1*sin)
        let pC = CGPoint(x: center2.x + r2*cos, y: center2.y + r2*sin)
        let pD = CGPoint(x: center2.x - r2*cos, y: center2.y - r2*sin)
        let pO = CGPoint(x: pA.x + dis/2*sin, y: pA.y - dis/2*cos)
        let pP = CGPoint(x: pB.x + dis/2*sin, y: pB.y - dis/2*cos)

        let path = UIBezierPath.init()
        path.move(to: pA)
        path.addQuadCurve(to: pD, controlPoint: pO)
        path.addLine(to: pC)
        path.addQuadCurve(to: pB, controlPoint: pP)
        path.close()
        
        
        self.shaperLayer.path = path.cgPath
        shaperLayer.fillColor = UIColor.red.cgColor
        self.view.layer.insertSublayer(shaperLayer, below: panView.layer)
        
        iconView.bounds = CGRect.init(x: 0, y: 0, width: radiu*2, height: radiu*2)
        iconView.layer.cornerRadius = radiu
    }
    
    
    //    MARK: - 控件加载
    private lazy var panView: UIView = {
        let view = UIView.init(frame: CGRect(x: 36, y: 60, width: 40, height: 40))
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor.red
        return view
    }()
    
    private lazy var iconView: UIView = {
        let view = UIView.init(frame: CGRect(x: 36, y: 60, width: 40, height: 40))
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor.red
        return view
    }()
    
    private lazy var textView: demoView = {
        let view = demoView()
        return view
    }()
}

