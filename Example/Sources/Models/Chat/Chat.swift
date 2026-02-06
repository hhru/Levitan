import Foundation
import Levitan

struct Chat: Changeable, Hashable, Sendable {

    let userID: Int

    var messages: [ChatMessage]
    var isPinned: Bool

    init(
        userID: Int,
        messages: [ChatMessage] = [],
        isPinned: Bool = false
    ) {
        self.userID = userID
        self.messages = messages
        self.isPinned = isPinned
    }

    func message(id: UUID) -> ChatMessage? {
        messages.first { $0.id == id }
    }

    func messageIndex(id: UUID) -> Int? {
        messages.firstIndex { $0.id == id }
    }
}

extension Chat {

    private static let date = Date()

    static let iOSDeveloper = Self(
        userID: 1,
        messages: [
            ChatMessage(
                type: .outgoing,
                text: """
                    Hi! We're interested in your profile for our iOS Developer position at Apple.
                    """,
                date: date.addingTimeInterval(-172_509.0)
            ),
            ChatMessage(
                type: .incoming,
                text: """
                    Hello! Thanks for reaching out. I'd love to hear more about the role.
                    """,
                date: date.addingTimeInterval(-172_094.0)
            ),
            ChatMessage(
                type: .outgoing,
                text: """
                    Great! The position involves working on our core iOS apps, \
                    building new features and optimizing performance.
                    """,
                date: date.addingTimeInterval(-171_905.0)
            ),
            ChatMessage(
                type: .incoming,
                text: """
                    Sounds exciting. Could you specify which technologies and experience are you looking for?
                    """,
                date: date.addingTimeInterval(-171_305.0)
            ),
            ChatMessage(
                type: .outgoing,
                text: """
                    We're looking for someone with 3+ years of experience in Swift and Objective-C, \
                    plus solid understanding of UIKit and SwiftUI.
                    """,
                date: date.addingTimeInterval(-170_933.0)
            ),
            ChatMessage(
                type: .incoming,
                text: """
                    I have about 4 years of experience in Swift and have worked extensively with UIKit \
                    and recently SwiftUI.
                    """,
                date: date.addingTimeInterval(-170_645.0)
            ),
            ChatMessage(
                type: .outgoing,
                text: """
                    That's perfect. Are you also familiar with asynchronous programming and Combine framework?
                    """,
                date: date.addingTimeInterval(-100_378.0)
            ),
            ChatMessage(
                type: .incoming,
                text: """
                    Yes, I have used Combine in production apps and comfortable with async/await introduced \
                    in recent Swift versions.
                    """,
                date: date.addingTimeInterval(-99_784.0)
            ),
            ChatMessage(
                type: .outgoing,
                text: """
                    Excellent. What about your experience with unit and UI testing?
                    """,
                date: date.addingTimeInterval(-99_498.0)
            ),
            ChatMessage(
                type: .incoming,
                text: """
                    I write unit tests using XCTest and have experience automating UI tests using XCUITest.
                    """,
                date: date.addingTimeInterval(-99_299.0)
            ),
            ChatMessage(
                type: .outgoing,
                text: """
                    Nice! Could you share examples of apps you've developed or contributed to?
                    """,
                date: date.addingTimeInterval(-98_880.0)
            ),
            ChatMessage(
                type: .incoming,
                text: """
                    Sure. I was a lead dev on a budgeting app and contributed to an e-commerce app currently \
                    on the App Store.
                    """,
                date: date.addingTimeInterval(-98_323.0)
            ),
            ChatMessage(
                type: .outgoing,
                text: """
                    Thanks! Would you be available for a video interview later this week?
                    """,
                date: date.addingTimeInterval(-98_141.0)
            ),
            ChatMessage(
                type: .incoming,
                text: """
                    Yes, I am available on Thursday or Friday afternoon.
                    """,
                date: date.addingTimeInterval(-2413.0)
            ),
            ChatMessage(
                type: .outgoing,
                text: """
                    Let's schedule it for Thursday 2pm. I'll send you the invite shortly.
                    """,
                date: date.addingTimeInterval(-2162.0)
            ),
            ChatMessage(
                type: .incoming,
                text: """
                    Perfect, looking forward to it!
                    """,
                date: date.addingTimeInterval(-1572.0)
            ),
            ChatMessage(
                type: .outgoing,
                text: """
                    Great! Please prepare to discuss your previous projects and coding challenges.
                    """,
                date: date.addingTimeInterval(-1252.0)
            ),
            ChatMessage(
                type: .incoming,
                text: """
                    Will do. Thanks for the heads up.
                    """,
                date: date.addingTimeInterval(-1066.0)
            ),
            ChatMessage(
                type: .outgoing,
                text: """
                    You're welcome. If you have any questions before then, just let me know.
                    """,
                date: date.addingTimeInterval(-656.0)
            ),
            ChatMessage(
                type: .incoming,
                text: """
                    Thanks, will do. Have a great day!
                    """,
                date: date.addingTimeInterval(-200.0)
            )
        ],
        isPinned: false
    )

    static let androidDeveloper = Self(
        userID: 2,
        messages: [
            ChatMessage(
                type: .incoming,
                text: """
                    Hi! I came across your company and wanted to ask \
                    if you’re hiring Android developers at Apple?
                    """,
                date: date.addingTimeInterval(-86_400.0)
            ),
            ChatMessage(
                type: .outgoing,
                text: """
                    Hello! Thanks for reaching out. \
                    Currently, we don't have open positions for Android development, \
                    as Apple focuses mainly on iOS ecosystem roles.
                    """,
                date: date.addingTimeInterval(-85_800.0)
            ),
            ChatMessage(
                type: .incoming,
                text: """
                    I see. Actually, I have some experience with iOS as well. \
                    Would you consider me for an iOS Developer role?
                    """,
                date: date.addingTimeInterval(-85_400.0)
            ),
            ChatMessage(
                type: .outgoing,
                text: """
                    Absolutely! If you’re interested, we’d love to review your iOS experience \
                    and discuss the position further.
                    """,
                date: date.addingTimeInterval(-85_000.0)
            )
        ],
        isPinned: false
    )

    static let uxDesigner = Self(
        userID: 12,
        messages: [
            ChatMessage(
                type: .outgoing,
                text: """
                    Hi! We've reviewed your portfolio and think you'd be a great fit \
                    for our UX Designer role at Apple.
                    """,
                date: date.addingTimeInterval(-250_000.0)
            ),
            ChatMessage(
                type: .incoming,
                text: """
                    Hello! Thank you for considering me. \
                    I'd love to know more about the role and the team.
                    """,
                date: date.addingTimeInterval(-249_500.0)
            ),
            ChatMessage(
                type: .outgoing,
                text: """
                    The position involves working on user research, wireframes, prototypes, \
                    and collaborating closely with engineers to design intuitive user experiences.
                    """,
                date: date.addingTimeInterval(-248_700.0)
            ),
            ChatMessage(
                type: .incoming,
                text: """
                    That sounds exciting! What tools and methodologies does your team typically use?
                    """,
                date: date.addingTimeInterval(-248_200.0)
            ),
            ChatMessage(
                type: .outgoing,
                text: """
                    We mainly use Figma and Sketch for design, and conduct regular usability testing sessions. \
                    Agile methodology guides our development cycles.
                    """,
                date: date.addingTimeInterval(-247_500.0)
            ),
            ChatMessage(
                type: .incoming,
                text: """
                    Great! I have extensive experience with Figma, and I've run usability studies \
                    that led to significant UI improvements.
                    """,
                date: date.addingTimeInterval(-246_900.0)
            ),
            ChatMessage(
                type: .outgoing,
                text: """
                    That's perfect. Can you share a specific project \
                    where your UX work dramatically improved user engagement or satisfaction?
                    """,
                date: date.addingTimeInterval(-200_000.0)
            ),
            ChatMessage(
                type: .incoming,
                text: """
                    Absolutely. At my previous company, I redesigned the onboarding flow \
                    which increased user retention by over 30%.
                    """,
                date: date.addingTimeInterval(-199_500.0)
            ),
            ChatMessage(
                type: .outgoing,
                text: """
                    Impressive! How comfortable are you working with cross-functional teams \
                    and managing feedback from multiple stakeholders?
                    """,
                date: date.addingTimeInterval(-199_000.0)
            ),
            ChatMessage(
                type: .incoming,
                text: """
                    Very comfortable. I regularly facilitate workshops \
                    and incorporate feedback iteratively to align designs with business goals.
                    """,
                date: date.addingTimeInterval(-198_600.0)
            ),
            ChatMessage(
                type: .outgoing,
                text: """
                    Excellent. Would you be open to participating in a design challenge \
                    as part of our interview process?
                    """,
                date: date.addingTimeInterval(-180_000.0)
            ),
            ChatMessage(
                type: .incoming,
                text: """
                    Sure, I welcome the opportunity to demonstrate my skills through a design challenge.
                    """,
                date: date.addingTimeInterval(-179_600.0)
            ),
            ChatMessage(
                type: .outgoing,
                text: """
                    Great to hear! We usually allocate about 48 hours for the challenge, \
                    after which we discuss it in a follow-up call.
                    """,
                date: date.addingTimeInterval(-179_100.0)
            ),
            ChatMessage(
                type: .incoming,
                text: """
                    Sounds fair. I'd appreciate any guidelines or resources you can share to prepare.
                    """,
                date: date.addingTimeInterval(-178_700.0)
            ),
            ChatMessage(
                type: .outgoing,
                text: """
                    Absolutely, I will email you a detailed brief and some sample challenges by end of day.
                    """,
                date: date.addingTimeInterval(-10_000.0)
            ),
            ChatMessage(
                type: .incoming,
                text: """
                    Thanks a lot! Also, could you share a bit about the team culture \
                    and work environment at Apple?
                    """,
                date: date.addingTimeInterval(-9500.0)
            ),
            ChatMessage(
                type: .outgoing,
                text: """
                    We foster a collaborative culture with a focus on creativity and innovation. \
                    Employees enjoy a great work-life balance and continuous learning opportunities.
                    """,
                date: date.addingTimeInterval(-9000.0)
            ),
            ChatMessage(
                type: .incoming,
                text: """
                    That's wonderful. I'm passionate about learning and growth, so this sounds ideal.
                    """,
                date: date.addingTimeInterval(-8600.0)
            ),
            ChatMessage(
                type: .outgoing,
                text: """
                    Perfect! When would you be available for the technical interview \
                    and design challenge kickoff?
                    """,
                date: date.addingTimeInterval(-8200.0)
            ),
            ChatMessage(
                type: .incoming,
                text: """
                    I am flexible next week, preferably in the afternoons. \
                    Let me know what works.
                    """,
                date: date.addingTimeInterval(-7800.0)
            ),
            ChatMessage(
                type: .outgoing,
                text: """
                    Let's plan for Tuesday at 3pm then. I'll send the calendar invite shortly.
                    """,
                date: date.addingTimeInterval(-7400.0)
            ),
            ChatMessage(
                type: .incoming,
                text: """
                    Tuesday at 3pm works perfectly. Thanks!
                    """,
                date: date.addingTimeInterval(-7100.0)
            ),
            ChatMessage(
                type: .outgoing,
                text: """
                    Excellent. Meanwhile, feel free to ask if you need any clarifications.
                    """,
                date: date.addingTimeInterval(-6800.0)
            ),
            ChatMessage(
                type: .incoming,
                text: """
                    Will do. By the way, do Apple designers collaborate often with product managers?
                    """,
                date: date.addingTimeInterval(-6500.0)
            ),
            ChatMessage(
                type: .outgoing,
                text: """
                    Yes, very closely. Our process emphasizes cross-team synergy throughout product lifecycle.
                    """,
                date: date.addingTimeInterval(-6100.0)
            ),
            ChatMessage(
                type: .incoming,
                text: """
                    Good to know. Looking forward to collaborating with such dynamic teams.
                    """,
                date: date.addingTimeInterval(-5800.0)
            ),
            ChatMessage(
                type: .outgoing,
                text: """
                    We’re excited to potentially have you onboard. Thanks for your time today!
                    """,
                date: date.addingTimeInterval(-5400.0)
            ),
            ChatMessage(
                type: .incoming,
                text: """
                    Thank you as well. I appreciate your detailed responses and transparency.
                    """,
                date: date.addingTimeInterval(-5000.0)
            ),
            ChatMessage(
                type: .outgoing,
                text: """
                    You're very welcome. Expect the email shortly with next steps.
                    """,
                date: date.addingTimeInterval(-4700.0)
            ),
            ChatMessage(
                type: .incoming,
                text: """
                    Looking forward to it. Have a great day!
                    """,
                date: date.addingTimeInterval(-4400.0)
            )
        ],
        isPinned: false
    )

    static let all: [Self] = [
        .iOSDeveloper,
        .androidDeveloper,
        .uxDesigner
    ]
}
