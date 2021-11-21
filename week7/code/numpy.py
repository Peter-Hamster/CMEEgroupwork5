#!/usr/bin/env python3

import numpy as np

a = np.array(range(5)) # a one-dimensional array
a

print(type(a))

print(type(a[0]))

a = np.array(range(5), float)
a

a.dtype # Check type 

x = np.arange(5)
x

x = np.arange(5.) #directly specify float using decimal
x

x.shape

b = np.array([i for i in range(10) if i % 2 == 1]) #odd numbers between 1 and 10 
b

c = b.tolist() #convert back to list
c

mat = np.array([[0, 1], [2, 3]])
mat

mat.shape

# indexing and accessing arrays
mat[1] # accessing whole 2nd row, remember indexing starts at  0

mat[:,1] #accessing whole second column  

mat[0,0] # 1st row, 1st column element

mat[1,0] # 2nd row, 1st column element

mat[:,0] #accessing whole first column  

mat[0,1]

mat[0,-1]

mat[-1,0]

mat[0,-2]

# manipulating arrays
# replacing, adding or deleting elements

mat[0,0] = -1 #replace a single element
mat

mat[:,0] = [12,12] #replace whole column
mat

np.append(mat, [[12,12]], axis = 0) #append row, note axis specification

np.append(mat, [[12],[12]], axis = 1) #append column

newRow = [[12,12]] #create new row

mat = np.append(mat, newRow, axis = 0) #append that existing row
mat

np.delete(mat, 2, 0) #Delete 3rd row

mat = np.array([[0, 1], [2, 3]])
mat0 = np.array([[0, 10], [-1, 3]])
np.concatenate((mat, mat0), axis = 0)

mat.ravel()

mat.reshape((4,1))

mat.reshape((1,4))

#mat.reshape((3, 1))
# This gives an error because total elements must remain the same!

np.ones((4,2)) #(4,2) are the (row,col) array dimensions

np.zeros((4,2)) # or zeros

m = np.identity(4) #create an identity matrix
m

m.fill(16) #fill the matrix with 16
m

# numpy matrices 
# matrix vector operations

mm = np.arange(16)
mm = mm.reshape(4,4) #Convert to matrix
mm

mm.transpose()

mm + mm.transpose()

mm - mm.transpose()

mm * mm.transpose() # Note that this is element-wise multiplication

mm // mm.transpose()

mm // (mm + 1).transpose()

mm * np.pi

mm.dot(mm) # No this is matric multiplication, or the dot product

mm = np.matrix(mm) # convert to scipy/numpy matrix class
mm

print(type(mm))

mm * mm # instead of mm.dot(mm)