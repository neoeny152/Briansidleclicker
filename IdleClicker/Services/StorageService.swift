import Foundation

class StorageService {
    private let gameStateKey = "com.idleclicker.gamestate"

    func saveGameState(_ state: GameState) {
        do {
            let data = try JSONEncoder().encode(state)
            UserDefaults.standard.set(data, forKey: gameStateKey)
        } catch {
            print("Failed to save game state: \(error)")
        }
    }

    func loadGameState() -> GameState? {
        guard let data = UserDefaults.standard.data(forKey: gameStateKey) else {
            return nil
        }

        do {
            let state = try JSONDecoder().decode(GameState.self, from: data)
            return state
        } catch {
            print("Failed to load game state: \(error)")
            return nil
        }
    }

    func resetGameState() {
        UserDefaults.standard.removeObject(forKey: gameStateKey)
    }
}
