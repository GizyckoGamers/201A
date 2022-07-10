import sys

with open(sys.argv[1], 'r') as f:
  idx = None
  lines = f.readlines()
  for i, l in enumerate(lines):
    try:
      if l.index(sys.argv[2]) >= 0:
        idx = i
    except:
      pass
  if idx is not None:
    print('replaced!')
    lines[idx] = sys.argv[3] + "\n"
 
with open(sys.argv[4], 'w') as f:
  f.writelines(lines)

