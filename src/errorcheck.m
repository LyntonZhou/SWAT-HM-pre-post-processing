figure
subplot(3,1,1)
plot(flowobsout66-flowout66)
subplot(3,1,2)
scatter(flowout66,flowobsout66-flowout66)
subplot(3,1,3)
scatter(flowobsout66,flowobsout66-flowout66)

figure
subplot(3,1,1)
plot(sedobsout66-sedout66)
subplot(3,1,2)
scatter(log(sedout66+1),log(abs(sedobsout66-sedout66)))
subplot(3,1,3)
scatter(log(sedobsout66+1),log(abs(sedobsout66-sedout66)))