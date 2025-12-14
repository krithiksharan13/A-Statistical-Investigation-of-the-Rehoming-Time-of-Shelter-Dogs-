endpoint = c("Statistician", "Surgeon")

cex = 1

effect 	= c(55,55)
lower  	= c(31, 38)
upper  	= c(80, 72)

verticalpos = c(1,2)

par(oma=c(0,0,0,0), mar=c(6,3,1,1))

plot(x=1, y=0, type="n",  ann=F, xaxt='n', yaxt='n', xlab = "", ylab= NULL, bty="n", xlim = c(0,100), ylim = c(0,3.4))


lines(c(35, 35), c(0, 18), lty = 3, lwd=1, col="blue") 
lines(c(55, 55), c(0, 18), lty = 3, lwd=1, col="blue") 
lines(c(70, 70), c(0, 18), lty = 3, lwd=1, col="blue") 

text(labels = "below normal", y=3, x=45, col = "blue", cex=1, adj=c(0.5,0)) 
text(labels = "normal", y=3, x=62.5, col = "blue", cex=1, adj=c(0.5,0))
text(labels = "above normal", y=3, x=80, col = "blue", cex=1, adj=c(0.5,0))
text(labels = "poor", y=3, x=25, col = "blue", cex=1, adj=c(0.5,0))

points(effect, verticalpos , cex=cex, pch=16)

for(i in 1:2 ){
  lines(c(lower[i], upper[i]), c(verticalpos[i], verticalpos[i]), lwd=1)
  lines(c(lower[i], lower[i]), c(verticalpos[i] + 0.2, verticalpos[i] - 0.2), lwd=1)
  lines(c(upper[i], upper[i]), c(verticalpos[i] + 0.2, verticalpos[i] - 0.2), lwd=1)
}

axis(at = 5*c(1:19), side = 1, cex.axis = 1)  # axis on bottom with tick marks lines up with equivalence limits

mtext("Mean LVEF (%)", side = 1, cex=cex, line = 4) 

mtext(text = endpoint, side = 2, line = 2, outer = FALSE, at = verticalpos , las=1, cex=cex, adj=0)

mtext(text = paste( "(", lower, ", ", upper, ")", sep=""), side = 4, line = -4, outer = FALSE, at = verticalpos , las=1, cex=cex, adj=0)

