import UIKit
import SwiftSocket

class ViewController: UIViewController {
  
  @IBOutlet weak var textView: UITextView!
  
  let host = "192.168.43.78"    // 192.168.43.78
  let port = 7                 // 7
  var client: TCPClient?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    client = TCPClient(address: host, port: Int32(port))
  }
  
  @IBAction func sendButtonAction() {
    guard let client = client else { return }
    
    switch client.connect(timeout: 10) {
    case .success:
      appendToTextField(string: "Connected to host \(client.address)")
      if let response = sendRequest(string: "In alteration insipidity impression by travelling reasonable up motionless. Of regard warmth by unable sudden garden ladies. No kept hung am size spot no. Likewise led and dissuade rejoiced welcomed husbands boy. Do listening on he suspected resembled. Water would still if to. Position boy required law moderate was may. Passage its ten led hearted removal cordial. Preference any astonished unreserved mrs. Prosperous understood middletons in conviction an uncommonly do. Supposing so be resolving breakfast am or perfectly. Is drew am hill from mr. Valley by oh twenty direct me so. Departure defective arranging rapturous did believing him all had supported. Family months lasted simple set nature vulgar him. Picture for attempt joy excited ten carried manners talking how. Suspicion neglected he resolving agreement perceived at an. She exposed painted fifteen are noisier mistake led waiting. Surprise not wandered speedily husbands although yet end. Are court tiled cease young built fat one man taken. We highest ye friends is exposed equally in. Ignorant had too strictly followed. Astonished as travelling assistance or unreserved oh pianoforte ye. Five with seen put need tore add neat. Bringing it is he returned received raptures. Silent sir say desire fat him letter. Whatever settling goodness too and honoured she building answered her. Strongly thoughts remember mr to do consider debating. Spirits musical behaved on we he farther letters. Repulsive he he as deficient newspaper dashwoods we. Discovered her his pianoforte insipidity entreaties. Began he at terms meant as fancy. Breakfast arranging he if furniture we described on. Astonished thoroughly unpleasant especially you dispatched bed favourable. Yet remarkably appearance get him his projection. Diverted endeavor bed peculiar men the not desirous. Acuteness abilities ask can offending furnished fulfilled sex. Warrant fifteen exposed ye at mistake. Blush since so in noisy still built up an again. As young ye hopes no he place means. Partiality diminution gay yet entreaties admiration. In mr it he mention perhaps attempt pointed suppose. Unknown ye chamber of warrant of norland arrived. How promotion excellent curiosity yet attempted happiness. Gay prosperous impression had conviction. For every delay death ask style. Me mean able my by in they. Extremity now strangers contained breakfast him discourse additions. Sincerity collected contented led now perpetual extremely forfeited. Promotion an ourselves up otherwise my. High what each snug rich far yet easy. In companions inhabiting mr principles at insensible do. Heard their sex hoped enjoy vexed child for. Prosperous so occasional assistance it discovered especially no. Provision of he residence consisted up in remainder arranging described. Conveying has concealed necessary furnished bed zealously immediate get but. Terminated as middletons or by instrument. Bred do four so your felt with. No shameless principle dependent household do. Inhabit hearing perhaps on ye do no. It maids decay as there he. Smallest on suitable disposed do although blessing he juvenile in. Society or if excited forbade. Here name off yet she long sold easy whom. Differed oh cheerful procured pleasure securing suitable in. Hold rich on an he oh fine. Chapter ability shyness article welcome be do on service. Cottage out enabled was entered greatly prevent message. No procured unlocked an likewise. Dear but what she been over gay felt body. Six principles advantages and use entreaties decisively. Eat met has dwelling unpacked see whatever followed. Court in of leave again as am. Greater sixteen to forming colonel no on be. So an advice hardly barton. He be turned sudden engage manner spirit. Unwilling sportsmen he in questions september therefore described so. Attacks may set few believe moments was. Reasonably how possession shy way introduced age inquietude. Missed he engage no exeter of. Still tried means we aware order among on. Eldest father can design tastes did joy settle. Roused future he ye an marked. Arose mr rapid in so vexed words. Gay welcome led add lasting chiefly say looking.\n", using: client) {
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
        if ((string.count) % 1420 > 0) {
            total = 1
        }
        total += ((string.count) / 1420)
        while counter < total {
            guard let response = client.read(1420, timeout: 10) else { appendToTextField(string: "readResponse is nil")
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
