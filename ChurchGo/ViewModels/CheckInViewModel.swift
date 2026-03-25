import Foundation
import UIKit

@MainActor
final class CheckInViewModel: ObservableObject {
    @Published var isCheckingIn: Bool = false
    @Published var showCelebration: Bool = false
    @Published var reward: GamificationService.CheckInReward?
    @Published var didLevelUp: Bool = false
    @Published var newBadges: [Badge] = []
    @Published var isInRange: Bool = false

    private let gamificationService: GamificationService
    private let locationService: LocationService

    init(gamificationService: GamificationService,
         locationService: LocationService) {
        self.gamificationService = gamificationService
        self.locationService = locationService
    }

    func checkProximity(to church: Church) {
        isInRange = locationService.isWithinCheckInRange(of: church)
    }

    func performCheckIn(at church: Church) async {
        isCheckingIn = true

        // Haptic
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()

        // Calculate reward
        let isNew = true // In production, check against user's visited churches
        let checkInReward = gamificationService.calculateReward(for: church, isNewChurch: isNew)
        reward = checkInReward

        // Simulate network delay
        try? await Task.sleep(for: .milliseconds(800))

        // Apply reward
        didLevelUp = gamificationService.applyCheckIn(reward: checkInReward)
        newBadges = gamificationService.checkBadgeUnlocks()

        isCheckingIn = false
        showCelebration = true

        // Success haptic
        let notif = UINotificationFeedbackGenerator()
        notif.notificationOccurred(.success)
    }

    func reset() {
        showCelebration = false
        reward = nil
        didLevelUp = false
        newBadges = []
    }

    static var preview: CheckInViewModel {
        let vm = CheckInViewModel(
            gamificationService: GamificationService(),
            locationService: LocationService()
        )
        vm.reward = GamificationService.CheckInReward(
            baseXP: 50, newChurchBonus: 100, historicBonus: 50, streakBonus: 25
        )
        return vm
    }
}
