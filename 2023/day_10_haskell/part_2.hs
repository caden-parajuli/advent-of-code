import Data.Array
import Data.Maybe
import Debug.Trace

filename = "input"

data Dir = North | South | East | West

instance Show Dir where
  show dir = case dir of
    North -> "North"
    South -> "South"
    East -> "East"
    West -> "West"

pipeDir :: Char -> Dir -> Maybe Dir
pipeDir c goingDir = case c of
  '|' -> case goingDir of
    North -> Just North
    South -> Just South
    _ -> Nothing
  '-' -> case goingDir of
    East -> Just East
    West -> Just West
    _ -> Nothing
  'L' -> case goingDir of
    West -> Just North
    South -> Just East
    _ -> Nothing
  'J' -> case goingDir of
    East -> Just North
    South -> Just West
    _ -> Nothing
  '7' -> case goingDir of
    East -> Just South
    North -> Just West
    _ -> Nothing
  'F' -> case goingDir of
    North -> Just East
    West -> Just South
    _ -> Nothing
  _ -> Nothing

goDir :: (Int, Int) -> Dir -> (Int, Int)
goDir (x, y) dir = case dir of
  North -> (x, y - 1)
  South -> (x, y + 1)
  East -> (x + 1, y)
  West -> (x - 1, y)

reverseDir :: Dir -> Dir
reverseDir dir = case dir of
  North -> South
  South -> North
  East -> West
  West -> East

nextPipe :: Array Int (Array Int Char) -> (Int, Int) -> Dir -> Maybe (Int, Int, Dir)
nextPipe lines (x, y) intoDir = case pipeDir (lines!y!x) intoDir of
  Nothing -> Nothing
  Just newDir -> Just (fst newPos, snd newPos, newDir) where
    newPos = goDir (x, y) newDir

findStart :: Array Int (Array Int Char) -> Maybe (Int, Int)
findStart lines = findLoop 0 0 where
  findLoop x y = case lines!y!x of
    'S' -> Just (x, y)
    _ ->
      if y >= length lines - 1
          then Nothing
      else if x >= length (lines!y) - 1
          then findLoop 0 (y + 1)
      else findLoop (x + 1) y

posChar :: Array Int (Array Int Char) -> (Int, Int) -> Maybe Char
posChar lines (x, y) =
  if 0 <= y && y < length lines && 0 <= x && x < length (lines!y)
      then Just (lines!y!x)
  else Nothing


-- Determine the total length of the loop, and
-- the area enclosed by the polygon obtained by considering the coordinates
-- of the points on the loop as vertices of a planar polygon (using the shoelace formula).
findLoopVals :: Array Int (Array Int Char) -> (Int, Int) -> Either String (Int, Int)
findLoopVals lines start =
  let dirs = [North, South, East, West] in
  let maybeFirstDir = getValidDir dirs
       where getValidDir [] = Nothing
             getValidDir (dir:tail) =
               let pos = goDir start dir in
                 case posChar lines pos of
                   Nothing -> getValidDir tail
                   Just c -> case pipeDir c dir of
                               Nothing -> getValidDir tail
                               Just _ -> Just dir in
  case maybeFirstDir of
    Nothing -> Left "Could not get first direction"
    Just firstDir ->
      let firstPos = goDir start firstDir in
      findLoopShoelace firstPos firstDir 0 (fst start * snd firstPos - fst firstPos * snd start)
        where findLoopShoelace pos dir count area =
                case posChar lines pos of
                  Nothing -> Left ("position invalid: " ++ show pos)
                  Just char ->
                    if char == 'S'
                      then Right (count + 1, div area 2)
                    else
                      case pipeDir char dir of
                        Nothing -> Left ("Went into invalid pipe" ++ show char ++ " from direction " ++ show dir)
                        Just newDir ->
                          let newPos = goDir pos newDir in
                            findLoopShoelace newPos newDir (count + 1) (area + fst pos * snd newPos - fst newPos * snd pos)

-- Uses Pick's Theorem to compute the number of interior points
findInside :: Array Int (Array Int Char) -> Either String Int
findInside lines =
  case findStart lines of
    Nothing -> Left "Start not found"
    Just start -> case findLoopVals lines start of
                    Left err -> Left err
                    Right (loopLen, area) -> Right (area + 1 - div loopLen 2)

splitLines :: String -> [String]
splitLines s = case dropWhile (== '\n') s of
  "" -> []
  s' -> w : splitLines s''
   where (w, s'') = break (== '\n') s'

processInput :: String -> Array Int (Array Int Char)
processInput input =
  listArray (0, length listLinesList - 1) listLinesList where
    listLinesList = map (\line -> listArray (0, length line - 1) line) linesList where
      linesList = splitLines input


main = do
  input <- readFile filename
  let lines = processInput input in
    case findInside lines of
      Left err -> putStrLn err
      Right farthest -> putStrLn $ "Final value: " ++ show farthest
