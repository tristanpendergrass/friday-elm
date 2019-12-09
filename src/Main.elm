module Main exposing (main)

import Browser
import Html exposing (Html, div, text)


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



-- MODEL


type alias Id =
    Int


{-| All Hazard cards have a hazard half and a player half. The player half is used if the card is in the player's deck
and hazard half if it's in the hazard deck
-}
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


{-| Cards that start out in the hazard deck and if defeated become part of the player's deck
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
    { name : String
    }


type Game
    = NotStartedGame
    | Game GameState
    | FinishedGame GameFinishedState


type alias GameState =
    { phase : Phase
    , lifePoints : Int
    , deck : List FightingCard
    , discard : List FightingCard
    }


type Phase
    = BossSelectionPhase BossSelectionState
    | HazardSelectionPhase HazardSelectionState
    | EncounterPhase EncounterState
    | ResolutionPhase ResolutionState


type alias BossSelectionState =
    { options : Maybe BossSelectionOptions }


type alias BossSelectionOptions =
    { left : PirateCard
    , right : PirateCard
    , selection : BossSelection
    }


type BossSelection
    = LeftBoss
    | RightBoss


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


type alias GameFinishedState =
    { outcome : GameOutcome
    }


type alias Model =
    { currentGame : Maybe Game
    , games : List Game
    }


init : () -> ( Model, Cmd Msg )
init _ =
    let
        initialGame : Game
        initialGame =
            Game
                { phase = BossSelectionPhase { options = Nothing }
                , lifePoints = 20
                , deck = []
                , discard = []
                }
    in
    ( { currentGame = Nothing, games = [] }, Cmd.none )



-- UPDATE


type Msg
    = NoOp


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
