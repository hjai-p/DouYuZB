//
//  PageContentView.swift
//  DouYuZB
//
//  Created by PH on 17/3/6.
//  Copyright © 2017年 HJ. All rights reserved.
//

import UIKit

// MARK: -定义常量
private let collectionViewCellID = "collectionViewCellID"

// MARK: -定义协议
protocol PageContentViewDelegate : class {
    func pageContentView(contentView : PageContentView, progress : CGFloat, sourceIndex : Int, targetIndex : Int)
}

// MARK: -定义类
class PageContentView: UIView {

    // MARK: -属性
    fileprivate var childVCs : [UIViewController]
    fileprivate weak var parentVC : UIViewController?
    fileprivate var startOffsetX : CGFloat = 0
    weak var delegate : PageContentViewDelegate?
    fileprivate var isForbidScrollDelegate : Bool = false   // 是否禁止滚动的代理方法
    
    // MARK: - 懒加载属性 
    fileprivate lazy var collectionView: UICollectionView = {[weak self] in
        // 创建layout
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = (self?.bounds.size)!
        
        // 创建collectionView
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellID)
        
        return collectionView
    }()
    
    // MARK: -自定义构造函数
    init(frame: CGRect, childVCs : [UIViewController], parentVC : UIViewController?) {
        self.childVCs = childVCs
        self.parentVC = parentVC
        
        super.init(frame : frame)
        
        // 设置UI界面
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: -设置UI界面
extension PageContentView {
    fileprivate func setupUI() {
        // 1 将自控制器添加到父控制器中
        for childVC in childVCs {
            parentVC?.addChildViewController(childVC)
        }
        
        // 2 添加UICollectionView，用于在cell中存放控制器的View
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}


// MARK: -遵守UICollectionViewDataSource
extension PageContentView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1 创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellID, for: indexPath)
        
        // 2 给cell设置内容
        for view in cell.contentView.subviews {     // 因为有循环利用，所以添加新的子视图之前要将之前的子视图移除
            view.removeFromSuperview()
        }
        
        let childVC = childVCs[indexPath.item]
        childVC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVC.view)

        return cell
    }
}



// MARK: -遵守UICollectionViewDelegate
extension PageContentView : UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScrollDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 判断是否为点击事件
        if isForbidScrollDelegate { return }
        
        // 定义需要获取的变量值
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        // 判断左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        
        if currentOffsetX > startOffsetX { // 左滑
            // 计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            // 计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            // 计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVCs.count {
                targetIndex = childVCs.count - 1
            }
            
            // 完整地划过一个View的宽度
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
            
        } else { // 右滑
            // 计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))

            // 计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            // 计算targetIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVCs.count {
                sourceIndex = childVCs.count - 1
            }
        }
        
        // 将progress，sourceIndex，targetIndex传给titleView
        delegate?.pageContentView(contentView: self,  progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}


// MARK: -对外暴露的方法 
extension PageContentView {
    func setCurrentIndex(currentIndex : Int) {
        
        // 记录需要禁止执行代理方法 
        isForbidScrollDelegate = true
        
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}
