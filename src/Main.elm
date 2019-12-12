module Main exposing (main)

import Browser
import Html exposing (Html, div, text)


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



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
    , numberOfFreeCards : Int
    , hazardValue : PirateHazardValue
    , specialAbility : PirateSpecialAbility
    }


{-| Most simply have a Number. If it's Special then show an asterisk and calculate how to beat it by referencing the special ability.
-}
type PirateHazardValue
    = Number Int
    | Special


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
    , selection : Maybe PirateSelection
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
    { games : List Game, mostRecentGame : Maybe Game }


type alias InGameState =
    { currentGame : Game
    , games : List Game
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( MainMenu { games = [], mostRecentGame = Nothing }, Cmd.none )



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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div [] [ text "Why hello there" ]
