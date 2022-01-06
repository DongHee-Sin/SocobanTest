import Foundation


/// 바탕화면에 저장된 프로젝트 폴더의 txt파일을 문자열로 받아오는 함수
/// 프로젝트 폴더가 어디에 있든 받아올 수 있도록 하는 방법을 찾아봤는데.. 잘 모르겠다..
func readFile() -> String {
    let fileManager: FileManager = FileManager.default
    
    var textForReturn: String = ""
    
    if let documentPath: URL = fileManager.urls(for: .desktopDirectory, in: .userDomainMask).first {
        let textPath: URL = documentPath.appendingPathComponent("SokobanTest/map.txt")

        do {
            let dataFromPath: Data = try Data(contentsOf: textPath)
            textForReturn = String(data: dataFromPath, encoding: .utf8) ?? "문서없음"
        } catch {
            print(error)
        }
    }
    
    return textForReturn
}

/// 문자열 변환을 위한 Dictionary
let dictionaryForReplace: [String: String] = ["#": "0", "O": "1", "o": "2", "P": "3", "=": "4", "0": "5"]


/// 입력된 문자열을 dictionary를 바탕으로 변환하여 리턴
/// reduce에 후행클로저를 사용
/// $0 = stringToConvert (String)
/// $1 = convertBy (Dictionary)
/// 초기값을 stringToConvert로 사용하고, 클로저로 어떤 변화를 줄지 작성함
func convertStringToNumber(stringToConvert: String, convertBy: [String: String]) -> String {
    return convertBy.reduce(stringToConvert) {
        $0.replacingOccurrences(of: $1.key, with: $1.value)
    }
}

func convertNumberToString(stringToConvert: String, convertBy: [String: String]) -> String {
    return convertBy.reduce(stringToConvert) {
        $0.replacingOccurrences(of: $1.value, with: $1.key)
    }
}




/// 변환된 문자열로 구성된 1차원 배열을
/// 변환되지 않은 문자열로 구성된 1차원 배열로 만들기 위한 함수
/// (콘솔 출력을 위해)
/// 매개변수로 convert2DArrayTo1DArray함수의 결과를 사용
func convertStringArray(stringArrayToConvert: [String], convertBy: [String: String]) -> [String] {
    return stringArrayToConvert.map({convertNumberToString(stringToConvert: $0, convertBy: convertBy)})
}


/// 입력된 문자열을 새로운 줄(\n)을 기준으로 분리하여 배열로 반환
func separateStringBasedNewLine(_ inputString: String) -> [String] {
    return inputString.components(separatedBy: "\n")
}


/// 줄 단위로 분리된 문자열 배열을 매개변수로 받아서
/// 각 Stage별로 구분되어 저장된 2차원 배열로 반환
func convertMapDataToEachStage(baseString: [String]) -> [[String]] {
    var eachStageArray: [[String]] = [
        [String](),
        [String](),
        [String](),
        [String](),
        [String]()
    ]
    var stageCount: Int = -1
    
    for eachLine in baseString {
        if eachLine.contains("Stage") {
            stageCount += 1
        }else {
            eachStageArray[stageCount].append(eachLine)
        }
    }
    
    return eachStageArray
}


/// 문자열 배열을 각 문자별로 잘라서 2차원 배열로 반환
func convertStringArrayTo2DArray(_ inputStringArray: [String]) -> [[String.Element]] {
    var twoDimensionalArray: [[String.Element]] = [[String.Element]]()

    for index in 0...inputStringArray.count-1 {
        twoDimensionalArray.append(Array(inputStringArray[index]))
    }

    return twoDimensionalArray
}



/// 문자열 배열을 입력받아서 콘솔에 맵 정보를 출력하는 함수
/// forEach를 사용하면 컨테이너의 요소들을 순차적으로 순환하면서 동작시키고 싶은 작업을 "클로저로" 넘겨줄 수 있음
func printMapData(stage2DArray: [[String.Element]]) {
    print("")
    convert2DArrayTo1DArrayForPrint(stage2DArray).forEach({print($0)})
    print("")
}


/// 옵셔널 바인딩
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


/// 파라미터로 받은 스테이지의 정보를 출력
func printStageInfo(_ mapData: [[String.Element]]) {
    print("")
    print("가로크기: \(calculateWidth(mapData: mapData))")
    print("세로크기: \(calculateHeight(mapData: mapData))")
    print("구멍의 수: \(findNumber(mapData: mapData, target: "1"))")
    print("공의 수: \(findNumber(mapData: mapData, target: "2"))")
    print("플레이어 위치: \(findPlayerLocation(mapData: mapData))")
    print("")
}


/// 2차원 배열을 출력을 위한 1차원 배열로 바꾸는 함수
func convert2DArrayTo1DArray(_ twoDimentionArray: [[String.Element]]) -> [String] {
    return twoDimentionArray.map({String($0)})
}


/// 변환된(숫자로 구성된) 2차원 배열을 콘솔 출력을 위한 1차원 배열로 바꾸는 함수
func convert2DArrayTo1DArrayForPrint(_ mapData: [[String.Element]]) -> [String] {
    let arrayOfNumber: [String] = convert2DArrayTo1DArray(mapData)
    let arrayOfString: [String] = convertStringArray(stringArrayToConvert: arrayOfNumber, convertBy: dictionaryForReplace)
    return arrayOfString
}


/// 플레이어 위치를 사용하여 지도에 원하는 값 입력
func enterValueOnMap(playerLocation: (Int, Int), valueToEnter: String.Element, mapData: inout[[String.Element]]) {
    mapData[playerLocation.1-1][playerLocation.0-1] = valueToEnter
}
    

/// 플레이어가 원하는 위치로 이동할 수 없는 경우 출력할 에러 메시지와 지도 정보 출력
func printErrorMessageAndMapData(playerInput: String.Element, mapData: [[String.Element]]) {
    printMapData(stage2DArray: mapData)
    print("\(playerInput): (경고!) 해당 명령을 수행할 수 없습니다.")
}



func playerMove(playerInput: String.Element, playerLocation: inout(Int, Int), mapData: inout[[String.Element]]) {
    
    switch playerInput {
    case "w", "a":
        enterValueOnMap(playerLocation: playerLocation, valueToEnter: " ", mapData: &mapData)
        if playerInput == "w" {
            playerLocation.1 -= 1
        }else {
            playerLocation.0 -= 1
        }
    case "s", "d":
        enterValueOnMap(playerLocation: playerLocation, valueToEnter: " ", mapData: &mapData)
        if playerInput == "s" {
            playerLocation.1 += 1
        }else {
            playerLocation.0 += 1
        }
    default:
        return
    }
    
    enterValueOnMap(playerLocation: playerLocation, valueToEnter: "3", mapData: &mapData)
    printMapData(stage2DArray: mapData)
    
    switch playerInput {
    case "w":
        print("w: 위로 이동합니다.")
    case "a":
        print("a: 왼쪽으로 이동합니다.")
    case "s":
        print("s: 아래로 이동합니다.")
    case "d":
        print("d: 오른쪽으로 이동합니다.")
    default:
        return
    }
}


/// 입력받은 키워드를 사용하여 플레ㅔ이어 위치를 이동
func changeMapDataBasedPlayerInput(playerInput: String.Element, playerLocation: inout(Int, Int), mapData: inout[[String.Element]]) {
    switch playerInput {
    case "w":
        // 이동하려는 공간이 0(벽) 또는 1(구멍)일 경우 실행불가 메시지 출력
        if mapData[playerLocation.1-2][playerLocation.0-1] == "0" || mapData[playerLocation.1-2][playerLocation.0-1] == "1" {
            printErrorMessageAndMapData(playerInput: playerInput, mapData: mapData)
        // 이동하려는 공간이 " "(공란) 또는 2(공)일 경우 else - switch문 실행
        }else {
            switch mapData[playerLocation.1-2][playerLocation.0-1] {
            // 이동하려는 공간이 공란인 경우
            case " ":
                playerMove(playerInput: playerInput, playerLocation: &playerLocation, mapData: &mapData)
            // 이동하려는 공간에 2(공)이 있는 경우
            case "2":
                switch mapData[playerLocation.1-3][playerLocation.0-1] {
                // 공이 이동될 공간이 공란인 경우
                case " ":
                    enterValueOnMap(playerLocation: (playerLocation.0, playerLocation.1-2), valueToEnter: "2", mapData: &mapData)
                    playerMove(playerInput: playerInput, playerLocation: &playerLocation, mapData: &mapData)
                // 공이 이동될 공간에 1(구멍)이 있는 경우
                case "1":
                    enterValueOnMap(playerLocation: (playerLocation.0, playerLocation.1-2), valueToEnter: "5", mapData: &mapData)
                    playerMove(playerInput: playerInput, playerLocation: &playerLocation, mapData: &mapData)
                // 공을 옮기려는 공간에 다른공 or 벽이 있을 때
                default:
                    printErrorMessageAndMapData(playerInput: playerInput, mapData: mapData)
                }
            default:
                printErrorMessageAndMapData(playerInput: playerInput, mapData: mapData)
            }
        }
    case "a":
        // 이동하려는 공간이 0(벽) 또는 1(구멍)일 경우 실행불가 메시지 출력
        if mapData[playerLocation.1-1][playerLocation.0-2] == "0" || mapData[playerLocation.1-1][playerLocation.0-2] == "1" {
            printErrorMessageAndMapData(playerInput: playerInput, mapData: mapData)
        // 이동하려는 공간이 " "(공란) 또는 2(공)일 경우 else - switch문 실행
        }else {
            switch mapData[playerLocation.1-1][playerLocation.0-2] {
            // 이동하려는 공간이 공란인 경우
            case " ":
                playerMove(playerInput: playerInput, playerLocation: &playerLocation, mapData: &mapData)
            // 이동하려는 공간에 2(공)이 있는 경우
            case "2":
                switch mapData[playerLocation.1-1][playerLocation.0-3] {
                // 공이 이동될 공간이 공란인 경우
                case " ":
                    enterValueOnMap(playerLocation: (playerLocation.0-2, playerLocation.1), valueToEnter: "2", mapData: &mapData)
                    playerMove(playerInput: playerInput, playerLocation: &playerLocation, mapData: &mapData)
                // 공이 이동될 공간에 1(구멍)이 있는 경우
                case "1":
                    enterValueOnMap(playerLocation: (playerLocation.0-2, playerLocation.1), valueToEnter: "5", mapData: &mapData)
                    playerMove(playerInput: playerInput, playerLocation: &playerLocation, mapData: &mapData)
                // 공을 옮기려는 공간에 다른공 or 벽이 있을 때
                default:
                    printErrorMessageAndMapData(playerInput: playerInput, mapData: mapData)
                }
            default:
                printErrorMessageAndMapData(playerInput: playerInput, mapData: mapData)
            }
        }
    case "s":
        // 이동하려는 공간이 0(벽) 또는 1(구멍)일 경우 실행불가 메시지 출력
        if mapData[playerLocation.1][playerLocation.0-1] == "0" || mapData[playerLocation.1][playerLocation.0-1] == "1" {
            printErrorMessageAndMapData(playerInput: playerInput, mapData: mapData)
        // 이동하려는 공간이 " "(공란) 또는 2(공)일 경우 else - switch문 실행
        }else {
            switch mapData[playerLocation.1][playerLocation.0-1] {
            // 이동하려는 공간이 공란인 경우
            case " ":
                playerMove(playerInput: playerInput, playerLocation: &playerLocation, mapData: &mapData)
            // 이동하려는 공간에 2(공)이 있는 경우
            case "2":
                switch mapData[playerLocation.1+1][playerLocation.0-1] {
                // 공이 이동될 공간이 공란인 경우
                case " ":
                    enterValueOnMap(playerLocation: (playerLocation.0, playerLocation.1+3), valueToEnter: "2", mapData: &mapData)
                    playerMove(playerInput: playerInput, playerLocation: &playerLocation, mapData: &mapData)
                // 공이 이동될 공간에 1(구멍)이 있는 경우
                case "1":
                    enterValueOnMap(playerLocation: (playerLocation.0, playerLocation.1+3), valueToEnter: "5", mapData: &mapData)
                    playerMove(playerInput: playerInput, playerLocation: &playerLocation, mapData: &mapData)
                // 공을 옮기려는 공간에 다른공 or 벽이 있을 때
                default:
                    printErrorMessageAndMapData(playerInput: playerInput, mapData: mapData)
                }
            default:
                printErrorMessageAndMapData(playerInput: playerInput, mapData: mapData)
            }
        }
    case "d":
        // 이동하려는 공간이 0(벽) 또는 1(구멍)일 경우 실행불가 메시지 출력
        if mapData[playerLocation.1-1][playerLocation.0] == "0" || mapData[playerLocation.1-1][playerLocation.0] == "1" {
            printErrorMessageAndMapData(playerInput: playerInput, mapData: mapData)
        // 이동하려는 공간이 " "(공란) 또는 2(공)일 경우 else - switch문 실행
        }else {
            switch mapData[playerLocation.1-1][playerLocation.0] {
            // 이동하려는 공간이 공란인 경우
            case " ":
                playerMove(playerInput: playerInput, playerLocation: &playerLocation, mapData: &mapData)
            // 이동하려는 공간에 2(공)이 있는 경우
            case "2":
                switch mapData[playerLocation.1-1][playerLocation.0+1] {
                // 공이 이동될 공간이 공란인 경우
                case " ":
                    enterValueOnMap(playerLocation: (playerLocation.0+3, playerLocation.1), valueToEnter: "2", mapData: &mapData)
                    playerMove(playerInput: playerInput, playerLocation: &playerLocation, mapData: &mapData)
                // 공이 이동될 공간에 1(구멍)이 있는 경우
                case "1":
                    enterValueOnMap(playerLocation: (playerLocation.0+3, playerLocation.1), valueToEnter: "5", mapData: &mapData)
                    playerMove(playerInput: playerInput, playerLocation: &playerLocation, mapData: &mapData)
                // 공을 옮기려는 공간에 다른공 or 벽이 있을 때
                default:
                    printErrorMessageAndMapData(playerInput: playerInput, mapData: mapData)
                }
            default:
                printErrorMessageAndMapData(playerInput: playerInput, mapData: mapData)
            }
        }
    default:
        printErrorMessageAndMapData(playerInput: playerInput, mapData: mapData)
    }
}






func gameStart() {
    // 주어진 문자열 (맵 데이터)
    let mapData: String = readFile()
    // 변환 전 문자열이 사용된 맵 데이터 배열
    let beforeConvertMapDataArray: [[String]] = convertMapDataToEachStage(baseString: separateStringBasedNewLine(mapData))
    // 변환 후 문자열이 사용된 맵 데이터 배열
    let afterConvertMapDataArray: [[String]] = convertMapDataToEachStage(baseString: separateStringBasedNewLine(convertStringToNumber(stringToConvert: mapData, convertBy: dictionaryForReplace)))
    
    
    // 5개의 Stage(2차원 배열) 정보를 담은 3차원 배열
    let stageMapDataArray: [[[String.Element]]] = afterConvertMapDataArray.map({convertStringArrayTo2DArray($0)})
    
    
    // Stage Count
    var stageCount: Int = 0
    
    // stage를 하나씩 받아서 처리하는 for문
    // eachStage = [[String.Element]]
    gameLoop: for eachStage in stageMapDataArray {
        var playerInput: String = ""
        var eachStage: [[String.Element]] = eachStage
        var playerLocation: (Int, Int) = findPlayerLocation(mapData: eachStage)
        var turnCount: Int = 0
        
        // stage 맵 정보 출력
        print("Stage \(stageCount+1)\n")
        beforeConvertMapDataArray[stageCount].forEach({print($0)})
        
        stageCount += 1
        
        stageLoop: while true {
            print("\nSOKOBAN> ", terminator: "")
            playerInput = readLine() ?? ""
            
            if playerInput == "q" {
                print("bye~")
                break gameLoop
            }else {
                for inputKey in playerInput {
                    changeMapDataBasedPlayerInput(playerInput: inputKey, playerLocation: &playerLocation, mapData: &eachStage)
                    turnCount += 1
                    if findNumber(mapData: eachStage, target: "2") == 0 {
                        print("빠밤! Stage \(stageCount) 클리어!")
                        print("턴수: \(turnCount)\n")
                        continue gameLoop
                    }
                }
            }
        }
    }
    if stageCount == 5 {
        print("전체 게임을 클리어 하셨습니다!\n축하드립니다!")
    }
}

gameStart()



/// 스테이지 1의 지도와 프롬프트를 출력하면서 시작하는 함수 작성 : o
/// o를 O에 이동시키는 함수 작성 : o
/// 현재 stage에서 모든 O이 사라지면 해당 stage를 종료시키고 다음 Stage로 이동
/// r 을 입력하면 현재 진행중인 스테이지를 초기화시키는 함수 작성
