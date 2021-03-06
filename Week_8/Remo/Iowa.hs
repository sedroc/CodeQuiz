{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}

module Iowa where

import CsvHelper
import CustomFields

import Data.Maybe
import Data.Text.Lazy (Text)
import Data.Time.Clock (UTCTime)
import GHC.Generics (Generic)

import Data.Csv 
import Data.Aeson (ToJSON)

import qualified Data.Vector as V
import qualified Data.ByteString.Lazy.Char8 as L8


data VoterRegistration = VoterRegistration {
                            date :: UTCTime,
                            fips :: Text,
                            county :: Text,
                            democratActive :: Maybe Int,
                            republicanActive :: Maybe Int,
                            libertarianActive :: Maybe Int,
                            noPartyActive :: Maybe Int,
                            otherActive :: Maybe Int,
                            totalActive :: Maybe Int,
                            democratInactive :: Maybe Int,
                            republicanInactive :: Maybe Int,
                            libertarianInactive :: Maybe Int,
                            noPartyInactive :: Maybe Int,
                            otherInactive :: Maybe Int,
                            totalInactive :: Maybe Int,
                            grandTotal :: Int,
                            primaryLatDec :: Double,
                            primaryLongDec :: Double,
                            primaryCountyCoordinates :: !Text
                         } deriving (Show, Generic)


instance ToJSON VoterRegistration

instance FromNamedRecord VoterRegistration where
    parseNamedRecord m = VoterRegistration
                      <$> m .: "Date"
                      <*> m .: "FIPS"
                      <*> m .: "County"
                      <*> m .: "Democrat - Active" 
                      <*> m .: "Republican - Active" 
                      <*> m .: "Libertarian - Active"
                      <*> m .: "No Party - Active"
                      <*> m .: "Other - Active"
                      <*> m .: "Total - Active"
                      <*> m .: "Democrat - Inactive"
                      <*> m .: "Republican - Inactive"
                      <*> m .: "Libertarian - Inactive"
                      <*> m .: "No Party - Inactive"
                      <*> m .: "Other - Inactive"
                      <*> m .: "Total - Inactive"
                      <*> m .: "Grand Total"
                      <*> m .: "Primary Lat Dec"
                      <*> m .: "Primary Long Dec"
                      <*> m .: "Primary County Coordinates"


iowaFilePath = "data/State_of_Iowa_-_Monthly_Voter_Registration_Totals_by_County.csv"

testLoadIowa numRows s = V.toList . fromJust $ V.take numRows <$> (justRecords . decodeIowa $ s)
testLoadIowaFile numRows fp = testLoadIowa numRows <$> L8.readFile fp

decodeIowa :: L8.ByteString -> Either String (Header, V.Vector VoterRegistration)
decodeIowa = decodeByNameWith decodeOptions

decodeOptions = defaultDecodeOptions
