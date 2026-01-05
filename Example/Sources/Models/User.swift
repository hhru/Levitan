import Foundation
import Levitan

struct User: Changeable, Hashable, Sendable {

    let id: Int

    var photoURL: URL?
    var name: String
    var description: String
    var rating: Int

    var isFavorite: Bool
}

extension User {

    static let all: [User] = [
        User(
            id: 1,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/1.jpg"),
            name: "John Doe",
            description: "iOS Developer",
            rating: 1,
            isFavorite: true
        ),
        User(
            id: 2,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/2.jpg"),
            name: "Jane Smith",
            description: "Android Developer",
            rating: 2,
            isFavorite: true
        ),
        User(
            id: 3,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/3.jpg"),
            name: "Michael Johnson",
            description: "Data Scientist",
            rating: 0,
            isFavorite: true
        ),
        User(
            id: 4,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/4.jpg"),
            name: "Emily Davis",
            description: "Graphic Designer",
            rating: 0,
            isFavorite: true
        ),
        User(
            id: 5,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/5.jpg"),
            name: "David Martinez",
            description: "Project Manager",
            rating: 0,
            isFavorite: false
        ),
        User(
            id: 6,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/6.jpg"),
            name: "Sarah Garcia",
            description: "SEO Specialist",
            rating: 0,
            isFavorite: false
        ),
        User(
            id: 7,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/7.jpg"),
            name: "James Wilson",
            description: "Software Engineer",
            rating: 0,
            isFavorite: false
        ),
        User(
            id: 8,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/8.jpg"),
            name: "Jessica Lopez",
            description: "Marketing Manager",
            rating: 0,
            isFavorite: false
        ),
        User(
            id: 9,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/9.jpg"),
            name: "Robert Brown",
            description: "UX Designer",
            rating: 0,
            isFavorite: false
        ),
        User(
            id: 10,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/10.jpg"),
            name: "Linda Miller",
            description: "Content Writer",
            rating: 0,
            isFavorite: false
        ),
        User(
            id: 11,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/11.jpg"),
            name: "Thomas Anderson",
            description: "Fullstack Developer",
            rating: 0,
            isFavorite: false
        ),
        User(
            id: 12,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/12.jpg"),
            name: "Sophia Turner",
            description: "UX/UI Designer",
            rating: 0,
            isFavorite: false
        ),
        User(
            id: 13,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/13.jpg"),
            name: "Daniel Clark",
            description: "DevOps Engineer",
            rating: 0,
            isFavorite: false
        ),
        User(
            id: 14,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/14.jpg"),
            name: "Olivia Scott",
            description: "Product Owner",
            rating: 0,
            isFavorite: false
        ),
        User(
            id: 15,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/15.jpg"),
            name: "Ethan Parker",
            description: "Mobile Developer",
            rating: 0,
            isFavorite: false
        ),
        User(
            id: 16,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/16.jpg"),
            name: "Mia Evans",
            description: "QA Engineer",
            rating: 0,
            isFavorite: false
        ),
        User(
            id: 17,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/17.jpg"),
            name: "Lucas Morgan",
            description: "Backend Developer",
            rating: 0,
            isFavorite: false
        ),
        User(
            id: 18,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/18.jpg"),
            name: "Amelia Reed",
            description: "Content Strategist",
            rating: 0,
            isFavorite: false
        ),
        User(
            id: 19,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/19.jpg"),
            name: "Nathan Murphy",
            description: "Cybersecurity Analyst",
            rating: 0,
            isFavorite: false
        ),
        User(
            id: 20,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/20.jpg"),
            name: "Isabella Foster",
            description: "HR Specialist",
            rating: 0,
            isFavorite: false
        )
    ]
}
