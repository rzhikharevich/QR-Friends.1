import UIKit
import VKSdkFramework

func makeCodeString() -> String {
    if UserDefaults.standard.bool(forKey: "vkSwitch") && VKSdk.accessToken() != nil {
        return "!QRF;vk:\(VKSdk.accessToken().userId!)"
    } else {
        return "!QRF"
    }
}

func makeCode() -> UIImage {
    return makeQRCode(string: makeCodeString())
}

func parseCodeString(string: String) -> String {
    return string.components(separatedBy: ";").last!.components(separatedBy: ":").last!
}
