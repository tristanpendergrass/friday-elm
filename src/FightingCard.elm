module FightingCard exposing
    ( AgingCardStats
    , FightingCard
    , HazardCardStats
    , RobinsonCardStats
    , firstHazardCard
    , hazardCards
    , secondHazardCard
    )


type FightingCard
    = RobinsonCard RobinsonCardStats
    | HazardCard HazardCardStats
    | AgingCard AgingCardStats


type alias RobinsonCardStats =
    { id : Int
    , title : String
    , fightingValue : Int
    , specialAbility : SpecialAbility
    }


type SpecialAbility
    = NoAbility
    | HealOne
    | HealTwo
    | DrawOne
    | DrawTwo
    | Destroy
    | Double
    | Copy
    | PhaseMinusOne
    | SortThreeCards
    | ExchangeOne
    | ExchangeTwo
    | BelowTheStack


{-| All Hazard cards have a hazard half and a player half. The player half is used if the card is in the player's deck
and hazard half if it's in the hazard deck
-}
type alias HazardCardStats =
    { id : Int
    , hazardTitle : String
    , numberOfFreeCards : Int
    , redPhaseHazardValue : Int
    , yellowPhaseHazardValue : Int
    , greenPhaseHazardValue : Int
    , robinsonTitle : String
    , fightingValue : Int
    , specialAbility : SpecialAbility
    }


type alias AgingCardStats =
    { id : Int
    , title : String
    , fightingValue : Int
    , specialAbility : AgingSpecialAbility
    , lifeCost : AgingLifeCost
    , agingSeverity : AgingSeverity
    }


type AgingSpecialAbility
    = LoseOne
    | LoseTwo
    | HighestCardZero
    | Stop


type AgingLifeCost
    = One
    | Two


type AgingSeverity
    = Normal
    | Difficult



-- FIXTURES


firstRobinsonCard : FightingCard
firstRobinsonCard =
    RobinsonCard { id = 201, title = "weak", fightingValue = 0, specialAbility = NoAbility }


secondRobinsonCard : FightingCard
secondRobinsonCard =
    RobinsonCard { id = 202, title = "distracted", fightingValue = -1, specialAbility = NoAbility }


robinsonCards : List FightingCard
robinsonCards =
    [ firstRobinsonCard
    , secondRobinsonCard
    , RobinsonCard { id = 203, title = "weak", fightingValue = 0, specialAbility = NoAbility }
    , RobinsonCard { id = 204, title = "distracted", fightingValue = -1, specialAbility = NoAbility }
    ]


firstHazardCard : FightingCard
firstHazardCard =
    HazardCard
        { id = 301
        , hazardTitle = "With the raft to the wreck"
        , numberOfFreeCards = 1
        , redPhaseHazardValue = 3
        , yellowPhaseHazardValue = 1
        , greenPhaseHazardValue = 0
        , robinsonTitle = "food"
        , fightingValue = 0
        , specialAbility = HealOne
        }


secondHazardCard : FightingCard
secondHazardCard =
    HazardCard
        { id = 302
        , hazardTitle = "Exploring the island"
        , numberOfFreeCards = 2
        , redPhaseHazardValue = 6
        , yellowPhaseHazardValue = 3
        , greenPhaseHazardValue = 1
        , robinsonTitle = "food"
        , fightingValue = 0
        , specialAbility = HealOne
        }


hazardCards : List FightingCard
hazardCards =
    [ firstHazardCard
    , secondHazardCard
    ]
