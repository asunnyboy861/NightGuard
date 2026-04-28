import ManagedSettingsUI
import ManagedSettings
import UIKit

class ShieldConfigurationExtension: ShieldConfigurationDataSource {

    override func configuration(shielding application: Application) -> ShieldConfiguration {
        ShieldConfiguration(
            backgroundBlurStyle: .dark,
            backgroundColor: UIColor.black.withAlphaComponent(0.95),
            icon: UIImage(systemName: "moon.stars.fill"),
            title: ShieldConfiguration.Label(
                text: "NightGuard Active",
                color: .white
            ),
            subtitle: ShieldConfiguration.Label(
                text: "This app is blocked to protect your sleep.",
                color: .lightGray
            ),
            primaryButtonLabel: ShieldConfiguration.Label(
                text: "I Understand",
                color: .white
            ),
            primaryButtonBackgroundColor: .systemIndigo,
            secondaryButtonLabel: ShieldConfiguration.Label(
                text: "Emergency Override",
                color: .systemRed
            )
        )
    }

    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        ShieldConfiguration(
            backgroundBlurStyle: .dark,
            backgroundColor: UIColor.black.withAlphaComponent(0.95),
            icon: UIImage(systemName: "moon.stars.fill"),
            title: ShieldConfiguration.Label(
                text: "NightGuard Active",
                color: .white
            ),
            subtitle: ShieldConfiguration.Label(
                text: "This category is blocked to protect your sleep.",
                color: .lightGray
            ),
            primaryButtonLabel: ShieldConfiguration.Label(
                text: "I Understand",
                color: .white
            ),
            primaryButtonBackgroundColor: .systemIndigo,
            secondaryButtonLabel: ShieldConfiguration.Label(
                text: "Emergency Override",
                color: .systemRed
            )
        )
    }

    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        ShieldConfiguration(
            backgroundBlurStyle: .dark,
            backgroundColor: UIColor.black.withAlphaComponent(0.95),
            icon: UIImage(systemName: "moon.stars.fill"),
            title: ShieldConfiguration.Label(
                text: "NightGuard Active",
                color: .white
            ),
            subtitle: ShieldConfiguration.Label(
                text: "This website is blocked to protect your sleep.",
                color: .lightGray
            ),
            primaryButtonLabel: ShieldConfiguration.Label(
                text: "I Understand",
                color: .white
            ),
            primaryButtonBackgroundColor: .systemIndigo,
            secondaryButtonLabel: ShieldConfiguration.Label(
                text: "Emergency Override",
                color: .systemRed
            )
        )
    }

    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        ShieldConfiguration(
            backgroundBlurStyle: .dark,
            backgroundColor: UIColor.black.withAlphaComponent(0.95),
            icon: UIImage(systemName: "moon.stars.fill"),
            title: ShieldConfiguration.Label(
                text: "NightGuard Active",
                color: .white
            ),
            subtitle: ShieldConfiguration.Label(
                text: "This category is blocked to protect your sleep.",
                color: .lightGray
            ),
            primaryButtonLabel: ShieldConfiguration.Label(
                text: "I Understand",
                color: .white
            ),
            primaryButtonBackgroundColor: .systemIndigo,
            secondaryButtonLabel: ShieldConfiguration.Label(
                text: "Emergency Override",
                color: .systemRed
            )
        )
    }
}
