//
//  Selection.swift
//  TCSort
//
//  Created by WangGang on 2019/12/7.
//  Copyright © 2019 onegoon. All rights reserved.
//

import Foundation

/*
 * 最坏情况要交互N-1次
 * T = θ(N^2)
 * 不稳定排序
 */
public
func selectionSort<Element: Comparable>(array: inout Array<Element>, n: Int) {
    for i in 0..<n-1 {
        let minPosition = scanForMin(array, i, n-1)  /* 从A[i]到A[num-1]中找到最小元，并将其位置付给minPosition */
        array.swapAt(i, minPosition)   /* 将未排序部分的最小元换到有序部分的最后位置 */
    }
}

func scanForMin<Element: Comparable>(_ array: Array<Element>, _ lef: TCIndex, _ rit: TCIndex) -> Int {
    var minPosition = rit
    for i in lef..<rit { if array[i] < array[minPosition] { minPosition = i } }
    return minPosition
}
 

/**
 * T(n) = O(n log n)
 *
 *  需要额外的n空间 tmpA
 *
 */


/**
 * 注意到下标是从0开始的
 * i: 0~
 * lef = 2i + 1, rgh = 2i + 2
 */
public
func heapSort<Element: Comparable>(array: inout Array<Element>, n: Int) {
    for i in (0...(n/2-1)).reversed() {
        percDown(&array, i, n)
    }
    for i in (0...n-1).reversed() {
        array.swapAt(0, i)   /* 从最后开始放大的 */
        percDown(&array, 0, i)
    }
    
}

/* 将n个元素的数组中以array[p]为根节点的子堆调整为最大堆 */
func percDown<Element: Comparable>(_ array: inout Array<Element>, _ p: TCIndex, _ n: Int) {
    let x = array[p]   /*取出根节点的值*/
    var parent = p
    var child: TCIndex
    while parent*2+1 < n  {
        child = parent*2+1
        if child != n-1 && array[child]<array[child+1] { child += 1 } /* child指向左右子节点的较大值 */
        if x >= array[child] { break } /*找到了合适的位置*/
        else { array[parent] = array[child] } /*下滤x*/
        parent = child
    }
    array[parent] = x /*把x赋回到parent指向的合适的位置*/
}


/*
 * 小顶堆 最小堆
 * 大顶堆 最大堆
 */


//MARK: - Heap
struct HNode {
    
}
