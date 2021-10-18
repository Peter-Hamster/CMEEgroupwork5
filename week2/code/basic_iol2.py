#############################
# FILE OUTPUT
#############################
# Save the elements of a list to a file
list_to_save = range(100)

f = open('../sandbox/testout.txt','w')
for i in range(100):
    f.write(str(i) + '\n') ## Add a new line at the end

f.close()

for i in range(6):
    print(i)