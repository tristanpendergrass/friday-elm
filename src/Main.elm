module Main exposing (main)

import Browser
import Html exposing (Html, div, text)
import Random


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



-- FIXTURES


defaultLeftPirate : PirateCard
defaultLeftPirate =
    { id = 103, numberOfFreeCards = StandardPirateFreeCards 9, hazardValue = StandardPirateHazardValue 22, specialAbility = OnlyHalf }


defaultRightPirate : PirateCard
defaultRightPirate =
    { id = 104, numberOfFreeCards = SpecialPirateFreeCards, hazardValue = SpecialPirateHazardValue, specialAbility = FightAllRemainingHazards }


pirateCards : List PirateCard
pirateCards =
    [ defaultLeftPirate
    , defaultRightPirate
    , { id = 101, numberOfFreeCards = StandardPirateFreeCards 9, hazardValue = StandardPirateHazardValue 35, specialAbility = NoPirateAbility }
    , { id = 102, numberOfFreeCards = StandardPirateFreeCards 7, hazardValue = StandardPirateHazardValue 16, specialAbility = EachAdditionalCardCostsTwo }
    ]


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



-- MODEL


type alias Id =
    Int


type FightingCard
    = RobinsonCard RobinsonCardStats
    | HazardCard HazardCardStats
    | AgingCard AgingCardStats


{-| Cards that start out in the player's deck
-}
type alias RobinsonCardStats =
    { id : Id
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
    { id : Id
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
    { id : Id
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


type alias PirateCard =
    { id : Id
    , numberOfFreeCards : PirateFreeCards
    , hazardValue : PirateHazardValue
    , specialAbility : PirateSpecialAbility
    }


type PirateFreeCards
    = StandardPirateFreeCards Int
    | SpecialPirateFreeCards


{-| Most simply have a Number. If it's Special then show an asterisk and calculate how to beat it by referencing the special ability.
-}
type PirateHazardValue
    = StandardPirateHazardValue Int
    | SpecialPirateHazardValue


type PirateSpecialAbility
    = NoPirateAbility
    | EachAdditionalCardCostsTwo
    | OnlyHalf
    | AllFightingCardsPlusOne
    | FightAllRemainingHazards
    | AddTwoPerAgingCard


{-| We model it where if you haven't picked a pirate to fight as the final boss yet then the game is a NotStartedGame, and becomes a FinishedGame when you die or win.
-}
type Game
    = NotStartedGame NotStartedGameState Difficulty
    | Game InProgressGameState Difficulty
    | FinishedGame FinishedGameState Difficulty


type Difficulty
    = Level1
    | Level2
    | Level3
    | Level4


type alias NotStartedGameState =
    { options : PirateSelectionOptions }


type alias InProgressGameState =
    { phase : Phase
    , lifePoints : Int
    , deck : List FightingCard
    , discard : List FightingCard
    }


type Phase
    = HazardSelectionPhase HazardSelectionState
    | EncounterPhase EncounterState
    | ResolutionPhase ResolutionState


type alias PirateSelectionOptions =
    { left : PirateCard
    , right : PirateCard
    , selection : PirateSelection
    }


type PirateSelection
    = NoPirateSelection
    | LeftPirate
    | RightPirate


{-| Options is a Maybe because at the start of the phase there are no options given
and after a player initiates a draw action an animation is played and the cards
are randomly picked and become the options.
-}
type alias HazardSelectionState =
    { options : Maybe HazardSelectionOptions
    }


type alias HazardSelectionOptions =
    { left : FightingCard
    , right : FightingCard
    , selection : HazardSelection
    }


type HazardSelection
    = LeftHazard
    | RightHazard


type alias EncounterState =
    { hazard : HazardCardStats
    , leftSide : List FightingCard
    , rightSide : List FightingCard
    }


type alias ResolutionState =
    { playerScore : Int
    , hazard : HazardCardStats
    , cardsPlayed : List FightingCard
    }


type GameOutcome
    = Win
    | Lose


type alias FinishedGameState =
    { outcome : GameOutcome
    }


type Model
    = MainMenu MainMenuState
    | InGame InGameState


type alias MainMenuState =
    { games : List Game
    , mostRecentGame : Maybe Game
    , seed : Random.Seed
    }


type alias InGameState =
    { currentGame : Game
    , games : List Game
    , seed : Random.Seed
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( MainMenu { games = [], mostRecentGame = Nothing, seed = Random.initialSeed 0 }, Cmd.none )



-- UPDATE


{-|

    = BossSelectionPhase BossSelectionState
    | HazardSelectionPhase HazardSelectionState
    | EncounterPhase EncounterState
    | ResolutionPhase ResolutionState

-}
type Msg
    = NoOp
      -- Not in a game
    | CreateGame Difficulty
    | SetCurrentGame (Maybe Game)
    | DeleteGame Game
      -- BossSelectionPhase
    | SetBossSelection PirateSelection
    | ConfirmBossSelection



-- HazardSelectionPhase


twoRandomPirates : Random.Seed -> ( Random.Seed, ( PirateCard, PirateCard ) )
twoRandomPirates seed =
    let
        ( left, seedAfterLeft ) =
            case pirateCards of
                [] ->
                    ( defaultLeftPirate, seed )

                first :: rest ->
                    Random.step (Random.uniform first rest) seed

        ( right, seedAfterRight ) =
            case List.filter ((==) left) pirateCards of
                [] ->
                    ( defaultRightPirate, seedAfterLeft )

                first :: rest ->
                    Random.step (Random.uniform first rest) seedAfterLeft
    in
    ( seedAfterRight, ( left, right ) )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( model, msg ) of
        ( _, NoOp ) ->
            ( model, Cmd.none )

        ( MainMenu mainMenuState, CreateGame difficulty ) ->
            let
                ( newSeed, ( left, right ) ) =
                    twoRandomPirates mainMenuState.seed

                newGame =
                    NotStartedGame { options = { left = left, right = right, selection = NoPirateSelection } } difficulty
            in
            ( InGame { currentGame = newGame, games = newGame :: mainMenuState.games, seed = newSeed }, Cmd.none )

        _ ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div [] [ text "Why hello there" ]
