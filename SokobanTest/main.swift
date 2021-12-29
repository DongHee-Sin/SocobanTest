//
//  main.swift
//  SokobanTest
//
//  Created by 신동희 on 2021/12/29.
//

import Foundation

// 주어진 문자열 (맵 데이터)
let mapData: String =
"""
Stage 1
#####
#OoP#
#####
=====
Stage 2
  #######
###  O  ###
#    o    #
# Oo P oO #
###  o  ###
 #   O  #
 ########
"""

let dictionaryForReplace: [String: String] = ["#": "0", "O": "1", "o": "2", "P": "3", "=": "4",]

/// 입력된 문자열을 dictionary를 바탕으로 변환하여 리턴
/// reduce에 후행클로저를 사용
/// $0 = stringToConvert (String)
/// $1 = convertBy (Dictionary)
/// 초기값을 stringToConvert로 사용하고, 클로저로 어떤 변화를 줄지 작성함
func replaceString(stringToConvert: String, convertBy: [String: String]) -> String {
    return convertBy.reduce(stringToConvert) {
        $0.replacingOccurrences(of: $1.key, with: $1.value)
    }
}

/// 입력된 문자열을 새로운 줄(\n)을 기준으로 분리하여 배열로 반환
func separateStringBasedNewLine(_ inputString: String) -> [String] {
    return inputString.components(separatedBy: "\n")
}



///// 문자열 배열을 각 문자별로 잘라서 2차원 배열로 반환
//func convertStringArrayTo2DArray(_ inputStringArray: [String]) -> [[String.Element]] {
//    var twoDimensionalArray: [[String.Element]] = [[]]
//
//    for index in 0...inputStringArray.count-1 {
//        twoDimensionalArray.append(Array(inputStringArray[index]))
//    }
//
//    return twoDimensionalArray
//}


