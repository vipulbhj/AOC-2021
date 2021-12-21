import os
import strutils
import sugar
import sequtils
import sets

proc reset_idx(board: var seq[seq[int]], idx: int) = 
  let h = board.len
  let orgR = idx div h
  let orgC = idx mod h
  board[orgR][orgC] = 0

proc flash_idx(board: var seq[seq[int]], idx: int, flashed: var HashSet[int]) = 
  let h = board.len
  let orgR = idx div h
  let orgC = idx mod h

  # Add to flashed indexes
  flashed.incl(idx)

  for i in -1..1:
    for j in -1..1:
      if i == 0 and j == 0:
        continue
      else:
        try:
          board[orgR + i][orgC + j] += 1
          let bVal = board[orgR + i][orgC + j]
          let newIdx = (orgR + i) * h + (orgC + j)
          if bVal > 9 and not flashed.contains(newIdx):
            flash_idx(board, newIdx, flashed)
        except:
          continue

proc inc_and_find_flash_idx(board: var seq[seq[int]]): seq[int] =
  let h = board.len
  let w = board[0].len
  for r in 0..(h-1):
    for c in 0..(w-1):
      board[r][c] += 1
      if board[r][c] > 9:
        let idx = r * h + c
        result.add(idx)

proc step(board: var seq[seq[int]]): int =
  var flashed = initHashSet[int]()
  var flash_indexes = inc_and_find_flash_idx(board)
  for idx in flash_indexes:
    if flashed.contains(idx):
      continue
    else:
      flash_idx(board, idx, flashed)

  for idx in flashed:
    reset_idx(board, idx)

  result = flashed.len

proc part_one(input: seq[seq[int]]): int = 
  var board = input
  for i in 0..99:
    result += step(board)


proc part_two(input: seq[seq[int]]): int = 
  var board = input
  var win: seq[seq[int]] = @[
    @[0,0,0,0,0,0,0,0,0,0],
    @[0,0,0,0,0,0,0,0,0,0],
    @[0,0,0,0,0,0,0,0,0,0],
    @[0,0,0,0,0,0,0,0,0,0],
    @[0,0,0,0,0,0,0,0,0,0],
    @[0,0,0,0,0,0,0,0,0,0],
    @[0,0,0,0,0,0,0,0,0,0],
    @[0,0,0,0,0,0,0,0,0,0],
    @[0,0,0,0,0,0,0,0,0,0],
    @[0,0,0,0,0,0,0,0,0,0]
  ]

  var count = 1
  while true:
    discard step(board)
    if board == win:
      return count
    else:
      count += 1

proc main(filePath: string) =
  var board: seq[seq[int]] = @[]
  for line in filePath.lines:
    let numSeq = line.map(c => parseInt($c))
    board.add(numSeq)
  
  echo part_one(board)
  echo part_two(board)

main("input.txt")
