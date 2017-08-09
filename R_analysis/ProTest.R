data <- read.csv("Protest.csv",header=TRUE)

R1 <- data[1:5,2:3]
R2 <- data[6:10,2:3]
R3 <- data[11:15,2:3]
R4 <- data[16:20,2:3]

protest(X=R1,Y=R2)
protest(X=R1,Y=R3)
protest(X=R1,Y=R4)
protest(X=R2,Y=R3)
protest(X=R2,Y=R4)
protest(X=R3,Y=R4)


###summary
all r2 > 0.9383 
all p <= 0.025





