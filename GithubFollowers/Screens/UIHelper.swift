//
//  UIHelper.swift
//  GithubFollowers
//
//  Created by Ankit Singh on 20/12/21.
//

import UIKit

struct UIHelper{
    static func createThreeColumnFlowLayout(in view : UIView) -> UICollectionViewFlowLayout {
        
        let totalWidth : CGFloat = view.bounds.width
        let padding : CGFloat = 12
        let minimumItemSpacing : CGFloat = 10
        let availableWidth = totalWidth - (2*padding) - (2*minimumItemSpacing)
        let textLabelSpace : CGFloat = 40
        let itemCellWidth = availableWidth/3
        
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemCellWidth, height: itemCellWidth + textLabelSpace)
        return flowLayout
    }
}
