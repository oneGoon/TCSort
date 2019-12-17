//
//  Merge.swift
//  TCSort
//
//  Created by WangGang on 2019/12/8.
//  Copyright © 2019 onegoon. All rights reserved.
//

import Foundation

 //MARK: - 有序子序列的归并

/// 将有序的a
/// - Parameters:
///   - a: 子序列
///   - b: 子序列
///   - l: 左边的起始位置
///   - r: 右边的起始位置
///   - rEnd: 右边终点位置
func merge<Element: Comparable>(_ array: inout Array<Element>, _ tmpA: inout Array<Element>, _ l:  TCIndex, _ r:  TCIndex, _ rEnd: TCIndex) {
    let lEnd = r-1  /*左边终点位置*/
    var tmpIdx = l
    var lIdx = l
    var rIdx = r
    
    while lIdx <= lEnd && rIdx <= rEnd {
        if array[lIdx] <= array[rIdx] {
            tmpA[tmpIdx] = array[lIdx]
            tmpIdx+=1
            lIdx+=1
        } else {
            tmpA[tmpIdx] = array[rIdx]
            tmpIdx+=1
            rIdx+=1
        }
    }
    
    while lIdx <= lEnd {
        tmpA[tmpIdx] = array[lIdx]
        tmpIdx+=1
        lIdx+=1
    }
    
    while rIdx <= rEnd {
        tmpA[tmpIdx] = array[rIdx]
        tmpIdx+=1
        rIdx+=1
    }
    
    for i in l...rEnd {
        array[i]  = tmpA[i]
    }
}


func mSort<Element: Comparable>(_ array: inout Array<Element>, _ tmpA: inout Array<Element>, _ l:  TCIndex, _ rEnd: TCIndex) {
    var center: TCIndex
    if l < rEnd {
        center = (rEnd-l)/2 + l
        mSort(&array, &tmpA, l, center)
        mSort(&array, &tmpA, center+1, rEnd)
        merge(&array, &tmpA, l, center+1, rEnd)
    }
}

public
func mergeSortRecursion<Element: Comparable>(array: inout Array<Element>, n: Int) {
    var tmpA: [Element] = Array<Element>.init(unsafeUninitializedCapacity: n, initializingWith: { _, initializedCount in initializedCount = n })
    
    mSort(&array, &tmpA, 0, n-1)
}

/// 归并排序 循环实现（非递归算法）
public
func mergeSortNotRecursion<Element: Comparable>(array: inout Array<Element>, n: Int) {
    var tmpA: [Element] = Array<Element>.init(unsafeUninitializedCapacity: n, initializingWith: { _, initializedCount in initializedCount = n })
    var length: Int = 1
    while length < n {
        mergePass(&array, &tmpA, n, length)  ///    array --> tmpA
        length *= 2
        mergePass(&tmpA, &array, n, length)  ///   tmpA -->array
        length *= 2
    }
}
/// 注意是从 array归并到tmpA
func mergePass<Element: Comparable>(_ array: inout Array<Element>, _ tmpA: inout Array<Element>, _ n: Int, _ length: Int) {
    var i = 0
    while i < n - 2*length {
        mergeNotWriteBackArray(&array, &tmpA, i, i+length, i+2*length-1)
        i += 2*length
    }
    if i + length < n { mergeNotWriteBackArray(&array, &tmpA, i, i+length, n-1)  /* 归并最后两个子序列 */}
    else {  for j in i..<n { tmpA[j] = array[j] }   /*归并最后一个子序列*/}
}

func mergeNotWriteBackArray<Element: Comparable>(_ array: inout Array<Element>, _ tmpA: inout Array<Element>, _ l:  TCIndex, _ r:  TCIndex, _ rEnd: TCIndex) {
    let lEnd = r-1  /*左边终点位置*/
    var tmpIdx = l
    var lIdx = l
    var rIdx = r
    
    while lIdx <= lEnd && rIdx <= rEnd {
        if array[lIdx] <= array[rIdx] {
            tmpA[tmpIdx] = array[lIdx]
            tmpIdx+=1
            lIdx+=1
        } else {
            tmpA[tmpIdx] = array[rIdx]
            tmpIdx+=1
            rIdx+=1
        }
    }
    
    while lIdx <= lEnd {
        tmpA[tmpIdx] = array[lIdx]
        tmpIdx+=1
        lIdx+=1
    }
    
    while rIdx <= rEnd {
        tmpA[tmpIdx] = array[rIdx]
        tmpIdx+=1
        rIdx+=1
    }
    
    /* 不写回,归并到tmpA */
}


/// 外部排序
