module Main (main) where

import System.IO
import Types
import Fetch
import Parse
import Database

main :: IO ()
main = do
    putStrLn "---------------------------------"
    putStrLn "  Welcome to the Sanitor data app  "
    putStrLn "  (1) Download the data"
    putStrLn "  (2) Display the sanitors of particualr party"
    putStrLn "  (3) Count of sanitors by party "
    putStrLn "  (4) Count of sanitors by state"
    putStrLn "  (5) Count of sanitors by rank"
    putStrLn "  (6) Count of sanitors by rank"
    putStrLn "  (7)Dispaly the details of sanitor by particular party and particualr gender"
    putStrLn "  (8)Count the number of sanitors who have tenure greater than x"
    putStrLn "---------------------------------"
    conn <- initialiseDB
    hSetBuffering stdout NoBuffering
    putStr "Choose an option > "
    option <- readLn :: IO Int
    case option of
        1 -> do
            let url = "https://www.govtrack.us/api/v2/role?current=true&role_type=senator"
            print "Downloading..."
            json <- download url
            print "Parsing..."
            case (parseRecords json) of
                Left err -> print err
                Right recs -> do
                    print "Saving on DB..."
                    saveRecords conn (records recs)
                    print "Saved!"
                    main
        2 -> do
            entries <- queryCountryAllEntries conn
            mapM_ print entries
            main
        3 -> do
            queryCountryTotalCases conn
            main
        4 -> print "Hope you've enjoyed using the app!"
        _ -> print "Invalid option"
