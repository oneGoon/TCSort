//
//  Quick.swift
//  TCSort
//
//  Created by WangGang on 2019/12/9.
//  Copyright © 2019 onegoon. All rights reserved.
//

import Foundation


/// 选取主元 pivot  选取左中右三个数其中的中位数 比如 3，9，6 则 pivot = 6
func median3<Element: Comparable>(_ array: inout Array<Element>, _ left: TCIndex, _ right: TCIndex) -> Element{
    let center = (left + right) / 2
    if array[left]   > array[center]  { array.swapAt(left, center) }
    if array[left]   > array[right]   { array.swapAt(left, right) }
    if array[center] > array[right]   { array.swapAt(center, right) }
    // 此时 array[left] <= array[center] <= array[right]
    array.swapAt(center, right-1)
    // 只需要考虑left+1 ... right-2
    return array[right-1]
}

/// 子集划分

public
func quickSort<Element: Comparable>(array: inout Array<Element>, n: Int) {
    
    func qSort(array: inout Array<Element>, left: TCIndex, right: TCIndex) {
        let cutoff: Int = 100 /// 阈值
        if right - left >= cutoff {
        var pivot: Element
        pivot = median3(&array, left, right)
        var low = left
        var high = right - 1
        while true {
            repeat { low += 1 } while array[low] < pivot  // low从left+1开始 跳出while后的low指向破坏loop的值
            repeat { high -= 1 } while array[high] > pivot // high从right-2开始
            if low < high { array.swapAt(low, high) }
            else { break }
        }
        array.swapAt(low, right-1) /// 将pivot换到正确的位置
        qSort(array: &array, left: left, right: low-1)  /// 递归解决左边
        qSort(array: &array, left: low+1, right: right) /// 递归解决右边
        } else {
            insertSort(array: &array, n: n)
        }
    }

    qSort(array: &array, left: 0, right: n-1)
    
}
