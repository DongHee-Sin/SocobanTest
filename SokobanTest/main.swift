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
func convertString(stringToConvert: String, convertBy: [String: String]) -> String {
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
        }else if baseString[index] == "=====" || baseString[index] == "44444" {
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
    var twoDimensionalArray: [[String.Element]] = [[String.Element]]()

    for index in 0...inputStringArray.count-1 {
        twoDimensionalArray.append(Array(inputStringArray[index]))
    }

    return twoDimensionalArray
}


// 맵 정보를 저장하는 배열, 2차원배열 변수 선언
var stage1Array: [String] = [String]()
var stage2Array: [String] = [String]()
addMapData(stage1: &stage1Array, stage2: &stage2Array, baseString: separateStringBasedNewLine(mapData))

var convertedStage1Array: [String] = [String]()
var convertedStage2Array: [String] = [String]()
addMapData(stage1: &convertedStage1Array, stage2: &convertedStage2Array, baseString: separateStringBasedNewLine(convertString(stringToConvert: mapData, convertBy: dictionaryForReplace)))
var stage1TwoDimentionalArray: [[String.Element]] = convertStringArrayTo2DArray(convertedStage1Array)
var stage2TwoDimentionalArray: [[String.Element]] = convertStringArrayTo2DArray(convertedStage2Array)



/// 문자열 배열을 입력받아서 콘솔에 맵 정보를 출력하는 함수
/// forEach를 사용하면 컨테이너의 요소들을 순차적으로 순환하면서 동작시키고 싶은 작업을 "클로저로" 넘겨줄 수 있음
func printMapData(stageArray: [String]) {
    stageArray.forEach({print($0)})
}


// 옵셔널 바인딩
func intOptionalBinding(optionalValue: Int?)  -> Int{
    guard let noneOptionalValue = optionalValue else {
        fatalError()
    }
    return noneOptionalValue
}


/// 맵 데이터의 가로크기 반환
/// map으로 요소를 순환하면서 해당 요소가 가진 요소의 갯수(count)를 가지는 컨테이너를 생성
/// 생성된 컨테이너의 요소중 가장 큰 값을 반환
func calculateWidth(mapData: [[String.Element]]) -> Int {
    return intOptionalBinding(optionalValue: mapData.map({$0.count}).max())
}

// 맵 데이터의 세로크기 반환
func calculateHeight(mapData: [[String.Element]]) -> Int {
    return mapData.count
}

/// 맵 데이터의 구멍, 공의 수를 찾아서 반환
/// map으로 순환하는 요소에 filter를 사용하여 target의 갯수를 가지는 컨테이너를 생성
/// 생성된 컨테이너의 요소들을 reduce를 통해 합산해서 반환
func findNumber(mapData: [[String.Element]], target: String.Element) -> Int {
    return mapData.map({$0.filter({$0 == target}).count}).reduce(0, +)
}

/// 맵 데이터에서 플레이어의 위치 반환
/// firstIndex(where:)  : 클로저를 파라미터로 전달
/// firstIndex(of:)  : 그냥 값을 파라미터로 전달
func findPlayerLocation(mapData: [[String.Element]]) -> (Int, Int) {
    let yLocation: Int = intOptionalBinding(optionalValue: mapData.firstIndex(where: {$0.contains("3")}))
    let xLocation: Int = intOptionalBinding(optionalValue: mapData[yLocation].firstIndex(of: "3"))
    
    return (xLocation+1, yLocation+1)
}


// 파라미터로 받는 스테이지의 정보를 출력
func printStageInfo(_ mapData: [[String.Element]]) {
    print("")
    print("가로크기: \(calculateWidth(mapData: mapData))")
    print("세로크기: \(calculateHeight(mapData: mapData))")
    print("구멍의 수: \(findNumber(mapData: mapData, target: "1"))")
    print("공의 수: \(findNumber(mapData: mapData, target: "2"))")
    print("플레이어 위치: \(findPlayerLocation(mapData: mapData))")
    print("")
}



// 1단계에서 요구하는 콘솔 출력하는 함수
func printStep1() {
    print("Stage 1\n")
    printMapData(stageArray: stage1Array)
    printStageInfo(stage1TwoDimentionalArray)
    
    print("Stage 2\n")
    printMapData(stageArray: stage2Array)
    printStageInfo(stage2TwoDimentionalArray)
}

printStep1()
