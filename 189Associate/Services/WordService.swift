import Foundation

final class WordService {
    private let storageService: StorageServiceProtocol

    init(storageService: StorageServiceProtocol = UserDefaultsStorageService()) {
        self.storageService = storageService
    }

    func getWords(for category: Category? = nil, difficulty: Difficulty? = nil) -> [Word] {
        var words = loadWords()

        if let category {
            let categoryWords = words.filter { $0.category == category }
            if categoryWords.isEmpty {
                let defaults = getDefaultWords().filter { $0.category == category }
                words.append(contentsOf: defaults)
                storageService.save(words, forKey: StorageKeys.words)
            }
        }

        if let category {
            words = words.filter { $0.category == category }
        }

        if let difficulty {
            words = words.filter { $0.difficulty == difficulty }
        }

        return words
    }

    private func loadWords() -> [Word] {
        var words: [Word] = storageService.load(forKey: StorageKeys.words)

        if words.isEmpty {
            words = getDefaultWords()
            storageService.save(words, forKey: StorageKeys.words)
        }

        return words
    }

    func addWord(_ word: Word) {
        storageService.append(word, forKey: StorageKeys.words)
    }

    func getDefaultWords() -> [Word] {
        [
            Word(id: UUID(), text: "Cat", category: .animals, difficulty: .easy,
                 associations: ["Purring", "Fluffy", "Tail", "Milk", "Meow"]),
            Word(id: UUID(), text: "Dog", category: .animals, difficulty: .easy,
                 associations: ["Loyalty", "Bark", "Bone", "Fur", "Leash"]),
            Word(id: UUID(), text: "Lion", category: .animals, difficulty: .medium,
                 associations: ["Mane", "King", "Roar", "Pride", "Savanna"]),
            Word(id: UUID(), text: "Pizza", category: .food, difficulty: .easy,
                 associations: ["Cheese", "Dough", "Sauce", "Tomatoes", "Oven"]),
            Word(id: UUID(), text: "Sushi", category: .food, difficulty: .medium,
                 associations: ["Rice", "Nori", "Salmon", "Soy sauce", "Wasabi"]),
            Word(id: UUID(), text: "Soup", category: .food, difficulty: .medium,
                 associations: ["Bowl", "Hot", "Spoon", "Broth", "Comfort"]),
            Word(id: UUID(), text: "Paris", category: .cities, difficulty: .easy,
                 associations: ["Eiffel Tower", "Romance", "France", "Croissant", "Seine"]),
            Word(id: UUID(), text: "Tokyo", category: .cities, difficulty: .medium,
                 associations: ["Cherry blossom", "Sushi", "Technology", "Japan", "Temple"]),
            Word(id: UUID(), text: "London", category: .cities, difficulty: .easy,
                 associations: ["Big Ben", "Rain", "Tea", "Thames", "Museum"]),
            Word(id: UUID(), text: "Doctor", category: .professions, difficulty: .easy,
                 associations: ["Hospital", "Medicine", "Heal", "Stethoscope", "Coat"]),
            Word(id: UUID(), text: "Teacher", category: .professions, difficulty: .easy,
                 associations: ["School", "Lessons", "Board", "Students", "Knowledge"]),
            Word(id: UUID(), text: "Programmer", category: .professions, difficulty: .medium,
                 associations: ["Code", "Computer", "Algorithms", "Office", "Technology"]),
            Word(id: UUID(), text: "Happiness", category: .feelings, difficulty: .easy,
                 associations: ["Smile", "Joy", "Love", "Luck", "Light"]),
            Word(id: UUID(), text: "Sadness", category: .feelings, difficulty: .easy,
                 associations: ["Tears", "Melancholy", "Autumn", "Loneliness", "Rain"]),
            Word(id: UUID(), text: "Fear", category: .feelings, difficulty: .medium,
                 associations: ["Darkness", "Trembling", "Adrenaline", "Danger", "Heart"]),
            Word(id: UUID(), text: "Red", category: .colors, difficulty: .easy,
                 associations: ["Fire", "Love", "Blood", "Rose", "Traffic light"]),
            Word(id: UUID(), text: "Blue", category: .colors, difficulty: .easy,
                 associations: ["Sky", "Sea", "Sadness", "Cold", "Eyes"]),
            Word(id: UUID(), text: "Forest", category: .nature, difficulty: .easy,
                 associations: ["Trees", "Mushrooms", "Hedgehog", "Silence", "Walk"]),
            Word(id: UUID(), text: "Ocean", category: .nature, difficulty: .easy,
                 associations: ["Waves", "Sand", "Seagulls", "Salt", "Sunset"]),
            Word(id: UUID(), text: "Internet", category: .technology, difficulty: .medium,
                 associations: ["Wi-Fi", "Websites", "Social media", "Speed", "Global"]),
            Word(id: UUID(), text: "Football", category: .sport, difficulty: .easy,
                 associations: ["Ball", "Goal", "Net", "Team", "Stadium"]),
            Word(id: UUID(), text: "Running", category: .sport, difficulty: .easy,
                 associations: ["Speed", "Training", "Marathon", "Sneakers", "Health"]),
            Word(id: UUID(), text: "Music", category: .art, difficulty: .easy,
                 associations: ["Notes", "Melody", "Voice", "Piano", "Rhythm"]),
            Word(id: UUID(), text: "Painting", category: .art, difficulty: .medium,
                 associations: ["Paint", "Artist", "Museum", "Masterpiece", "Frame"]),
            Word(id: UUID(), text: "Tiger", category: .animals, difficulty: .hard,
                 associations: ["Stripes", "Jungle", "Hunt", "Fierce", "Predator"]),
            Word(id: UUID(), text: "Steak", category: .food, difficulty: .hard,
                 associations: ["Grill", "Juicy", "Knife", "Restaurant", "Medium rare"]),
            Word(id: UUID(), text: "Dubai", category: .cities, difficulty: .hard,
                 associations: ["Desert", "Skyscraper", "Luxury", "UAE", "Heat"]),
            Word(id: UUID(), text: "Pilot", category: .professions, difficulty: .hard,
                 associations: ["Cockpit", "Sky", "Wings", "Flight", "Uniform"]),
            Word(id: UUID(), text: "Anxiety", category: .feelings, difficulty: .hard,
                 associations: ["Worry", "Stress", "Panic", "Sweat", "Nervous"]),
            Word(id: UUID(), text: "Violet", category: .colors, difficulty: .hard,
                 associations: ["Purple", "Flower", "Royal", "Twilight", "Lavender"]),
            Word(id: UUID(), text: "Volcano", category: .nature, difficulty: .hard,
                 associations: ["Lava", "Eruption", "Ash", "Magma", "Crater"]),
            Word(id: UUID(), text: "Robot", category: .technology, difficulty: .hard,
                 associations: ["AI", "Machine", "Metal", "Future", "Automation"]),
            Word(id: UUID(), text: "Boxing", category: .sport, difficulty: .hard,
                 associations: ["Gloves", "Ring", "Punch", "Knockout", "Round"]),
            Word(id: UUID(), text: "Sculpture", category: .art, difficulty: .hard,
                 associations: ["Stone", "Museum", "Chisel", "Marble", "Statue"]),
            Word(id: UUID(), text: "Phone", category: .technology, difficulty: .easy,
                 associations: ["Call", "Screen", "Apps", "Battery", "Message"]),
            Word(id: UUID(), text: "Green", category: .colors, difficulty: .medium,
                 associations: ["Grass", "Forest", "Nature", "Leaf", "Spring"])
        ]
    }
}
