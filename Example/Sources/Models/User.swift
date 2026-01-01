import Foundation

struct User: Hashable {

    let id: Int

    let photoURL: URL?
    let firstName: String
    let lastName: String
    let city: String

    let phoneNumber: String
    let emailAddress: String

    let position: String
    let skills: [String]
    let aboutMe: String

    var fullName: String {
        "\(firstName) \(lastName)"
    }
}

extension User {

    static let all: [User] = [
        User(
            id: 1,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/1.jpg"),
            firstName: "John",
            lastName: "Doe",
            city: "New York, USA",
            phoneNumber: "+1-212-555-0101",
            emailAddress: "john.doe@example.com",
            position: "iOS Developer",
            skills: ["Swift", "SwiftUI", "UIKit", "Xcode"],
            aboutMe: """
                - I love coding
                - I enjoy hiking
                - I'm a coffee addict
                - I play guitar
                - I travel often
                """
        ),
        User(
            id: 2,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/2.jpg"),
            firstName: "Jane",
            lastName: "Smith",
            city: "London, UK",
            phoneNumber: "+44-20-7946-0958",
            emailAddress: "jane.smith@example.com",
            position: "Android Developer",
            skills: ["Kotlin", "Java", "Android Studio", "Jetpack Compose"],
            aboutMe: """
                - I am a foodie
                - I love painting
                - I have two cats
                - I enjoy yoga
                - I speak three languages
                """
        ),
        User(
            id: 3,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/3.jpg"),
            firstName: "Michael",
            lastName: "Johnson",
            city: "Sydney, Australia",
            phoneNumber: "+61-2-9876-5432",
            emailAddress: "michael.johnson@example.com",
            position: "Data Scientist",
            skills: ["Python", "R", "Machine Learning", "SQL"],
            aboutMe: """
                - I love data
                - I'm a chess enthusiast
                - I run marathons
                - I enjoy cooking
                - I'm a night owl
                """
        ),
        User(
            id: 4,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/4.jpg"),
            firstName: "Emily",
            lastName: "Davis",
            city: "Tokyo, Japan",
            phoneNumber: "+81-3-1234-5678",
            emailAddress: "emily.davis@example.com",
            position: "Graphic Designer",
            skills: ["Photoshop", "Illustrator", "InDesign", "Sketch"],
            aboutMe: """
                - I love design
                - I'm a dog lover
                - I enjoy photography
                - I play video games
                - I'm an early riser
                """
        ),
        User(
            id: 5,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/5.jpg"),
            firstName: "David",
            lastName: "Martinez",
            city: "Barcelona, Spain",
            phoneNumber: "+34-93-1234-5678",
            emailAddress: "david.martinez@example.com",
            position: "Project Manager",
            skills: ["Agile", "Scrum", "Leadership", "Communication"],
            aboutMe: """
                - I love teamwork
                - I'm a sports fan
                - I enjoy reading books
                - I travel frequently
                - I'm a coffee lover
                """
        ),
        User(
            id: 6,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/6.jpg"),
            firstName: "Sarah",
            lastName: "Garcia",
            city: "Berlin, Germany",
            phoneNumber: "+49-30-12345678",
            emailAddress: "sarah.garcia@example.com",
            position: "SEO Specialist",
            skills: ["SEO", "Content Marketing", "Google Analytics", "Keyword Research"],
            aboutMe: """
                - I love analytics
                - I'm a nature enthusiast
                - I enjoy blogging
                - I'm a foodie at heart
                - I have a passion for travel
                """
        ),
        User(
            id: 7,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/7.jpg"),
            firstName: "James",
            lastName: "Wilson",
            city: "Toronto, Canada",
            phoneNumber: "+1-416-555-0107",
            emailAddress: "james.wilson@example.com",
            position: "Software Engineer",
            skills: ["Java", "C++", "Python", "DevOps"],
            aboutMe: """
                - I love coding challenges
                - I'm an avid reader
                - I enjoy hiking on weekends
                - I'm passionate about technology
                - I've built my own PC
                """
        ),
        User(
            id: 8,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/8.jpg"),
            firstName: "Jessica",
            lastName: "Lopez",
            city: "Moscow, Russia",
            phoneNumber: "+7-495-123-45-67",
            emailAddress: "jessica.lopez@example.com",
            position: "Marketing Manager",
            skills: ["Digital Marketing", "Social Media", "Brand Strategy", "Content Creation"],
            aboutMe: """
                - I love storytelling
                - I'm passionate about branding
                - I enjoy networking
                - I've traveled to over 20 countries
                - I'm a huge movie buff
                """
        ),
        User(
            id: 9,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/9.jpg"),
            firstName: "Robert",
            lastName: "Brown",
            city: "São Paulo, Brazil",
            phoneNumber: "+55-11-91234-5678",
            emailAddress: "robert.brown@example.com",
            position: "UX Designer",
            skills: ["User Research", "Wireframing", "Prototyping", "Usability Testing"],
            aboutMe: """
                - I'm passionate about user experience
                - I love solving problems
                - I've worked with startups
                - I'm an avid traveler
                - I enjoy cooking
                """
        ),
        User(
            id: 10,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/10.jpg"),
            firstName: "Linda",
            lastName: "Miller",
            city: "Rome, Italy",
            phoneNumber: "+39-06-12345678",
            emailAddress: "linda.miller@example.com",
            position: "Content Writer",
            skills: ["Copywriting", "Blogging", "SEO", "Social Media"],
            aboutMe: """
                - I'm a wordsmith at heart
                - I love storytelling
                - I've written for major publications
                - I'm an animal lover
                - I enjoy hiking
                """
        ),
        User(
            id: 11,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/11.jpg"),
            firstName: "Thomas",
            lastName: "Anderson",
            city: "San Francisco, USA",
            phoneNumber: "+1-415-555-0111",
            emailAddress: "thomas.anderson@example.com",
            position: "Fullstack Developer",
            skills: ["JavaScript", "React", "Node.js", "AWS"],
            aboutMe: """
                - I love coding
                - I enjoy playing soccer
                - I'm a tech blogger
                - I enjoy traveling
                - I like board games
                """
        ),
        User(
            id: 12,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/12.jpg"),
            firstName: "Sophia",
            lastName: "Turner",
            city: "Dublin, Ireland",
            phoneNumber: "+353-1-234-5678",
            emailAddress: "sophia.turner@example.com",
            position: "UX/UI Designer",
            skills: ["Figma", "Adobe XD", "Sketch", "User Testing"],
            aboutMe: """
                - I love minimalist design
                - I'm a coffee enthusiast
                - I enjoy hiking and nature
                - I paint in my free time
                - I like learning new languages
                """
        ),
        User(
            id: 13,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/13.jpg"),
            firstName: "Daniel",
            lastName: "Clark",
            city: "Chicago, USA",
            phoneNumber: "+1-312-555-0133",
            emailAddress: "daniel.clark@example.com",
            position: "DevOps Engineer",
            skills: ["Docker", "Kubernetes", "AWS", "Terraform"],
            aboutMe: """
                - I love automating workflows
                - I'm an early riser
                - I enjoy mountain biking
                - I play the piano
                - I watch sci-fi movies
                """
        ),
        User(
            id: 14,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/14.jpg"),
            firstName: "Olivia",
            lastName: "Scott",
            city: "Amsterdam, Netherlands",
            phoneNumber: "+31-20-123-4567",
            emailAddress: "olivia.scott@example.com",
            position: "Product Owner",
            skills: ["Agile", "JIRA", "Roadmap Planning", "Communication"],
            aboutMe: """
                - I love empowering teams
                - I enjoy running marathons
                - I like photography
                - I'm a passionate reader
                - I enjoy cooking international dishes
                """
        ),
        User(
            id: 15,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/15.jpg"),
            firstName: "Ethan",
            lastName: "Parker",
            city: "Melbourne, Australia",
            phoneNumber: "+61-3-9876-5432",
            emailAddress: "ethan.parker@example.com",
            position: "Mobile Developer",
            skills: ["Flutter", "Dart", "Firebase", "REST API"],
            aboutMe: """
                - I love cross-platform apps
                - I enjoy surfing
                - I like playing chess
                - I’m a music lover
                - I love coding challenges
                """
        ),
        User(
            id: 16,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/16.jpg"),
            firstName: "Mia",
            lastName: "Evans",
            city: "Vancouver, Canada",
            phoneNumber: "+1-604-555-0166",
            emailAddress: "mia.evans@example.com",
            position: "QA Engineer",
            skills: ["Test Automation", "Selenium", "JUnit", "Bug Tracking"],
            aboutMe: """
                - I love finding bugs
                - I enjoy puzzles and riddles
                - I’m a tea lover
                - I take part in hackathons
                - I enjoy baking
                """
        ),
        User(
            id: 17,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/17.jpg"),
            firstName: "Lucas",
            lastName: "Morgan",
            city: "Chicago, USA",
            phoneNumber: "+1-312-555-0177",
            emailAddress: "lucas.morgan@example.com",
            position: "Backend Developer",
            skills: ["Java", "Spring Boot", "SQL", "Microservices"],
            aboutMe: """
                - I love backend architecture
                - I enjoy woodworking
                - I’m passionate about football
                - I like sci-fi novels
                - I play the drums
                """
        ),
        User(
            id: 18,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/18.jpg"),
            firstName: "Amelia",
            lastName: "Reed",
            city: "Paris, France",
            phoneNumber: "+33-1-2345-6789",
            emailAddress: "amelia.reed@example.com",
            position: "Content Strategist",
            skills: ["SEO", "Content Creation", "Social Media", "Analytics"],
            aboutMe: """
                - I love storytelling
                - I enjoy cycling
                - I’m passionate about art
                - I like volunteering
                - I speak four languages
                """
        ),
        User(
            id: 19,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/19.jpg"),
            firstName: "Nathan",
            lastName: "Murphy",
            city: "Dublin, Ireland",
            phoneNumber: "+353-1-234-5679",
            emailAddress: "nathan.murphy@example.com",
            position: "Cybersecurity Analyst",
            skills: ["Network Security", "Python", "Penetration Testing", "SIEM"],
            aboutMe: """
                - I love cybersecurity puzzles
                - I practice martial arts
                - I enjoy hiking
                - I’m a movie buff
                - I volunteer in community events
                """
        ),
        User(
            id: 20,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/20.jpg"),
            firstName: "Isabella",
            lastName: "Foster",
            city: "Lisbon, Portugal",
            phoneNumber: "+351-21-123-4567",
            emailAddress: "isabella.foster@example.com",
            position: "HR Specialist",
            skills: ["Recruitment", "Employee Engagement", "HR Policies", "Training"],
            aboutMe: """
                - I love helping people grow
                - I enjoy yoga and meditation
                - I’m passionate about volunteering
                - I love traveling
                - I enjoy gardening
                """
        )
    ]
}
