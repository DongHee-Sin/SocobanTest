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

// 문자열 변환을 위한 Dictionary
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


// 입력된 문자열을 새로운 줄(\n)을 기준으로 분리하여 배열로 반환
func separateStringBasedNewLine(_ inputString: String) -> [String] {
    return inputString.components(separatedBy: "\n")
}


/// 두 개의 stage 정보를 가진 문자열 배열을 조건문을 사용하여 각각의 stage 맵 정보로 저장
func addMapData(stage1: inout [String], stage2: inout [String], baseString: [String]) {
    var isOverStage1: Bool = false
    for index in 0..<baseString.count {
        if baseString[index] == "Stage 1" {
            continue
        }else if baseString[index] == "Stage 2" {
            isOverStage1 = true
        }else if baseString[index] == "=====" {
            continue
        }else if isOverStage1 == false {
            stage1.append(baseString[index])
        }else {
            stage2.append(baseString[index])
        }
    }
}


/// 문자열 배열을 각 문자별로 잘라서 2차원 배열로 반환
func convertStringArrayTo2DArray(_ inputStringArray: [String]) -> [[String.Element]] {
    var twoDimensionalArray: [[String.Element]] = [[]]

    for index in 0...inputStringArray.count-1 {
        twoDimensionalArray.append(Array(inputStringArray[index]))
    }

    return twoDimensionalArray
}


// 맵 정보를 저장하는 배열, 2차원배열 변수 선언
var stage1Array: [String] = [String]()
var stage2Array: [String] = [String]()
addMapData(stage1: &stage1Array, stage2: &stage2Array, baseString: separateStringBasedNewLine(mapData))

var stage1TwoDimentionalArray: [[String.Element]] = convertStringArrayTo2DArray(stage1Array)
var stage2TwoDimentionalArray: [[String.Element]] = convertStringArrayTo2DArray(stage2Array)



// 문자열 배열을 입력받아서 콘솔에 맵 정보를 출력하는 함수
func printMapData(stageArray: [String]) {
    stageArray.forEach({print($0)})
}
