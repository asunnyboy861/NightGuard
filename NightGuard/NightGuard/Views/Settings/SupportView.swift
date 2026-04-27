import SwiftUI
import MessageUI

struct SupportView: View {

    @State private var showMailComposer = false
    @State private var showMailAlert = false

    var body: some View {
        List {
            Section("Get Help") {
                NavigationLink {
                    FAQView()
                } label: {
                    Label("FAQ", systemImage: "questionmark.circle")
                }

                Button {
                    if MFMailComposeViewController.canSendMail() {
                        showMailComposer = true
                    } else {
                        showMailAlert = true
                    }
                } label: {
                    Label("Email Support", systemImage: "envelope")
                }
            }

            Section("Resources") {
                Link(destination: URL(string: "https://nightguard.app/guide")!) {
                    Label("User Guide", systemImage: "book")
                }

                Link(destination: URL(string: "https://nightguard.app/privacy")!) {
                    Label("Privacy Policy", systemImage: "hand.raised")
                }

                Link(destination: URL(string: "https://nightguard.app/terms")!) {
                    Label("Terms of Use", systemImage: "doc.text")
                }
            }

            Section("About") {
                HStack {
                    Text("Version")
                    Spacer()
                    Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Support")
        .sheet(isPresented: $showMailComposer) {
            MailComposeView()
        }
        .alert("Cannot Send Email", isPresented: $showMailAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please set up a mail account on your device to send feedback.")
        }
    }
}

struct FAQView: View {
    let faqs: [(String, String)] = [
        ("How does NightGuard block apps?", "NightGuard uses Apple's Screen Time API to apply shields to selected apps during your scheduled bedtime. The blocking is enforced at the system level, making it very difficult to bypass."),
        ("What is Hard Lock mode?", "Hard Lock mode blocks ALL app categories during bedtime. This makes it nearly impossible to bypass your bedtime protection, even for determined users."),
        ("Can I override the block?", "You can use Emergency Override, but your accountability partner will be notified. This adds a social accountability layer to discourage bypassing."),
        ("Does NightGuard work in the background?", "Yes, NightGuard uses Device Activity monitoring to maintain protection even when the app is closed. Chain scheduling ensures continuous coverage throughout the night."),
        ("How do I restore purchases?", "Go to Settings > Restore Purchases. Your subscription will be synced with your Apple ID."),
        ("Is my data private?", "Yes. NightGuard stores all data locally on your device. We do not collect, transmit, or share any personal information.")
    ]

    var body: some View {
        List {
            ForEach(faqs, id: \.0) { question, answer in
                DisclosureGroup {
                    Text(answer)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 4)
                } label: {
                    Text(question)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
            }
        }
        .navigationTitle("FAQ")
    }
}

struct MailComposeView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let controller = MFMailComposeViewController()
        controller.setToRecipients(["support@nightguard.app"])
        controller.setSubject("NightGuard Feedback")
        controller.setMessageBody("\n\n---\nApp Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")\niOS: \(UIDevice.current.systemVersion)", isHTML: false)
        return controller
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
}
