import UIKit
import SwiftSocket

class ViewController: UIViewController {
  
  @IBOutlet weak var textView: UITextView!
    
  let host = "192.168.43.78"    // 192.168.43.78 192.168.43.121
  let port = 7                  // 7
  var client: TCPClient?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    client = TCPClient(address: host, port: Int32(port))
  }
  
    @IBAction func sendButtonAction(sender: UIButton) {
    guard let client = client else { return }
        let ywz = YardWorkZone(zone_num: sender.tag, duration: 10).convertToJSONString()
    
    switch client.connect(timeout: 10) {
    case .success:
      appendToTextField(string: "Connected to host \(client.address)")
      if let response = sendRequest(string: ywz, using: client) {   // "YW_"+ywz
        appendToTextField(string: "Response: \(response)")
      }
    case .failure(let error):
      appendToTextField(string: String(describing: error))
    }
  }
  
  private func sendRequest(string: String, using client: TCPClient) -> String? {
    appendToTextField(string: "Sending data ... ")
    
    switch client.send(string: string) {
    case .success:
      appendToTextField(string: "succeed.")
      return readResponse(from: client, string: string)
    case .failure(let error):
      appendToTextField(string: "failed.")
      appendToTextField(string: String(describing: error))
      return nil
    }
  }
  
    private func readResponse(from client: TCPClient, string: String) -> String? {
        var data = [UInt8]()
        var counter = 0, total = 0
        let len = 1420  // one-time read limit: 1420 bytes
        if ((string.count) % len > 0) {
            total = 1
        }
        total += ((string.count) / len)
        while counter < total {
            guard let response = client.read(len, timeout: 10) else { appendToTextField(string: "readResponse is nil")
                return nil
            }
            counter += 1
            data += response
        }
        return String(bytes: data, encoding: .utf8)
  }
  
  private func appendToTextField(string: String) {
    print(string)
    textView.text = textView.text.appending("\n\(string)")
  }

}
