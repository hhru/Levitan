import Foundation
import Levitan

// swiftlint:disable file_length

struct User: Changeable, Hashable, Sendable {

    let id: Int

    var photoURL: URL?
    var name: String
    var description: String
    var rating: Int

    var isFavorite: Bool
}

extension User {

    static let all: [Self] = [
        Self(
            id: 1,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/1.jpg"),
            name: "John Doe",
            description: "iOS Developer",
            rating: 1,
            isFavorite: true
        ),
        Self(
            id: 2,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/2.jpg"),
            name: "Jane Smith",
            description: "Android Developer",
            rating: 2,
            isFavorite: true
        ),
        Self(
            id: 3,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/3.jpg"),
            name: "Michael Johnson",
            description: "Data Scientist",
            rating: 0,
            isFavorite: true
        ),
        Self(
            id: 4,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/4.jpg"),
            name: "Emily Davis",
            description: "Graphic Designer",
            rating: 0,
            isFavorite: true
        ),
        Self(
            id: 5,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/5.jpg"),
            name: "David Martinez",
            description: "Project Manager",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 6,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/6.jpg"),
            name: "Sarah Garcia",
            description: "SEO Specialist",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 7,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/7.jpg"),
            name: "James Wilson",
            description: "Software Engineer",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 8,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/8.jpg"),
            name: "Jessica Lopez",
            description: "Marketing Manager",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 9,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/9.jpg"),
            name: "Robert Brown",
            description: "UX Designer",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 10,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/10.jpg"),
            name: "Linda Miller",
            description: "Content Writer",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 11,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/11.jpg"),
            name: "Thomas Anderson",
            description: "Fullstack Developer",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 12,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/12.jpg"),
            name: "Sophia Turner",
            description: "UX/UI Designer",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 13,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/13.jpg"),
            name: "Daniel Clark",
            description: "DevOps Engineer",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 14,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/14.jpg"),
            name: "Olivia Scott",
            description: "Product Owner",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 15,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/15.jpg"),
            name: "Ethan Parker",
            description: "Mobile Developer",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 16,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/16.jpg"),
            name: "Mia Evans",
            description: "QA Engineer",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 17,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/17.jpg"),
            name: "Lucas Morgan",
            description: "Backend Developer",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 18,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/18.jpg"),
            name: "Amelia Reed",
            description: "Content Strategist",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 19,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/19.jpg"),
            name: "Nathan Murphy",
            description: "Cybersecurity Analyst",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 20,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/20.jpg"),
            name: "Isabella Foster",
            description: "HR Specialist",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 21,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/21.jpg"),
            name: "Alexander Hayes",
            description: "Cloud Architect",
            rating: 1,
            isFavorite: true
        ),
        Self(
            id: 22,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/22.jpg"),
            name: "Chloe Morgan",
            description: "Business Analyst",
            rating: 2,
            isFavorite: true
        ),
        Self(
            id: 23,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/23.jpg"),
            name: "Jack White",
            description: "Machine Learning Engineer",
            rating: 0,
            isFavorite: true
        ),
        Self(
            id: 24,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/24.jpg"),
            name: "Lily Baker",
            description: "Social Media Manager",
            rating: 0,
            isFavorite: true
        ),
        Self(
            id: 25,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/25.jpg"),
            name: "Matthew Hill",
            description: "Solutions Architect",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 26,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/26.jpg"),
            name: "Ella Campbell",
            description: "PR Specialist",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 27,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/27.jpg"),
            name: "Benjamin Evans",
            description: "Network Engineer",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 28,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/28.jpg"),
            name: "Zoe Adams",
            description: "Copywriter",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 29,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/29.jpg"),
            name: "Samuel Brooks",
            description: "Scrum Master",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 30,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/30.jpg"),
            name: "Grace Morris",
            description: "Art Director",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 31,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/31.jpg"),
            name: "Aaron Cook",
            description: "Security Engineer",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 32,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/32.jpg"),
            name: "Natalie Rivera",
            description: "Product Designer",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 33,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/33.jpg"),
            name: "Elijah Price",
            description: "Mobile Architect",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 34,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/34.jpg"),
            name: "Hannah Howard",
            description: "Technical Writer",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 35,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/35.jpg"),
            name: "Ryan Bell",
            description: "Data Engineer",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 36,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/36.jpg"),
            name: "Elizabeth Ward",
            description: "Customer Support",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 37,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/37.jpg"),
            name: "Jacob Russell",
            description: "Technical Lead",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 38,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/38.jpg"),
            name: "Megan Bailey",
            description: "HR Manager",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 39,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/39.jpg"),
            name: "Christopher Jenkins",
            description: "QA Lead",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 40,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/40.jpg"),
            name: "Abigail Long",
            description: "Digital Strategist",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 41,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/41.jpg"),
            name: "Jonathan Simmons",
            description: "Lead Developer",
            rating: 1,
            isFavorite: true
        ),
        Self(
            id: 42,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/42.jpg"),
            name: "Victoria Foster",
            description: "Product Manager",
            rating: 2,
            isFavorite: true
        ),
        Self(
            id: 43,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/43.jpg"),
            name: "Adam Bryant",
            description: "Cloud Engineer",
            rating: 0,
            isFavorite: true
        ),
        Self(
            id: 44,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/44.jpg"),
            name: "Ella Cooper",
            description: "Brand Manager",
            rating: 0,
            isFavorite: true
        ),
        Self(
            id: 45,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/45.jpg"),
            name: "Nathaniel Howard",
            description: "Solutions Engineer",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 46,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/46.jpg"),
            name: "Avery Ward",
            description: "Social Media Specialist",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 47,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/47.jpg"),
            name: "Henry West",
            description: "System Administrator",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 48,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/48.jpg"),
            name: "Samantha Hughes",
            description: "Copy Editor",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 49,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/49.jpg"),
            name: "Owen Reed",
            description: "Scrum Product Owner",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 50,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/50.jpg"),
            name: "Madison Patterson",
            description: "Art Manager",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 51,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/51.jpg"),
            name: "Isaac Collins",
            description: "Information Security Manager",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 52,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/52.jpg"),
            name: "Scarlett Rogers",
            description: "Visual Designer",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 53,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/53.jpg"),
            name: "Anthony Price",
            description: "Mobile UX Designer",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 54,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/54.jpg"),
            name: "Natalia Ross",
            description: "Content Manager",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 55,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/55.jpg"),
            name: "Julian Watson",
            description: "Data Analyst",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 56,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/56.jpg"),
            name: "Luna Brooks",
            description: "Customer Success Manager",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 57,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/57.jpg"),
            name: "Levi Sanders",
            description: "Tech Support Engineer",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 58,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/58.jpg"),
            name: "Zara Bennett",
            description: "HR Coordinator",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 59,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/59.jpg"),
            name: "David Griffin",
            description: "QA Tester",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 60,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/60.jpg"),
            name: "Sofia Foster",
            description: "Digital Marketing Specialist",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 61,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/61.jpg"),
            name: "Charles Coleman",
            description: "Lead Architect",
            rating: 1,
            isFavorite: true
        ),
        Self(
            id: 62,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/62.jpg"),
            name: "Aria Rivera",
            description: "Product Analyst",
            rating: 2,
            isFavorite: true
        ),
        Self(
            id: 63,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/63.jpg"),
            name: "Gabriel Sanders",
            description: "AI Researcher",
            rating: 0,
            isFavorite: true
        ),
        Self(
            id: 64,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/64.jpg"),
            name: "Julia Russell",
            description: "Community Manager",
            rating: 0,
            isFavorite: true
        ),
        Self(
            id: 65,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/65.jpg"),
            name: "Nathan Wells",
            description: "Infrastructure Engineer",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 66,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/66.jpg"),
            name: "Penelope Armstrong",
            description: "Account Manager",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 67,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/67.jpg"),
            name: "Caleb Butler",
            description: "Release Manager",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 68,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/68.jpg"),
            name: "Camila Stone",
            description: "Editor",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 69,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/69.jpg"),
            name: "Dylan Ross",
            description: "Product Owner",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 70,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/70.jpg"),
            name: "Madeline Cox",
            description: "Art Supervisor",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 71,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/71.jpg"),
            name: "Jason Hughes",
            description: "Security Consultant",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 72,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/72.jpg"),
            name: "Alexa Jenkins",
            description: "Interface Designer",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 73,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/73.jpg"),
            name: "Kevin Simpson",
            description: "Mobile UX Engineer",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 74,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/74.jpg"),
            name: "Stephanie Foster",
            description: "Content Coordinator",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 75,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/75.jpg"),
            name: "Brian Simmons",
            description: "Information Analyst",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 76,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/76.jpg"),
            name: "Gabriella Rivera",
            description: "Customer Service Lead",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 77,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/77.jpg"),
            name: "Evan Gordon",
            description: "Tech Support Specialist",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 78,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/78.jpg"),
            name: "Katherine Patterson",
            description: "Recruitment Specialist",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 79,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/79.jpg"),
            name: "George Butler",
            description: "QA Analyst",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 80,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/80.jpg"),
            name: "Clara Bryant",
            description: "Digital Content Strategist",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 81,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/81.jpg"),
            name: "Samuel Hughes",
            description: "Chief Technology Officer",
            rating: 1,
            isFavorite: true
        ),
        Self(
            id: 82,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/82.jpg"),
            name: "Nora Ellis",
            description: "Product Owner",
            rating: 2,
            isFavorite: true
        ),
        Self(
            id: 83,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/83.jpg"),
            name: "Felix Chambers",
            description: "Data Scientist",
            rating: 0,
            isFavorite: true
        ),
        Self(
            id: 84,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/84.jpg"),
            name: "Ruby Rogers",
            description: "Brand Consultant",
            rating: 0,
            isFavorite: true
        ),
        Self(
            id: 85,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/85.jpg"),
            name: "Henry Newman",
            description: "Infrastructure Specialist",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 86,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/86.jpg"),
            name: "Ella Hammonds",
            description: "Community Coordinator",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 87,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/87.jpg"),
            name: "Omar Knight",
            description: "System Engineer",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 88,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/88.jpg"),
            name: "Molly Hunter",
            description: "Editor-in-Chief",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 89,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/89.jpg"),
            name: "Adrian Black",
            description: "Product Strategist",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 90,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/90.jpg"),
            name: "Kimberly Larson",
            description: "Art Coordinator",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 91,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/91.jpg"),
            name: "Julian Doyle",
            description: "Security Analyst",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 92,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/92.jpg"),
            name: "Ivy Webb",
            description: "Visual Design Lead",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 93,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/93.jpg"),
            name: "Patrick Shaw",
            description: "Mobile Design Lead",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 94,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/94.jpg"),
            name: "Alice Morales",
            description: "Content Specialist",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 95,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/95.jpg"),
            name: "Zachary Dean",
            description: "Data Analyst",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 96,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/96.jpg"),
            name: "Maria Ross",
            description: "Customer Relations",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 97,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/97.jpg"),
            name: "Alex Turner",
            description: "Support Engineer",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 98,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/98.jpg"),
            name: "Claudia Hardy",
            description: "Recruiter",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 99,
            photoURL: URL(string: "https://randomuser.me/api/portraits/men/99.jpg"),
            name: "Eli Patterson",
            description: "QA Specialist",
            rating: 0,
            isFavorite: false
        ),
        Self(
            id: 100,
            photoURL: URL(string: "https://randomuser.me/api/portraits/women/100.jpg"),
            name: "Alina Grant",
            description: "Digital Content Manager",
            rating: 0,
            isFavorite: false
        )
    ]
}
