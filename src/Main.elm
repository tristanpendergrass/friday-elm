module Main exposing (main)

import Browser
import FightingCard exposing (FightingCard, HazardCardStats)
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import PirateCard
    exposing
        ( PirateCard
        , firstPirateCard
        , pirateCards
        , secondPirateCard
        , twoRandomPirates
        )
import Random


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



-- MODEL


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
    = MainMenu MetagameState MainMenuState
    | InGame MetagameState Game


{-| Gamestate that should be kept no matter if we're in the Main Menu or in a game or what.
-}
type alias MetagameState =
    { games : List Game
    , mostRecentGame : Maybe Game
    , seed : Random.Seed
    }


type alias MainMenuState =
    {}


init : () -> ( Model, Cmd Msg )
init _ =
    ( MainMenu { games = [], mostRecentGame = Nothing, seed = Random.initialSeed 0 } {}, Cmd.none )



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
    case ( model, msg ) of
        ( _, NoOp ) ->
            ( model, Cmd.none )

        ( MainMenu metagameState _, CreateGame difficulty ) ->
            let
                ( newSeed, ( left, right ) ) =
                    twoRandomPirates metagameState.seed

                newGame =
                    NotStartedGame { options = { left = left, right = right, selection = NoPirateSelection } } difficulty
            in
            ( InGame { metagameState | seed = newSeed } newGame, Cmd.none )

        _ ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    case model of
        MainMenu mainMenuState _ ->
            div []
                [ button [ onClick (CreateGame Level1) ] [ text "Create Game" ]
                ]

        InGame _ _ ->
            div []
                [ text "In Game" ]
