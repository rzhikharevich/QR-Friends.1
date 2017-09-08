import UIKit
import VKSdkFramework

class CodeViewController: UIViewController {
    @IBOutlet weak var codeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        VKSdk.wakeUpSession(["friends"]) {
            state, error in
            
            switch state {
            case .initialized:
                print("initialized!")
                VKSdk.authorize(["friends"])
            case .authorized:
                print("authorized: \(VKSdk.accessToken().accessToken)")
                accountData.setKey(VKSdk.accessToken().accessToken, forSocialNetwork: .vk)
            case .error:
                print("error: \(error)")
            default:
                print("smth else?")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        codeImageView.image = makeCode()
    }
}

class ScannerViewController: UIViewController {
    @IBOutlet weak var capturerView: UIView!
    
    var capturer: QRCodeCapturer!
    
    var requestsSent = Set<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        capturer = QRCodeCapturer(view: capturerView) {
            string in
            
//            print(parseCodeString(string: string))
            
            let id = parseCodeString(string: string)
            
            guard !self.requestsSent.contains(id) else {return}
            
            self.requestsSent.insert(id)
            
            print(id)
            
            VKApi.request(withMethod: "friends.add", andParameters: ["user_id":id]).execute(resultBlock: {
                response in
                print("response: \(response?.json)")
                
                let alert = UIAlertController(title: "Запрос в друзья отправлен", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }, errorBlock: {
                error in
                print("error: \(error)")
            })
        }
    }
}

class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var vkSwitch: UISwitch!
    @IBOutlet weak var vkAddButton: UIButton!
    
    override func viewDidLoad() {
        if accountData.getKey(socialNetwork: .vk) != nil {
            vkSwitch.isOn = UserDefaults.standard.bool(forKey: "vkSwitch")
            vkAddButton.isHidden = true
        } else {
            vkSwitch.isHidden = true
            vkAddButton.isHidden = false
        }
    }
    
    @IBAction func addVK(_ sender: Any) {
        VKSdk.wakeUpSession(["friends"]) {
            state, error in
            
            switch state {
            case .initialized:
                print("initialized!")
                VKSdk.authorize(["friends"])
            case .authorized:
                print("authorized: \(VKSdk.accessToken().accessToken)")
                accountData.setKey(VKSdk.accessToken().accessToken, forSocialNetwork: .vk)
            case .error:
                print("error: \(error)")
            default:
                print("smth else?")
            }
        }
    }
    
    @IBAction func vkSwitchChanged(_ sender: Any) {
        UserDefaults.standard.set(vkSwitch.isOn, forKey: "vkSwitch")
    }
}
