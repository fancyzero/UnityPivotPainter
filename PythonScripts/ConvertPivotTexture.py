import sys
import array
import OpenEXR
import Imath


import numpy as np
from PIL import Image
m = Image.open(r"Assets\PivotPainter\Samples\Tree\HT_P2_XVec_XExDiv2048r2048_UV_2.TGA")

R,G,B,A = m.split()
m.close()
G = np.asarray(G)
G = 255-G

G = Image.fromarray(G,'L')


result = Image.merge('RGBA', (R,B,G,A))
result.save(r"Assets\PivotPainter\Samples\Tree\HT_P2_XVec_XExDiv2048r2048_UV_2_converts.TGA")




exit()

# Open the input file
file = OpenEXR.InputFile(".\PythonScripts\HiTree_P2.exr")

h = file.header()
# Compute the size
dw = file.header()['dataWindow']
sz = (dw.max.x - dw.min.x + 1, dw.max.y - dw.min.y + 1)

# Read the three color channels as 32-bit floats
chanType = Imath.PixelType(Imath.PixelType.FLOAT)

(R,G,B,A) = [array.array('f', file.channel(Chan, chanType)).tolist() for Chan in ("R", "G", "B","A") ]
# R = [ r*-1 for r in R] # flip x axis sign
G = [ g-1 for g in G] # minus 1 from y axis
G = [ -g for g in G] # minus 1 from y axis


# Convert to strings
(Rs, Gs, Bs,As) = [ (Chan) for Chan in (R, G, B,A) ]
Rs = array.array('f',Rs).tobytes()
Gs = array.array('f',Gs).tobytes()
Bs = array.array('f',Bs).tobytes()
As = array.array('f',As).tobytes()
# Rs = [str(s) for s in Rs]
# Gs = [str(s) for s in Gs]
# Bs = [str(s) for s in Bs]
# Rs = ",".join(Rs)
# Gs = ",".join(Gs)
# Bs = ",".join(Bs)
newChanType = Imath.PixelType(Imath.PixelType.FLOAT)
newh = OpenEXR.Header(sz[0], sz[1])
newh["channels"]={"R":Imath.Channel(newChanType),
"G": Imath.Channel(newChanType),
"B":Imath.Channel(newChanType),
"A":Imath.Channel(newChanType)}


# Write the three color channels to the output file
out = OpenEXR.OutputFile(".\Assets\PivotPainter\Samples\Tree\HiTree_P2_Convertes.exr",newh )
out.writePixels({'R' : Rs, 'G' : Bs, 'B' : Gs ,'A':As})#swap z and y
out.close()


