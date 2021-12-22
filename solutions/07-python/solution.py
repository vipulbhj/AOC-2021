import math

def mean(nums):
  return sum(nums) / len(nums)

def median(nums):
  sz = len(nums)
  nums.sort()
  if sz % 2 == 0:
    median1 = nums[sz//2]
    median2 = nums[sz//2 - 1]
    return (median1 + median2)/2
  else:
    return nums[n//2]

def part_one(nums):
  res = 0
  val = int(median(nums))
  for num in nums:
    res += abs(num - val)

  print("Part 1: ", res)

def part_two(nums):
  res1 = 0
  res2 = 0
  num_mean = mean(nums)
  val1 = math.floor(num_mean)
  val2 = math.ceil(num_mean)
  
  for num in nums:
    n = abs(num - val1)
    res1 += (n * (n + 1)) // 2

  for num in nums:
    n = abs(num - val2)
    res2 += (n * (n + 1)) // 2 

  print("Part 2: ", min(res1, res2))

with open("input.txt", "r") as f:
  nums = list (map (int, f.readline().strip().split(","))) 
  part_one(nums)
  part_two(nums)
