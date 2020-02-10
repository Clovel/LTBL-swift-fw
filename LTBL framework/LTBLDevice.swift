import Foundation

/**
 * @brief Different states the LTBL device can be in.
 */
enum LTBLState: String {
    case LTBL_UNKNOWN_STATE = "unknown"
    case LTBL_ON = "on"
    case LTBL_OFF = "off"
}

fileprivate func parseState(pStr: String) -> LTBLState {
    let lMatch = pStr.range(of: #"State (ON|OFF)"#, options: .regularExpression)

    if(nil != lMatch) {
        switch(pStr[lMatch!]) {
        case "State ON":
            return LTBLState.LTBL_ON
        case "State OFF":
            return LTBLState.LTBL_OFF
        default:
            return LTBLState.LTBL_UNKNOWN_STATE
        }
    } else {
        return LTBLState.LTBL_UNKNOWN_STATE
    }
}

/**
 * @class This class represents a LTBL device.
 */
public class LTBLDevice: ObservableObject {
    @Published var state: LTBLState = LTBLState.LTBL_UNKNOWN_STATE
    var IPAddr: String?

    init(_ pIPAddr: String) {
        IPAddr = pIPAddr
    }

    func getHomePage() -> Void {
        var lDataString: String = ""

        let url = URL(string: "http://" + IPAddr!)!
        let urlSession: URLSession = URLSession.shared
        let urlSessionTask: URLSessionDataTask = urlSession.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            print("[DEBUG] <LTBLDevice::getHomePage> Data = ", data as Any)
            print("[DEBUG] <LTBLDevice::getHomePage> Response = ", response as Any)
            print("[DEBUG] <LTBLDevice::getHomePage> Error = ", error as Any)

            if(nil != data) {
                lDataString = String(data: data!, encoding: .utf8)!
                print("[DEBUG] <LTBLDevice::getHomePage> lDataString = ", lDataString)

                DispatchQueue.main.async {
                    self.state = parseState(pStr: lDataString)
                }
            }
        })

        urlSessionTask.resume()
    }

    func turnOn() -> Void {
        var lDataString: String = ""

        let url = URL(string: "http://" + IPAddr! + "/on")!
        let urlSession: URLSession = URLSession.shared
        let urlSessionTask: URLSessionDataTask = urlSession.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            print("[DEBUG] <LTBLDevice::getHomePage> Data = ", data as Any)
            print("[DEBUG] <LTBLDevice::getHomePage> Response = ", response as Any)
            print("[DEBUG] <LTBLDevice::getHomePage> Error = ", error as Any)

            if(nil != data) {
                lDataString = String(data: data!, encoding: .utf8)!
                print("[DEBUG] <LTBLDevice::getHomePage> lDataString = ", lDataString)

                DispatchQueue.main.async {
                    self.state = parseState(pStr: lDataString)
                }
            }
        })

        urlSessionTask.resume()
    }

    func turnOff() -> Void {
        var lDataString: String = ""

        let url = URL(string: "http://" + IPAddr! + "/off")!
        let urlSession: URLSession = URLSession.shared
        let urlSessionTask: URLSessionDataTask = urlSession.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            print("[DEBUG] <LTBLDevice::getHomePage> Data = ", data as Any)
            print("[DEBUG] <LTBLDevice::getHomePage> Response = ", response as Any)
            print("[DEBUG] <LTBLDevice::getHomePage> Error = ", error as Any)

            if(nil != data) {
                lDataString = String(data: data!, encoding: .utf8)!
                print("[DEBUG] <LTBLDevice::getHomePage> lDataString = ", lDataString)

                DispatchQueue.main.async {
                    self.state = parseState(pStr: lDataString)
                }
            }
        })

        urlSessionTask.resume()
    }

    func toggle() -> Void {
        switch(self.state) {
        case LTBLState.LTBL_ON:
            self.turnOff()
        case LTBLState.LTBL_OFF:
            self.turnOn()
        default:
            /* Do nothing */
            return
        }
    }

    func switchState(_ pState: LTBLState) -> Void {
        switch(pState) {
        case LTBLState.LTBL_ON:
            self.turnOn()
        case LTBLState.LTBL_OFF:
            self.turnOff()
        default:
            /* Do nothing */
            return
        }
    }
}
