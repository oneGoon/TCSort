//
//  Bubble.swift
//  TCSort
//
//  Created by WangGang on 2019/12/2.
//  Copyright © 2019 onegoon. All rights reserved.
//

import Foundation

typealias TCIndex = CFIndex

/**
 * 稳定排序
 * 记忆 记住一次冒泡
 * 外层迭代
 */

public func bubbleSort<Element: Comparable>(array: inout Array<Element>, num: Int) {
    var haveSwap = false
    for p in (0...num-1).reversed() { /* 利用迭代器实现逆序，没有新开辟空间 reversed Complexity: O(1) */
        haveSwap = false
        for i in 0 ..< p { /* 一次冒泡 */
            if array[i] > array[i+1] {
                array.swapAt(i, i+1)
                haveSwap = true
            }
        }
        if !haveSwap { break }
    }
}

//public mutating func swapAt(_ i: Index, _ j: Index) {
//  guard i != j else { return }
//  let tmp = self[i]
//  self[i] = self[j]
//  self[j] = tmp
//}
