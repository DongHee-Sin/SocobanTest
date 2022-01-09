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


/// 입력된 문자열을 dictionary를 바탕으로 변환하여 리턴
/// reduce에 후행클로저를 사용
/// $0 = stringToConvert (String)
/// $1 = convertBy (Dictionary)
/// 초기값을 stringToConvert로 사용하고, 클로저로 어떤 변화를 줄지 작성함
func convertStringToNumber(stringToConvert: String) -> String {
    /// 문자열 변환을 위한 Dictionary
    let dictionaryForReplace: [String: String] = ["#": "0", "O": "1", "o": "2", "P": "3", "=": "4"]
    
    return dictionaryForReplace.reduce(stringToConvert) {
        $0.replacingOccurrences(of: $1.key, with: $1.value)
    }
}

func convertNumberToString(stringToConvert: String) -> String {
    /// 문자열 변환을 위한 Dictionary
    let dictionaryForReplace: [String: String] = ["#": "0", "O": "1", "o": "2", "P": "3", "=": "4"]
    
    return dictionaryForReplace.reduce(stringToConvert) {
        $0.replacingOccurrences(of: $1.value, with: $1.key)
    }.replacingOccurrences(of: "c", with: "0")
}




/// 변환된 문자열로 구성된 1차원 배열을
/// 변환되지 않은 문자열로 구성된 1차원 배열로 만들기 위한 함수
/// (콘솔 출력을 위해)
/// 매개변수로 convert2DArrayTo1DArray함수의 결과를 사용
func convertStringArray(stringArrayToConvert: [String]) -> [String] {
    return stringArrayToConvert.map({convertNumberToString(stringToConvert: $0)})
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
    let arrayOfString: [String] = convertStringArray(stringArrayToConvert: arrayOfNumber)
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


// 입력된 값을 바탕으로 플레이어 좌표를 수정하고 맵 데이터에 반영하는 함수
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
}


/// 입력받은 키워드를 사용하여 플레이어 위치를 이동
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
                printMapData(stage2DArray: mapData)
                print("\(playerInput): 위로 이동합니다.")
            // 이동하려는 공간에 2(공)이 있는 경우
            case "2":
                switch mapData[playerLocation.1-3][playerLocation.0-1] {
                // 공이 이동될 공간이 공란인 경우
                case " ":
                    enterValueOnMap(playerLocation: (playerLocation.0, playerLocation.1-2), valueToEnter: "2", mapData: &mapData)
                    playerMove(playerInput: playerInput, playerLocation: &playerLocation, mapData: &mapData)
                    printMapData(stage2DArray: mapData)
                    print("\(playerInput): 위로 이동합니다.")
                // 공이 이동될 공간에 1(구멍)이 있는 경우
                case "1":
                    enterValueOnMap(playerLocation: (playerLocation.0, playerLocation.1-2), valueToEnter: "c", mapData: &mapData)
                    playerMove(playerInput: playerInput, playerLocation: &playerLocation, mapData: &mapData)
                    printMapData(stage2DArray: mapData)
                    print("\(playerInput): 위로 이동합니다.")
                // 공을 옮기려는 공간에 다른공 or 벽이 있을 때
                default:
                    printErrorMessageAndMapData(playerInput: playerInput, mapData: mapData)
                }
            // 이동하려는 공간에 c(공을 넣은 구멍)이 있는 경우
            case "c":
                switch mapData[playerLocation.1-3][playerLocation.0-1] {
                    // 공을 밀어낼 공간이 공란인 경우
                case " ":
                    enterValueOnMap(playerLocation: (playerLocation.0, playerLocation.1-2), valueToEnter: "2", mapData: &mapData)
                    enterValueOnMap(playerLocation: (playerLocation.0, playerLocation.1-1), valueToEnter: "1", mapData: &mapData)
                    printMapData(stage2DArray: mapData)
                    print("\(playerInput): 구멍에서 공을 밀어냅니다.")
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
                printMapData(stage2DArray: mapData)
                print("\(playerInput): 왼쪽으로 이동합니다.")
            // 이동하려는 공간에 2(공)이 있는 경우
            case "2":
                switch mapData[playerLocation.1-1][playerLocation.0-3] {
                // 공이 이동될 공간이 공란인 경우
                case " ":
                    enterValueOnMap(playerLocation: (playerLocation.0-2, playerLocation.1), valueToEnter: "2", mapData: &mapData)
                    playerMove(playerInput: playerInput, playerLocation: &playerLocation, mapData: &mapData)
                    printMapData(stage2DArray: mapData)
                    print("\(playerInput): 왼쪽으로 이동합니다.")
                // 공이 이동될 공간에 1(구멍)이 있는 경우
                case "1":
                    enterValueOnMap(playerLocation: (playerLocation.0-2, playerLocation.1), valueToEnter: "c", mapData: &mapData)
                    playerMove(playerInput: playerInput, playerLocation: &playerLocation, mapData: &mapData)
                    printMapData(stage2DArray: mapData)
                    print("\(playerInput): 왼쪽으로 이동합니다.")
                // 공을 옮기려는 공간에 다른공 or 벽이 있을 때
                default:
                    printErrorMessageAndMapData(playerInput: playerInput, mapData: mapData)
                }
            case "c":
                switch mapData[playerLocation.1-1][playerLocation.0-3] {
                    // 공을 밀어낼 공간이 공란인 경우
                case " ":
                    enterValueOnMap(playerLocation: (playerLocation.0-2, playerLocation.1), valueToEnter: "2", mapData: &mapData)
                    enterValueOnMap(playerLocation: (playerLocation.0-1, playerLocation.1), valueToEnter: "1", mapData: &mapData)
                    printMapData(stage2DArray: mapData)
                    print("\(playerInput): 구멍에서 공을 밀어냅니다.")
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
                printMapData(stage2DArray: mapData)
                print("\(playerInput): 아래로 이동합니다.")
            // 이동하려는 공간에 2(공)이 있는 경우
            case "2":
                switch mapData[playerLocation.1+1][playerLocation.0-1] {
                // 공이 이동될 공간이 공란인 경우
                case " ":
                    enterValueOnMap(playerLocation: (playerLocation.0, playerLocation.1+2), valueToEnter: "2", mapData: &mapData)
                    playerMove(playerInput: playerInput, playerLocation: &playerLocation, mapData: &mapData)
                    printMapData(stage2DArray: mapData)
                    print("\(playerInput): 아래로 이동합니다.")
                // 공이 이동될 공간에 1(구멍)이 있는 경우
                case "1":
                    enterValueOnMap(playerLocation: (playerLocation.0, playerLocation.1+2), valueToEnter: "c", mapData: &mapData)
                    playerMove(playerInput: playerInput, playerLocation: &playerLocation, mapData: &mapData)
                    printMapData(stage2DArray: mapData)
                    print("\(playerInput): 아래로 이동합니다.")
                // 공을 옮기려는 공간에 다른공 or 벽이 있을 때
                default:
                    printErrorMessageAndMapData(playerInput: playerInput, mapData: mapData)
                }
            case "c":
                switch mapData[playerLocation.1+1][playerLocation.0-1] {
                    // 공을 밀어낼 공간이 공란인 경우
                case " ":
                    enterValueOnMap(playerLocation: (playerLocation.0, playerLocation.1+2), valueToEnter: "2", mapData: &mapData)
                    enterValueOnMap(playerLocation: (playerLocation.0, playerLocation.1+1), valueToEnter: "1", mapData: &mapData)
                    printMapData(stage2DArray: mapData)
                    print("\(playerInput): 구멍에서 공을 밀어냅니다.")
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
                printMapData(stage2DArray: mapData)
                print("\(playerInput): 오른쪽으로 이동합니다.")
            // 이동하려는 공간에 2(공)이 있는 경우
            case "2":
                switch mapData[playerLocation.1-1][playerLocation.0+1] {
                // 공이 이동될 공간이 공란인 경우
                case " ":
                    enterValueOnMap(playerLocation: (playerLocation.0+2, playerLocation.1), valueToEnter: "2", mapData: &mapData)
                    playerMove(playerInput: playerInput, playerLocation: &playerLocation, mapData: &mapData)
                    printMapData(stage2DArray: mapData)
                    print("\(playerInput): 오른쪽으로 이동합니다.")
                // 공이 이동될 공간에 1(구멍)이 있는 경우
                case "1":
                    enterValueOnMap(playerLocation: (playerLocation.0+2, playerLocation.1), valueToEnter: "c", mapData: &mapData)
                    playerMove(playerInput: playerInput, playerLocation: &playerLocation, mapData: &mapData)
                    printMapData(stage2DArray: mapData)
                    print("\(playerInput): 오른쪽으로 이동합니다.")
                // 공을 옮기려는 공간에 다른공 or 벽이 있을 때
                default:
                    printErrorMessageAndMapData(playerInput: playerInput, mapData: mapData)
                }
            case "c":
                switch mapData[playerLocation.1-1][playerLocation.0+1] {
                    // 공을 밀어낼 공간이 공란인 경우
                case " ":
                    enterValueOnMap(playerLocation: (playerLocation.0+2, playerLocation.1), valueToEnter: "2", mapData: &mapData)
                    enterValueOnMap(playerLocation: (playerLocation.0+1, playerLocation.1), valueToEnter: "1", mapData: &mapData)
                    printMapData(stage2DArray: mapData)
                    print("\(playerInput): 구멍에서 공을 밀어냅니다.")
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
    // [슬롯번호: [현재 스테이지: 2차원배열 맵 정보]]
    var saveSlot: [Int: [Int: [[String.Element]]]] = [Int: [Int: [[String.Element]]]]()
    // 주어진 문자열 (맵 데이터)
    let mapData: String = readFile()
    // 변환 전 문자열이 사용된 맵 데이터 배열
    let beforeConvertMapDataArray: [[String]] = convertMapDataToEachStage(baseString: separateStringBasedNewLine(mapData))
    // 변환 후 문자열이 사용된 맵 데이터 배열
    let afterConvertMapDataArray: [[String]] = convertMapDataToEachStage(baseString: separateStringBasedNewLine(convertStringToNumber(stringToConvert: mapData)))
    
    
    // 5개의 Stage(2차원 배열) 정보를 담은 3차원 배열
    let stageMapDataArray: [[[String.Element]]] = afterConvertMapDataArray.map({convertStringArrayTo2DArray($0)})
    
    
    // 현재 진행중인 스테이지가 몇 단계인지 나타내기 위한 count
    var stageCount: Int = 0
    
    /// 되돌리기 기능 구현을 위한 변수
    /// 이전 상태를 저장하는 변수, 되돌리기 전 상태를 저장하는 변수
    var beforePlayerMove: [[String.Element]]? = nil
    var beforeRevert: [[String.Element]]? = nil
    
    // stage를 하나씩 받아서 처리하는 for문
    // eachStage = [[String.Element]]
    gameLoop: for eachStage in stageMapDataArray {
        var playerInput: String = ""
        var eachStage: [[String.Element]] = eachStage
        var playerLocation: (Int, Int) = findPlayerLocation(mapData: eachStage)
        var turnCount: Int = 0
        let slotRange = 1...5
        
        // stage 맵 정보 출력
        print("Stage \(stageCount+1)\n")
        beforeConvertMapDataArray[stageCount].forEach({print($0)})
        
        stageCount += 1
        
        stageLoop: while true {
            print("\nSOKOBAN> ", terminator: "")
            playerInput = readLine() ?? ""
            
            
            switch playerInput {
            // 게임 종료
            case "q":
                print("bye~")
                break gameLoop
            // Stage 리셋
            case "r":
                print("\n스테이지 초기화\nStage \(stageCount)\n")
                turnCount = 0
                beforeConvertMapDataArray[stageCount-1].forEach({print($0)})
                eachStage = stageMapDataArray[stageCount-1]
                playerLocation = findPlayerLocation(mapData: eachStage)
            // 현재 스테이지 저장
            case let input where input.contains("S"):
                guard let slotNumber = playerInput.first?.wholeNumberValue, slotRange.contains(slotNumber) else {
                    print("\n저장 슬롯은 5개 사용 가능합니다.\nex) 2S = 2번 슬롯에 현재 상태 저장")
                    continue
                }
                //       저장 번호    =  [진행된 스테이지 번호 : 맵 정보]
                saveSlot[slotNumber] = [stageCount: eachStage]
                print("\(slotNumber)번 세이브에 진행상황을 저장합니다.")
            // 저장된 스테이지 불러오기
            // saveData 상수에는 [저장된 스테이지 번호: [[String.Element]]] 가 들어옴
            case let input where input.contains("L"):
                guard let slotNumber = playerInput.first?.wholeNumberValue, let saveData = saveSlot[slotNumber] else {
                    print("\n저장 슬롯은 5개 사용 가능합니다.\n현재 \(saveSlot.keys.sorted())번 슬롯에 데이터가 저장되어 있습니다.")
                    continue
                }
                stageCount = Array(saveData.keys)[0]
                eachStage = saveData[stageCount] ?? eachStage
                playerLocation = findPlayerLocation(mapData: eachStage)
                print("\n\(slotNumber)번 세이브에서 진행상황을 불러옵니다.\nStage \(stageCount)")
                printMapData(stage2DArray: eachStage)
            // 이전 상태로 되돌리는 기능
            case "u":
                guard let beforeStage = beforePlayerMove else {
                    print("되돌릴 데이터가 없습니다.")
                    continue
                }
                beforeRevert = eachStage
                print("\n한 턴 되돌리기를 실행합니다.")
                eachStage = beforeStage
                turnCount -= 1
                playerLocation = findPlayerLocation(mapData: eachStage)
                printMapData(stage2DArray: eachStage)
            // u로 되돌렸던 상태를 취소
            case "U":
                guard let beforeStage = beforeRevert else {
                    print("되돌리기를 취소할 데이터가 없습니다.")
                    continue
                }
                eachStage = beforeStage
                turnCount += 1
                playerLocation = findPlayerLocation(mapData: eachStage)
                printMapData(stage2DArray: eachStage)
                beforeRevert = nil
            // 입력된 키로 플레이어 움직임 구현
            default:
                beforePlayerMove = eachStage
                for inputKey in playerInput {
                    changeMapDataBasedPlayerInput(playerInput: inputKey, playerLocation: &playerLocation, mapData: &eachStage)
                    turnCount += 1
                    if findNumber(mapData: eachStage, target: "2") == 0 {
                        print("빠밤! Stage \(stageCount) 클리어!")
                        print("턴수: \(turnCount)\n")
                        beforePlayerMove = nil
                        beforeRevert = nil
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
