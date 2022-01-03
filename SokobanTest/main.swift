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

/// 변환된 문자열로 구성된 1차원 배열을
/// 변환되지 않은 문자열로 구성된 1차원 배열로 만들기 위한 함수
/// (콘솔 출력을 위해)
/// 매개변수로 convert2DArrayTo1DArray함수의 결과를 사용
func convertStringArray(stringArrayToConvert: [String], convertBy: [String: String]) -> [String] {
    return stringArrayToConvert.map({convertBy.reduce($0, {$0.replacingOccurrences(of: $1.value, with: $1.key)})})
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
    print("")
    stageArray.forEach({print($0)})
    print("")
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


// 파라미터로 받은 스테이지의 정보를 출력
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



//func movePlayer(_ input: String.Element) {
//    switch input {
//    case "w":
//        print("위")
//    case "a":
//        print("왼쪽")
//    case "s":
//        print("아래")
//    case "d":
//        print("오른쪽")
//    default:
//        print("(경고!) 해당 명령을 수행할 수 없습니다.")
//    }
//}



// 2차원 배열을 출력을 위한 1차원 배열로 바꾸는 함수
func convert2DArrayTo1DArray(_ twoDimentionArray: [[String.Element]]) -> [String] {
    return twoDimentionArray.map({String($0)})
}


// 플레이어 위치를 사용하여 지도에 원하는 값 입력
func enterValueOnMap(playerLocation: (Int, Int), valueToEnter: String.Element, mapData: inout[[String.Element]]) {
    mapData[playerLocation.1-1][playerLocation.0-1] = valueToEnter
}
    

// 플레이어가 원하는 위치로 이동할 수 없는 경우 출력할 에러 메시지와 지도 정보 출력
func printErrorMessageAndMapData(playerInput: String.Element, mapData: [[String.Element]]) {
    printMapData(stageArray: convertStringArray(stringArrayToConvert: convert2DArrayTo1DArray(mapData), convertBy: dictionaryForReplace))
    print("\(playerInput): (경고!) 해당 명령을 수행할 수 없습니다.")
}


// 사용자의 입력값을 사용하여 맵 데이터를 변경하고 출력하는 함수
func changeMapDataBasedPlayerInput(playerInput: String.Element, playerLocation: inout(Int, Int), mapData: inout[[String.Element]]) {
    switch playerInput {
    case "w":
        // 플레이어가 이동하려는 곳이 아무것도 없는지 확인하여 처리하는 조건식
        if mapData[playerLocation.1-2][playerLocation.0-1] != " " {
            printErrorMessageAndMapData(playerInput: playerInput, mapData: mapData)
        }else {
            // 2차원 배열의 맵 정보에서 플레이어의 현재 위치값을 공란으로 변경
            enterValueOnMap(playerLocation: playerLocation, valueToEnter: " ", mapData: &mapData)
            
            // 함수 내부의 플레이어 좌표값을 변경
            playerLocation.1 -= 1
            
            // 변경된 플레이어 좌표값을 바탕으로 2차원 배열에 P(플레이어) 넣기
            enterValueOnMap(playerLocation: playerLocation, valueToEnter: "3", mapData: &mapData)
            
            // 변경된 2차원 배열 출력
            printMapData(stageArray: convertStringArray(stringArrayToConvert: convert2DArrayTo1DArray(mapData), convertBy: dictionaryForReplace))
            print("\(playerInput): 위로 이동합니다.")
        }
    case "a":
        if mapData[playerLocation.1-1][playerLocation.0-2] != " " {
            printErrorMessageAndMapData(playerInput: playerInput, mapData: mapData)
        }else {
            enterValueOnMap(playerLocation: playerLocation, valueToEnter: " ", mapData: &mapData)
            
            playerLocation.0 -= 1
            
            enterValueOnMap(playerLocation: playerLocation, valueToEnter: "3", mapData: &mapData)

            printMapData(stageArray: convertStringArray(stringArrayToConvert: convert2DArrayTo1DArray(mapData), convertBy: dictionaryForReplace))
            print("\(playerInput): 왼쪽으로 이동합니다.")
        }
    case "s":
        if mapData[playerLocation.1][playerLocation.0-1] != " " {
            printErrorMessageAndMapData(playerInput: playerInput, mapData: mapData)
        }else {
            enterValueOnMap(playerLocation: playerLocation, valueToEnter: " ", mapData: &mapData)
            
            playerLocation.1 += 1
            
            enterValueOnMap(playerLocation: playerLocation, valueToEnter: "3", mapData: &mapData)
            
            printMapData(stageArray: convertStringArray(stringArrayToConvert: convert2DArrayTo1DArray(mapData), convertBy: dictionaryForReplace))
            print("\(playerInput): 아래로 이동합니다.")
        }
    case "d":
        if mapData[playerLocation.1-1][playerLocation.0] != " " {
            printErrorMessageAndMapData(playerInput: playerInput, mapData: mapData)
        }else {
            enterValueOnMap(playerLocation: playerLocation, valueToEnter: " ", mapData: &mapData)
            
            playerLocation.0 += 1
            
            enterValueOnMap(playerLocation: playerLocation, valueToEnter: "3", mapData: &mapData)

            printMapData(stageArray: convertStringArray(stringArrayToConvert: convert2DArrayTo1DArray(mapData), convertBy: dictionaryForReplace))
            print("\(playerInput): 오른쪽으로 이동합니다.")
        }
    default:
        printErrorMessageAndMapData(playerInput: playerInput, mapData: mapData)
    }
}

// 플레이어 이동 구현
func stage2GameStart() {
    print("Stage 2")
    
    // 맵 정보 출력
    printMapData(stageArray: stage2Array)
    
    var gameMapData: [[String.Element]] = stage2TwoDimentionalArray

    var playerInput: String = ""
    var playerLocation: (Int, Int) = findPlayerLocation(mapData: stage2TwoDimentionalArray)

    // 사용자가 q를 입력할 때까지 반복 수행
    while true {
        print("\nSOKOBAN> ", terminator: "")
        playerInput = readLine() ?? ""
        if playerInput == "q" {
            print("Bye~")
            break
        }else {
            playerInput.map({
                changeMapDataBasedPlayerInput(playerInput: $0, playerLocation: &playerLocation, mapData: &gameMapData)
            })
        }
    }
}

stage2GameStart()

