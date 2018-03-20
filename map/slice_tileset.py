import sys
import os
import image_slicer

# tiles_per_image tile_size ... tileset_file ... 

c = list()

for i in range(3,len(sys.argv)):
	c.append(image_slicer.slice(sys.argv[i],float(sys.argv[1])))

filename = 'tileSetDescriptor.txt'

f = open(filename,'w')

f.write(sys.argv[2] + 'x' + sys.argv[2] + '\n')

num_tiles = int()
for i in c:
	num_tiles += len(i)
 
f.write(str(num_tiles) + '\n')

for i in c:
	for j in i:
		f.write(j.filename + '>' + '1' + '\t' + '1' + '\n')	
	



