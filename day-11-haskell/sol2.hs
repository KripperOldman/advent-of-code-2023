import Data.Char
import System.IO (isEOF)

main = mainLoop []

expansionRate = 999_999

transpose :: [[a]] -> [[a]]
transpose lst = if all null lst then [] else map head lst : transpose (map tail lst)

emptyColumns :: [[Char]] -> [Bool]
emptyColumns rows = map (all (== '.')) (transpose rows)

extractGalaxyRow_ :: [Bool] -> Int -> Int -> Int -> [Char] -> [(Int, Int)]
extractGalaxyRow_ colFlags offset y x [] = []
extractGalaxyRow_ colFlags offset y x (g : gs)
  | g == '#' = (x + offset, y) : extractGalaxyRow_ colFlags offset y (x + 1) gs
  | colFlags!!x = extractGalaxyRow_ colFlags (offset + expansionRate) y (x + 1) gs
  | otherwise = extractGalaxyRow_ colFlags offset y (x + 1) gs

extractGalaxies_ :: [Bool] -> Int -> Int -> [[Char]] -> [(Int, Int)]
extractGalaxies_ colFlags offset y [] = []
extractGalaxies_ colFlags offset y (row : rows) =
  if all (== '.') row
    then extractGalaxies_ colFlags (offset + expansionRate) (y + 1) rows
    else extractGalaxyRow_ colFlags 0 (y +  offset) 0 row ++ extractGalaxies_ colFlags offset (y + 1) rows

extractGalaxies :: [[Char]] -> [(Int, Int)]
extractGalaxies rows = extractGalaxies_ (emptyColumns rows) 0 0 rows

calculateDistances :: [(Int, Int)] -> [Int]
calculateDistances points =
  map calculateDistance (subsets 2 points)

calculateDistance :: [(Int, Int)] -> Int
calculateDistance ((x1, y1) : (x2, y2) : _) = abs (x1 - x2) + abs (y1 - y2)

subsets :: Int -> [a] -> [[a]]
subsets 0 _ = [[]]
subsets _ [] = []
subsets n (x : xs) = map (x :) (subsets (n - 1) xs) ++ subsets n xs

mainLoop lines = do
  done <- isEOF
  if done
    then
      print $
        sum $
        calculateDistances $
          extractGalaxies lines
    else do
      line <- getLine
      mainLoop (lines ++ [line])
