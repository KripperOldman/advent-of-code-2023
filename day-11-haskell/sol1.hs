import Data.Char
import System.IO (isEOF)

main = mainLoop []

expand :: [[Char]] -> [[Char]]
expand [] = []
expand (line : lines) =
  if all (== '.') line
    then line : line : expand lines
    else line : expand lines

transpose :: [[a]] -> [[a]]
transpose lst = if all null lst then [] else map head lst : transpose (map tail lst)

extractGalaxyRow_ :: Int -> Int -> [Char] -> [(Int, Int)]
extractGalaxyRow_ y x [] = []
extractGalaxyRow_ y x (g : gs) =
  if g == '#'
    then (x, y) : extractGalaxyRow_ y (x + 1) gs
    else extractGalaxyRow_ y (x + 1) gs

extractGalaxies_ :: Int -> [[Char]] -> [(Int, Int)]
extractGalaxies_ y [] = []
extractGalaxies_ y (row : rows) =
  extractGalaxyRow_ y 0 row ++ extractGalaxies_ (y + 1) rows

extractGalaxies = extractGalaxies_ 0

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
            extractGalaxies $
              transpose $
                expand $
                  transpose $
                    expand lines
    else do
      line <- getLine
      mainLoop (lines ++ [line])
