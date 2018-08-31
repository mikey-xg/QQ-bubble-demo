
//
//  demoView.swift
//  QQ气泡Demo
//
//  Created by best su on 2018/8/16.
//  Copyright © 2018年 best su. All rights reserved.
//

import UIKit

class demoView: UIView {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let hitView = super.hitTest(point, with: event)
        
        let viewPoint = self.celarView.convert(point, from: self)
        
        let viewPoints = self.deleteBtn.convert(point, from: self)

        
        if self.deleteBtn.point(inside: viewPoints, with: event){
            print("deleteBtn点击")
            return self.deleteBtn
        }
        
        if self.celarView.point(inside: viewPoint, with: event){
            print("celarView点击")
            return self.celarView
        }
        return hitView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI(){
        addSubview(deleteBtn)
        addSubview(celarView)
        
        deleteBtn.frame = CGRect(x: 100, y: 100, width: 60, height: 60)
        celarView.frame = CGRect(x: 0, y: 100, width: 375, height: 200)
        
        
       
    }
    
    
    @objc private func deleteBtnClick(){
        print("点击了按钮")
    }
    
    
    private lazy var celarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        view.alpha = 0.4
        return view
    }()
    
    
    private lazy var deleteBtn: UIButton = {
        let button = UIButton()
        button.adjustsImageWhenHighlighted = false
        button.backgroundColor = UIColor.orange
        button.addTarget(self, action: #selector(deleteBtnClick), for: .touchUpInside)
        return button
    }()
    
}
