import Foundation
import Combine
#if canImport(UIKit)
import UIKit
#endif

@MainActor
final class CheckInViewModel: ObservableObject {
    @Published var isCheckingIn: Bool = false
    @Published var showCelebration: Bool = false
    @Published var reward: GamificationService.CheckInReward?
    @Published var didLevelUp: Bool = false
    @Published var newBadges: [Badge] = []
    @Published var isInRange: Bool = false
    @Published var distanceText: String?

    private let gamificationService: GamificationService
    private let locationService: LocationService

    init(gamificationService: GamificationService? = nil,
         locationService: LocationService? = nil) {
        self.gamificationService = gamificationService ?? GamificationService()
        self.locationService = locationService ?? .shared
    }

    func checkProximity(to church: Church) {
        isInRange = locationService.isWithinCheckInRange(of: church)
        distanceText = locationService.formattedDistance(to: church.coordinate)
    }

    func performCheckIn(at church: Church) async {
        isCheckingIn = true

        // Haptic
        #if canImport(UIKit)
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        #endif

        // Calculate reward
        let isNew = true // In production, check against user's visited churches
        let checkInReward = gamificationService.calculateReward(for: church, isNewChurch: isNew)
        reward = checkInReward

        // Simulate network delay
        try? await Task.sleep(nanoseconds: 800_000_000)

        // Apply reward
        didLevelUp = gamificationService.applyCheckIn(reward: checkInReward)
        newBadges = gamificationService.checkBadgeUnlocks()

        isCheckingIn = false
        showCelebration = true

        // Success haptic
        #if canImport(UIKit)
        let notif = UINotificationFeedbackGenerator()
        notif.notificationOccurred(.success)
        #endif
    }

    func reset() {
        showCelebration = false
        reward = nil
        didLevelUp = false
        newBadges = []
    }

    static var preview: CheckInViewModel {
        let vm = CheckInViewModel()
        vm.reward = GamificationService.CheckInReward(
            baseXP: 50, newChurchBonus: 100, historicBonus: 50, streakBonus: 25
        )
        return vm
    }
}
