%interact simulink to matlab.
clear
clc
close all

%Define.
for i=1:4
k=i*10;
dutycycle = i*20;
sim('buckconv.slx')
Vin = yout.getElement('');
t = Vin.Values.Time;
Vfin = Vin.Values.Data;

figure
plot(t,Vfin)
xlabel('Time (seconds)');
ylabel('Vout (bucked)');
grid on
title('Buck converter');
end