module PirateCard exposing (PirateCard, firstPirateCard, pirateCards, secondPirateCard, twoRandomPirates)

import Random


type alias PirateCard =
    { id : Int
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


twoRandomPirates : Random.Seed -> ( Random.Seed, ( PirateCard, PirateCard ) )
twoRandomPirates seed =
    let
        ( left, seedAfterLeft ) =
            case pirateCards of
                [] ->
                    ( firstPirateCard, seed )

                first :: rest ->
                    Random.step (Random.uniform first rest) seed

        ( right, seedAfterRight ) =
            case List.filter ((==) left) pirateCards of
                [] ->
                    ( secondPirateCard, seedAfterLeft )

                first :: rest ->
                    Random.step (Random.uniform first rest) seedAfterLeft
    in
    ( seedAfterRight, ( left, right ) )



-- FIXTURES


firstPirateCard : PirateCard
firstPirateCard =
    { id = 103, numberOfFreeCards = StandardPirateFreeCards 9, hazardValue = StandardPirateHazardValue 22, specialAbility = OnlyHalf }


secondPirateCard : PirateCard
secondPirateCard =
    { id = 104, numberOfFreeCards = SpecialPirateFreeCards, hazardValue = SpecialPirateHazardValue, specialAbility = FightAllRemainingHazards }


pirateCards : List PirateCard
pirateCards =
    [ firstPirateCard
    , secondPirateCard
    , { id = 101, numberOfFreeCards = StandardPirateFreeCards 9, hazardValue = StandardPirateHazardValue 35, specialAbility = NoPirateAbility }
    , { id = 102, numberOfFreeCards = StandardPirateFreeCards 7, hazardValue = StandardPirateHazardValue 16, specialAbility = EachAdditionalCardCostsTwo }
    ]
