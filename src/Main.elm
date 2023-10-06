module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as D
import Locales exposing (locales)



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Model =
    { language : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { language = "sr-RS" }
    , Cmd.none
    )



-- UPDATE


type Msg
    = LanguageChanged String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LanguageChanged language ->
            ( { model | language = language }
            , Cmd.none
            )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ p [] [ viewDate model.language 2012 5 ]
        , p [] [ text model.language ]
        , select
            [ onInput LanguageChanged
            , id "language-dropdown"
            , name "language-dropdown"
            , title "Choose a langauge of your interest."
            ]
          <|
            List.map (viewOption ((==) model.language)) locales
        ]


viewOption : (String -> Bool) -> ( String, String ) -> Html msg
viewOption select ( code, name ) =
    option [ selected (select code), value code ] [ text <| "[" ++ code ++ "] " ++ name ]



-- Use the Custom Element defined in index.html
--


viewDate : String -> Int -> Int -> Html msg
viewDate lang year month =
    node "intl-date"
        [ attribute "lang" lang
        , attribute "year" (String.fromInt year)
        , attribute "month" (String.fromInt month)
        ]
        []


valueDecoder : D.Decoder String
valueDecoder =
    D.field "currentTarget" (D.field "value" D.string)
