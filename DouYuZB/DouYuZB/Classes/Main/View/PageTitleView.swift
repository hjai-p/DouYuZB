//
//  PageTitleView.swift
//  DouYuZB
//
//  Created by PH on 17/2/16.
//  Copyright © 2017年 HJ. All rights reserved.
//

import UIKit

// MARK: -定义常量
private let kScrollLineH : CGFloat = 2
private let kNormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kSelectColor : (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

// MARK: -定义协议
protocol PageTitleViewDelegate : class {
    func pageTitleView(titleView : PageTitleView, selectIndex index : Int)
}

// MARK: -定义类
class PageTitleView: UIView {

    // MARK: -定义属性
    var titles : [String]
    var currentIndex : Int = 0
    weak var delegate : PageTitleViewDelegate?  //  代理最好用weak修饰
    
    
    // MARK: -懒加载属性
    lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    
    lazy var scrollLine : UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    
    lazy var titleLabels : [UILabel] = [UILabel]()
    
    // MARK: -自定义构造函数
    init(frame: CGRect, titles : [String]) {
        self.titles = titles
        
        super.init(frame: frame)
        
        // MARK: -设置UI界面
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: -设置UI界面
extension PageTitleView {
    func setupUI() {
        // 1 添加UIScrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        
        // 2 添加title对应的label
        setupTitleLabels()
        
        // 3 设置底线和滚动的滑块
        setupBottomLineAndScrollLine()
    }
    
    private func setupTitleLabels() {
        
        // 确定label的一些frame值(避免重复计算 )
        let labelW : CGFloat = frame.width / CGFloat(titles.count)
        let labelH : CGFloat = frame.height - kScrollLineH
        let labelY : CGFloat = 0

        for (index, title) in titles.enumerated() {
            // 创建label
            let label = UILabel()
            
            // 设置label属性
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            
            // 设置label的frame
            let labelX : CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            // 将label添加到scrollView
            scrollView.addSubview(label)
            titleLabels.append(label)
            
            // 给label添加手势
            label.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tap)
        }
    }
    
    private func setupBottomLineAndScrollLine() {
        // 添加底线
        let bottomLine = UIView()
        let lineH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        // 添加滑块
        guard let firstLabel = titleLabels.first else {return}
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
    }
}


// MARK: -监听label的点击事件
extension PageTitleView {
    @objc fileprivate func titleLabelClick(tapGes : UITapGestureRecognizer) {
        // 获取点击的label
        guard let currentLabel = tapGes.view as? UILabel else { return }
        
        // 获取之前的label
        let oldLabel = titleLabels[currentIndex]
        
        // 切换文字颜色
        oldLabel.textColor = UIColor.darkGray
        currentLabel.textColor = UIColor.orange
        
        // 保存最新的label下标
        currentIndex = currentLabel.tag
        
        // 滚动条位置上改变
        let scrollLineX = CGFloat(currentIndex) * scrollLine.frame.width
        UIView.animate(withDuration: 0.2, animations: {
            self.scrollLine.frame.origin.x = scrollLineX
        })
        
        // 通知代理
        delegate?.pageTitleView(titleView: self, selectIndex: currentIndex)
    }
}



// MARK: -对外暴露的方法
extension PageTitleView {
    func setTitleViewWith(progress : CGFloat, sourceIndex : Int, targetIndex : Int) {
        // 1 取出sourceLabel和targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 2 处理滑块的逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        // 3 处理滑动过程中的颜色渐变
        // 3.1 取出颜色的变化范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        
        // label的颜色渐变
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        
        // 4 记录最新的currentIndex
        currentIndex = targetIndex
    }
}
