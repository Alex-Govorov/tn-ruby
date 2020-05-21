arr = [0, 1]

arr << arr[-2] + arr[-1] until arr[-2] + arr[-1] >= 100
